import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   File _image;

//   getImageFile(ImageSource source) async {

//      //Clicking or Picking from Gallery 

//     var image = await ImagePicker.pickImage(source: source);

//     //Cropping the image

//     File croppedFile = await ImageCropper.cropImage(
//       sourcePath: image.path,
//       ratioX: 1.0,
//       ratioY: 1.0,
//       maxWidth: 512,
//       maxHeight: 512,
//     );

//     //Compress the image

//     var result = await FlutterImageCompress.compressAndGetFile(
//       image.path,
//       image.path,
//       quality: 50,
//     );

//     setState(() {
//       _image = result;
//       print(_image.lengthSync());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(_image?.lengthSync());
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Click | Pick | Crop | Compress"),
//       ),
//       body: Center(
//         child: _image == null
//             ? Text("Image")
//             : Image.file(
//                 _image,
//                 height: 200,
//                 width: 200,
//               ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           FloatingActionButton.extended(
//             label: Text("Camera"),
//             onPressed: () => getImageFile(ImageSource.camera),
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.camera),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           FloatingActionButton.extended(
//             label: Text("Gallery"),
//             onPressed: () => getImageFile(ImageSource.gallery),
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.photo_library),
//           )
//         ],
//       ),
//     );
//   }
// }

class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It'
      );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[

            Image.file(_imageFile),

            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),

            //Uploader(file: _imageFile)
          ]
        ],
      ),
    );
  }
}