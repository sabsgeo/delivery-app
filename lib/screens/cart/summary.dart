import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:vegitabledelivery/models/order.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/services/auth.dart';
import 'package:vegitabledelivery/services/order.dart';

class OrderSummary extends StatelessWidget {
  Future orderInfo(Map<String, dynamic> details, bool isAuthed,
      BuildContext myContext) async {
    if (!isAuthed) {
      await AuthService().signOut();
      await Navigator.pushNamed(myContext, "/phone-number");
    }

    Map<String, dynamic> data = await OrderItems().getOrder(details['orderId']);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> navData = ModalRoute.of(context).settings.arguments;
    bool userAuthenticated = Provider.of<User>(context) == null ? false : true;
    return FutureBuilder(
        future: orderInfo(navData, userAuthenticated, context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SpinKitCubeGrid(
                    color: Colors.green[500],
                    size: 80.0,
                  ),
                ));
          }
          List<String> itemKeys = snapshot.data['items'].keys.toList();
          double total = 0;
          itemKeys.forEach((element) {
            Map item = snapshot.data['items'][element];
            double price = double.parse(item['price']);
            int quan = item['num'];
            total += price * quan;
          });
          Widget selectedIcon = Icon(
            Icons.access_time,
            size: 16.0,
            color: Colors.green[900],
          );
          String titleText = 'Awaiting confirmation';

          if (snapshot.data['order_status'] ==
              OrderStatus.ORDER_ON_THE_WAY.toString()) {
            titleText = 'On the way';
            selectedIcon = Icon(
              Icons.motorcycle,
              size: 20.0,
              color: Colors.green[900],
            );
          } else if (snapshot.data['order_status'] ==
              OrderStatus.ORDER_ACCEPTED.toString()) {
            titleText = 'Order accepted';
            selectedIcon = Icon(
              Icons.playlist_add_check,
              size: 20.0,
              color: Colors.green[900],
            );
          } else if (snapshot.data['order_status'] ==
              OrderStatus.AWAITING_CONFORMATION.toString()) {
            titleText = 'Awaiting confirmation';
            selectedIcon = Icon(
              Icons.access_time,
              size: 16.0,
              color: Colors.green[900],
            );
          } else if (snapshot.data['order_status'] ==
              OrderStatus.ORDER_DELIVERED.toString()) {
            titleText = 'Delivered';
            selectedIcon = Icon(
              Icons.done,
              size: 20.0,
              color: Colors.green[900],
            );
          } else if (snapshot.data['order_status'] ==
              OrderStatus.ORDER_CANCELLED.toString()) {
            titleText = 'Order cancelled';
            selectedIcon = Icon(
              Icons.clear,
              size: 20.0,
              color: Colors.green[900],
            );
          } else if (snapshot.data['order_status'] ==
              OrderStatus.ORDER_DECLINED.toString()) {
            titleText = 'Order declined';
            selectedIcon = Icon(
              Icons.clear,
              size: 20.0,
              color: Colors.green[900],
            );
          }
          var objectData = Map.from(snapshot.data['address']);
          String finalAddress =
              '${objectData['house']}, ${objectData['landmark']}, ${objectData['subThoroughfare']}, ${objectData['subLocality']}, ${objectData['locality']}, ${objectData['administrativeArea']}, ${objectData['postalCode']}, ${objectData['country']}';
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 2.0,
                backgroundColor: Colors.white,
                title: Text(
                  'ORDER SUMMARY',
                  style: TextStyle(fontSize: 18.0, color: Colors.green[900]),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.green[900]),
                  onPressed: () async {
                    if (navData['from'] == 'notification') {
                      await Navigator.pushReplacementNamed(context, '/');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Row(
                            children: <Widget>[
                              StepsIndicator(
                                isHorizontal: false,
                                selectedStep: 0,
                                nbSteps: 2,
                                doneLineColor: Colors.green[900],
                                undoneLineColor: Colors.green[900],
                                lineThickness: 2.0,
                                lineLength: 30,
                                unselectedStepWidget: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on,
                                        color: Colors.amber[500]),
                                  ],
                                ),
                                selectedStepWidget: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on,
                                        color: Colors.amber[500]),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Store',
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.green[900],
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * .5,
                                    child: Text(
                                      finalAddress,
                                      style: TextStyle(
                                        fontSize: 8.0,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      titleText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green[900],
                                          fontSize: 10.0),
                                    ),
                                  ),
                                  selectedIcon,
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(''),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .50,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: itemKeys.length,
                                itemBuilder: (builderContext, index) {
                                  Map item =
                                      snapshot.data['items'][itemKeys[index]];
                                  int quantityOfItem = item['num'];
                                  String minQuantityOfItem =
                                      item['minQuantity'];
                                  String name = item['name'];
                                  bool isVeg = item['isVeg'];
                                  double price = double.parse(item['price']);
                                  return ListTile(
                                    title: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.brightness_1,
                                          size: 12.0,
                                          color: isVeg
                                              ? Colors.green[500]
                                              : Colors.red[900],
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Text(
                                          '$name ($minQuantityOfItem) x ${quantityOfItem.toString()}',
                                          style: TextStyle(fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                    trailing: Text(
                                      (price * quantityOfItem).toString(),
                                      style: TextStyle(fontSize: 10.0),
                                    ),
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
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                            child: Text(
                              total.toString(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
