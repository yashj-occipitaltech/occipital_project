// import 'package:fl_chart/fl_chart.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:occipital_tech/models/get_order_data.dart';
import 'package:occipital_tech/models/order_status_check.dart';
import 'package:occipital_tech/models/orders_data.dart';
import 'package:occipital_tech/screens/OrderDetailScreen.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;
import 'package:occipital_tech/util/colorValues.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:share_extend/share_extend.dart';

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

  bool downloading = false;
  var progressString = "";

  String fileUrl = '';

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      print(url);
      await dio.download(url, "${dir.path}/${orderData.value.orderId}.pdf",
          onReceiveProgress: (rec, total) {
        if (!mounted) {
          return;
        }
        setState(() {
          fileUrl = "${dir.path}/${orderData.value.orderId}.pdf";
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Order Detail',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          StreamBuilder<Object>(
              stream: orderData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as GetOrderData;
                  return data.pdfPath != null
                      ? InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(Icons.share),
                          ),
                          onTap: ()async {
                            await downloadFile(data.pdfPath).then((dat){
                             ShareExtend.share(fileUrl, "file");
                            });
                           
                          },
                        )
                      : Container();
                }
                return Container();
              }),
          StreamBuilder<Object>(
              stream: orderData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as GetOrderData;
                  return data.pdfPath != null
                      ? InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(Icons.file_download),
                          ),
                          onTap: () async {
                            await downloadFile(data.pdfPath);
                          },
                        )
                      : Container();
                }
                return Container();
              }),
        ],
      ),
      bottomNavigationBar: downloading == true
          ? Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black26))),
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Downloading file: $progressString'),
                ],
              ),
            )
          : progressString == 'Completed'
              ? InkWell(
                  onTap: () {
                    print(fileUrl);
                    OpenFile.open(fileUrl);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black26))),
                    padding: EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Text('Open Pdf',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue[800],
                            fontSize: 16.0)),
                  ),
                )
              : SizedBox(),
      body: StreamBuilder<Object>(
          stream: orderData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final order = snapshot.data as GetOrderData;
              print(order.toJson());
              return ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  header(
                      order.city ?? 'N/A',
                      '${order.date ?? 'N/A'}-${order.month ?? 'NA'}-${order.year ?? 'N/A'}',
                      order.time ?? 'N/A',
                      order.ordernumber.toString() ?? 'N/A'),
                  SizedBox(height: 15.0),
                  Text('Average Details of All Images'),
                  SizedBox(height: 15.0),
                  sizeTable(order.range, order.frequencyArray),
                  SizedBox(height: 5.0),
                  Center(
                      child: Text(
                    '*Scroll for more data',
                    style: TextStyle(color: Colors.grey),
                  )),
                  // SizedBox(height: 5.0),
                  order.colorDetails == null
                      ? Center(
                          child: Text('No data available'),
                        )
                      : pieCharts(
                          order.colorDetails, order.colorRGB, order.colors),
                  //SizedBox(height: 15.0),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    padding: EdgeInsets.all(16.0),
                    color: Color(0XFF01AF51),
                    child: Text(
                      'Order Detail',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(order)));
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  defectsCard(order.defects, order.totalDefects)
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

  Widget sizeTable(List range, List<List> frequencyArr) {
    List avgList = [];
    List totalFreq = [];

    int index = 0;
    int length = frequencyArr[0].length;
    var tempArr = [];

    while (index < length) {
      for (var i = 0; i < frequencyArr.length; i++) {
        tempArr.add(frequencyArr[i][index]);
      }
      var value = tempArr.reduce((a, b) => a + b) / frequencyArr.length;
      avgList.add(value);
      tempArr.clear();
      index++;
    }

    var valueTwo = avgList.reduce((a, b) => a + b);

    for (var k = 0; k < avgList.length; k++) {
      totalFreq.add((avgList[k] / valueTwo) * 100);
    }

    return Center(
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10.0)),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DataTable(
                  horizontalMargin: 10.0,
                  headingRowHeight: 25.0,
                  dataRowHeight: 30.0,
                  columnSpacing: 20.0,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Size(mm)',
                      ),
                    ),
                    DataColumn(label: Text('Percentage'))
                  ],
                  rows: [
                    for (int i = 0; i < range.length - 1; i++)
                      DataRow(cells: [
                        DataCell(
                            Center(child: Text('${range[i]}-${range[i + 1]}'))),
                        DataCell(Center(
                            child: Text(
                                '${num.parse(totalFreq[i].toString()).toStringAsFixed(2)} %')))
                      ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pieCharts(List<Map<String, double>> data, Map<String, String> colorVal,
      List<String> colors) {
        
    List<charts.Series<PieChartData, String>> _seriesPieData = List();
    List<PieChartData> pieData = List<PieChartData>();
    for (var item in colors) {
      var result =
          (data.map((m) => m[item]).reduce((a, b) => a + b) / data.length) *
              100;
      var myInt = int.parse("0xFF${colorVal[item].substring(1)}");
      pieData.add(PieChartData(Color(myInt), result, item));
    }
    _seriesPieData.add(
      charts.Series(
        insideLabelStyleAccessorFn: (data,int index) => charts.TextStyleSpec(fontSize: 14),

        displayName: 'Data',
        domainFn: (PieChartData data, _) => data.x,
        measureFn: (PieChartData data, _) => data.y,
        colorFn: (PieChartData data, _) =>
            charts.ColorUtil.fromDartColor(data.color),
        id: 'Order Color Chart',
        data: pieData,
        labelAccessorFn: (PieChartData row, _) => '${num.parse(row.y.toString()).toStringAsFixed(2)}%',
      ),
    );
    return Padding(
      padding:  EdgeInsets.all(8.0),
      child: Container(
        height: 350.0,
        child: charts.PieChart(_seriesPieData,
            
            animate: true,
            animationDuration: Duration(milliseconds: 300),
            behaviors: [
               charts.DatumLegend(
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 2,
                cellPadding:  EdgeInsets.only(right: 4.0, bottom: 4.0),
                showMeasures: true
              )
            ],
            defaultRenderer:  charts.ArcRendererConfig(
                arcWidth: 100,
                arcRendererDecorators: [
                   charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.inside)
                ])),
      ),
    );
  }

  Widget showPieChart(List<Map<String, double>> data,
      Map<String, String> colorVal, List<String> colors) {
    List<CircularSegmentEntry> pieData = List<CircularSegmentEntry>();
    for (var item in colors) {
      var result =
          (data.map((m) => m[item]).reduce((a, b) => a + b) / data.length) *
              100;
      var myInt = int.parse("0xFF${colorVal[item].substring(1)}");
      pieData.add(CircularSegmentEntry(result, Color(myInt)));
    }
    return AnimatedCircularChart(
      //key: _chartKey,
      size: const Size(300.0, 300.0),
      initialChartData: [CircularStackEntry(pieData)],
      chartType: CircularChartType.Pie,
    );
  }

  Widget buildPieChart(List<Map<String, double>> data,
      Map<String, String> colorVal, List<String> colors) {
    List<PieChartData> pieData = List<PieChartData>();
    for (var item in colors) {
      var result =
          (data.map((m) => m[item]).reduce((a, b) => a + b) / data.length) *
              100;
      var myInt = int.parse("0xFF${colorVal[item].substring(1)}");
      pieData.add(PieChartData(Color(myInt), result, item));
      // avgArr.add(result);
      // dataTwo.add({"$item": result});
    }
    return Center(
      child: Container(
        height: 300.0,
        width: 300.0,
        child: SfCircularChart(
          series: [
            PieSeries(
                dataSource: pieData,
                pointColorMapper: (data, _) => data.color,
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y)
          ],
        ),
      ),
    );
  }

  Widget defectsCard(
      List<Map<String, String>> data, List<String> totalDefects) {
    num _defectVal;
    // for (var item in totalDefects) {
    //  _defectVal =
    //       (data.map((m) => num.parse(m[item])).reduce((a, b) => a + b) / data.length) *
    //           100;
    // }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Defects', style: TextStyle(fontSize: 16.0)),
            Container(
              padding: EdgeInsets.all(10.0),
              width: 90.0,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30.0)),
              child: Center(
                  child: Text(
                '${data[0]['Defective']}',
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
        TableRow(
          children: [Text('Size'), Text('Percentage')],
        ),
        TableRow(
          children: [Text('Size'), Text('113')],
        ),
        TableRow(
          children: [Text('12'), Text('113')],
        ),
      ],
    );
  }
}

class PieChartData {
  final String x;
  final double y;
  final Color color;

  PieChartData(this.color, this.y, this.x);
}
