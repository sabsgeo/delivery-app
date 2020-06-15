import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/services/image.dart';
import 'package:vegitabledelivery/shared/widgets/increment_decrement_button.dart';

class ShoppingItemCard extends StatelessWidget {
  final FreshGreen eachItem;
  final bool enableAddToCart;
  ShoppingItemCard({@required this.eachItem, @required this.enableAddToCart});
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
              future: this._getImage(
                  image:
                      'fresh_green/${eachItem.image}'),
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
                    color: eachItem.isVeg
                        ? Colors.green[500]
                        : Colors.red[900],
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                      child: Text(
                        '${eachItem.name} (${eachItem.minQuantity})',
                        overflow: TextOverflow.visible,
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.green[900]),
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
                    style:
                        TextStyle(fontSize: 10.0, color: Colors.green[900]),
                  ),
                ),
                this.enableAddToCart ? IncrementDecrementButton(eachItem): Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
