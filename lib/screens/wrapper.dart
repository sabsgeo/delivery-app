import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/screens/authenticate/authenticate.dart';
import 'package:vegitabledelivery/screens/cart/cart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vegitabledelivery/screens/home/options.dart';
import 'package:vegitabledelivery/services/notification.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;
  bool userAuthenticated = false;
  final PushNotificationService _pushNotificationService =
  GetIt.instance<PushNotificationService>();

  Future handleStartUpLogic() async {
    precacheImage(
        AssetImage('assets/temp_pics/veg_fruits_background.png'), context);
    warmUpFlare();
  }

  @override
  initState() {
    super.initState();
    _pushNotificationService.initialise();
  }

  Future<void> warmUpFlare() async {
    const flareAssets = [
      'assets/flare/notification_bell.flr',
      'assets/flare/status_success.flr'
    ];
    flareAssets.forEach((element) async {
      AssetProvider assetProvider = AssetFlare(bundle: rootBundle, name: element);
      await cachedActor(assetProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    userAuthenticated = Provider.of<User>(context) == null ? false : true;

    List<Widget> _widgetOptions = <Widget>[
      AllOptions(userAuthenticated),
      Authenticate(userAuthenticated),
      Cart(userAuthenticated)
    ];
    return FutureBuilder(
        future: handleStartUpLogic(),
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
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: SizedBox(
              height: 45.0,
              child: BottomNavigationBar(
                iconSize: 20.0,
                backgroundColor: Colors.green[500],
                elevation: 50.0,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.list,
                      color: Colors.white,
                      size: 13.0,
                    ),
                    title: Text(
                      'Items',
                      style:
                          TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.userAlt,
                      color: Colors.white,
                      size: 13.0,
                    ),
                    title: Text(
                      'Account',
                      style:
                          TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.shoppingCart,
                      color: Colors.white,
                      size: 13.0,
                    ),
                    title: Text(
                      'Cart',
                      style:
                          TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          );
        });
  }
}
