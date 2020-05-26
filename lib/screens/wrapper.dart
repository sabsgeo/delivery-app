import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/screens/authenticate/authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Text(
        'Index 0: Home',
      ),
      Authenticate()
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20.0,
        backgroundColor: Hexcolor('#DFE9AC'),
        elevation: 50.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: Hexcolor('#FFA820'),),
            title: Text('Items', style: TextStyle(fontSize: 12.0, color: Hexcolor('#FFA820')),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box, color: Hexcolor('#FFA820'),),
            title: Text('Account', style: TextStyle(fontSize: 12.0, color: Hexcolor('#FFA820')),),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
