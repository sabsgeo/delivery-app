import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/services/freshgreen_database.dart';
import 'package:vegitabledelivery/services/image.dart';
import 'package:vegitabledelivery/shared/widgets/increment_decrement_button.dart';

class ShoppingItemCard extends StatelessWidget {
  final FreshGreen eachItem;
  final bool enableAddToCart;
  final String userType;
  final bool itemDeleted = false;
  ShoppingItemCard(
      {@required this.eachItem, @required this.enableAddToCart, this.userType});
  final refStorage = FireStorageService();

  Future<String> _getImage({String image}) async {
    String d = await this.refStorage.loadImage(image);
    return d;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder(
              future: this._getImage(image: 'fresh_green/${eachItem.image}'),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Image.asset(
                    'assets/temp_pics/veg_fruits_background.png',
                    fit: BoxFit.fill,
                  );
                }
                return CachedNetworkImage(
                  imageUrl: snapshot.data.toString(),
                  placeholder: (context, url) => Image.asset(
                    'assets/temp_pics/veg_fruits_background.png',
                    fit: BoxFit.fill,
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.brightness_1,
                    size: 12.0,
                    color: eachItem.isVeg ? Colors.green[500] : Colors.red[900],
                  ),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: 25.0,
                        maxHeight: 25.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 5.0, 0.0, 0.0),
                        child: Text(
                          '${eachItem.name} (${eachItem.minQuantity})',
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontSize: 10.0, color: Colors.green[900]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '\u20B9${eachItem.price}',
                    style: TextStyle(fontSize: 10.0, color: Colors.green[900]),
                  ),
                ),
                this.userType == 'ADMIN'
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7.5, horizontal: 8),
                            child: ButtonTheme(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal:
                                      8.0), //adds padding inside the button
                              materialTapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, //limits the touch area to the button area
                              minWidth: 0, //wraps child's width
                              height: 0, //wraps child's height
                              child: OutlineButton(
                                child: Text(
                                  'EDIT',
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.green[900]),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.green[500]),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/image-crop',
                                      arguments: {
                                        'action': 'EDIT',
                                        'eachItem': eachItem
                                      });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7.5, horizontal: 8),
                            child: ButtonTheme(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal:
                                      8.0), //adds padding inside the button
                              materialTapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, //limits the touch area to the button area
                              minWidth: 0, //wraps child's width
                              height: 0, //wraps child's height
                              child: OutlineButton(
                                child: Text(
                                  'DELETE',
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.red[900]),
                                ),
                                borderSide: BorderSide(color: Colors.red[500]),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, dialogueState) {
                                          return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0)), //this right here
                                              child: Container(
                                                height: 300.0,
                                                width: 300.0,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("Item ${eachItem.name} will be deleted permanently",
                                                      style: TextStyle(color: Colors.green[900]), textAlign: TextAlign.center,),
                                                      RaisedButton(
                                                      onPressed: this.itemDeleted ? null: () {
                                                          Navigator.pop(context);
                                                          FreshGreenDatabaseService()
                                                              .deleteItems(eachItem.uid);
                                                        },
                                                        color: Colors.green[500],
                                                        child: Text("DELETE",
                                                            style: TextStyle(color: Colors.green[900])),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        });
                                      });
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : this.enableAddToCart
                        ? IncrementDecrementButton(eachItem)
                        : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
