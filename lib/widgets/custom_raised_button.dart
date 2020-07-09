import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child,
    this.color,
    this.height:50.0,
    this.borderRadius:10.0,
    this.onPressed,
  });
  final Widget child;
  final Color color;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
          color: color,
          disabledColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
          child: child,
          onPressed: onPressed),
    );
  }
}
