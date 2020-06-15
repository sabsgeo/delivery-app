import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vegitabledelivery/models/ordered_items.dart';

class ButtonCartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: GestureDetector(
        child: Container(
          color: Colors.green[500],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Builder(builder: (subContext) {
                      int totalItemNum = 0;
                      double totalPrice = 0;
                      Provider.of<Map<String, EachOrderedItem>>(context)
                          .forEach((key, value) {
                        totalItemNum += value.num;
                        totalPrice += value.num * double.parse(value.item.price);
                      });
                      return Text(
                        '$totalItemNum Items | \u20B9$totalPrice',
                        style: TextStyle(fontSize: 10.0, color: Colors.white),
                      );
                    }),
                    Text(
                      'Extra charges may apply',
                      style: TextStyle(fontSize: 8.0, color: Colors.white),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'VIEW CART',
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    FaIcon(
                      FontAwesomeIcons.shoppingCart,
                      color: Colors.white,
                      size: 13.0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        onTap: () {
          if(Provider.of<Map<String, EachOrderedItem>>(context, listen: false).keys.length > 0) {
            Navigator.pushNamed(context, '/cart');
          }
        },
      ),
    );
  }
}
