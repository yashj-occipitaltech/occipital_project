import 'dart:async';

import 'package:flutter/material.dart';
import 'package:occipital_tech/models/get_recent_orders.dart';
// import 'package:occipital_tech/models/order_status_check.dart';
// import 'package:occipital_tech/models/order_status_result.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/screens/CommodityForm.dart';
import 'package:occipital_tech/screens/OrderDataTiles.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentOrdersScreen extends StatefulWidget {
  @override
  _RecentOrdersScreenState createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  final BehaviorSubject orders = BehaviorSubject();

  Timer timer;

  void initState() {
    super.initState();
    _getRecentOrders();
  }

  void dispose() {
    super.dispose();
    timer?.cancel();
    orders.close();
  }

  _getRecentOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await ApiClient.getLastSomeOrders(
        GetRecentOrders(prefs.getString('phoneNo'), prefs.getString('token')));
    orders.add(data);
  }

  init() {
    orders.add(null);
    _getRecentOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[refreshIcon()],
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
                  itemCount: data.cities.length,
                  itemBuilder: (context, index) {
                    print(args?.orderId);
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
                        data.years[index],
                        index: index,recentOrderId: args?.orderId,);
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

  Widget refreshIcon() {
    return StreamBuilder<Object>(
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
        });
  }
}
