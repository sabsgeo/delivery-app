import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:vegitabledelivery/services/auth.dart';

class SmsCode extends StatefulWidget {
  @override
  _SmsCodeState createState() => _SmsCodeState();
}

class _SmsCodeState extends State<SmsCode> {
  final _auth = AuthService();
  String pinCode;
  @override
  Widget build(BuildContext context) {
    Map phoneData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: Hexcolor('#DFE9AC'),
        appBar: AppBar(
          title: Text('Verify'),
          backgroundColor: Hexcolor('#97BE11'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40.0),
          child: Column(
            children: <Widget>[
              Text(
                "Please provide the OTP code",
                style: TextStyle(color: Hexcolor('#28590C')),
              ),
              SizedBox(height: 15.0),
              PinFieldAutoFill(
                  decoration: UnderlineDecoration(
                      enteredColor: Hexcolor('#FFA820'),
                      color: Hexcolor('#FFA820'),
                      textStyle: TextStyle(
                          color: Hexcolor('#28590C'), fontSize: 25.0)),
                  onCodeChanged: (String verificationCode) {
                    this.pinCode = verificationCode;
                  }),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Hexcolor('#97BE11'),
                onPressed: () async {
                  print(phoneData);
                  print(this.pinCode);
                  if (phoneData['authCredential'] != null) {
                    await _auth.registerSignIn(
                        authCredential: phoneData['authCredential'],
                        authResult: phoneData['emailAuthResult'],
                        firstName: phoneData['firstName'],
                        lastName: phoneData['lastName'],
                        email: phoneData['email'],
                        phone: phoneData['phone']);

                  } else if (phoneData['verificationId'] != null) {
                    await _auth.registerSignIn(
                        code: this.pinCode,
                        verificationId: phoneData['verificationId'],
                        authResult: phoneData['emailAuthResult'],
                        firstName: phoneData['firstName'],
                        lastName: phoneData['lastName'],
                        email: phoneData['email'],
                        phone: phoneData['phone']);
                  } else {
                    print("Try Again");
                  }
                  await Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                child: Text("Verify",
                    style: TextStyle(color: Hexcolor('#28590C'))),
              )
            ],
          ),
        ));
  }
}
