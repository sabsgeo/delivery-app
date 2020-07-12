import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/services/freshgreen_database.dart';
import 'package:vegitabledelivery/shared/constants.dart';
import 'package:vegitabledelivery/shared/widgets/custom_button.dart';
import 'package:vegitabledelivery/shared/widgets/custom_dropdown.dart';

class AddNewItem extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();

  // Text Input state
  String minQuantity = '100g';
  String group = 'FRUITS';
  String imageName;
  String isVeg = 'VEG';
  String name = '';
  String price = '';
  FreshGreen item;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> routeData = ModalRoute.of(context).settings.arguments as Map;
    if (routeData['action'] == 'IMAGE_NOT_UPDATED') {
      item = routeData['eachItem'];
      this.imageName = item.image;
      this.minQuantity = item.minQuantity;
      this.group = item.group;
      this.isVeg =  item.isVeg ? 'VEG': 'NON-VEG';
      this.name = item.name;
      this.price = item.price;
    } else if (routeData['action'] == 'IMAGE_ADDED' && routeData['eachItem'] == null) {
      this.imageName = routeData['imageName'];
    } else {
      item = routeData['eachItem'];
      this.imageName = routeData['imageName'];
      this.minQuantity = item.minQuantity;
      this.group = item.group;
      this.isVeg =  item.isVeg ? 'VEG': 'NON-VEG';
      this.name = item.name;
      this.price = item.price;
    }
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
                  Text(
                    "ADD A NEW ITEM",
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Add a new item to the list",
                    style: TextStyle(color: Colors.green[900], fontSize: 10.0),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: this.name,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (val) => val.isEmpty ? "Item name" : null,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: textDecoration.copyWith(hintText: 'Item name'),
                    onChanged: (String name) {
                      this.name = name;
                    },
                  ),
                  SizedBox(height: 10.0),
                  CustomDropdown(items: [
                    '100g',
                    '200g',
                    '250g',
                    '500g',
                    '1Kg',
                    '1No.'
                  ], defaultValue: this.minQuantity, onChange: (value) {
                    this.minQuantity = value;
                  },),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: this.price,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: textDecoration.copyWith(hintText: 'Price'),
                    onChanged: (String price) {
                      this.price = price;
                    },
                    validator: (val) => val.isEmpty ? "Enter price" : null,
                  ),
                  SizedBox(height: 10.0),
                  CustomDropdown(items: ['VEG', 'NON-VEG'], defaultValue: this.isVeg, onChange: (value) {
                    this.isVeg = value;
                  },),
                  SizedBox(height: 15.0),
                  CustomDropdown(items: [
                    'FRUITS',
                    'VEGETABLES',
                    'EGGS AND DIARY PRODUCTS',
                    'MEAT',
                    'READY TO COOK',
                    'READY TO EAT'
                  ], defaultValue: this.group, onChange: (value) {
                    group = value;
                  },),
                  CustomRaisedButtonWithLoader(child: Text(item == null? "Add Item": "Update Item"), onTap: () async {
                    if (_formKey.currentState.validate()) {
                      Map<String, dynamic> finalData = {
                        'group': this.group,
                        'image': this.imageName,
                        'isVeg': this.isVeg == 'VEG' ? true : false,
                        'minQuantity': this.minQuantity,
                        'name': this.name,
                        'price': this.price
                      };
                      if (item == null) {
                        await FreshGreenDatabaseService()
                            .addNewItems(finalData);
                        Map<String, dynamic> data = {};
                        Navigator.pushReplacementNamed(
                            context, '/image-crop', arguments: data);
                      } else {
                        await FreshGreenDatabaseService()
                            .updateItems(item.uid, finalData);
                        Navigator.pushReplacementNamed(
                            context, '/edit-items');
                      }
                    }
                  },),
                ],
              ))),
    );
  }
}
