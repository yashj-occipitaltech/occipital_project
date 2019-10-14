import 'dart:async';

import 'package:flutter/material.dart';
import 'package:occipital_tech/models/get_recent_orders.dart';
import 'package:occipital_tech/models/order_status_check.dart';
import 'package:occipital_tech/models/order_status_result.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/screens/CommodityForm.dart';
import 'package:occipital_tech/screens/OrderDataTiles.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:occipital_tech/util/colorValues.dart';

class RecentOrdersScreen extends StatefulWidget {
  @override
  _RecentOrdersScreenState createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  final BehaviorSubject orders = BehaviorSubject();
  final BehaviorSubject mostRecentOrder = BehaviorSubject();
  Timer timer;

  void initState() {
    super.initState();

    //timer = Timer.periodic(Duration(seconds: 5), (Timer t) => init());
    // print(timer.tick.toString());
   // _getArgs();
    _getRecentOrders();
    //  _checkOrderStatus();
  }

  void dispose() {
    super.dispose();
    timer?.cancel();
    orders.close();
    mostRecentOrder.close();
  }

  _getRecentOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await ApiClient.getLastSomeOrders(
        GetRecentOrders(prefs.getString('phoneNo'), prefs.getString('token')));
    orders.add(data);
  }

  _checkOrderStatus(String orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final OrderStatusResult data = await ApiClient.checkStatus(
        OrderStatusCheck(orderId, prefs.getString('token')));
    mostRecentOrder.add(data);
    // print(data)
    // orders.add(data);
  }

  bool _getArgs()  {
    final ScreenArgs args = ModalRoute.of(context).settings.arguments;
    print(args.toString());
    if (args.orderId != null) {
       _checkOrderStatus(args.orderId);
      return true;
    } else {
      return false;
    }
  }

  init() {
    orders.add(null);
    _getRecentOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            StreamBuilder<Object>(
                stream: orders,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: orders.value == null
                        ? Center(
                            child: Container(),
                          )
                        : InkWell(
                            onTap: () {
                              init();
                            },
                            child: Icon(Icons.refresh)),
                  );
                })
          ],
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          title: Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () async => await init(),
          child: StreamBuilder(
            stream: orders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as OrdersData;
                if (data.cities == null || data.cities.length == 0) {
                  return Center(
                    child: Text('No orders found'),
                  );
                }

                return ListView.builder(
                  //padding: EdgeInsets.all(16.0),
                  itemCount: data.cities.length,
                  itemBuilder: (context, index) {
                    // String status = "";
                    // if (data.pdfStatuses[index] == 'False' &&
                    //     data.commodityStatus[index] == 'False' &&
                    //     data.markerStatuses[index] == 'False') {
                    //   status = 'Processing 0%';
                    // } else if (data.commodityStatus[index] == 'True' &&
                    //     data.pdfStatuses[index] == 'False' &&
                    //     data.markerStatuses[index] == 'False') {
                    //   status = "Processing 50%";
                    // } else if (data.commodityStatus[index] == 'True' &&
                    //     data.pdfStatuses[index] == 'True' &&
                    //     data.markerStatuses[index] == 'False') {
                    //   status = "Processing 80%";
                    // } else if (data.markerStatuses[index] == 'Error') {
                    //   status = "Error";
                    // } else if (data.commodityStatus[index] == 'True' &&
                    //     data.pdfStatuses[index] == 'True' &&
                    //     data.markerStatuses[index] == 'True') {
                    //   status = "Completed";
                    // } else {
                    //   status = "Completed";
                    // }
                    // if (index == 0 && _getArgs()==true) {
                      // return StreamBuilder<Object>(
                      //     stream: mostRecentOrder,
                      //     builder: (context, recentOrderSnapshot) {
                      //       final recentOrderData =
                      //           recentOrderSnapshot as OrderStatusResult;
                      //       return OrderDataTiles(
                      //           data.orderNumbers[index].toString(),
                      //           data.cities[index],
                      //           statusString(
                      //               recentOrderData.pdfStatus,
                      //               recentOrderData.commodityStatus,
                      //               recentOrderData.markerStatus),
                      //           data.dates[index],
                      //           data.months[index],
                      //           data.commodities[index],
                      //           data.orderIds[index].toString(),
                      //           data.times[index],
                      //           data.years[index]);
                      //     });
                    // } 
                    // else {
                       return OrderDataTiles(
                          data.orderNumbers[index].toString(),
                          data.cities[index],
                          statusString(
                              data.pdfStatuses[index],
                              data.commodityStatus[index],
                              data.markerStatuses[index]),
                          data.dates[index],
                          data.months[index],
                          data.commodities[index],
                          data.orderIds[index].toString(),
                          data.times[index],
                          data.years[index]);
                    // }
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
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

  Widget locationTile(String location) {
    return Row(
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

  Widget previousDataTiles(String number, String location, String status) {
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
                            color: Color(0XFF01AF51)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text('26-09-19,10:10 A.M'),
                  SizedBox(
                    height: 10.0,
                  ),
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
}
