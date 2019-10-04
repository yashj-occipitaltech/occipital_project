import 'package:flutter/material.dart';



class Widgets{
  static Widget appBar(String title,{bool showRefresh=false}){
    return AppBar(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right:15.0),
          child: showRefresh ? InkWell(onTap: (){},child: Icon(Icons.refresh)):Container(),
        )
      ],
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