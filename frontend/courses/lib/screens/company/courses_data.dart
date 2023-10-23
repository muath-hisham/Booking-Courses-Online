import 'dart:convert';

import 'package:flutter/material.dart';

import '../../shared/call_api.dart';
import '../../shared/colors.dart';
import '../../shared/dimensions.dart';
import '../../shared/widgets/awesome_dialog.dart';
import '../../shared/widgets/exandable_text.dart';
import '../../shared/widgets/my_backButton.dart';
import '../../shared/globals.dart' as globals;
import '../../shared/widgets/my_text.dart';

class CCourseData extends StatefulWidget {
  final Map<String, dynamic> data;
  const CCourseData({super.key, required this.data});

  @override
  State<CCourseData> createState() => _CCourseDataState();
}

class _CCourseDataState extends State<CCourseData>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Future getBooks() async {
    final data = {'method': 'get_books', 'course_id': widget.data['course_id']};
    var response = await CallApi().postData(data);
    print("${globals.student.id} ------------------");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        List list = state['books'];
        return list;
      } else if (state['state'] == 102) {
        return "no books";
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "${globals.domain}/courses/upload/images/profiles/${widget.data['company_img']}";

    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            // the image
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                width: Dimensions.width(375),
                height: Dimensions.height(200),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: Dimensions.height(230),
                ),
              ),
            ),
            // back button
            MyBackButton(),
            // Reviews
            Positioned(
              top: Dimensions.height(170),
              left: globals.lang['lang'] == 'ar' ? 0 : null,
              right: globals.lang['lang'] == 'ar' ? null : 0,
              child: Container(
                height: Dimensions.height(61),
                width: Dimensions.width(150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: globals.lang['lang'] == 'ar'
                        ? Radius.zero
                        : Radius.circular(8),
                    bottomLeft: globals.lang['lang'] == 'ar'
                        ? Radius.zero
                        : Radius.circular(8),
                    topRight: globals.lang['lang'] == 'ar'
                        ? Radius.circular(8)
                        : Radius.zero,
                    bottomRight: globals.lang['lang'] == 'ar'
                        ? Radius.circular(8)
                        : Radius.zero,
                  ),
                  color: Color(0xff0c0c32),
                ),
                child: Directionality(
                  textDirection: globals.lang['lang'] == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.horizontal(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.data['company_name'],
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          //  mainAxisAlignment: lang['lang']=='ar'? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.star,
                              color: SharedColors.star,
                              size: Dimensions.fontSize(14),
                            ),
                            SizedBox(width: Dimensions.width(3)),
                            MyText(
                              text: "3.8 (149 ${globals.lang['Reviews']})",
                              color: Colors.white,
                              lang: globals.lang['lang']!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // name and price
            Positioned(
              top: Dimensions.height(250),
              left: Dimensions.width(50),
              right: Dimensions.width(50),
              child: Directionality(
                textDirection: globals.lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        // name
                        Text(
                          widget.data['course_name'],
                          style: TextStyle(
                              fontSize: Dimensions.fontSize(22),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: Dimensions.height(10)),
                        // type
                        Text(
                          globals.lang[widget.data['course_type']]!,
                          style: TextStyle(
                            fontSize: Dimensions.fontSize(18),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        // price after
                        Text(
                          widget.data['course_price_after_discount'],
                          style: TextStyle(
                              fontSize: Dimensions.fontSize(20),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: Dimensions.height(10)),
                        // price before
                        Text(
                          widget.data['course_price_before_discount'],
                          style: TextStyle(
                            fontSize: Dimensions.fontSize(15),
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
            // about this course
            Positioned(
              top: Dimensions.height(340),
              left: Dimensions.width(40),
              right: Dimensions.width(40),
              child: Directionality(
                textDirection: globals.lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Text(
                  globals.lang['About this course']!,
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
                ),
              ),
            ),
            // long test to about
            Positioned(
              top: Dimensions.height(370),
              left: Dimensions.width(25),
              right: Dimensions.width(25),
              child: Directionality(
                textDirection: globals.lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Container(
                  height: Dimensions.height(105),
                  child: SingleChildScrollView(
                    child: ExandableText(
                      text: widget.data['course_description'],
                      lang: globals.lang,
                    ),
                  ),
                ),
              ),
            ),
            // content and books (tags)
            Positioned(
              top: Dimensions.height(475),
              left: Dimensions.horizontal(0),
              right: Dimensions.horizontal(0),
              child: Directionality(
                textDirection: globals.lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.horizontal(25)),
                      // color: Colors.redAccent,
                      child: TabBar(
                        //labelPadding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(30)),
                        controller: _tabController,
                        //indicatorColor: Colors.transparent,
                        labelColor: Color(0xFF1C1C3E),
                        //isScrollable: true,
                        //labelPadding: EdgeInsets.only(right: 45.0),
                        unselectedLabelColor: Color(0xFFCDCDCD),
                        tabs: [
                          Tab(
                            child: Text(
                              globals.lang['Content']!,
                              style: TextStyle(
                                // color: Colors.white,
                                fontFamily: globals.lang['lang'] == 'ar'
                                    ? 'Cairo'
                                    : 'Varela',
                                //  fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontSize(15),
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              globals.lang['Books']!,
                              style: TextStyle(
                                // color: Colors.white,
                                fontFamily: globals.lang['lang'] == 'ar'
                                    ? 'Cairo'
                                    : 'Varela',
                                //  fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontSize(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.horizontal(40)),
                      height: Dimensions.height(230),
                      width: double.infinity,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Content
                          SingleChildScrollView(
                            child: Container(
                                margin:
                                    EdgeInsets.only(top: Dimensions.height(20)),
                                child: Text(widget.data['course_content'])),
                          ),
                          // books
                          FutureBuilder(
                            future: getBooks(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 'no books') {
                                  return Center(
                                      child: Text(
                                    globals.lang["There are no books"]!,
                                    style: TextStyle(
                                        fontSize: Dimensions.fontSize(18),
                                        fontWeight: FontWeight.w500),
                                  ));
                                } else {
                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () { 
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: Dimensions.height(200),
                                                child: Directionality(
                                                  textDirection:
                                                      globals.lang['lang'] ==
                                                              'ar'
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        width: Dimensions.width(
                                                            150),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              globals.lang[
                                                                  'Number of pages before summarizing']!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    Dimensions
                                                                        .height(
                                                                            20)),
                                                            Text(snapshot
                                                                    .data[index]
                                                                [
                                                                'book_to_course_number_of_pages_before_summ']),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    Dimensions
                                                                        .vertical(
                                                                            15)),
                                                        child: VerticalDivider(
                                                          color: Colors.black,
                                                          thickness: 0.8,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: Dimensions.width(
                                                            150),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              globals.lang[
                                                                  'Number of pages after summarizing']!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    Dimensions
                                                                        .height(
                                                                            20)),
                                                            Text(snapshot
                                                                    .data[index]
                                                                [
                                                                'book_to_course_number_of_pages_after_summ']),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: ListTile(
                                          leading:
                                              Icon(Icons.menu_book_rounded),
                                          title: Text(snapshot.data[index]
                                              ['book_to_course_name']),
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                              // print("1");
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
