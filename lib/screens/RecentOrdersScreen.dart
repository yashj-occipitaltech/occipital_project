import 'package:flutter/material.dart';
import 'package:occipital_tech/models/get_recent_orders.dart';
import 'package:occipital_tech/models/orders_data.dart';
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

  void initState() {
    super.initState();
    _getRecentOrders();
  }

  void dispose() {
    super.dispose();
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
    print(orders.value);
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
                  onRefresh: () async=> await init(),
                  child: StreamBuilder(
            stream: orders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as OrdersData;
                print(data.cities);
                if (data.cities == null || data.cities.length == 0) {
                  return Center(
                    child: Text('No orders found'),
                  );
                }

                return ListView.builder(
                  //padding: EdgeInsets.all(16.0),
                  itemCount: data.cities.length,
                  itemBuilder: (context, index) {
                    String status = "";
                    if (data.pdfStatuses[index] == 'False' &&
                        data.commodityStatus[index] == 'False' &&
                        data.markerStatuses[index] == 'False') {
                      status = 'Processing 0%';
                    } else if (data.commodityStatus[index] == 'True' &&
                        data.pdfStatuses[index] == 'False' &&
                        data.markerStatuses[index] == 'False') {
                      status = "Processing 50%";
                    } else if (data.commodityStatus[index] == 'True' &&
                        data.pdfStatuses[index] == 'True' &&
                        data.markerStatuses[index] == 'False') {
                      status = "Processing 80%";
                    } else if (data.markerStatuses[index] == 'Error') {
                      status = "Error";
                    } else if (data.commodityStatus[index] == 'True' &&
                        data.pdfStatuses[index] == 'True' &&
                        data.markerStatuses[index] == 'True') {
                      status = "Completed";
                    } else {
                      status = "Completed";
                    }
                    return OrderDataTiles(
                        data.orderNumbers[index].toString(),
                        data.cities[index],
                        "$status",
                        data.dates[index],
                        data.months[index],
                        data.commodities[index],
                        data.orderIds[index].toString(),
                        data.times[index],
                        data.years[index]);
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
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
