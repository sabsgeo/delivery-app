import 'package:flutter/material.dart';

class CustomRaisedButtonWithLoader extends StatefulWidget {
  final Widget child;
  final Function onTap;
  CustomRaisedButtonWithLoader({this.child, this.onTap});
  @override
  _CustomRaisedButtonWithLoaderState createState() => _CustomRaisedButtonWithLoaderState();
}

class _CustomRaisedButtonWithLoaderState extends State<CustomRaisedButtonWithLoader> {
  bool submitted = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.green[500],
      onPressed: this.submitted
          ? null
          : () async {
        setState(() {
          this.submitted = true;
        });
        await this.widget.onTap();
        setState(() {
          this.submitted = false;
        });
      },
      child: !this.submitted
          ? this.widget.child
          : Theme(
        child: Container(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
              backgroundColor: Colors.green[900]),
        ),
        data: Theme.of(context)
            .copyWith(accentColor: Colors.white),
      ),
    );
  }
}
