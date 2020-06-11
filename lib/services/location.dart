import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = new Location();
  Geolocator geolocator = Geolocator();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Future<Map<String, dynamic>> getLocation() async {
    Map<String, dynamic> loc = Map();
    LocationData finalLoc = await location.getLocation();
    loc['lat'] = finalLoc.latitude;
    loc['long'] = finalLoc.longitude;
    List<Placemark> placemark = await geolocator.placemarkFromCoordinates(finalLoc.latitude, finalLoc.longitude);
    loc['subLocality'] = placemark[0].subLocality;
    loc['subThoroughfare'] = placemark[0].subThoroughfare;
    loc['locality'] = placemark[0].locality;
    loc['postalCode'] = placemark[0].postalCode;
    loc['administrativeArea'] = placemark[0].administrativeArea;
    loc['country'] = placemark[0].country;
    return loc;
  }

  Future getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
