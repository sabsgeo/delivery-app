import 'package:flutter/material.dart';
import 'package:vegitabledelivery/services/auth.dart';

class ExpansionPanelCustom extends StatefulWidget {
  final List<dynamic> data;
  final Function children;
  ExpansionPanelCustom({this.data, this.children});
  @override
  _ExpansionPanelCustomState createState() => _ExpansionPanelCustomState();
}

class _ExpansionPanelCustomState extends State<ExpansionPanelCustom> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: this.widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.white),
          child: ExpansionTile(
            initiallyExpanded: false,
            title: Text(
              this.widget.data[index]['headerValue'],
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.green[900],
              ),
            ),
            trailing: this.widget.data[index]['headerValue'] == 'Logout'
                ? Icon(
                    Icons.power_settings_new,
                    size: 18.0,
                    color: Colors.amber[500],
                  )
                : this.widget.data[index]['isExpanded']
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        size: 18.0,
                        color: Colors.amber[500],
                      )
                    : Icon(
                        Icons.keyboard_arrow_right,
                        size: 18.0,
                        color: Colors.amber[500],
                      ),
            children: this.widget.children(index),
            onExpansionChanged: (state) async {
              setState(() {
                if (this.widget.data[index]['headerValue'] == 'Orders') {
                  this.widget.data[index]['isExpanded'] = state;
                }
              });
              if (this.widget.data[index]['headerValue'] == 'Logout') {
                await _auth.signOut();
              } else if (this.widget.data[index]['headerValue'] ==
                  'Manage Address') {
                await Navigator.pushNamed(context, '/list-address');
              }
            },
          ),
        );
      },
    );
  }
}
