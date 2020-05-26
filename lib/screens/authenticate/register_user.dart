import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/services/auth.dart';
import 'package:vegitabledelivery/shared/constants.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text Input state
  String email;
  String password;
  String firstName = '';
  String lastName = '';
  bool isRegistering = false;

  @override
  Widget build(BuildContext context) {
    Map phoneData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Hexcolor('#DFE9AC'),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Hexcolor('#DFE9AC'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Hexcolor('#FFA820')),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 15.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Text(
                    "SIGN UP",
                    style: TextStyle(color: Hexcolor('#28590C'), fontSize: 16.0,),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Create an account with the new phone number",
                    style: TextStyle(color: Hexcolor('#28590C'), fontSize: 10.0),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          validator: (val) =>
                              val.isEmpty ? "Enter first name" : null,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration:
                              textDecoration.copyWith(hintText: 'First Name'),
                          onChanged: (String firstName) {
                            setState(() {
                              this.firstName = firstName;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          validator: (val) =>
                              val.isEmpty ? "Enter last name" : null,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration:
                              textDecoration.copyWith(hintText: 'Last Name'),
                          onChanged: (String lastName) {
                            setState(() {
                              this.lastName = lastName;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: textDecoration.copyWith(hintText: 'Email'),
                    onChanged: (String email) {
                      setState(() {
                        this.email = email;
                      });
                    },
                    validator: (String email) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email)
                          ? null
                          : 'Not a valid email';
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: textDecoration.copyWith(hintText: 'Password'),
                    onChanged: (String password) {
                      setState(() {
                        this.password = password;
                      });
                    },
                    validator: (String password) =>
                        password.length < 6 ? 'Not a valid password' : null,
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                    color: Hexcolor('#97BE11'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (!this.isRegistering) {
                          this.isRegistering = true;
                          Map data = await _auth.createVerifyUser(
                              phoneData['phone'],
                              email: this.email,
                              password: this.password);
                          if (data['state'] == 'VERIFICATION_COMPLETE') {
                            Navigator.pushNamed(context, '/sms-code',
                                arguments: {
                                  'authCredential': data['data']
                                      ['authCredential'],
                                  'emailAuthResult': data['data']
                                      ['emailAuthResult'],
                                  'firstName': firstName,
                                  'lastName': lastName,
                                  'email': email,
                                  'phone': phoneData['phone']
                                });
                          } else if (data['state'] == 'CODE_SENT') {
                            Navigator.pushNamed(context, '/sms-code',
                                arguments: {
                                  'verificationId': data['data']
                                      ['verificationId'],
                                  'emailAuthResult': data['data']['emailAuthResult'],
                                  'firstName': firstName,
                                  'lastName': lastName,
                                  'email': email,
                                  'phone': phoneData['phone']
                                });
                          }
                          this.isRegistering = false;
                        }
                      }
                    },
                    child: Text("Register"),
                  ),
                ],
              ))),
    );
  }
}
