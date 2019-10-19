import 'package:flutter/material.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:occipital_tech/util/widgets.dart';


class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: AppDrawer(),
      appBar: Widgets.appBar('Help',backToHome:true,context:context),
      body: Center(
        child: Text('Help Here'),
      ),
    );
  }
}