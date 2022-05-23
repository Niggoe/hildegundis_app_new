import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/constants.dart';

class InputField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final String? label;
  final TextInputType? type;
  final TextEditingController? controller;
  final bool obscure;
  final FormFieldSetter<String>? savedFunction;

  const InputField(
      {Key? key,
      this.hintText,
      this.prefixIcon,
      this.label,
      this.type,
      this.controller,
      this.savedFunction,
      required this.obscure})
      : super(key: key);
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 17.0),
      child: TextFormField(
        obscureText: widget.obscure,
        onSaved: widget.savedFunction,
        controller: widget.controller,
        keyboardType: widget.type,
        validator: (value) {
          if (value!.isEmpty) {
            return ProjectConfig.ValidatorMessage;
          }
          return ProjectConfig.ValidatorSuccessfulMessage;
        },
        style: const TextStyle(fontSize: 22.0),
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 16.0),
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0)),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.indigo[400],
          ),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
