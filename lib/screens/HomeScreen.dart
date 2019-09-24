import 'package:flutter/material.dart';
import 'package:occipital_tech/screens/CommodityForm.dart';
import 'package:occipital_tech/screens/DemoVideoScreen.dart';
import 'package:occipital_tech/screens/PreviousData.dart';
import 'package:occipital_tech/screens/RecentOrdersScreen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> items = ["Account", "Logout"];
  final List<Widget> _children = [
    PreviousData(),
    RecentOrdersScreen(),
    DemoVideoScreen()
  ];
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[600],
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommodityForm()),
          ),
          child: Icon(Icons.add,size: 30.0,),
          elevation: 2.0,
          tooltip: 'New Data',
        ),
        bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedLabelStyle: TextStyle(color: Colors.black),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    title: Column(
                      children: <Widget>[Text('See Previous'), Text('Detail')],
                    )),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon: Icon(
                    Icons.home,
                    size: 0.0,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.video_label),
                    title: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5.0,
                        ),
                        Text("Demo or Video")
                      ],
                    )),
              ],
            )),
        body: _children[_currentIndex]);
  }
}
