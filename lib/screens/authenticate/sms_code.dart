import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:vegitabledelivery/services/auth.dart';

class SmsCode extends StatefulWidget {
  @override
  _SmsCodeState createState() => _SmsCodeState();
}

class _SmsCodeState extends State<SmsCode> {
  final _auth = AuthService();
  bool isVerified = false;
  String pinCode;

  Future<Map> sendMessageAndVerify(Map phoneData) async {
    Map finalData = {};
    Map data;
    await SmsAutoFill().listenForCode;
    if (phoneData.containsKey('email') && phoneData.containsKey('password')) {
      data = await _auth.createVerifyUser(phoneData['phone'],
          email: phoneData['email'], password: phoneData['password']);
    } else {
      data = await _auth.createVerifyUser(phoneData['phone']);
    }

    if (data['state'] == 'VERIFICATION_COMPLETE') {
      finalData['authCredential'] = data['data']['authCredential'];
    } else if (data['state'] == 'CODE_SENT') {
      finalData['verificationId'] = data['data']['verificationId'];
    }
    finalData['emailAuthResult'] = data['data']['emailAuthResult'];
    finalData['firstName'] = phoneData['firstName'];
    finalData['lastName'] = phoneData['lastName'];
    finalData['email'] = phoneData['email'];
    finalData['phone'] = phoneData['phone'];
    finalData['password'] = phoneData['password'];
    return finalData;
  }

  @override
  Widget build(BuildContext context) {
    Map phoneData = ModalRoute.of(context).settings.arguments;
    return !isVerified
        ? FutureBuilder(
            future: sendMessageAndVerify(phoneData),
            builder: (futureContext, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Scaffold(
                    backgroundColor: Hexcolor('#DFE9AC'),
                    appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: Hexcolor('#DFE9AC'),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Hexcolor('#FFA820')),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    body: Container(
                      child: Center(
                        child: SpinKitCubeGrid(
                          color: Hexcolor('#97BE11'),
                          size: 80.0,
                        ),
                      ),
                    ));
              }
              phoneData = snapshot.data;
              return Scaffold(
                  backgroundColor: Hexcolor('#DFE9AC'),
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Hexcolor('#DFE9AC'),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Hexcolor('#FFA820')),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  body: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 50, horizontal: 15.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "VERIFY DETAILS",
                            style: TextStyle(
                              color: Hexcolor('#28590C'),
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "OTP sent to " + phoneData['phone'],
                            style: TextStyle(
                                color: Hexcolor('#28590C'), fontSize: 10.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        PinFieldAutoFill(
                            decoration: UnderlineDecoration(
                                enteredColor: Hexcolor('#FFA820'),
                                color: Hexcolor('#FFA820'),
                                textStyle: TextStyle(
                                    color: Hexcolor('#28590C'),
                                    fontSize: 25.0)),
                            onCodeChanged: (String verificationCode) {
                              this.pinCode = verificationCode;
                            }),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: Hexcolor('#97BE11'),
                          onPressed: () async {
                            setState(() {
                              this.isVerified = true;
                            });
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
                            this.isVerified = true;
                            await Navigator.pushReplacementNamed(context, '/');
                          },
                          child: Text("Verify",
                              style: TextStyle(color: Hexcolor('#28590C'))),
                        )
                      ],
                    ),
                  ));
            })
        : Scaffold(
            backgroundColor: Hexcolor('#DFE9AC'),
            body: Container(
              child: Center(
                child: SpinKitCubeGrid(
                  color: Hexcolor('#97BE11'),
                  size: 80.0,
                ),
              ),
            ));
  }
}
