import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/services/freshgreen_database.dart';
import 'package:vegitabledelivery/shared/widgets/bottom_cart_summary.dart';
import 'package:vegitabledelivery/shared/widgets/shopping_item_card.dart';

class Home extends StatelessWidget {
  final bool userAuthenticated;
  final String userType;
  Home(this.userAuthenticated, {this.userType});
  @override
  Widget build(BuildContext context) {
    String itemToShow = (ModalRoute.of(context).settings.arguments as Map)['itemToShow'].toString();
    return StreamBuilder<Object>(
        stream: FreshGreenDatabaseService().getAllItemsFromCategory(itemToShow),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SafeArea(
                child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: SpinKitCubeGrid(
                  color: Colors.green[500],
                  size: 80.0,
                ),
              ),
            ));
          }
          List<FreshGreen> itemData = snapshot.data;
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: <Widget>[
                  SizedBox(
                    height: 45.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 2.0), //(x,y)
                            blurRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.green[900],
                              size: 16.0,
                            ),
                          ),
                          Text(itemToShow, style: TextStyle(color: Colors.green[900]),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (itemData.length / 2).round(),
                      itemBuilder: (listContext, index) {
                        const double padding = 6.0;
                        const double spacing = 8.0;
                        return Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                  width: (MediaQuery.of(context).size.width - 2 * padding - spacing) / 2,
                                  child: index * 2 + 1 > itemData.length
                                      ? Container()
                                      : ShoppingItemCard(
                                          eachItem: itemData[index * 2],
                                          enableAddToCart: this.userAuthenticated,
                                    userType: this.userType,
                                        )),
                              SizedBox(width: spacing,),
                              SizedBox(
                                  width: (MediaQuery.of(context).size.width - 2 * padding - spacing) / 2,
                                  child: index * 2 + 2 > itemData.length
                                      ? Container()
                                      : ShoppingItemCard(
                                          eachItem: itemData[index * 2 + 1],
                                          enableAddToCart: this.userAuthenticated,
                                    userType: this.userType,
                                        )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  this.userType == 'ADMIN'? Container(height: 0.0,): ButtonCartSummary()
                ],
              ),
            ),
          );
        });
  }
}
