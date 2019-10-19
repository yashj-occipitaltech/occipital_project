import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:occipital_tech/scoped_models/user_model.dart';
import 'package:occipital_tech/screens/BottomNavigator.dart';
import 'package:occipital_tech/screens/ContactScreen.dart';
import 'package:occipital_tech/screens/HelpScreen.dart';
import 'package:occipital_tech/screens/SettingsScreen.dart';
import 'package:occipital_tech/util/locator.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage('assets/home_logo.png'),
                        fit: BoxFit.fitWidth)),
              ),
              drawerTiles('Home', BottomNavigator(showHome: true,), Icons.home),
              drawerTiles('Settings', SettingsScreen(), Icons.settings),
              drawerTiles('Help', HelpScreen(), Icons.help),
              drawerTiles('Contact us', ContactScreen(), Icons.phone),
              logoutTile()
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerTiles(
    String name,
    Widget screen,
    IconData iconName,
  ) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconName,
                color: Color(0XFF01AF51),
                size: 25.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Container(
              height: 1.0,
              width: 320.0,
              color: Colors.black12,
            ),
          )
        ],
      ),
      onTap: () => name == 'Home' ? homeRoute(true) : Navigator.push(
          context, MaterialPageRoute(builder: (context) => screen)),
    );
  }

  void homeRoute(bool homeVal){
     Navigator.of(context).popUntil((route) => route.isFirst);
     Navigator.of(context).pop();
     Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavigator(showHome: homeVal,)));
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are you sure you want to logout ?'),
            title: Text('Logout'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  //Dont touch this piece of code , it works 
                  Navigator.of(context).pop();
                  locator<UserModel>().logout();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/loginotp');
                  
                  Fluttertoast.showToast(
                    msg: 'Successfully logged out',
                  );
                 
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget logoutTile() {
    return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  color: Color(0XFF01AF51),
                  size: 25.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: Container(
                height: 1.0,
                width: 320.0,
                color: Colors.black12,
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.pop(context);
          _showDialog();
        });
  }
}
