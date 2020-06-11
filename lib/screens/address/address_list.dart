import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vegitabledelivery/models/address.dart';
import 'package:vegitabledelivery/services/user_database.dart';
import 'package:vegitabledelivery/shared/constants.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  @override
  Widget build(BuildContext context) {
    dynamic routeData = ModalRoute.of(context).settings.arguments;
    bool isSelectAddress = ModalRoute.of(context).settings.arguments == null
        ? false
        : routeData['isSelectAddress'];
    print(isSelectAddress);
    return FutureBuilder(
        future: UserDatabaseService().getAllAddress(),
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
          List<Address> allAddress = snapshot.data;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                backgroundColor: Hexcolor('#DFE9AC'),
                title: Text(
                  isSelectAddress ? 'SELECT ADDRESS' : 'ADD ADDRESS',
                  style: TextStyle(fontSize: 18.0, color: Hexcolor('#28590C')),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Hexcolor('#FFA820')),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              backgroundColor: Hexcolor('#DFE9AC'),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: allAddress.length,
                      itemBuilder: (listContext, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: Hexcolor('#DFE9AC'),
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Hexcolor('#FFA820'),
                                  ),
                                ],
                              ),
                              title: Text(
                                allAddress[index].saveAs.capitalize(),
                                style: TextStyle(
                                    color: Hexcolor('28590C'), fontSize: 14.0),
                              ),
                              subtitle: Text(
                                '${allAddress[index].house}, ${allAddress[index].landmark}, ${allAddress[index].subThoroughfare}, ${allAddress[index].subLocality}, ${allAddress[index].locality}, ${allAddress[index].administrativeArea}, ${allAddress[index].postalCode}, ${allAddress[index].country}',
                                style: TextStyle(
                                    color: Hexcolor('28590C'), fontSize: 12.0),
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 18.0,
                                    color: Hexcolor('#FFA820'),
                                  ),
                                  onPressed: () {
                                    appData.selectedAddress = allAddress[index];
                                    Navigator.pop(context);
                                  }),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/add-address');
                        },
                        color: Hexcolor('#97BE11'),
                        child: Text("Add address",
                            style: TextStyle(color: Hexcolor('#28590C'))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
