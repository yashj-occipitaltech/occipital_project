import 'package:flutter/material.dart';
import 'package:occipital_tech/screens/OrderResultScreen.dart';
import 'package:occipital_tech/util/colorValues.dart';

class OrderDataTiles extends StatelessWidget {
  final String number;
  final String location;
  final String status;
  final String date;
  final String month;
  final String commodity;
  final String orderId;
  final String time;
  final String year;
  OrderDataTiles(this.number, this.location, this.status, this.date, this.month,
      this.commodity, this.orderId, this.time, this.year);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(orderId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderResultScreen(orderId)));
      },
      child: Card(
        elevation: 0.8,
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
                            color: Color(0XFF01AF51)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text("$commodity",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8.0,
                  ),
                  locationTile(location, date, month, time, year)
                ],
              ),
            ),
            statusChip(status)
          ],
        ),
      ),
    );
  }

  Widget statusChip(String status) {
    return Container(
      width: 100.0,
      padding: EdgeInsets.all(10.0),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      decoration: BoxDecoration(
          color: getColorForStatus(status),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0))),
    );
  }

  Widget locationTile(
      String location, String date, String month, String time, String year) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.location_on,
          size: 15.0,
          color: Colors.red,
        ),
        Text('$location, '),
        Text('$date-$month-${year.substring(2)}, $time'),
      ],
    );
  }

  Color getColorForStatus(String status) {
    print('---->');
    print(status);
    switch (status) {
      case 'Error':
        return Colors.red;
        break;
      case 'Completed':
        return Colors.green[600];
        break;
      case 'Processing 0%':
        return Colors.orange[600];
        break;
      case 'Processing 50%':
        return Colors.orange[600];
        break;
      case 'Processing 80%':
        return Colors.orange[600];

        break;
    }
  }
}
