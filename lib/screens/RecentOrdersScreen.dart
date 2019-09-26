import 'package:flutter/material.dart';
import 'package:occipital_tech/util/widgets.dart';


class RecentOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     // appBar: Widgets.appBar('Home'),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              previousDataTiles('12345', 'Nasik,India'),
              previousDataTiles('14567', 'Pune,India'),
              previousDataTiles('98925', 'Assam,India'),
              previousDataTiles('23390', 'Kerala,India'),
              previousDataTiles('91403', 'Goa,India'),
            ],
          ),
        ),
    );
  
  }

 Widget locationTile(String location) {
    return Container(
      width: 120.0,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45.0), color: Colors.grey[100]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.location_on,
            size: 20.0,
          ),
          Text('$location')
        ],
      ),
    );
  }

  Widget previousDataTiles(String number, String location) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Order No:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Text(
                        ' $number',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text('26-09-19,10:10 A.M')
                ],
              ),
              locationTile(location)
            ],
          ),
        ),
      ),
    );
  }
}