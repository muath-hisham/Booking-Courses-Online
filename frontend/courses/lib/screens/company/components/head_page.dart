import 'dart:io';

import 'package:courses/models/company_model.dart';
import 'package:flutter/material.dart';
import '../../../shared/colors.dart';
import '../../../shared/dimensions.dart';
import '../../../shared/globals.dart' as globals;

class HeadPage extends StatelessWidget {
  const HeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    Company company = globals.company;
    String imageUrl = "${globals.domain}/courses/upload/images/profiles/${company.img}";
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
          Container(
            // margin: EdgeInsets.only(top: Dimensions.height(35)),
            width: Dimensions.width(40),
            height: Dimensions.height(40),
            child: CircleAvatar(
              foregroundImage:
                  company.img == "" ? null : NetworkImage(imageUrl), 
              backgroundColor: SharedColors.activeColor,
              child: Text(
                company.name.substring(0, 2).toUpperCase(),
                style: TextStyle(
                    fontSize: Dimensions.fontSize(20), color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
