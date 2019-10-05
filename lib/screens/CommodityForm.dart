import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:occipital_tech/screens/HomePage.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:rxdart/subjects.dart';

class CommodityForm extends StatefulWidget {
  @override
  _CommodityFormState createState() => _CommodityFormState();
}

class _CommodityFormState extends State<CommodityForm> {
  String _value = 'Onions';

  BehaviorSubject<List<ImageSource>> images = BehaviorSubject<List<ImageSource>>();

  final _formKeyCommodity = GlobalKey<FormState>();


  void initState(){
    super.initState();
   // images.add(Image.asset(name))
  }

  void dispose(){
    super.dispose();
    images.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets.appBar('New Data'),
      body: Form(
        key: _formKeyCommodity,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            labelText('Commodity *'),
            _itemDown(),
            labelText('Description:'),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a description'),
            ),
            //SizedBox(height: 10.0),
            Widgets.labelText('Upload Images'),
            Align(child: addButton(),alignment: Alignment.bottomLeft,)
           // imageUploadButton()
          ],
        ),
      ),
    );
  }

  DropdownButton _itemDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem(value: "Onions", child: Text('Onions')),
          DropdownMenuItem(value: "Tomatoes", child: Text('Tomatoes')),
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
    return RaisedButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => ImageCapture())),
      child: Text('Select an image to upload'),
      padding: EdgeInsets.all(16.0),
    );
  }


  Widget uploadImages(){
    return StreamBuilder<Object>(
      stream: images,
      builder: (context, snapshot) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){

          },
        );
      }
    );
  }


  Widget addButton(){
    return InkWell(
          onTap: (){},
          child: SizedBox(
        
        //padding: EdgeInsets.all(20.0),
        height:100.0 ,
        width: 80.0,
        //width: 0.8,
        child: Container(child: Text('+'),decoration: BoxDecoration(border: Border.all(color:Colors.black )),),
      ),
    );
  }


}
