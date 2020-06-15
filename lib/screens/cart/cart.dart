import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:vegitabledelivery/models/ordered_items.dart';
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
    Map<String, EachOrderedItem> selectedItems =
        Provider.of<Map<String, EachOrderedItem>>(context, listen: false);
    List<String> allSelectedItemUid =
        selectedItems.keys.length > 0 ? selectedItems.keys.toList() : [];
    selectedItems.forEach((key, value) {
      total += double.parse(value.item.price) * value.num;
    });
    var model = Provider.of<OrderedItems>(context);
    return SafeArea(
      child: this.orderPlaced
          ? Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
              ),
              body: Center(
                child: SpinKitCubeGrid(
                  color: Colors.green[500],
                  size: 80.0,
                ),
              ))
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: this.widget.userAuthenticated &&
                      Provider.of<Map<String, EachOrderedItem>>(context,
                                  listen: false)
                              .keys
                              .length >
                          0
                  ? AppBar(
                      elevation: 2.0,
                      backgroundColor: Colors.white,
                      title: Text(
                        'REVIEW ORDER',
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.green[900]),
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.green[900]),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  : AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                    ),
              body: this.widget.userAuthenticated &&
                      Provider.of<Map<String, EachOrderedItem>>(context,
                                  listen: false)
                              .keys
                              .length >
                          0
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .50,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 10.0, 0.0, 10.0),
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: Provider.of<
                                                  Map<String, EachOrderedItem>>(
                                              context,
                                              listen: false)
                                          .keys
                                          .length,
                                      itemBuilder: (builderContext, index) {
                                        EachOrderedItem eachSelectedItem =
                                            selectedItems[
                                                allSelectedItemUid[index]];
                                        return ListTile(
                                          title: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.brightness_1,
                                                size: 12.0,
                                                color:
                                                    eachSelectedItem.item.isVeg
                                                        ? Colors.green[500]
                                                        : Colors.red[900],
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              Text(
                                                '${eachSelectedItem.item.name} (${eachSelectedItem.item.minQuantity})',
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
                                                    eachSelectedItem.item,
                                                  ),
                                                  Text(
                                                    (double.parse(
                                                                eachSelectedItem
                                                                    .item
                                                                    .price) *
                                                            eachSelectedItem
                                                                .num)
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
                                .copyWith(dividerColor: Colors.white),
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: Text(
                                appData.selectedAddress == null
                                    ? 'Select address'
                                    : 'Address selected',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.green[900],
                                ),
                              ),
                              subtitle: appData.selectedAddress == null
                                  ? null
                                  : Text(
                                      '${appData.selectedAddress.house}, ${appData.selectedAddress.landmark}, ${appData.selectedAddress.subThoroughfare}, ${appData.selectedAddress.subLocality}, ${appData.selectedAddress.locality}, ${appData.selectedAddress.administrativeArea}, ${appData.selectedAddress.postalCode}, ${appData.selectedAddress.country}',
                                      style: TextStyle(
                                        fontSize: 8.0,
                                        color: Colors.green[900],
                                      ),
                                    ),
                              onExpansionChanged: (state) async {
                                await Navigator.pushNamed(
                                    context, '/list-address',
                                    arguments: {'isSelectAddress': true});
                                setState(() {});
                              },
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                size: 18.0,
                                color: Colors.amber[500],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.green[500],
                                onPressed: appData.selectedAddress == null
                                    ? null
                                    : () async {
                                        setState(() {
                                          this.orderPlaced = true;
                                        });
                                        var finalOrder = {};
                                        Provider.of<
                                                    Map<String,
                                                        EachOrderedItem>>(
                                                context,
                                                listen: false)
                                            .forEach((key, value) {
                                          finalOrder[key] = {
                                            'num': value.num,
                                            'price': value.item.price,
                                            'minQuantity':
                                                value.item.minQuantity,
                                            'name': value.item.name,
                                            'isVeg': value.item.isVeg
                                          };
                                        });
                                        await OrderItems()
                                            .completeOrder(finalOrder);
                                        model.clearAllData();
                                        appData.selectedAddress = null;
                                        Navigator.pushReplacementNamed(
                                            context, '/success');
                                      },
                                child: Text("Place Order",
                                    style: TextStyle(color: Colors.green[900])),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
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
                                        image: AssetImage(
                                            'assets/online-shopping.jpg')))),
                            SizedBox(height: 15.0),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "DELIVERY AT DOOR STEP",
                                style: TextStyle(
                                  color: Colors.green[900],
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
                                  color: Colors.green[900],
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.green[500],
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                child: Text("Add Items",
                                    style: TextStyle(color: Colors.green[900])),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
    );
  }
}
