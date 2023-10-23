import 'package:flutter/material.dart';

import '../dimensions.dart';

class MyText extends StatelessWidget {
  final String text;
  final String lang;
  final Color color;
  final double font;
  const MyText(
      {super.key,
      required this.text,
      required this.lang,
      required this.color,
      this.font = 13});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        style: TextStyle(
            fontFamily: lang == 'ar' ? 'Cairo' : 'Varela',
            fontSize: font,
            color: color),
      ),
    );
  }
}
