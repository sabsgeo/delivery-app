import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/models/order.dart';
import 'package:vegitabledelivery/services/auth.dart';
import 'package:vegitabledelivery/services/location.dart';
import 'package:vegitabledelivery/services/navigator.dart';
import 'package:vegitabledelivery/services/order.dart';
import 'package:vegitabledelivery/shared/widgets/expansion_panel_custom.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

class Authenticate extends StatefulWidget {
  final bool userAuthenticated;
  Authenticate(this.userAuthenticated);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  List<Map> _data = [
    {'headerValue': 'Manage Address', 'isExpanded': false},
    {'headerValue': 'Orders', 'isExpanded': false},
    {'headerValue': 'Logout', 'isExpanded': false}
  ];
  List<Order> orderData = [];
  LocationService location = LocationService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: OrderItems().latestNOrders(5),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SafeArea(
                child: Scaffold(
              backgroundColor: Hexcolor('#DFE9AC'),
              body: Center(
                child: SpinKitCubeGrid(
                  color: Hexcolor('#97BE11'),
                  size: 80.0,
                ),
              ),
            ));
          }
          this.orderData = snapshot.data;
          return SafeArea(
            child: Scaffold(
                backgroundColor: Hexcolor('#DFE9AC'),
                body: Center(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: Container(
                            width: 200.0,
                            height: 200.0,
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image:
                                        AssetImage('assets/green_veg.jpg')))),
                      ),
                      SizedBox(height: 15.0),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "ACCOUNT",
                          style: TextStyle(
                            color: Hexcolor('#28590C'),
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      ..._login(context, this.widget.userAuthenticated)
                    ],
                  ),
                ))),
          );
        });
  }

  List<Widget> _login(BuildContext context, bool userAuthed) {
    if (!userAuthed) {
      return [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Login/create account to quickly manage orders",
            style: TextStyle(
              color: Hexcolor('#28590C'),
              fontSize: 10.0,
            ),
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
            child: Text("Login", style: TextStyle(color: Hexcolor('#28590C'))),
          ),
        )
      ];
    } else {
      return [ExpansionPanelCustom(data: _data, children: accountInfo)];
    }
  }

  List<Widget> accountInfo(index) {
    if (index == 0) {
      return [Container()];
    } else if (index == 1) {
      return orderData.map((Order e) {
        bool isLastElement = false;
        if (orderData[orderData.length - 1].id == e.id) {
          isLastElement = true;
        }
        String titleText = '';
        String subString = '';
        Widget selectedIcon = Icon(
          Icons.access_time,
          size: 16.0,
          color: Hexcolor('#28590C'),
        );
        double total = 0;
        Widget actionButtons = Container();
        if (e.orderStatus == OrderStatus.ORDER_ON_THE_WAY) {
          titleText = 'On the way';
          selectedIcon = Icon(
            Icons.motorcycle,
            size: 20.0,
            color: Hexcolor('#28590C'),
          );
          actionButtons = Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: () async {
                  Map<String, dynamic> details = new Map();
                  details['orderId'] = e.id;
                  details['from'] = 'orders';
                  e.items.forEach((key, value) {
                    print(key);
                    print(value);
                  });
                  Navigator.pushNamed(context, '/summary', arguments: details);
                },
                child: Text("Summary",
                    style:
                        TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0)),
              )
            ],
          );
        } else if (e.orderStatus == OrderStatus.ORDER_ACCEPTED) {
          titleText = 'Order accepted';
          selectedIcon = Icon(
            Icons.playlist_add_check,
            size: 20.0,
            color: Hexcolor('#28590C'),
          );
          actionButtons = Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: () async {
                  Map<String, dynamic> details = new Map();
                  details['orderId'] = e.id;
                  details['from'] = 'orders';
                  e.items.forEach((key, value) {
                    print(key);
                    print(value);
                  });
                  Navigator.pushNamed(context, '/summary', arguments: details);
                },
                child: Text("Summary",
                    style:
                        TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0)),
              )
            ],
          );
        } else if (e.orderStatus == OrderStatus.AWAITING_CONFORMATION) {
          titleText = 'Awaiting confirmation';
          actionButtons = Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: () async {
                  Map<String, dynamic> details = new Map();
                  details['orderId'] = e.id;
                  details['from'] = 'orders';
                  Navigator.pushNamed(context, '/summary', arguments: details);
                },
                child: Text("Summary",
                    style:
                        TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0)),
              ),
              RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: () async {
                  await OrderItems().cancelOrder(e.id);
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text("Cancel",
                    style:
                    TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0)),
              )
            ],
          );
        } else if (e.orderStatus == OrderStatus.ORDER_DELIVERED) {
          titleText = 'Delivered';
          selectedIcon = Icon(
            Icons.done,
            size: 20.0,
            color: Hexcolor('#28590C'),
          );
          actionButtons = Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: () async {
                  appData.orderedItems = {};
                  e.items.forEach((key, value) {
                    appData.orderedItems['key'] = value;
                  });
                  Navigator.pushReplacementNamed(context, '/cart');
                },
                child: Text("Reorder",
                    style:
                        TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0)),
              ),
              RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: e.rating > -1 ? null : () async {
                  Navigator.pushNamed(context, '/rate-us', arguments: {
                    'orderId': e.id
                  });
                },
                child: Text(e.rating > -1? "Rated ${e.rating.toString()}":"Rate order",
                    style:
                        TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0)),
              ),
            ],
          );
        } else if (e.orderStatus == OrderStatus.ORDER_CANCELLED) {
          titleText = 'Order cancelled';
          selectedIcon = Icon(
            Icons.clear,
            size: 20.0,
            color: Hexcolor('#28590C'),
          );
          actionButtons = Container();
        } else if (e.orderStatus == OrderStatus.ORDER_DECLINED) {
          titleText = 'Order declined';
          selectedIcon = Icon(
            Icons.clear,
            size: 20.0,
            color: Hexcolor('#28590C'),
          );
          actionButtons = Container();
        }

        e.items.forEach((key, value) {
          total += double.parse(value['price']) * value['num'];
          subString +=
              '${value["name"]}(${value["minQuantity"]}) x ${value['num']}, ';
        });
        subString = subString.substring(0, subString.length - 2);
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0.0,
          color: Hexcolor('#DFE9AC'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                dense: true,
                title: Row(
                  children: <Widget>[
                    selectedIcon,
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      titleText,
                      style:
                          TextStyle(color: Hexcolor('#28590C'), fontSize: 12.0),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '\u20B9 ${total.toString()}',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 10.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        subString,
                        style: TextStyle(fontSize: 10.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      actionButtons,
                      isLastElement
                          ? Container()
                          : Divider(
                              height: 20.0,
                              color: Hexcolor('#97BE11'),
                              thickness: 1.0,
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }).toList();
    } else {
      return [Container()];
    }
  }
}
