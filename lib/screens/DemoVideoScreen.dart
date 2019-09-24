import 'package:flutter/material.dart';
import 'package:occipital_tech/util/widgets.dart';

class DemoVideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets.appBar('Demo Video',false),
      body:  Center(child: Text('Demo video here')),
    );
  
  }
}