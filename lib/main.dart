import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:vegitabledelivery/models/ordered_items.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/screens/address/address_add.dart';
import 'package:vegitabledelivery/screens/address/address_list.dart';
import 'package:vegitabledelivery/screens/authenticate/phone_number.dart';
import 'package:vegitabledelivery/screens/authenticate/register_user.dart';
import 'package:vegitabledelivery/screens/authenticate/sms_code.dart';
import 'package:vegitabledelivery/screens/cart/cart.dart';
import 'package:vegitabledelivery/screens/cart/summary.dart';
import 'package:vegitabledelivery/screens/home/home.dart';
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
    return MultiProvider(providers: [
      StreamProvider<User>.value(value: AuthService().user),
      Provider<OrderedItems>(
        create: (context) => OrderedItems(),
      ),
    ], child: MainApp());
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<OrderedItems>(context);

    return MultiProvider(
      providers: [
        StreamProvider<Map<String, EachOrderedItem>>.value(
            initialData: {},
            value: model.orderedItemsStream,
            updateShouldNotify: (_, __) => true)
      ],
      child: OverlaySupport(
        child: MaterialApp(
            theme: ThemeData(textTheme: GoogleFonts.aBeeZeeTextTheme()),
            navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => Wrapper(),
              '/home': (context) =>
                  Home(Provider.of<User>(context) == null ? false : true),
              '/phone-number': (context) => PhoneNumber(),
              '/register': (context) => RegisterUser(),
              '/sms-code': (context) => SmsCode(),
              '/success': (context) => SuccessTick(),
              '/summary': (context) => OrderSummary(),
              '/list-address': (context) => AddressList(),
              '/add-address': (context) => AddAddress(),
              '/cart': (context) =>
                  Cart(Provider.of<User>(context) == null ? false : true),
              '/rate-us': (context) => RateUs()
            }),
      ),
    );
  }
}
