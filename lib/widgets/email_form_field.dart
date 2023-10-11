import 'package:flutter/material.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField(
      {super.key,
      required this.controller,
      required this.icon,
      required this.labeltext,
      required this.type
      //  required this.focus
      });

  final TextEditingController controller;
  final Icon icon;
  final String labeltext;
  final TextInputType type;
  //final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),

      // focusNode: focus,
      // validator: context.validator.email().build(),
      decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(color: Colors.white),
          suffixIconColor: Colors.white,
          suffixIcon: icon,
          iconColor: Colors.white),
      keyboardType: type,
      textInputAction: TextInputAction.next,
    );
  }
}
