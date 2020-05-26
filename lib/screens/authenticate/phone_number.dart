import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/services/auth.dart';
import 'package:vegitabledelivery/services/database.dart';
import 'package:vegitabledelivery/shared/constants.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text Input state
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Hexcolor('#DFE9AC'),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Login'),
          backgroundColor: Hexcolor('#97BE11'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Text(
                      "Please enter your phone number",
                      style: TextStyle(color: Hexcolor('#28590C')),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: textDecoration.copyWith(
                          hintText: 'Phone',
                          prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              child: Text('+91-'))),
                      onChanged: (String phone) {
                        setState(() {
                          this.phone = '+91' + phone;
                        });
                      },
                      validator: (String phone) => phone.length == 10
                          ? null
                          : 'Not a valid phone number',
                    ),
                    SizedBox(height: 15.0),
                    RaisedButton(
                      color: Hexcolor('#97BE11'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          DatabaseService db = DatabaseService();
                          bool isRegistered =
                              await db.isUserRegistered(this.phone);
                          if (isRegistered) {
                            Map data = await _auth.createVerifyUser(this.phone);
                            if (data['state'] == 'VERIFICATION_COMPLETE') {
                              Navigator.pushNamed(context, '/sms-code',
                                  arguments: {
                                    'authCredential': data['data']
                                        ['authCredential'],
                                    'emailAuthResult': data['data']
                                        ['emailAuthResult'],
                                    'phone': this.phone
                                  });
                            } else if (data['state'] == 'CODE_SENT') {
                              Navigator.pushNamed(context, '/sms-code',
                                  arguments: {
                                    'verificationId': data['data']
                                        ['verificationId'],
                                    'emailAuthResult': data['data']
                                        ['emailAuthResult'],
                                    'phone': this.phone
                                  });
                            }
                          } else {
                            Navigator.pushNamed(context, '/register',
                                arguments: {'phone': this.phone});
                          }
                        }
                      },
                      child: Text("Proceed",
                          style: TextStyle(color: Hexcolor('#28590C'))),
                    ),
                  ],
                ))));
  }
}
