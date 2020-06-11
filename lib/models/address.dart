class Address {
  String uid;
  String administrativeArea;
  String country;
  String house;
  String landmark;
  double lat;
  String locality;
  double long;
  String postalCode;
  String saveAs;
  String subLocality;
  String subThoroughfare;
  int createdTime;

  Address(this.uid,
      {this.createdTime,
      this.administrativeArea,
      this.country,
      this.house,
      this.landmark,
      this.lat,
      this.locality,
      this.long,
      this.postalCode,
      this.saveAs,
      this.subLocality,
      this.subThoroughfare});

  Map<String, dynamic> getAllData() {
    Map<String, dynamic> finalData = {};
    finalData['uid'] = this.uid;
    finalData['administrativeArea'] = this.administrativeArea;
    finalData['country'] = this.country;
    finalData['house'] = this.house;
    finalData['landmark'] = this.landmark;
    finalData['lat'] = this.lat;
    finalData['locality'] = this.locality;
    finalData['long'] = this.long;
    finalData['postalCode'] = this.postalCode;
    finalData['saveAs'] = this.saveAs;
    finalData['subLocality'] = this.subLocality;
    finalData['subThoroughfare'] = this.subThoroughfare;
    finalData['createdTime'] = this.createdTime;
    return finalData;
  }
}
