import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Hexcolor('#DFE9AC'),
        body: new Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 200.0,
                height: 200.0,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/green_veg.jpg')))),
            SizedBox(height: 15.0),
            Text(
              "Please login to order",
              textScaleFactor: 1.5,
              style: TextStyle(color: Hexcolor('#28590C')),
            ),
            SizedBox(height: 10.0),
            ButtonTheme(
              minWidth: 200.0,
              child: RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/phone-number');
                },
                child:
                    Text("Login", style: TextStyle(color: Hexcolor('#28590C'))),
              ),
            )
          ],
        )));
  }
}
