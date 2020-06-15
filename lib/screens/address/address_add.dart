import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:vegitabledelivery/models/ordered_items.dart';
import 'package:vegitabledelivery/services/location.dart';
import 'package:vegitabledelivery/services/user_database.dart';
import 'package:vegitabledelivery/shared/constants.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  LocationService location = LocationService();
  String house;
  String landmark;
  String saveAs;
  bool savedClicked = false;
  Map<String, dynamic> locationData = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: location.getLocation(),
        builder: (futureContext, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SpinKitCubeGrid(
                    color: Colors.green[500],
                    size: 80.0,
                  ),
                ));
          }
          this.locationData = snapshot.data;
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
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.amber[500],
                            ),
                            Text(
                              snapshot.data['subLocality'],
                              style: TextStyle(
                                color: Colors.green[900],
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '${snapshot.data['subThoroughfare']}, ${snapshot.data['subLocality']}, ${snapshot.data['locality']}, ${snapshot.data['administrativeArea']}, ${snapshot.data['postalCode']}, ${snapshot.data['country']}',
                          style: TextStyle(
                              color: Colors.green[900], fontSize: 10.0),
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (val) => val.isEmpty
                                    ? "Enter House/ Flat/ Block NO."
                                    : null,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                decoration: textDecoration.copyWith(
                                    hintText: 'House/Flat/Block NO.'),
                                onChanged: (String house) {
                                  this.house = house;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration:
                              textDecoration.copyWith(hintText: 'Landmark'),
                          onChanged: (String landmark) {
                            this.landmark = landmark;
                          },
                          validator: (val) =>
                              val.isEmpty ? "Enter save as" : null,
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration:
                              textDecoration.copyWith(hintText: 'Save as'),
                          onChanged: (String saveAs) {
                            this.saveAs = saveAs;
                          },
                          validator: (val) =>
                              val.isEmpty ? "Enter landmark." : null,
                        ),
                        SizedBox(height: 15.0),
                        RaisedButton(
                          color: Colors.green[500],
                          onPressed: this.savedClicked ? null : _saveAddress,
                          child: Text("Save and Continue"),
                        ),
                      ],
                    ))),
          );
        });
  }

  Future _saveAddress() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        this.savedClicked = true;
      });
      Map<String, dynamic> completeAddress = this.locationData;
      completeAddress['house'] = this.house;
      completeAddress['landmark'] = this.landmark;
      completeAddress['saveAs'] = this.saveAs;
      await UserDatabaseService().saveNewAddress(completeAddress);
      if (Provider.of<Map<String, EachOrderedItem>>(context, listen: false).keys.length > 0) {
        await Navigator.pushReplacementNamed(context, '/cart');
      } else {
        await Navigator.pushReplacementNamed(context, '/');
      }
      this.savedClicked = false;
    }
  }
}
