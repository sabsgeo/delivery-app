import 'package:cloud_firestore/cloud_firestore.dart';

class FreshGreen {
  String uid;
  String name;
  String price;
  String image;
  String minQuantity;
  bool isVeg;
  String group;
  FreshGreen(
      {this.uid,
      this.name,
      this.price,
      this.image,
      this.isVeg,
      this.minQuantity,
      this.group});
  factory FreshGreen.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data;
    return FreshGreen(
        uid: doc.documentID ?? 'invalid',
        name: data['name'] ?? 'invalid',
        price: data['price'] ?? 'invalid',
        image: data['image'] ?? 'invalid',
        minQuantity: data['minQuantity'] ?? 'invalid',
        isVeg: data['isVeg'] ?? true,
        group: data['group'] ?? 'invalid');
  }
}
