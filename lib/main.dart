import 'package:flutter/material.dart';
import 'package:vegitabledelivery/screens/authenticate/phone_number.dart';
import 'package:vegitabledelivery/screens/authenticate/register_user.dart';
import 'package:vegitabledelivery/screens/authenticate/sms_code.dart';
import 'package:vegitabledelivery/screens/home/home.dart';
import 'package:vegitabledelivery/screens/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => Wrapper(),
          '/phone-number': (context) => PhoneNumber(),
          '/register': (context) => RegisterUser(),
          '/home': (context) => Home(),
          '/sms-code': (context) => SmsCode()
        }
    );
  }
}
