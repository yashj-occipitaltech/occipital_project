import 'package:flutter/material.dart';
import 'package:occipital_tech/models/get_orderId.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/screens/OrderDataTiles.dart';
import 'package:occipital_tech/screens/OrderResultScreen.dart';
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

  Map<String, String> mappedVAL = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12"
  };

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
    print('I ran hrer');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(GetOrderId(prefs.getString('phoneNo'), mappedVAL[_defaultMonth],
            prefs.getString('token'), _defaultYear)
        .toJson());
    final data = await ApiClient.getOrderIds(GetOrderId(
        prefs.getString('phoneNo'),
        mappedVAL[_defaultMonth],
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
                            child: Text('No orders found '),
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
    return ListView.builder(
      itemCount: data.cities.length,
      itemBuilder: (context, index) {
        String status = "";
        if (data.pdfStatuses[index] == 'True' &&
            data.commodityStatus[index] == 'True' &&
            data.markerStatuses[index] == 'True') {
          status = 'Completed';
        } else {
          status = "Error";
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

  Widget _dropDowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
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
              borderRadius: BorderRadius.circular(10.0),
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

  void init() {
    orders.add(null);
    _getOrders();
  }
}
