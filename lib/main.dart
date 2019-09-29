import 'package:flutter/material.dart';
import 'package:occipital_tech/scoped_models/user_model.dart';
import 'package:occipital_tech/screens/BottomNavigator.dart';
import 'package:occipital_tech/screens/LoginOTPScreen.dart';
import 'package:occipital_tech/screens/SignUpScreen.dart';
import 'package:occipital_tech/util/locator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAuthenticated = false;
  final UserModel model = locator<UserModel>();
  void initState() {
    super.initState();
    model.autoLogin();
    model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
  }

  void showPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getString('userType'));
    print(prefs.getString('userName'));
    print(prefs.getString('phoneNo'));

  }

  @override
  Widget build(BuildContext context) {
    showPrefs();
    return ScopedModel(
      model: locator<UserModel>(),
      child: ScopedModelDescendant(
        builder: (context, child, UserModel model) {
          return MaterialApp(
              routes: {
                '/home': (context) => BottomNavigator(),
                '/signup': (context) => SignUpScreen(),
                '/loginotp': (context) => LoginOTPScreen()
              },
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: _isAuthenticated ? BottomNavigator() : LoginOTPScreen());
        },
      ),
    );
  }
}
