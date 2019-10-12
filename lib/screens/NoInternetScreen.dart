
import 'package:flutter/material.dart';
import 'package:occipital_tech/util/widgets.dart';


class NoInternetScreen extends StatelessWidget{
 @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Widgets.appBar('No internet connection'),
      
      body: Center(child: Text('Sorry you are not connected to Internet')),
    );
  }
}
