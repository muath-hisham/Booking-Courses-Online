import 'package:courses/shared/colors.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';

import '../diff.dart';

class MyNotification extends StatelessWidget {
  final Map<String, dynamic> notification;
  final String lang;
  const MyNotification(
      {super.key, required this.notification, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: Dimensions.vertical(15)),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.horizontal(30),
                  vertical: Dimensions.vertical(30),
                ),
                child: Icon(
                  FontAwesome.bell_o,
                  color: SharedColors.star,
                  size: Dimensions.fontSize(50),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      differenceDate(notification['notification_time']),
                      style: TextStyle(
                        fontFamily: lang == 'ar' ? 'Cairo' : 'Varela',
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height(5),
                    ),
                    Text(
                      notification['notification_content'],
                      style: TextStyle(
                        fontFamily: lang == 'ar' ? 'Cairo' : 'Varela',
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(25)),
          child: Divider(color: SharedColors.activeColor, height: 0.5),
        )
      ],
    );
  }
}
