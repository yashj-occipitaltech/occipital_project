import 'package:flutter/material.dart';
import 'package:occipital_tech/screens/HomePage.dart';


class CommodityForm extends StatefulWidget {
  @override
  _CommodityFormState createState() => _CommodityFormState();
}

class _CommodityFormState extends State<CommodityForm> {

   String _value = 'Onions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Data'),
      ),
      body: Form(
              child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[

            labelText('Commodity *'),
            _itemDown(),
            labelText('Description:'),
            TextFormField(maxLines: 5,decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Enter a description'),),
            SizedBox(height: 18.0),
            imageUploadButton()
          ],
        ),
      ),
    );
  }

  DropdownButton _itemDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem(
            value: "Onions",
            child: Text('Onions')
          ),
          DropdownMenuItem(
            value: "Tomatoes",
            child: Text('Tomatoes')
          ),
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


      Widget labelText(String label){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(label,style: TextStyle(fontSize: 16.0),),
            SizedBox(height: 10.0,)
          ],
        );
      }


      Widget imageUploadButton(){
        return RaisedButton(
          onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCapture())),
          child: Text('Select an image to upload'),
          padding: EdgeInsets.all(16.0)
          ,
        );
      }
}