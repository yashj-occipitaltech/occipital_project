import 'package:flutter/material.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:occipital_tech/util/widgets.dart';


class HelpScreen extends StatelessWidget {

 //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: AppDrawer(),
      appBar: Widgets.appBar('Help'),
      body: Center(
        child: Text('Help Here'),
      ),
    );
  }
}