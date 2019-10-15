import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:occipital_tech/models/get_order_data.dart';
import 'package:occipital_tech/util/widgets.dart';

class OrderDetailScreen extends StatefulWidget {
  final GetOrderData orderData;
  OrderDetailScreen(this.orderData);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _selectedTab = 1;
  int indexImg = 0;
  

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
        appBar: Widgets.appBar('Order Detail'),
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
                      ? colorDetail(widget.orderData.colorDetails[indexImg],
                          widget.orderData.colorRGB, widget.orderData.colors)
                      : defectsDetail(),
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

    return SingleChildScrollView(
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
     // key: _chartKey,
      size: Size(300.0, 300.0),
      initialChartData: [CircularStackEntry(pieData)],
      chartType: CircularChartType.Pie,
      percentageValues: true,
    );
  }

  Widget defectsDetail() {
    return Center(
      child: Text('defects'),
    );
  }
}
