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
        body: Center(
            child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
          child: Column(
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
              SizedBox(
                width: double.infinity,
                child: Text(
                  "ACCOUNT",
                  style: TextStyle(color: Hexcolor('#28590C'), fontSize: 16.0,),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Login/create account to quickly manage orders",
                  style: TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0,),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Hexcolor('#97BE11'),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/phone-number');
                  },
                  child: Text("Login",
                      style: TextStyle(color: Hexcolor('#28590C'))),
                ),
              ),
            ],
          ),
        )));
  }
}
