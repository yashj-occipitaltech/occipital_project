import 'package:flutter/material.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:occipital_tech/util/widgets.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKeyContacts = GlobalKey<FormState>();

  String _message = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: Widgets.appBar('Contact Us'),
      body: Form(
        key: _formKeyContacts,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Widgets.labelText("Email:"),
                emailInput(),
                Widgets.labelText("Message:"),
                messageInput(),
                SizedBox(height: 15.0),
                Center(child: submitButton())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return TextFormField(
        validator: (String val) {
          if (val.isEmpty) {
            return 'Please enter email';
          }
          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(val)) {
            return 'Please enter correct email ';
          }
          return null;
        },
        onChanged: (String email) {
          _email = email;
        },
        decoration: InputDecoration(
            hintText: 'abc123@gmail.com', border: OutlineInputBorder()));
  }

  Widget messageInput() {
    return TextFormField(
        validator: (String val) {
          if (val.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onChanged: (String message) {
          _message = message;
        },
        maxLines: 8,
        decoration: InputDecoration(
            hintText: 'Write message here', border: OutlineInputBorder()));
  }


  Widget submitButton(){
    return InkWell(
      onTap: ()async{
        _submitForm();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        
          borderRadius: BorderRadius.circular(50.0)
        ),
        padding: EdgeInsets.all(20.0),
        child: Text('Send Message',style: TextStyle(color: Colors.white,fontSize: 18.0)) ,
      ),
    );
  }

  _submitForm() async{
    if(_formKeyContacts.currentState.validate()){
      _formKeyContacts.currentState.save();
      print(_message);
      print(_email);
    }
  }
}
