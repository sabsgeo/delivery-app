import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    return FutureBuilder(
        future: UserDatabaseService().getAllAddress(),
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
          List<Address> allAddress = snapshot.data;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                backgroundColor: Colors.white,
                title: Text(
                  isSelectAddress ? 'SELECT ADDRESS' : 'ADD ADDRESS',
                  style: TextStyle(fontSize: 18.0, color: Colors.green[900]),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.green[900]),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              backgroundColor: Colors.white,
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: allAddress.length,
                      itemBuilder: (listContext, index) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              color: Colors.white,
                              child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.amber[500],
                                    ),
                                  ],
                                ),
                                title: Text(
                                  allAddress[index].saveAs.capitalize(),
                                  style: TextStyle(
                                      color: Colors.green[900], fontSize: 14.0),
                                ),
                                subtitle: Text(
                                  '${allAddress[index].house}, ${allAddress[index].landmark}, ${allAddress[index].subThoroughfare}, ${allAddress[index].subLocality}, ${allAddress[index].locality}, ${allAddress[index].administrativeArea}, ${allAddress[index].postalCode}, ${allAddress[index].country}',
                                  style: TextStyle(
                                      color: Colors.green[900], fontSize: 12.0),
                                ),
                                trailing: isSelectAddress? Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 18.0,
                                      color: Colors.amber[500],
                                    ): null,
                              ),
                            ),
                          ),
                          onTap: isSelectAddress?() async {
                            appData.selectedAddress = allAddress[index];
                            Navigator.pop(context);
                          } : null,
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
                        color: Colors.green[500],
                        child: Text("Add address",
                            style: TextStyle(color: Colors.green[900])),
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
