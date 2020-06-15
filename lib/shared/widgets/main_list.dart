import 'package:flutter/material.dart';

class MainItemCard extends StatelessWidget {
  final String localImage;
  final double height;
  final Function onTap;
  final String mainText;
  MainItemCard(
      {@required this.localImage,
      this.height,
      this.onTap,
      @required this.mainText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height == null ? 120.0 : this.height,
      child: GestureDetector(
        onTap: () {
          this.onTap();
        },
        child: Card(
          child: Row(
            children: <Widget>[
              SizedBox(width: 150.0, child: ClipRRect(child: Image.asset(this.localImage, fit: BoxFit.fill))),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      this.mainText,
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(fontSize: 12.0, color: Colors.green[900]),
                    )),
                    SizedBox(
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 18.0,
                          color: Colors.amber[500],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
