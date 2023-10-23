import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../shared/call_api.dart';
import '../../../shared/colors.dart';
import '../../../shared/dimensions.dart';
import '../../../shared/globals.dart' as globals;
import '../company_details_page.dart';

class Review extends StatelessWidget {
  final Map<String, dynamic> review;
  final String lang;
  final bool delete;
  const Review(
      {super.key,
      required this.review,
      required this.lang,
      this.delete = false});

  Future deleteRate(context) async {
    Map data = {
      'method': 'delete_rate',
      'student_id': globals.student.id,
      'company_id': '${review['company_id']}'
    };
    var response = await CallApi().postData(data);
    Navigator.of(context).pop();
    Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: SCompanyPage(companyData: review)));
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: Dimensions.height(49),
                    width: Dimensions.width(49),
                    child: CircleAvatar(
                      foregroundImage: review['student_img'] == ""
                          ? null
                          : NetworkImage(
                              "${globals.domain}/courses/upload/images/profiles/${review['student_img']}"),
                      backgroundColor: SharedColors.activeColor,
                      child: Text(
                        "${review['student_first_name'].substring(0, 1)}${review['student_last_name'].substring(0, 1)}",
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
                        "${review['student_first_name']} ${review['student_last_name']}",
                        style: TextStyle(
                            fontFamily: lang == 'ar' ? 'Cairo' : 'Varela',
                            fontSize: Dimensions.fontSize(13),
                            color: Colors.black),
                      ),
                      Builder(
                        builder: (context) {
                          int x = int.parse(review['rate']);
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
                  ),
                ],
              ),
              delete
                  ? CupertinoButton(
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(globals.lang['Delete the Rate']!),
                              content: Text(globals.lang['Are you sure?']!),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  child: Text(globals.lang['No']!),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(globals.lang['Yes']!),
                                  onPressed: () async {
                                    await deleteRate(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.redAccent.shade100,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          Builder(
            builder: (context) {
              if (review['rate_content'] == "") {
                return SizedBox();
              }
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: Dimensions.horizontal(12),
                  right: Dimensions.horizontal(12),
                  top: Dimensions.vertical(10),
                  bottom: Dimensions.vertical(10),
                ),
                child: Text(
                  "${review['rate_content']}",
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
