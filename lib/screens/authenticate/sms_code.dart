import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.amber[500]),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    body: Container(
                      child: Center(
                        child: SpinKitCubeGrid(
                          color: Colors.green[500],
                          size: 80.0,
                        ),
                      ),
                    ));
              }
              phoneData = snapshot.data;
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.amber[500]),
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
                              color: Colors.green[900],
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
                                color: Colors.green[900], fontSize: 10.0),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        PinFieldAutoFill(
                            decoration: UnderlineDecoration(
                                enteredColor: Colors.amber[500],
                                color: Colors.amber[500],
                                textStyle: TextStyle(
                                    color: Colors.green[900],
                                    fontSize: 25.0)),
                            onCodeChanged: (String verificationCode) {
                              this.pinCode = verificationCode;
                            }),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: Colors.green[500],
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
                              style: TextStyle(color: Colors.green[900])),
                        )
                      ],
                    ),
                  ));
            })
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Center(
                child: SpinKitCubeGrid(
                  color: Colors.green[500],
                  size: 80.0,
                ),
              ),
            ));
  }
}
