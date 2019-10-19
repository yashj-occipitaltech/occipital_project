import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:occipital_tech/models/order_status_result.dart';
import 'package:occipital_tech/models/upload_images_response.dart';
import 'package:occipital_tech/models/upload_order.dart';
import 'package:occipital_tech/screens/HomePage.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/consts.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class CommodityForm extends StatefulWidget {
  @override
  _CommodityFormState createState() => _CommodityFormState();
}

class _CommodityFormState extends State<CommodityForm> {
  String _value;
  List<String> _commodities = List<String>();

  String _description = '';

  List<File> _images = List<File>();

  BehaviorSubject<List<File>> images = BehaviorSubject<List<File>>();

  BehaviorSubject progressValue = BehaviorSubject();

  final _formKeyCommodity = GlobalKey<FormState>();
  final now = DateTime.now();

  void initState() {
    super.initState();
    getCommodities();
  }

  void dispose() {
    super.dispose();
    images.close();
    progressValue.close();
  }

  Future<bool> getCompressionSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('compression');
  }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;

  //   _images.forEach((f) {
  //     f.path;
  //   });
  //   return File('$path/uploads');
  // }

  Future<void> addImagesToList() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.camera);

    if (selected != null) {
      File croppedImage = await _cropImage(selected);
      _images.add(croppedImage ?? selected);
      final compressionVal = await getCompressionSetting();
      if (compressionVal == true) {
        var result = await FlutterImageCompress.compressAndGetFile(
            (croppedImage ?? selected).path, (croppedImage ?? selected).path,
            quality: 60, minWidth: 2000, minHeight: 2000);
      }
      // print(result.lengthSync());
      images.add(_images);
    }
  }

  Future<File> _cropImage(File selected) async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: selected.path,
        toolbarColor: Colors.green,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It',
        statusBarColor: Colors.green);
    return cropped;
  }

  void deleteImage(int index) {
    _images.removeAt(index);
    images.add(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RaisedButton(
        color: Color(0XFF01AF51),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('UPLOAD ORDER',
                style: TextStyle(color: Colors.white, fontSize: 16.0)),
            SizedBox(width: 5.0),
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20.0,
            )
          ],
        ),
        padding: EdgeInsets.all(16.0),
        onPressed: () async => _onFormSubmmited(),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'New Data',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,

        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.all(10.0),
        //     child: InkWell(
        //       onTap: () async => _onFormSubmmited(),
        //       child: Icon(Icons.check),
        //     ),
        //   )
        // ],
      ),
      body: Form(
        key: _formKeyCommodity,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            labelText('Commodity *'),
            _itemDown(),
            labelText('Description:'),
            TextFormField(
              onChanged: (String val) {
                _description = val;
              },
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a description'),
            ),
            Widgets.labelText('Upload Images:'),
            imageUploadButton(),
            SizedBox(
              height: 15.0,
            ),
            selectedImages()
          ],
        ),
      ),
    );
  }

  _onFormSubmmited() async {
    if (_value == null) {
      Fluttertoast.showToast(msg: 'Please select a commodity');
    } else if (_images.length <= 0) {
      Fluttertoast.showToast(msg: 'Please upload an image');
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final permission = await Geolocator().checkGeolocationPermissionStatus();
      ServiceStatus serviceStatus =
          await LocationPermissions().checkServiceStatus();
      if (permission == GeolocationStatus.denied ||
          permission == GeolocationStatus.disabled) {
        await LocationPermissions().requestPermissions();
      } else if (serviceStatus == ServiceStatus.disabled) {
        Fluttertoast.showToast(msg: 'Please enable location');
      } else if (permission == GeolocationStatus.granted &&
          serviceStatus == ServiceStatus.enabled) {
        await uploadImages(
            UploadOrder(
                prefs.getString('phoneNo'),
                DateFormat("H:m:s").format(now),
                now.day.toString(),
                now.month.toString(),
                now.year.toString(),
                await getAddress().then((data) => data.first.featureName),
                _value,
                prefs.getString('userType'),
                prefs.getString('token'),
                _description,
                await getAddress().then((data) => data.first.addressLine)),
            _images);
      }
    }
  }

  Future<List<Address>> getAddress() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = Coordinates(position.latitude, position.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses;
  }

  DropdownButton _itemDown() => DropdownButton<String>(
        items: [
          for (var item in _commodities)
            DropdownMenuItem(value: "$item", child: Text('$item'))
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        value: _value,
        isExpanded: true,
        hint: Text('Select a commodity'),
        //isDense: true,
      );

  Widget labelText(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget imageUploadButton() {
    return FlatButton(
      onPressed: () async {
        if (_images.length >= await imagesAllowed()) {
          Fluttertoast.showToast(
              msg: 'Only ${await imagesAllowed()} images are allowed');
        } else {
          addImagesToList();
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Color(0XFF01AF51),
      child: Text(
        'Select Images to upload',
        style: TextStyle(color: Colors.white),
      ),
      padding: EdgeInsets.all(16.0),
    );
  }

  Widget selectedImages() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250.0,
      child: StreamBuilder<Object>(
          stream: images,
          builder: (context, snapshot) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                if (_images.length > 0) {
                  return imageContainer(_images[index], index);
                }

                return Text('No images uploaded');
              },
            );
          }),
    );
  }

  Widget imageContainer(File image, int index) {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Stack(
        children: <Widget>[
          Image.file(
            image,
            height: 150.0,
          ),
          Positioned(
            child: InkWell(
                onTap: () {
                  deleteImage(index);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                )),
            right: 0,
          )
        ],
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        //padding: EdgeInsets.all(20.0),
        height: 100.0,
        width: 80.0,
        //width: 0.8,
        child: Container(
          child: Text('+'),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        ),
      ),
    );
  }

  Future<Null> _uploadDialog(BuildContext context) async {
    return await showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              elevation: 0.0,
              contentPadding: EdgeInsets.all(16.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Uploading '),
                      StreamBuilder<Object>(
                          stream: progressValue,
                          builder: (context, snapshot) {
                            return Text('${snapshot.data.toString()}%');
                          })
                    ],
                  ),
                  // StreamBuilder<Object>(
                  //   stream: progressValue,
                  //   builder: (context, snapshot) {
                  //     print(double.parse(snapshot.data));
                  //     return LinearProgressIndicator(value:double.parse(snapshot.data) ,);
                  //   }
                  // )
                ],
              ),
            ),
          );
        });
  }

  Future uploadImages(UploadOrder order, List<File> images) async {
    final uploader = FlutterUploader();
    final Directory dir = await getApplicationDocumentsDirectory();
    print(dir.path.split('/').take(5).join('/').substring(1));
    final String savedDir = 'data/user/0/com.occipitaltech.agrograde/cache';
    final task = await uploader.enqueue(
      url: '${ApiEndpoints.baseUrl}${ApiEndpoints.uploadImages}',
      method: UploadMethod.POST,
      files: [
        // FileItem(filename: fileName, fieldname: 'uploads', savedDir: savedDir),
        for (var image in images)
          FileItem(
              filename: image.path.split('/').last,
              fieldname: 'uploads',
              savedDir:
                  '${dir.path.split('/').take(5).join('/').substring(1)}/cache')
      ],
      data: order.toJson().cast<String, String>(),
    );
    _uploadDialog(context);
    final progressListener = uploader.progress.listen((progress) {
      progressValue.add(progress.progress.toString());
    });
    final subscription = uploader.result.listen((result) {
      //... code to handle result
      if (result.statusCode == 200 && result.status.value == 3) {
        final responseData = json.decode(result.response);

        Fluttertoast.showToast(msg: 'Successfully Uploaded');
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, '/home',
            arguments: ScreenArgs(responseData['OrderId']));
      }
    }, onError: (ex, stacktrace) {
      // ... code to handle error
      print('From errpr');
      print(ex);
      Navigator.pushReplacementNamed(context, '/home');
      Fluttertoast.showToast(msg: 'Some error occured.Please try again');
    });
  }

  getCommodities() async {
    final prefs = await SharedPreferences.getInstance();
    final commodities = prefs.getStringList('commodities');
    setState(() {
      _commodities = commodities;
    });
  }

  Future<int> imagesAllowed() async {
    final prefs = await SharedPreferences.getInstance();
    final maxImages = prefs.getInt('maxImages');
    return maxImages;
  }
}

class ScreenArgs {
  String orderId;

  ScreenArgs(this.orderId);
}
