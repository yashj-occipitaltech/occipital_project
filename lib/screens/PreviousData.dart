import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:occipital_tech/models/get_orderId.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/screens/OrderDataTiles.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousData extends StatefulWidget {
  // PreviousData(this.title);
  // final String title;
  @override
  _PreviousDataState createState() => _PreviousDataState();
}

class _PreviousDataState extends State<PreviousData> {
  final now = DateTime.now();
  String _defaultMonth = DateFormat("MMMM").format(DateTime.now()).toString();
  String _defaultYear = DateTime.now().year.toString();


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
  List<String> years = ["2018"];

  BehaviorSubject orders = BehaviorSubject();

  void addYears(){
    for(int i = 0 ; i<10;i++){
      years.add('${now.year+i}');
    }
  }

  void dispose() {
    super.dispose();
    orders.close();
  }

  void initState() {
    super.initState();
    _getOrders();
     addYears();
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
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          title: Text(
            'See Previous Detail',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        drawer: AppDrawer(),
        body: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: _dropDowns(),
        ),
        Expanded(
          child: RefreshIndicator(
                      onRefresh: () => _getOrders(),
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
          ),
        )
      ],
    ));
  }

  Widget makeTiles(OrdersData data) {
    return ListView.builder(
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
        }else{
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
