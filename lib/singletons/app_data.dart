import 'package:vegitabledelivery/models/address.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/models/user.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  List<FreshGreen> freshGreen = [];
  Map<String, dynamic> orderedItems = {};
  bool notificationConfigured = false;
  User appUser;
  Address selectedAddress;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}
final appData = AppData();