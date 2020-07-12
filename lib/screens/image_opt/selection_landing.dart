
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionLanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.aBeeZeeTextTheme()),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.height >
                        MediaQuery.of(context).size.width
                        ? MediaQuery.of(context).size.width * .75
                        : MediaQuery.of(context).size.height * .75,
                    height: MediaQuery.of(context).size.height >
                        MediaQuery.of(context).size.width
                        ? MediaQuery.of(context).size.width * .75
                        : MediaQuery.of(context).size.height * .75,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/online-shopping.jpg')))),
                SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green[500],
                    onPressed: () {
                      Map<String, dynamic> data = {};
                      Navigator.pushNamed(context, '/image-crop', arguments: data);
                    },
                    child: Text("ADD ITEMS",
                        style: TextStyle(color: Colors.green[900])),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green[500],
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit-items');
                    },
                    child: Text("EDIT ITEMS",
                        style: TextStyle(color: Colors.green[900])),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}
