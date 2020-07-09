import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_boilerplate/widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String text,
    @required String asset,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        assert(asset != null),
        super(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(asset),
                  Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 15.0),
                  ),
                  Opacity(opacity: 0.0, child: Image.asset(asset))
                ]),
            color: color,
            onPressed: onPressed);
}
