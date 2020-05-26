import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        color: Hexcolor('#DFE9AC'),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Hexcolor('#DFE9AC'),
            appBar: TabBar(
              indicatorColor: Hexcolor('#97BE11'),
                tabs: [
                  Tab(icon: Icon(Icons.directions_car, color: Hexcolor('#FFA820')), child: Text('fresh', style: TextStyle(fontSize: 10.0),),),
                  Tab(icon: Icon(Icons.directions_transit, color: Hexcolor('#FFA820')), child: Text('ready to cook', style: TextStyle(fontSize: 10.0),),),
                  Tab(icon: Icon(Icons.directions_bike, color: Hexcolor('#FFA820')), child: Text('ready to eat', style: TextStyle(fontSize: 10.0),),),
                ],
              ),
            body: TabBarView(
              children: [
                Icon(Icons.directions_car),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
