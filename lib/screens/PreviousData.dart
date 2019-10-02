import 'package:flutter/material.dart';
import 'package:occipital_tech/models/get_orderId.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousData extends StatefulWidget {
  // PreviousData(this.title);
  // final String title;
  @override
  _PreviousDataState createState() => _PreviousDataState();
}

class _PreviousDataState extends State<PreviousData> {
  String _defaultMonth = "January";
  String _defaultYear = "2019";

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> years = ["2018", "2019", "2020"];

  BehaviorSubject orders = BehaviorSubject();

  void dispose() {
    super.dispose();
    orders.close();
  }

  void initState() {
    super.initState();
    _getOrders();
  }

  _getOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await ApiClient.getOrderIds(GetOrderId(
        prefs.getString('phoneNo'),
        _defaultMonth,
        prefs.getString('token'),
        _defaultYear));
    orders.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      //padding: EdgeInsets.all(16.0),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: _dropDowns(),
        ),
        Expanded(
          child: StreamBuilder(
              stream: orders,
              builder: (context, snapshot) {
                final data = snapshot.data as OrdersData;

                return snapshot.hasData
                    ? data.cities == null
                        ? Center(
                            child: Text('Nothing here'),
                          )
                        : makeTiles(data)
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        )
      ],
    ));
  }

  Widget makeTiles(OrdersData data) {
    return ListView.builder(itemBuilder: (context, index) {
      for (int i = 0; i < data.cities.length; i++) {
        return previousDataTiles(
            data.orderIds[i], data.cities[i], data.commodityStatus[i]);
      }
    });
  }

  Widget _dropDowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                onChanged: (value) {
                  setState(() {
                    _defaultMonth = value;
                  });
                  init();
                },
                //  isDense: true,
                value: _defaultMonth,
                hint: Text(months[0]),
                items: months
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                //isDense: true,
                onChanged: (value) {
                  setState(() {
                    _defaultYear = value;
                  });
                  init();
                },
                value: _defaultYear,
                hint: Text(years[0]),
                items: years
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
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
                            color: Colors.green[400]),
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

  void init() {
    orders.add(null);
    _getOrders();
  }
}
