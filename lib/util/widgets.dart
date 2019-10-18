import 'package:flutter/material.dart';



class Widgets{
  static Widget appBar(String title,{bool backToHome=false,BuildContext context,bool showLeading}){
    return AppBar(
      leading: backToHome ? InkWell(child: Icon(Icons.arrow_back),onTap: (){
        Navigator.pushNamed(context, '/home');
      },):InkWell(child: Icon(Icons.arrow_back),onTap: (){
        Navigator.pop(context);
      },),
      iconTheme:  IconThemeData(color: Colors.black),
      elevation: 0.0,
      title: Text(title,style: TextStyle(color: Colors.black),),
      centerTitle: true,
      backgroundColor: Colors.white,
     
    );
  }


   static Widget labelText(String label){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(label,style: TextStyle(fontSize: 16.0),),
            SizedBox(height: 10.0,)
          ],
        );
      }

}