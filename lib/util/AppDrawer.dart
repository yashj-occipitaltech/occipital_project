import 'package:flutter/material.dart';
import 'package:occipital_tech/screens/BottomNavigator.dart';
import 'package:occipital_tech/screens/ContactScreen.dart';
import 'package:occipital_tech/screens/HelpScreen.dart';
import 'package:occipital_tech/screens/SettingsScreen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(child: Text('Agrograde')),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
          drawerTiles('Home', BottomNavigator(), Icons.home),
          drawerTiles('Settings', SettingsScreen(), Icons.settings),
          drawerTiles('Help', HelpScreen(), Icons.help),
          drawerTiles('Contact us', ContactScreen(), Icons.contact_phone),
          ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.account_circle),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Logout')
                ],
              ),
              onTap: ()  {
                Navigator.pop(context);
                _showDialog();
                
                }),
        ],
      ),
    );
  }

  Widget drawerTiles(
    String name,
    Widget screen,
    IconData iconName,
  ) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(iconName),
          SizedBox(
            width: 10.0,
          ),
          Text(name)
        ],
      ),
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => screen)),
    );
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
                onPressed: () {},
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}
