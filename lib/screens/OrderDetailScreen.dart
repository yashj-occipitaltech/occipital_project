import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:occipital_tech/models/get_order_data.dart';
import 'package:occipital_tech/screens/OrderResultScreen.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class OrderDetailScreen extends StatefulWidget {
  final GetOrderData orderData;
  OrderDetailScreen(this.orderData);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _selectedTab = 1;
  int indexImg = 0;

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  
  

  changeSelectedTab(int tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Widgets.appBar('Order Detail',backToHome: false,context: context),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image(
                    filterQuality: FilterQuality.low,
                    image: NetworkImageWithRetry(
                        widget.orderData.imageURLs[index]),
                  );
                },
                onIndexChanged: (int index) {
                  setState(() {
                    indexImg = index;
                  });
                  // _changePieData(widget.orderData.colorDetails[index],
                  //         widget.orderData.colorRGB, widget.orderData.colors);
                },
                loop: false,
                itemCount: widget.orderData.imageURLs.length,
                pagination: SwiperPagination(),
                control: SwiperControl(color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                tabButton('Size', 1),
                tabButton('Color', 2),
                tabButton('Defects', 3),
              ],
            ),
            SingleChildScrollView(
              child: _selectedTab == 1
                  ? sizeDetail(widget.orderData.range,
                      widget.orderData.frequencyArray[indexImg])
                  : _selectedTab == 2
                      ? pieCharts(widget.orderData.colorDetails[indexImg],
                          widget.orderData.colorRGB, widget.orderData.colors)
                      : Padding(padding: EdgeInsets.symmetric(vertical: 120.0,horizontal: 16.0),child: defectsDetail(widget.orderData.defects[indexImg],widget.orderData.totalDefects),),
            )
          ],
        ),
      ),
    );
  }

  Widget tabButton(String text, int tab) {
    return Flexible(
      flex: 1,
      child: InkWell(
          onTap: () {
            changeSelectedTab(tab);
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
                border: tab == _selectedTab
                    ? Border(bottom: BorderSide(color: Color(0XFF01AF51)))
                    : Border()),
            child: Text(
              '$text',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight:
                      tab == _selectedTab ? FontWeight.bold : FontWeight.normal,
                  color: tab == _selectedTab ? Colors.green : Colors.black),
            ),
          )),
    );
  }

  Widget sizeDetail(List range, List frequencyArr) {
    List totalFreq = [];
    var totalVal = frequencyArr.reduce((a, b) => a + b);

    for (var i = 0; i < frequencyArr.length; i++) {
      totalFreq.add((frequencyArr[i] / totalVal) * 100);
    }

    // updatePiechartData();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: 
          Container(
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10.0)),
          child: DataTable(
            headingRowHeight: 25.0,
            dataRowHeight: 30.0,
            columnSpacing: 10.0,
            columns: [
              DataColumn(
                label: Container(
                  child: Text('Size(mm)'),
                  // color: Colors.red,
                ),
              ),
              DataColumn(label: Text('Percentage'))
            ],
            rows: [
              for (int i = 0; i < range.length - 1; i++)
                DataRow(cells: [
                  DataCell(Text('${range[i]}-${range[i + 1]}')),
                  DataCell(Text(
                      '${num.parse(totalFreq[i].toString()).toStringAsFixed(2)} %'))
                ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorDetail(Map<String, double> colorDetail,
      Map<String, String> colorVal, List<String> colors) {
    List<CircularSegmentEntry> pieData = List<CircularSegmentEntry>();
    for (var item in colors) {
      var result = colorDetail[item] * 100;
      var myInt = int.parse("0xFF${colorVal[item].substring(1)}");
      pieData.add(CircularSegmentEntry(result, Color(myInt)));
    }

    return AnimatedCircularChart(
     key: _chartKey,
      size: Size(300.0, 300.0),
      initialChartData: [CircularStackEntry(pieData)],
      chartType: CircularChartType.Pie,
      percentageValues: true,
    );
  }

   Widget pieCharts(Map<String, double> colorDetail,
      Map<String, String> colorVal, List<String> colors) {
        
    List<charts.Series<PieChartData, String>> _seriesPieData = List();
    List<PieChartData> pieData = List<PieChartData>();
    for (var item in colors) {
      var result = colorDetail[item] * 100;
      var myInt = int.parse("0xFF${colorVal[item].substring(1)}");
      pieData.add(PieChartData(Color(myInt), result, item));
    }
    _seriesPieData.add(
      charts.Series(
        insideLabelStyleAccessorFn: (data,int index) => charts.TextStyleSpec(),
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
        height: MediaQuery.of(context).size.height * 0.45,
        child: charts.PieChart(_seriesPieData,
            animate: true,
            animationDuration: Duration(milliseconds: 300),
            behaviors: [
               charts.DatumLegend(
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 2,
                cellPadding:  EdgeInsets.only(right: 4.0, bottom: 4.0),
                
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


  void _changePieData(Map<String, double> colorDetail,
      Map<String, String> colorVal, List<String> colors){
        List<CircularSegmentEntry> pieData = List<CircularSegmentEntry>();
    for (var item in colors) {
      var result = colorDetail[item] * 100;
      var myInt = int.parse("0xFF${colorVal[item].substring(1)}");
      pieData.add(CircularSegmentEntry(result, Color(myInt)));
    }
    setState(() {
      print([CircularStackEntry(pieData)].first.entries);
    _chartKey.currentState.updateData([CircularStackEntry(pieData)]);
  });
  }

  Widget defectsDetail(Map<String,String> data,List<String> totalDefects) {
    // num _defectVal =0;
    // for(var item in totalDefects){
    //   _defectVal += num.parse(data[item])*100;
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
                '${data['Defective'].toString()}',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
            )
          ],
        ),
      ),
    );
  }
}
