import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/services/order.dart';
import 'package:vegitabledelivery/shared/widgets/increment_decrement_button.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

class Cart extends StatefulWidget {
  final bool userAuthenticated;
  final bool orderStatusCheck;
  final String orderId;
  Cart(this.userAuthenticated, {this.orderStatusCheck, this.orderId});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool orderPlaced = false;
  @override
  Widget build(BuildContext context) {
    double total = 0;
    appData.orderedItems.keys.toList().forEach((element) {
      FreshGreen selectedItem = appData.freshGreen[
          int.parse(appData.orderedItems[element]['index'].toString())];
      total += double.parse(selectedItem.price) *
          appData.orderedItems[element]['num'];
    });
    return SafeArea(
      child: this.orderPlaced
          ? Scaffold(
              backgroundColor: Hexcolor('#DFE9AC'),
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Hexcolor('#DFE9AC'),
              ),
              body: Center(
                child: SpinKitCubeGrid(
                  color: Hexcolor('#97BE11'),
                  size: 80.0,
                ),
              ))
          : Scaffold(
              backgroundColor: Hexcolor('#DFE9AC'),
              appBar: this.widget.userAuthenticated &&
                      appData.orderedItems.keys.length > 0
                  ? AppBar(
                      elevation: 2.0,
                      backgroundColor: Hexcolor('#DFE9AC'),
                      title: Text(
                        'REVIEW ORDER',
                        style: TextStyle(
                            fontSize: 18.0, color: Hexcolor('#28590C')),
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Hexcolor('#FFA820')),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/'),
                      ),
                    )
                  : AppBar(
                      elevation: 0.0,
                      backgroundColor: Hexcolor('#DFE9AC'),
                    ),
              body: this.widget.userAuthenticated &&
                      appData.orderedItems.keys.length > 0
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .50,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Card(
                                color: Hexcolor('#DFE9AC'),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 10.0, 0.0, 10.0),
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount:
                                          appData.orderedItems.keys.length,
                                      itemBuilder: (builderContext, index) {
                                        int mainIndex = int.parse(appData
                                            .orderedItems[appData
                                                .orderedItems.keys
                                                .toList()[index]]['index']
                                            .toString());
                                        int quantityOfItem = int.parse(appData
                                            .orderedItems[appData
                                                .orderedItems.keys
                                                .toList()[index]]['num']
                                            .toString());
                                        FreshGreen selectedItem =
                                            appData.freshGreen[int.parse(appData
                                                .orderedItems[appData
                                                    .orderedItems.keys
                                                    .toList()[index]]['index']
                                                .toString())];
                                        return ListTile(
                                          title: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.brightness_1,
                                                size: 12.0,
                                                color: selectedItem.isVeg
                                                    ? Hexcolor('#97BE11')
                                                    : Hexcolor('#DC1E0B'),
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              Text(
                                                '${selectedItem.name} (${selectedItem.minQuantity})',
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              )
                                            ],
                                          ),
                                          trailing: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: Row(
                                                children: <Widget>[
                                                  IncrementDecrementButton(
                                                    index: mainIndex,
                                                    onIncrement: () {
                                                      setState(() {});
                                                    },
                                                    onDecrement: () {
                                                      setState(() {});
                                                    },
                                                  ),
                                                  Text(
                                                    (double.parse(selectedItem
                                                                .price) *
                                                            quantityOfItem)
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.0),
                                                  )
                                                ],
                                              )),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'TOTAL',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 30.0, 0.0),
                                  child: Text(
                                    total.toString(),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Hexcolor('#DFE9AC')),
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: Text(
                                appData.selectedAddress == null ? 'Select address': 'Address selected',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Hexcolor('#28590C'),
                                ),
                              ),
                              subtitle: Text(
                                appData.selectedAddress == null
                                    ? ''
                                    : '${appData.selectedAddress.house}, ${appData.selectedAddress.landmark}, ${appData.selectedAddress.subThoroughfare}, ${appData.selectedAddress.subLocality}, ${appData.selectedAddress.locality}, ${appData.selectedAddress.administrativeArea}, ${appData.selectedAddress.postalCode}, ${appData.selectedAddress.country}',
                                style: TextStyle(
                                  fontSize: 8.0,
                                  color: Hexcolor('#28590C'),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 18.0,
                                  color: Hexcolor('#FFA820'),
                                ),
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, '/list-address',
                                      arguments: {'isSelectAddress': true});
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Hexcolor('#97BE11'),
                                onPressed: appData.selectedAddress == null? null: () async {
                                  setState(() {
                                    this.orderPlaced = true;
                                  });
                                  await OrderItems().completeOrder();
                                  appData.selectedAddress = null;
                                  Navigator.pushReplacementNamed(
                                      context, '/success');
                                },
                                child: Text("Place Order",
                                    style:
                                        TextStyle(color: Hexcolor('#28590C'))),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                          AssetImage('assets/green_veg.jpg')))),
                          SizedBox(height: 15.0),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "DELIVERY AT DOOR STEP",
                              style: TextStyle(
                                color: Hexcolor('#28590C'),
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Your cart is empty. Add something from the items",
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
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              child: Text("Add Items",
                                  style: TextStyle(color: Hexcolor('#28590C'))),
                            ),
                          )
                        ],
                      ),
                    ))),
    );
  }
}
