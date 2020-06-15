import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SuccessTick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                Text('Order Placed', style: TextStyle(color:  Colors.green[900], fontWeight: FontWeight.w900),),
                SizedBox(height: 10.0,),
                RaisedButton(
                  color: Colors.green[500],
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text("Back home",
                      style: TextStyle(color: Colors.green[900])),
                )
              ],
            ),
          ),
        ));
  }
}
