import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../models/student_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/dimensions.dart';
import '../../../shared/globals.dart' as globals;
import '../profile_page.dart';

class HeadPage extends StatelessWidget {
  const HeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    Student student = globals.student;
    String imageUrl =
        "${globals.domain}/courses/upload/images/profiles/" + student.img;
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFAFAFA), boxShadow: [
        BoxShadow(
            color: Color(0x90A6A6AA), offset: Offset(0, 0.33), blurRadius: 0.4)
      ]),
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.vertical(9),
          horizontal: Dimensions.horizontal(21)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Hot Course",
              style: TextStyle(
                  fontSize: Dimensions.fontSize(25),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'logo')),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: SProfile()));
            },
            child: Container(
              // margin: EdgeInsets.only(top: Dimensions.height(35)),
              width: Dimensions.width(40),
              height: Dimensions.height(40),
              child: CircleAvatar(
                foregroundImage:
                    student.img == "" ? null : NetworkImage(imageUrl),
                backgroundColor: SharedColors.activeColor,
                child: Text(
                  "${student.fName.substring(0, 1).toUpperCase()}${student.lName.substring(0, 1).toUpperCase()}",
                  style: TextStyle(
                      fontSize: Dimensions.fontSize(15), color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
