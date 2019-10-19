import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:occipital_tech/models/store_user.dart';
import 'package:occipital_tech/models/user_check.dart';
import 'package:occipital_tech/models/verify_trader.dart';
import 'package:occipital_tech/scoped_models/user_model.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/result_codes.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:occipital_tech/util/colorValues.dart';

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
  String _userType = 'Farmer';
  String _password;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, UserModel model) => WillPopScope(
              onWillPop:() => routePopAllowed(model),
              child: Scaffold(
          appBar: Widgets.appBar('Sign Up'),
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: submitButton(context, model),
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
          return 'Please enter email here';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter correct email ';
        }
        return null;
      },
      onSaved: (String val) {
        _email = val;
      },
      onChanged: (String val) {
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
      onChanged: (String val) {
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
      onChanged: (String val) {
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

  Widget submitButton(BuildContext context, UserModel model) {
    return RaisedButton(
        color: Color(0XFF01AF51),
        padding: EdgeInsets.all(16.0),
        child: model.isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
            : Text(
                'SUBMIT',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
        onPressed: () => model.isLoading
            ? null
            : _userType == 'Farmer'
                ? _savedata(model)
                : _verifyingTrader(model));
  }

  _savedata(UserModel model) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = await model.storeUser(StoreUserData(
          now.day.toString(),
          DateFormat("H:m:s").format(now),
          prefs.getString('phoneNo'),
          _controllerOne.text,
          _userType,
          _companyId,
          _email,
          now.month.toString(),
          now.year.toString()));

      if (data['success'] == true && data['message'] == 'True') {
         Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'Successful');
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, '/home');
      } else if (data['resultCode'] == ResultCodes.jsonError) {
        Fluttertoast.showToast(msg: 'Some error occured.Please try again');
      } else {
        print(data['message']);
        Fluttertoast.showToast(msg: data['message']);
      }
    }
  }

  _verifyingTrader(UserModel model) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final data =
          await model.verifyTrader(VerifyTrader(_companyId, _password));
      if (data['error'] == true && data['verified'] == false) {
        Fluttertoast.showToast(msg: data['status']);
      } else if (data['error'] == false && data['verified'] == true) {
        _savedata(model);
      }
      print(data['error']);
      print(data['verified']);
      print(data['status']);
    }
  }


  Future<bool> routePopAllowed(UserModel model)async{
      if(model.isLoading){
        return false;
      }

      return true;
  }
}
