import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegitabledelivery/services/order.dart';
import 'package:vegitabledelivery/shared/constants.dart';

class RateUs extends StatefulWidget {
  @override
  _RateUsState createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  int rateUs = 0;
  final _formKey = GlobalKey<FormState>();
  String tellusMore = '';
  String hintField = '';
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    dynamic routeData = ModalRoute.of(context).settings.arguments;
    String orderId = ModalRoute.of(context).settings.arguments == null
        ? null
        : routeData['orderId'];
    if (rateUs >= 4) {
      hintField = 'Tell us what you liked...';
    } else if (rateUs == 3) {
      hintField = 'Tell us your suggestions...';
    } else if( rateUs >= 1) {
      hintField = 'Tell us more...';
    } else {
      hintField = 'Feedback...';
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.amber[500]),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Rate your Order',
                  style: TextStyle(
                      color: Colors.green[900], fontWeight: FontWeight.w900),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          rateUs >= 1 ? Icons.star : Icons.star_border,
                          color: Colors.amber[500],
                        ),
                        onPressed: () {
                          setState(() {
                            rateUs = 1;
                          });
                        }),
                    IconButton(
                        icon: Icon(rateUs >= 2 ? Icons.star : Icons.star_border,
                            color: Colors.amber[500]),
                        onPressed: () {
                          setState(() {
                            rateUs = 2;
                          });
                        }),
                    IconButton(
                        icon: Icon(rateUs >= 3 ? Icons.star : Icons.star_border,
                            color: Colors.amber[500]),
                        onPressed: () {
                          setState(() {
                            rateUs = 3;
                          });
                        }),
                    IconButton(
                        icon: Icon(rateUs >= 4 ? Icons.star : Icons.star_border,
                            color: Colors.amber[500]),
                        onPressed: () {
                          setState(() {
                            rateUs = 4;
                          });
                        }),
                    IconButton(
                        icon: Icon(rateUs >= 5 ? Icons.star : Icons.star_border,
                            color: Colors.amber[500]),
                        onPressed: () {
                          setState(() {
                            rateUs = 5;
                          });
                        })
                  ],
                ),
                Form(
                    key: _formKey,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(150),
                      ],
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      decoration: textDecoration.copyWith(
                          hintText: this.hintField,),
                      onChanged: (String tellUsMore) {
                        this.tellusMore = tellUsMore;
                      },
                    )),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                  color: Colors.green[500],
                  onPressed: this.rateUs > 0 ? this.submitted ? null: () async {
                    setState(() {
                      this.submitted = true;
                    });
                    await OrderItems().rateOrder(orderId,this.rateUs, this.tellusMore);
                    Navigator.pushReplacementNamed(context, '/');
                  }: null,
                  child: Text("Submit",
                      style: TextStyle(color: Colors.green[900])),
                )
              ],
            ),
          ),
        ));
  }
}
