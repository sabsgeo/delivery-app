import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/services/location.dart';
import 'package:vegitabledelivery/services/user_database.dart';
import 'package:vegitabledelivery/shared/constants.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

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
                backgroundColor: Hexcolor('#DFE9AC'),
                body: Center(
                  child: SpinKitCubeGrid(
                    color: Hexcolor('#97BE11'),
                    size: 80.0,
                  ),
                ));
          }
          this.locationData = snapshot.data;
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
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Hexcolor('#FFA820'),
                            ),
                            Text(
                              snapshot.data['subLocality'],
                              style: TextStyle(
                                color: Hexcolor('#28590C'),
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
                              color: Hexcolor('#28590C'), fontSize: 10.0),
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
                          color: Hexcolor('#97BE11'),
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
      if (appData.orderedItems.keys.length > 0) {
        await Navigator.pushReplacementNamed(context, '/cart');
      } else {
        await Navigator.pushReplacementNamed(context, '/');
      }
      this.savedClicked = false;
    }
  }
}
