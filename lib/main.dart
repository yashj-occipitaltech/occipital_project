import 'dart:async';

import 'package:flutter/material.dart';
import 'package:occipital_tech/scoped_models/user_model.dart';
import 'package:occipital_tech/screens/BottomNavigator.dart';
import 'package:occipital_tech/screens/LoginOTPScreen.dart';
import 'package:occipital_tech/screens/NoInternetScreen.dart';
import 'package:occipital_tech/screens/SignUpScreen.dart';
import 'package:occipital_tech/util/locator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

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
  StreamSubscription subscription;

  bool _isDeviceConnected = false;

  checkInternet() {}

  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        var isDeviceConnected = await DataConnectionChecker().hasConnection;
        setState(() {
          _isDeviceConnected = isDeviceConnected;
        });
      } else if (result == ConnectivityResult.none) {
        setState(() {
          _isDeviceConnected = false;
        });
      }
    });
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

  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //showPrefs();
    //print(_isDeviceConnected);
    return ScopedModel<UserModel>(
        model: locator<UserModel>(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            
            routes: {
              '/home': (context) => BottomNavigator(),
              '/signup': (context) => SignUpScreen(),
              '/loginotp': (context) => LoginOTPScreen()
            },
            title: 'Agrograde',
            // darkTheme: ThemeData.dark(),
            // themeMode: ThemeMode.dark,
            theme: ThemeData(
              primarySwatch: Colors.green,

              // bottomAppBarColor: Colors.green,
            ),
            home: _isAuthenticated ? BottomNavigator() : LoginOTPScreen()));
  }
}
