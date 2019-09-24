import 'package:flutter/material.dart';



class Widgets{
  static Widget appBar(String title,bool showPopup){
  final List<String> items = ["Account", "Logout"];
    return AppBar(
      elevation: 0.0,
      title: Text(title,style: TextStyle(color: Colors.black),),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: <Widget>[
           showPopup ? PopupMenuButton(
              icon: Icon(
                Icons.account_box,
                color: Colors.black,
              ),
              itemBuilder: (context) => items
                  .map((data) => PopupMenuItem(
                        child: Text(data),
                        value: data,
                      ))
                  .toList(),
            ):Container()
          ],
    );
  }
}