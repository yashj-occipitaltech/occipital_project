import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:occipital_tech/models/store_user.dart';
import 'package:occipital_tech/models/user_check.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/widgets.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int selectedUser = 1;
  final _users = ['Farmer', 'Trader', 'Enterprise'];
  final _formKey = GlobalKey<FormState>();

  final now = DateTime.now();

  final _controllerOne = TextEditingController();

  setSelectedUser(int val) {
    setState(() {
      selectedUser = val;
      _userType = _users[val - 1];
    });
  }

  String _username;
  String _email = 'null';
  String _companyId = 'null';
  String _phone;
  String _userType='Farmer';
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets.appBar('Sign Up'),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: submitButton(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Widgets.labelText('User Name'),
                usernameInput(),
                SizedBox(
                  height: 10.0,
                ),
                Widgets.labelText('Type of User'),
                userOptions(),
                selectedUser == 2 || selectedUser == 3
                    ? showOtherInputs()
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameInput() {
    return TextFormField(
      controller: _controllerOne,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: 'Enter Name',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10.0)),
    );
  }

  Widget userOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        userType(1),
        userLabel('Farmer'),
        userType(2),
        userLabel('Trader'),
        userType(3),
        userLabel('Enterprise'),
      ],
    );
  }

  Widget userType(int _value) {
    return Radio(
      groupValue: selectedUser,
      value: _value,
      onChanged: (int val) {
        setSelectedUser(val);
      },
    );
  }

  Widget userLabel(String user) {
    return Text(user);
  }

  Widget emailInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter valid email';
        }
        return null;
      },
      onSaved: (String val) {
        _email = val;
      },
      decoration: InputDecoration(
          hintText: 'abc@gmail.com',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10.0)),
    );
  }

  Widget companyIdInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter company id';
        }
        return null;
      },
      onSaved: (String val) {
        _companyId = val;
      },
      decoration: InputDecoration(
          hintText: 'ABC12345',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10.0)),
    );
  }

  Widget passwordInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (String val) {
        _password = val;
      },
      obscureText: true,
      decoration: InputDecoration(
          hintText: '**********',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10.0)),
    );
  }

  Widget showOtherInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Widgets.labelText('Email'),
        emailInput(),
        SizedBox(
          height: 10.0,
        ),
        Widgets.labelText('Company ID'),
        companyIdInput(),
        SizedBox(
          height: 10.0,
        ),
        Widgets.labelText('Password'),
        passwordInput(),
      ],
    );
  }

  Widget submitButton(BuildContext context) {
    return RaisedButton(
      color: Colors.green[400],
      padding: EdgeInsets.all(16.0),
      child: Text(
        'SUBMIT',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          print(_controllerOne.text);
          print('Done');
          print(StoreUserData(
              DateFormat("dd-MM-yyyy").format(now),
              DateFormat("H:m:s").format(now),
              'userId',
              _username,
              _userType,
              _companyId,
              _email).toJson());

          final response = await ApiClient.storeUser(StoreUserData(
              DateFormat("dd-MM-yyyy").format(now),
              DateFormat("H:m:s").format(now),
              '9172396642',
              _controllerOne.text,
              _userType,
              _companyId,
              _email));

          if (response.status == 'True') {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Fluttertoast.showToast(msg: 'Some error occured');
          }
        }
      },
    );
  }
}
