import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String title;
  final Widget child;

  const MyTextField({Key key, this.title, this.child}) : super(key: key);

  @override
  _MyTextFieldState createState() => new _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).primaryColorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFEDEBED),
          ),
          child: widget.child,
        ),
      ],
    );
  }
}
