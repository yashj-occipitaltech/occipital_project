import 'package:flutter/material.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:occipital_tech/util/widgets.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets.appBar('Settings'),
       drawer: AppDrawer(),
      body: Center(child: Text('Settings Here'),),
    );
  }
}