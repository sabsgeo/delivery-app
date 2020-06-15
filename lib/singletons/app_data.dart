import 'package:vegitabledelivery/models/address.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  bool notificationConfigured = false;
  Address selectedAddress;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}
final appData = AppData();