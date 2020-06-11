import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/services/image.dart';
import 'package:vegitabledelivery/shared/widgets/increment_decrement_button.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

class ShoppingItemCard extends StatelessWidget {
  final int index;
  final bool enableAddToCart;
  ShoppingItemCard({@required this.index, @required this.enableAddToCart});
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
        color: Hexcolor('#DFE9AC'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder(
              future: this._getImage(
                  image:
                      'fresh_green/${appData.freshGreen[this.index].image}'),
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
                    color: appData.freshGreen[this.index].isVeg
                        ? Hexcolor('#97BE11')
                        : Hexcolor('#DC1E0B'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                    child: Text(
                      '${appData.freshGreen[this.index].name} (${appData.freshGreen[this.index].minQuantity})',
                      style:
                          TextStyle(fontSize: 12.0, color: Hexcolor('#28590C')),
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
                    '\u20B9${appData.freshGreen[this.index].price}',
                    style:
                        TextStyle(fontSize: 12.0, color: Hexcolor('#28590C')),
                  ),
                ),
                this.enableAddToCart ? IncrementDecrementButton(index: this.index): Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
