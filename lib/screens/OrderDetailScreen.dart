import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:occipital_tech/util/widgets.dart';
import 'package:occipital_tech/util/colorValues.dart';
class OrderDetailScreen extends StatefulWidget {
  final List<String> imageUrls;
  OrderDetailScreen(this.imageUrls);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _selectedTab = 1;

  changeSelectedTab(int tab) {
    setState(() {
      _selectedTab = tab;
    });
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
                    image: NetworkImageWithRetry(widget.imageUrls[index]),
                  );
                },
                loop: false,
                itemCount: widget.imageUrls.length,
                pagination: SwiperPagination(),
                control: SwiperControl(color: Colors.white),
              ),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                tabButton('Size', 1),
                tabButton('Color', 2),
                tabButton('Defects', 3),
              ],
            )),
            Expanded(
              child: _selectedTab == 1
                  ? sizeDetail()
                  : _selectedTab == 2 ? colorDetail() : defectsDetail(),
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

  Widget sizeDetail() {
    return Center(
      child: Text('size'),
    );
  }

  Widget colorDetail() {
    return Center(
      child: Text('color'),
    );
  }

  Widget defectsDetail() {
    return Center(
      child: Text('defects'),
    );
  }
}
