import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

InputDecoration textDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Hexcolor('#FBFCEB'), width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Hexcolor('#FFA820'), width: 2.0)),
    errorStyle: TextStyle(
      fontSize: 12.0,
      color: Hexcolor('#DC1E0B')
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Hexcolor('#DC1E0B'), width: 2.0)) ,
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Hexcolor('#DC1E0B'), width: 2.0)),
    fillColor: Hexcolor('#FBFCEB'));

extension StringExtension on String {
    String capitalize() {
        return "${this[0].toUpperCase()}${this.substring(1)}";
    }
}