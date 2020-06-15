import 'package:flutter/material.dart';

InputDecoration textDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300], width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber[500], width: 2.0)),
    errorStyle: TextStyle(
      fontSize: 12.0,
      color: Colors.red[900]
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[900], width: 2.0)) ,
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[900], width: 2.0)),
    fillColor: Colors.white);

extension StringExtension on String {
    String capitalize() {
        return "${this[0].toUpperCase()}${this.substring(1)}";
    }
}