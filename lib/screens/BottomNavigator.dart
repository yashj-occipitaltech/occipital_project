import 'package:flutter/material.dart';
import 'package:occipital_tech/main.dart';
import 'package:occipital_tech/screens/CommodityForm.dart';
import 'package:occipital_tech/screens/ContactScreen.dart';
import 'package:occipital_tech/screens/DemoVideoScreen.dart';
import 'package:occipital_tech/screens/HelpScreen.dart';
import 'package:occipital_tech/screens/PreviousData.dart';
import 'package:occipital_tech/screens/RecentOrdersScreen.dart';
import 'package:occipital_tech/screens/SettingsScreen.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:occipital_tech/util/widgets.dart';

class BottomNavigator extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Widgets.appBar(
          appBarTitle,
        ),
        drawer: AppDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[600],
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
            clipBehavior: Clip.antiAlias,
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: BottomNavigationBar(
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
                    icon: Icon(Icons.history),
                    title: Column(
                      children: <Widget>[
                        Text('See Previous Detail'),
                      ],
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.video_label),
                    title: Column(
                      children: <Widget>[Text("Demo or Video")],
                    )),
              ],
            )),
        body: appBarTitle == 'Home'
            ? RecentOrdersScreen()
            : _children[_currentIndex]);
  }

  Widget drawerTiles(String name, Widget screen, IconData iconName) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(iconName),
          SizedBox(
            width: 10.0,
          ),
          Text(name)
        ],
      ),
      onTap: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => screen)),
    );
  }
}

class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  ShapeBorder lerpFrom(ShapeBorder a ,double t){
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0));
  }
  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }

 
}
