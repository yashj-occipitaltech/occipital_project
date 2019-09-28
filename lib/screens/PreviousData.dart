import 'package:flutter/material.dart';
import 'package:occipital_tech/util/widgets.dart';

class PreviousData extends StatelessWidget {
  PreviousData(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: Widgets.appBar('Previous Data'),
      body: Center(child: Text(title)),
    );
  }
}
