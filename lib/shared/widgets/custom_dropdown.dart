import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String defaultValue;
  final Function onChange;
  CustomDropdown({this.items, this.defaultValue, this.onChange});
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String value;
  @override
  void initState() {
    super.initState();
    this.value = this.widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
              vertical: 0.0, horizontal: 5.0),
          decoration: new BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(2.0)),
              border: new Border.all(
                  color: Colors.grey[300], width: 2.0)),
          child: DropdownButton<String>(
            value: this.value,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[500],
            ),
            iconSize: 30,
            elevation: 16,
            style: TextStyle(color: Colors.black54),
            underline: Container(
              height: 0,
              color: Colors.white,
            ),
            onChanged: (String newValue) async {
              setState(() {
                this.value = newValue;
              });
              if (this.widget.onChange != null) {
                await this.widget.onChange(this.value);
              }
            },
            items: this.widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
