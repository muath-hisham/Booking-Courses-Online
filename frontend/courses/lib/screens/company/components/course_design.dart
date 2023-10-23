import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../shared/globals.dart' as globals;
import '../../../shared/settings/dropdown_menu/menu_item.dart';
import '../../../shared/settings/dropdown_menu/menu_items.dart';
import '../courses_data.dart';

class CourseDesign extends StatelessWidget {
  final Map<String, dynamic> data;
  const CourseDesign({super.key, required this.data});

  // dorpdown menu
  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            SizedBox(width: Dimensions.width(12)),
            Text(globals.lang[item.text]!),
          ],
        ),
      );

  Future onSelected(
      BuildContext context, MenuItem item, Map<String, dynamic> course) async {
    switch (item) {
      case MenuItems.itemDelete:
        // await FlutterClipboard.copy(text);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(globals.lang['Copied to clipboard']!)));
        break;
      case MenuItems.itemEdit:
        // Share.share('check out my website https://pub.dev/packages/share_plus'); //////////////////////////////////
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "${globals.domain}/courses/upload/images/profiles/${globals.company.img}";
    return Row(
      children: [
        Expanded(
          child: Container(
            // width: double.infinity,
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
                        child: CCourseData(
                          data: data,
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
                              width: Dimensions.width(66),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    data['company_name'],
                                    style: TextStyle(
                                        fontSize: Dimensions.fontSize(15)),
                                  ),
                                  SizedBox(height: Dimensions.height(5)),
                                  Text(data['course_name'], softWrap: true,)
                                ],
                              ),
                            ),
                          ]),
                          Column(
                            children: [
                              Text(
                                data['course_price_after_discount'].toString(),
                                style: TextStyle(
                                    fontSize: Dimensions.fontSize(20)),
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
          ),
        ),
        // controller
        PopupMenuButton<MenuItem>(
          padding: EdgeInsets.zero,
          onSelected: (item) => onSelected(context, item, data),
          itemBuilder: (context) => [
            ...MenuItems.itemsCorses.map(buildItem).toList(),
          ],
        ),
      ],
    );
  }
}
