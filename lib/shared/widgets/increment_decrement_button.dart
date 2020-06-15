import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/models/ordered_items.dart';

class IncrementDecrementButton extends StatelessWidget {
  final FreshGreen eachItem;
  IncrementDecrementButton(this.eachItem);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<OrderedItems>(context);
    return ButtonBar(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              height: 18.0,
              width: 18.0,
              child: RawMaterialButton(
                onPressed: () {
                  if (Provider.of<Map<String, EachOrderedItem>>(context,
                              listen: false)
                          .containsKey(eachItem.uid) &&
                      Provider.of<Map<String, EachOrderedItem>>(context,
                                  listen: false)[eachItem.uid]
                              .num >
                          1) {
                    model.decrementExistingItem(eachItem.uid);
                  } else {
                    model.removeAnItemCompletely(eachItem.uid);
                  }
                },
                fillColor: Colors.green[500],
                child: Icon(
                  Icons.remove,
                  size: 18.0,
                  color: Colors.green[900],
                ),
                padding: EdgeInsets.all(0.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: SizedBox(
                  height: 18.0,
                  width: 18.0,
                  child: Center(
                      child: Text(
                          Provider.of<Map<String, EachOrderedItem>>(
                                      context)[eachItem.uid] ==
                                  null
                              ? "0"
                              : Provider.of<Map<String, EachOrderedItem>>(
                                      context)[eachItem.uid]
                                  .num
                                  .toString(),
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.green[900]),
                          textAlign: TextAlign.center))),
            ),
            SizedBox(
              height: 18.0,
              width: 18.0,
              child: RawMaterialButton(
                onPressed: () {
                  if (Provider.of<Map<String, EachOrderedItem>>(context,
                          listen: false)
                      .containsKey(eachItem.uid)) {
                    model.incrementExistingItem(eachItem.uid);
                  } else {
                    model.addNewItem(
                        eachItem.uid,
                        EachOrderedItem(eachItem, 1));
                  }
                },
                fillColor: Colors.green[500],
                child: Icon(
                  Icons.add,
                  size: 18.0,
                  color: Colors.green[900],
                ),
                padding: EdgeInsets.all(0.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
