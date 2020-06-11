import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SuccessTick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Hexcolor('#DFE9AC'),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 250.0,
                  child: FlareActor(
                    "assets/flare/status_success.flr",
                    animation: "success",
                  ),
                ),
                Text('Order Placed', style: TextStyle(color:  Hexcolor('#28590C'), fontWeight: FontWeight.w900),),
                SizedBox(height: 10.0,),
                RaisedButton(
                  color: Hexcolor('#97BE11'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text("Back home",
                      style: TextStyle(color: Hexcolor('#28590C'))),
                )
              ],
            ),
          ),
        ));
  }
}
