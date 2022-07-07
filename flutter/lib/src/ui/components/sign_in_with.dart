import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInWithOAuthButton extends StatelessWidget {
  const SignInWithOAuthButton({
    Key? key,
    this.size = 19,
    required this.button,
    required this.onSignInPress,
  })  : _padding = size * 1.33 / 2,
        super(key: key);

  final Future<void> Function(BuildContext context) onSignInPress;
  final Buttons button;

  final double _padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    final margin = (size + _padding * 2) / 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SignInButton(
          button,
          padding: EdgeInsets.all(margin),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          onPressed: () {
            return onSignInPress(context);
          },
        ),
      ],
    );
  }
}
