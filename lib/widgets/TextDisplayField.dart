import 'package:flutter/material.dart';

class TextDisplayField extends StatefulWidget {
  final IconData? prefixIcon;
  final String? text;
  final bool? readonly;
  const TextDisplayField({Key? key, this.prefixIcon, this.text, this.readonly})
      : super(key: key);

  @override
  _StateTextDisplayField createState() => _StateTextDisplayField();
}

class _StateTextDisplayField extends State<TextDisplayField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 17.0),
      child: TextField(
        readOnly: widget.readonly!,
        style: const TextStyle(fontSize: 22.0),
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 16.0),
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0)),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.indigo[400],
          ),
          hintText: widget.text,
        ),
      ),
    );
  }
}
