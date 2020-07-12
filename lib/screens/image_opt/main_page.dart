import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/screens/home/home.dart';
import 'package:vegitabledelivery/screens/home/options.dart';
import 'package:vegitabledelivery/screens/image_opt/image_crop.dart';
import 'package:vegitabledelivery/screens/image_opt/item_information.dart';
import 'package:vegitabledelivery/screens/image_opt/selection_landing.dart';
import 'package:vegitabledelivery/services/auth.dart';

class MainCustomerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainApp();
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
      ],
      child: OverlaySupport(
        child: MaterialApp(
            theme: ThemeData(textTheme: GoogleFonts.aBeeZeeTextTheme()),
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => SelectionLanding(),
              '/image-crop': (context) => ImageCropper(),
              '/add-new-items': (context) => AddNewItem(),
              '/edit-items': (context) => AllOptions(Provider.of<User>(context) == null ? false : true, userType: 'ADMIN',),
              '/home': (context) => Home(Provider.of<User>(context) == null ? false : true, userType: 'ADMIN',)
            }),
      ),
    );
  }
}
