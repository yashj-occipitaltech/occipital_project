import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:occipital_tech/models/order_status_check.dart';
import 'package:occipital_tech/models/order_status_result.dart';
import 'package:occipital_tech/screens/OrderResultScreen.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDataTiles extends StatefulWidget {
  final String number;
  final String location;
  final String status;
  final String date;
  final String month;
  final String commodity;
  final String orderId;
  final String time;
  final String year;
  final int index;
  final String recentOrderId;
  OrderDataTiles(this.number, this.location, this.status, this.date, this.month,
      this.commodity, this.orderId, this.time, this.year,
      {this.index, this.recentOrderId});

  @override
  _OrderDataTilesState createState() => _OrderDataTilesState();
}

class _OrderDataTilesState extends State<OrderDataTiles> {
  final recentOrderStatus = BehaviorSubject();
  Timer timer;

  void dispose() {
    super.dispose();
    recentOrderStatus.close();
    timer?.cancel();
  }

  checkStatus(String orderId) async {
    print('Running ');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final OrderStatusResult data = await ApiClient.checkStatus(
        OrderStatusCheck(orderId, prefs.getString('token')));
    recentOrderStatus.add(
        statusString(data.pdfStatus, data.commodityStatus, data.markerStatus));
    print(recentOrderStatus.value);
  }

  void initState() {
    super.initState();
    if (widget.status != 'Completed') {
      if (widget.index == 0 && widget.recentOrderId != null) {
        timer = Timer.periodic(Duration(seconds: 20), (timer) {
          if (recentOrderStatus.value == 'Completed') {
            cancelTimer();
          } else {
            checkStatus(widget.orderId);
          }
        });
      }
    } else {}
  }

  cancelTimer() {
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: recentOrderStatus,
        builder: (context, snapshot) {
          return InkWell(
              onTap: () {
                if (widget.index == 0 &&
                    widget.recentOrderId != null &&
                    widget.status != 'Completed') {
                  if (snapshot.hasData) {
                    if (snapshot.data == 'Completed') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderResultScreen(widget.orderId)));
                    } else {
                      Fluttertoast.showToast(msg: 'Still Processing');
                    }
                  }
                } else if (widget.status == 'Completed') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderResultScreen(widget.orderId)));
                }
              },
              child: cardUi());
        });
  }

  Widget cardUi() {
    return Card(
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
                      ' ${widget.number}',
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
                Text("${widget.commodity}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8.0,
                ),
                locationTile(widget.location, widget.date, widget.month,
                    widget.time, widget.year),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                    '${widget.date}-${widget.month}-${widget.year.substring(2)}, ${widget.time.substring(0, 5)}'),
              ],
            ),
          ),
          widget.index == 0 &&
                  widget.recentOrderId != null &&
                  widget.status != 'Completed'
              ? streamStatus()
              : statusChip(widget.status)
        ],
      ),
    );
  }

  Widget streamStatus() {
    return StreamBuilder<Object>(
        stream: recentOrderStatus,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: 120.0,
              padding: EdgeInsets.all(10.0),
              child: Text(
                snapshot.data.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  color: getColorForStatus(snapshot.data.toString()),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0))),
            );
          } else {
            return Container(
              width: 120.0,
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Processing 0 %',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  color: getColorForStatus('Processing 0%'),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0))),
            );
          }
        });
  }

  String statusString(
      String pdfStatus, String commodityStatus, String markerStatus) {
    String status = "";
    if (pdfStatus == 'False' &&
        commodityStatus == 'False' &&
        markerStatus == 'False') {
      status = 'Processing 0%';
    } else if (commodityStatus == 'True' &&
        pdfStatus == 'False' &&
        markerStatus == 'False') {
      status = "Processing 50%";
    } else if (commodityStatus == 'True' &&
        pdfStatus == 'True' &&
        markerStatus == 'False') {
      status = "Processing 80%";
    } else if (markerStatus == 'Error') {
      status = "Error";
    } else if (commodityStatus == 'True' &&
        pdfStatus == 'True' &&
        markerStatus == 'True') {
      status = "Completed";
    } else {
      status = "Completed";
    }

    return status;
  }

  Widget statusChip(String status) {
    return Container(
      width: 120.0,
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
        Text(
          '$location',
          overflow: TextOverflow.clip,
          softWrap: true,
        ),
        // Text('$date-$month-${year.substring(2)}, $time'),
      ],
    );
  }

  Color getColorForStatus(String status) {
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
      case 'Loading':
        return Colors.blue;
        break;
    }
  }
}
