import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

class IncrementDecrementButton extends StatefulWidget {
  final int index;
  final Function onIncrement;
  final Function onDecrement;
  IncrementDecrementButton(
      {@required this.index, this.onIncrement, this.onDecrement});
  @override
  _IncrementDecrementButtonState createState() =>
      _IncrementDecrementButtonState();
}

class _IncrementDecrementButtonState extends State<IncrementDecrementButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              height: 18.0,
              width: 18.0,
              child: RawMaterialButton(
                onPressed: () {
                  setState(() {
                    if (appData.orderedItems.containsKey(
                            appData.freshGreen[this.widget.index].uid) &&
                        appData.orderedItems[appData
                                .freshGreen[this.widget.index].uid]['num'] >
                            0) {
                      appData.orderedItems[appData
                          .freshGreen[this.widget.index].uid]['num'] -= 1;
                    } else {
                      appData.orderedItems
                          .remove(appData.freshGreen[this.widget.index].uid);
                    }
                  });
                  if (this.widget.onDecrement != null) {
                    this.widget.onDecrement();
                  }
                },
                fillColor: Hexcolor('#97BE11'),
                child: Icon(
                  Icons.remove,
                  size: 12.0,
                  color: Hexcolor('#28590C'),
                ),
                padding: EdgeInsets.all(0.0),
                shape: CircleBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: SizedBox(
                  height: 18.0,
                  width: 18.0,
                  child: Center(
                      child: Text(
                          appData.orderedItems[appData
                                      .freshGreen[this.widget.index].uid] ==
                                  null
                              ? "0"
                              : appData.orderedItems[appData
                                      .freshGreen[this.widget.index].uid]['num']
                                  .toString(),
                          style: TextStyle(
                              fontSize: 12.0, color: Hexcolor('#28590C')),
                          textAlign: TextAlign.center))),
            ),
            SizedBox(
              height: 18.0,
              width: 18.0,
              child: RawMaterialButton(
                onPressed: () {
                  setState(() {
                    if (appData.orderedItems.containsKey(
                        appData.freshGreen[this.widget.index].uid)) {
                      appData.orderedItems[appData
                          .freshGreen[this.widget.index].uid]['num'] += 1;
                    } else {
                      appData.orderedItems[
                          appData.freshGreen[this.widget.index].uid] = {
                        'num': 1,
                        'index': this.widget.index,
                        'name': appData.freshGreen[this.widget.index].name,
                        'minQuantity':
                            appData.freshGreen[this.widget.index].minQuantity,
                        'price': appData.freshGreen[this.widget.index].price,
                        'isVeg': appData.freshGreen[this.widget.index].isVeg
                      };
                    }
                  });
                  if (this.widget.onIncrement != null) {
                    this.widget.onIncrement();
                  }
                },
                fillColor: Hexcolor('#97BE11'),
                child: Icon(
                  Icons.add,
                  size: 12.0,
                  color: Hexcolor('#28590C'),
                ),
                padding: EdgeInsets.all(0.0),
                shape: CircleBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
