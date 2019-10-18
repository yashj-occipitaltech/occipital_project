import 'package:flutter/material.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = true;

  changePrefs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('compression', value);
  }

  getPrefs()async{
    final prefs = await SharedPreferences.getInstance();
    final valueSaved = prefs.getBool('compression');
    if(valueSaved== null){
      changePrefs(value);
    }else{
       setState(() {
    value = valueSaved;
    });
    }
   
  }

  void initState(){
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets.appBar('Settings',backToHome:true,context:context),
      drawer: AppDrawer(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          CheckboxListTile(
            value: value,
            title: Text('Allow Compression'),
            onChanged: (bool val) {
              setState(() {
                value = val;
              });
              changePrefs(value);
              
            },
          )
        ],
      ),
    );
  }
}
