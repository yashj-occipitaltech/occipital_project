import 'package:flutter/material.dart';



class RecentOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     // appBar: Widgets.appBar('Home'),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              previousDataTiles('12345', 'Nasik,India','Processing'),
              previousDataTiles('14567', 'Pune,India','Uploaded'),
              previousDataTiles('98925', 'Assam,India','Uploaded'),
              previousDataTiles('23390', 'Kerala,India','Completed'),
              previousDataTiles('91403', 'Goa,India','Completed'),
            ],
          ),
        ),
    );
  
  }

 Widget locationTile(String location) {
    return 
       Row(
         mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.location_on,
            size: 20.0,
          ),
          Text('$location')
        ],
      );
    
  }

  Widget previousDataTiles(String number, String location,String status) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 1.0,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
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
                              color: Colors.green[400]),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text('26-09-19,10:10 A.M'),
                    SizedBox(height: 10.0,),
                    locationTile(location)
                  ],
                ),
              ),

              statusChip(status)
              
            ],
          ),
        
      ),
    );
  }



   Color getColorForStatus(String status) {
    switch (status) {
      case 'Uploaded':
        return Colors.yellow[700];
        break;
      case 'Completed':
        return Colors.green[600];
        break;
      case 'Processing':
        return Colors.orange[600];
        
        break;
    }
  }


  Widget statusChip(String status){
    return Container(
      width: 100.0,
      padding: EdgeInsets.all(10.0),
      child: Text(status,textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
      decoration: BoxDecoration(
        color: getColorForStatus(status),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0),bottomLeft: Radius.circular(50.0))
      ),
    );
  }
}