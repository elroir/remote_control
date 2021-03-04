import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:remote_app/helpers/client_handler.dart';
import 'package:remote_app/views/control.dart';
import 'package:remote_app/views/control_apple.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          title: TabBar(
            onTap: (value){
              setState(() {
                ClientHandler.instance.currentClient = value;
              });
            },
            labelStyle: TextStyle( //up to your taste
                fontWeight: FontWeight.w700
            ),
            indicatorSize: TabBarIndicatorSize.label, //makes it better
            labelColor: Color(0xff1a73e8), //Google's sweet blue
            unselectedLabelColor: Color(0xff5f6368), //niceish grey
            isScrollable: false, //up to your taste
            indicator: MD2Indicator( //it begins here
                indicatorHeight: 3,
                indicatorColor: Color(0xff1a73e8),
                indicatorSize: MD2IndicatorSize.normal //3 different modes tiny-normal-full
            ),
            tabs: <Widget>[
              Tab(
                text: "Mqtt_client",
              ),
              Tab(
                text: "OpenHAB",
              ),
            ],
          ),
        ),
        body: _callPage(_selectedItemPosition),
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.rectangle,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          padding: EdgeInsets.all(15.0),

          snakeViewColor: Colors.white60,
          selectedItemColor: SnakeShape.circle == SnakeShape.indicator ? Theme.of(context).primaryColor : null,
          unselectedItemColor: Colors.white70,

          showUnselectedLabels: true,
          showSelectedLabels: true,

          currentIndex: _selectedItemPosition,
          onTap: (index) => setState(() {
            _selectedItemPosition = index;

          }),
          items: [
            // You can change icon and label here
            BottomNavigationBarItem(icon: Icon(MaterialCommunityIcons.remote_tv),label: 'LG'),
            BottomNavigationBarItem(icon: Icon(FontAwesome.apple), label: 'TV'),
          ],

        ),
      ),
    );


  }

  _callPage(int currentPage) {
    switch ( currentPage){
      case 0: return ControlView();
      case 1: return ControlAppleView();
    }

  }
}
