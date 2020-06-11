import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/screens/address/address_add.dart';
import 'package:vegitabledelivery/screens/address/address_list.dart';
import 'package:vegitabledelivery/screens/authenticate/phone_number.dart';
import 'package:vegitabledelivery/screens/authenticate/register_user.dart';
import 'package:vegitabledelivery/screens/authenticate/sms_code.dart';
import 'package:vegitabledelivery/screens/cart/cart.dart';
import 'package:vegitabledelivery/screens/cart/summary.dart';
import 'package:vegitabledelivery/screens/rate_us.dart';
import 'package:vegitabledelivery/screens/success.dart';
import 'package:vegitabledelivery/screens/wrapper.dart';
import 'package:vegitabledelivery/services/auth.dart';
import 'package:vegitabledelivery/services/navigator.dart';
import 'package:vegitabledelivery/services/notification.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => NavigationService());
  GetIt.instance.registerLazySingleton(() => PushNotificationService());
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(
        seconds: 5,
          navigateAfterSeconds: StreamProvider<User>.value(
            value: AuthService().user,
            child: OverlaySupport(
              child: MaterialApp(
                  navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
                  debugShowCheckedModeBanner: false,
                  routes: {
                    '/': (context) => Wrapper(),
                    '/phone-number': (context) => PhoneNumber(),
                    '/register': (context) => RegisterUser(),
                    '/sms-code': (context) => SmsCode(),
                    '/success': (context) => SuccessTick(),
                    '/summary': (context) => OrderSummary(),
                    '/list-address': (context) => AddressList(),
                    '/add-address': (context) => AddAddress(),
                    '/cart': (context) => Cart(Provider.of<User>(context) == null ? false : true),
                    '/rate-us': (context) => RateUs()
                  }
              ),
            ),
          ),
          title: new Text('Welcome In SplashScreen',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),),
          image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
          backgroundColor: Hexcolor('#DFE9AC'),
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          onClick: ()=>print("Flutter Egypt"),
          loaderColor: Hexcolor('#FFA820'),
      ),
    );
  }
}
