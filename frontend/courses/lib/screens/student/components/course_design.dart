import 'package:courses/screens/student/course_data.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../shared/globals.dart' as globals;

class CourseDesign extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool wasItBought;
  const CourseDesign(
      {super.key, required this.data, required this.wasItBought});

  @override
  Widget build(BuildContext context) {
    String imageUrl = "${globals.domain}/courses/upload/images/profiles/" +
        data['company_img'];
    return Container(
      width: double.infinity,
      // height: Dimensions.height(81),
      margin: EdgeInsets.symmetric(vertical: Dimensions.vertical(11)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Color(0xFFE4E4E4)),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(22, 0, 0, 0),
              offset: Offset(2, 4),
              blurRadius: 5)
        ],
      ),
      // margin: EdgeInsets.symmetric(horizontal: Dimensions.vertical(30)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: SCourseData(
                    data: data,
                    wasItBought: wasItBought,
                  )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                // color: Colors.black,
                padding: EdgeInsets.only(
                    top: Dimensions.vertical(14),
                    bottom: Dimensions.vertical(14),
                    left: Dimensions.horizontal(17)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        height: Dimensions.height(46),
                        width: Dimensions.width(46),
                        child: CircleAvatar(
                          foregroundImage: NetworkImage(imageUrl),
                        ),
                      ),
                      SizedBox(width: Dimensions.width(15)),
                      Container(
                        width: Dimensions.width(85),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              data['company_name'],
                              style:
                                  TextStyle(fontSize: Dimensions.fontSize(15)),
                            ),
                            SizedBox(height: Dimensions.height(5)),
                            Text(
                              data['course_name'],
                              softWrap: true,
                            )
                          ],
                        ),
                      ),
                    ]),
                    Column(
                      children: [
                        Text(
                          data['course_price_after_discount'].toString(),
                          style: TextStyle(fontSize: Dimensions.fontSize(20)),
                        ),
                        SizedBox(height: Dimensions.height(8)),
                        Text(
                          data['course_price_before_discount'].toString(),
                          style: TextStyle(
                            color: Colors.redAccent,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                VerticalDivider(color: Color(0xFFE4E4E4)),
                Container(
                  // color: Colors.black,
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontal(8)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Dimensions.horizontal(20),
                            vertical: Dimensions.vertical(10)),
                        child: Icon(
                          data['course_type'] == 'online'
                              ? Icons.ondemand_video_outlined
                              : data['course_type'] == 'physical'
                                  ? Icons.person_rounded
                                  : Icons.menu_book,
                          size: 27,
                        ),
                      ),
                      Text("${globals.lang[data['course_type']]}"),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
