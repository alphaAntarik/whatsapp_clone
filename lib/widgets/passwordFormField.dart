import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  //final FocusNode focus;
  // final bool obscure;
  // final VoidCallback onToggle;

  PasswordFormField({super.key, required this.controller
      //  required this.obscure,
      // required this.onToggle,
      });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: widget.controller,
      obscureText: obscure,
      style: TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: 'password',
        labelStyle: TextStyle(color: Colors.white),
        suffixIconColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
        ),
      ),
      textInputAction: TextInputAction.done,
      // focusNode: widget.focus,
      // onFieldSubmitted: (v){
      //         FocusScope.of(context).requestFocus(widget.focus);
      //       },
    );
  }
}
