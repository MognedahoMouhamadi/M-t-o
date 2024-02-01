import 'package:flutter/material.dart';

class Bouton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // Corrected variable name to follow Dart conventions

  Bouton({
    Key? key, // Corrected variable name to follow Dart conventions
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.amber,
      child: Text(text),
    );
  }
}
