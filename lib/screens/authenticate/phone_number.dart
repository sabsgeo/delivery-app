import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vegitabledelivery/services/user_database.dart';
import 'package:vegitabledelivery/shared/constants.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _formKey = GlobalKey<FormState>();

  // Text Input state
  String phone = '';

  @override
  Widget build(BuildContext context) {
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
                      "ALMOST THERE!",
                      style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Login or Sign up to place your order",
                      style:
                          TextStyle(color: Colors.green[900], fontSize: 10.0),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10.0),
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
                      color: Colors.green[500],
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          UserDatabaseService db = UserDatabaseService();
                          bool isRegistered =
                              await db.isUserRegistered(this.phone);
                          if (isRegistered) {
                            Navigator.pushNamed(context, '/sms-code',
                                arguments: {'phone': this.phone});
                          } else {
                            Navigator.pushNamed(context, '/register',
                                arguments: {'phone': this.phone});
                          }
                        }
                      },
                      child: Text("Proceed",
                          style: TextStyle(color: Colors.green[900])),
                    ),
                  ],
                ))));
  }
}
