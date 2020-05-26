import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Hexcolor('#DFE9AC'),
    appBar: AppBar(
    title: Text('Home'),
    backgroundColor: Hexcolor('#97BE11'),
    ),
    body: Container()
    );
  }
}
