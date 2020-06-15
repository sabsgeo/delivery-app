import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegitabledelivery/shared/constants.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.green[900]),
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
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Create an account with the new phone number",
                    style:
                        TextStyle(color: Colors.green[900], fontSize: 10.0),
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
                    color: Colors.green[500],
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pushNamed(context, '/sms-code', arguments: {
                          'firstName': this.firstName,
                          'lastName': this.lastName,
                          'email': this.email,
                          'phone': phoneData['phone'],
                          'password': this.password
                        });
                      }
                    },
                    child: Text("Register"),
                  ),
                ],
              ))),
    );
  }
}
