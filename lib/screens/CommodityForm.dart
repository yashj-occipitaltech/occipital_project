import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:occipital_tech/models/upload_order.dart';
import 'package:occipital_tech/screens/HomePage.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/consts.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommodityForm extends StatefulWidget {
  @override
  _CommodityFormState createState() => _CommodityFormState();
}

class _CommodityFormState extends State<CommodityForm> {
  String _value = 'Onion';

  String _description= '';

  List<File> _images = List<File>();

  BehaviorSubject<List<File>> images = BehaviorSubject<List<File>>();

  final _formKeyCommodity = GlobalKey<FormState>();
  final now = DateTime.now();

  void initState() {
    super.initState();
    // images.add(Image.asset(name))
  }

  void dispose() {
    super.dispose();
    images.close();
  }

  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;

  _images.forEach((f){
    f.path;
  });
  return File('$path/uploads');
}

  Future<void> addImagesToList() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.camera);
                    
    if (selected != null) {
       String fileName = selected.path.split('/').last;
        print(fileName);
        print(selected.path);
      _images.add(selected);
      print(_images);
      images.add(_images);
    }
  }

  void deleteImage(int index) {
    _images.removeAt(index);
    images.add(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'New Data',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () async {
                if (_images.length <= 0) {
                  Fluttertoast.showToast(msg: 'Please upload an image');
                } else {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final answer = await ApiClient.uploadImages(
                      UploadOrder(
                          prefs.getString('phoneNo'),
                          DateFormat("H:m:s").format(now),
                          now.day.toString(),
                          now.month.toString(),
                          now.year.toString(),
                          "Mumbai",
                          _value,
                          prefs.getString('userType'),
                          prefs.getString('token'),
                          _description
                          ),
                      _images);
                 Navigator.pushReplacementNamed(context, '/home');
                 print(answer.toJson());     
                }
              },
              child: Icon(Icons.check),
            ),
          )
        ],
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
              onChanged: (String val){
                _description =val;
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

  DropdownButton _itemDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem(value: "Onion", child: Text('Onion')),
          DropdownMenuItem(value: "Tomato", child: Text('Tomato')),
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
      onPressed: () {
        if (_images.length >= Values.uploadsAllowed) {
          Fluttertoast.showToast(
              msg: 'Only ${Values.uploadsAllowed} images are allowed');
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
}
