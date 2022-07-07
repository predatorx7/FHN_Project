import 'package:flutter/material.dart';

const _borderRadius = BorderRadius.all(Radius.circular(8.0));

class AppLoginFormField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final FormFieldSetter<String> onSave;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  const AppLoginFormField({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.onSave,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autofillHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return TextFormField(
      onSaved: onSave,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: isDark ? Colors.black12 : Colors.white30,
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        border: const OutlineInputBorder(
          borderRadius: _borderRadius,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
