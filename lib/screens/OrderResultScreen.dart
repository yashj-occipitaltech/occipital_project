// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:occipital_tech/models/get_order_data.dart';
import 'package:occipital_tech/models/order_status_check.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/screens/OrderDetailScreen.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;
import 'package:occipital_tech/util/colorValues.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderResultScreen extends StatefulWidget {
  final String orderId;
  OrderResultScreen(this.orderId);
  @override
  _OrderResultScreenState createState() => _OrderResultScreenState();
}

class _OrderResultScreenState extends State<OrderResultScreen> {
  BehaviorSubject<GetOrderData> orderData = BehaviorSubject<GetOrderData>();

  void initState() {
    super.initState();
    _getOrderData();
  }

  void dispose() {
    super.dispose();
    orderData.close();
  }

  _getOrderData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GetOrderData data = await ApiClient.getOrderData(
        OrderStatusCheck(widget.orderId, prefs.getString('token')));
    orderData.add(data);
  }

  @override
  Widget build(BuildContext context) {
    // print(orderData.orderId);
    return Scaffold(
      appBar: Widgets.appBar('Result'),
      body: StreamBuilder<Object>(
          stream: orderData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final order = snapshot.data as GetOrderData;
              final colors = order.colors.forEach((String f) => f);
              print(order.toJson());
              return ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  header(
                      order.city,
                      '${order.date}-${order.month}-${order.year}',
                      order.time,
                      order.ordernumber),
                  SizedBox(height: 15.0),
                  Text('Average Details of All Images'),
                  SizedBox(height: 15.0),
                  sizeTable(),
                  pieCharts(order.colorDetails[0]),
                  SizedBox(height: 15.0),
                  FlatButton(
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30.0) ),
                    padding: EdgeInsets.all(16.0),
                    color: Color(0XFF01AF51),
                    child: Text('Order Detail',style: TextStyle(color:Colors.white,fontSize: 16.0 ),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(order.imageURLs)));
                  }
                  ,)
                  //defectsCard(order.defects[0]['Defective'])
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Some error occured'),
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget header(
      String location, String fullDate, String time, String orderNumber) {
    return Card(
      margin: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Order No: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      '$orderNumber',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Color(0XFF01AF51)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Text('$fullDate, $time')
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 15.0,
                  color: Colors.red,
                ),
                Text('$location'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget sizeTable() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.black)
          //color: Colors.red
          ),
      child: DataTable(
        headingRowHeight: 25.0,
        dataRowHeight: 30.0,
        columnSpacing: 10.0,
        columns: [
          DataColumn(
            label: Container(
              child: Text('Size(mm)'),
              color: Colors.red,
            ),
          ),
          DataColumn(label: Text('Percentage'))
        ],
        rows: [
          DataRow(cells: [DataCell(Text('12')), DataCell(Text('14'))]),
          DataRow(cells: [DataCell(Text('16')), DataCell(Text('18'))]),
        ],
      ),
    );
  }

  Widget pieCharts(Map<String, double> data) {
    Map<String, double> dataMap = Map<String, double>();
    data.forEach((k, v) {
      dataMap[k] = v * 100;
    });
    return PieChart(
      dataMap: dataMap,
      legendFontColor: Colors.blueGrey[900],
      legendFontSize: 14.0,
      legendFontWeight: FontWeight.w500,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery.of(context).size.width / 1.6,
      showChartValuesInPercentage: true,
      showChartValues: true,
      chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
      colorList: [Colors.orange, Colors.red, Colors.yellow, Colors.green],
      showLegends: false,
      initialAngle: math.pi * 0.5,

    );
  }

  Widget buildPieChart(){
    return SfCircularChart(
      series: [
        PieSeries(
          // dataSource: 
        )
      ],
    );
  }

  getColors(){

  }

  Widget defectsCard(double defect) {
    final _defectVal = num.parse((defect * 100).toStringAsFixed(0));
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Defects',style: TextStyle(fontSize: 16.0)),
            Container(
              padding: EdgeInsets.all(10.0),
              width: 60.0,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30.0)),
              child: Center(
                  child: Text(
                '$_defectVal%',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget sizeTables() {
    return Table(
      border: TableBorder.all(),
      children: [
        // TableRow(children: )
      ],
    );
  }
}


class PieChartData{
  final String value;
  final double percentage;
  final Color color;

  PieChartData(this.color,this.percentage,this.value);
}