import 'package:flutter/material.dart';

import '../../../shared/colors.dart';
import '../../../shared/dimensions.dart';

class Review extends StatelessWidget {
  final Map<String, dynamic> review;
  final String lang;
  const Review({super.key, required this.review, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.horizontal(17.8),
          vertical: Dimensions.vertical(16.2)),
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.vertical(10),
          horizontal: Dimensions.horizontal(31)),
      //  width: Dimensions.width(313),
      // height: Dimensions.height(81),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.height(10))),
          color: Colors.white,
          border: Border.all(
              color: Color(0xFFE4E4E4), width: Dimensions.fontSize(1)),
          boxShadow: [
            BoxShadow(
              blurRadius: Dimensions.fontSize(5),
              offset: Offset(Dimensions.width(2), Dimensions.height(4)),
              color: Color.fromARGB(20, 0, 0, 0),
            )
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: Dimensions.height(49),
                width: Dimensions.width(49),
                child: CircleAvatar(
                  foregroundImage:
                      review['img'] == "" ? null : NetworkImage(review['img']),
                  backgroundColor: SharedColors.activeColor,
                  child: Text(
                    "${review['name'].substring(0, 2)}",
                    style: TextStyle(
                        fontFamily: lang == 'ar' ? 'Cairo' : 'Varela',
                        fontSize: Dimensions.fontSize(13),
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.width(8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['name'],
                    style: TextStyle(
                        fontFamily: lang == 'ar' ? 'Cairo' : 'Varela',
                        fontSize: Dimensions.fontSize(13),
                        color: Colors.black),
                  ),
                  Builder(
                    builder: (context) {
                      int x = review['rate'];
                      List<Widget> stars = [];
                      for (int i = 0; i < x; i++) {
                        stars.add(Icon(
                          Icons.star,
                          color: SharedColors.star,
                          size: Dimensions.fontSize(17),
                        ));
                      }
                      for (int j = x; j < 5; j++) {
                        stars.add(Icon(
                          Icons.star_border,
                          color: SharedColors.star,
                          size: Dimensions.fontSize(17),
                        ));
                      }
                      Row rowStars = Row(
                        children: stars,
                      );
                      return rowStars;
                    },
                  )
                ],
              )
            ],
          ),
          Builder(
            builder: (context) {
              if (review['contant'] == "") {
                return SizedBox();
              }
              return Container(
                margin: EdgeInsets.only(
                  left: Dimensions.horizontal(12),
                  right: Dimensions.horizontal(12),
                  top: Dimensions.vertical(10),
                  bottom: Dimensions.vertical(10),
                ),
                child: Text(
                  "${review['contant']}",
                  style: TextStyle(
                      fontFamily: lang == 'ar' ? 'Cairo' : 'Varela',
                      color: Colors.black),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
