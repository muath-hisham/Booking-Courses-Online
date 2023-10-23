import 'package:courses/shared/language/language.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../dimensions.dart';
import 'my_text.dart';

class ExandableText extends StatefulWidget {
  final String text;
  final Map<String, dynamic> lang;
  const ExandableText({super.key, required this.text, required this.lang});

  @override
  State<ExandableText> createState() => _ExandableTextState();
}

class _ExandableTextState extends State<ExandableText> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  double textHeight = Dimensions.height(100);

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight.toInt()) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(17)),
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              style: TextStyle(
                  color: Colors.black),
            )
          : InkWell(
              onTap: () {
                setState(() {
                  hiddenText = !hiddenText;
                });
              },
              child: Column(
                children: [
                  Text(
                    hiddenText
                        ? (firstHalf + " ...")
                        : (firstHalf + " " + secondHalf),
                    style: TextStyle(
                        color: Colors.black),
                  ),
                  Row(
                    children: [
                      Text(
                        hiddenText
                            ? widget.lang['See more']
                            : widget.lang['See less'],
                        style: TextStyle(color: SharedColors.activeColor),
                      ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: SharedColors.activeColor,
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
