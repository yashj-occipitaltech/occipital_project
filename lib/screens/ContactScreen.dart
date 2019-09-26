import 'package:flutter/material.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:occipital_tech/util/widgets.dart';


class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: Widgets.appBar('Contact Us'),
    );
  }
}