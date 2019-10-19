import 'package:flutter/material.dart';
import 'package:occipital_tech/screens/CommodityForm.dart';
import 'package:occipital_tech/screens/DemoVideoScreen.dart';
import 'package:occipital_tech/screens/PreviousData.dart';
import 'package:occipital_tech/screens/RecentOrdersScreen.dart';

class BottomNavigator extends StatefulWidget {
  final bool showHome;
  BottomNavigator({this.showHome = false});
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final List<String> items = ["Account", "Logout"];

  String appBarTitle = 'Home';
  final List<Widget> _children = [PreviousData(), DemoVideoScreen()];
  int _currentIndex = 0;

  setAppBarTitle(String title) {
    setState(() {
      appBarTitle = title;
    });
  }

  void initState() {
    super.initState();
    if (widget.showHome) setAppBarTitle('Home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0XFF01AF51),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommodityForm()),
          ),
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
          elevation: 2.0,
          tooltip: 'New Data',
        ),
        bottomNavigationBar: BottomAppBar(
            //color: Theme.of(context).bottomAppBarColor,
            clipBehavior: Clip.antiAlias,
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: BottomNavigationBar(
              backgroundColor: Color(0XFF01AF51),
              selectedItemColor: Colors.black54,
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                  index == 0
                      ? setAppBarTitle('See Previous Detail')
                      : setAppBarTitle('Demo Video');
                });
              },
              selectedLabelStyle: TextStyle(color: Colors.black),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    title: Column(
                      children: <Widget>[
                        Text('See Previous Detail',
                            style: TextStyle(color: Colors.white)),
                      ],
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.video_label,
                      color: Colors.white,
                    ),
                    title: Column(
                      children: <Widget>[
                        Text("Demo or Video",
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ],
            )),
        body: appBarTitle == 'Home'
            ? RecentOrdersScreen()
            : _children[_currentIndex]);
  }
}
