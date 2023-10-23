import 'dart:convert';
import 'package:courses/screens/student/rate_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:courses/screens/student/components/course_design.dart';
import 'package:courses/screens/student/components/review.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:courses/shared/widgets/my_text.dart';
import 'package:courses/shared/widgets/post_view_to_student.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import '../../shared/widgets/my_backButton.dart';
import 'components/BottomBar.dart';
import 'components/about.dart';

class SCompanyPage extends StatefulWidget {
  final Map<String, dynamic> companyData;
  const SCompanyPage({super.key, required this.companyData});

  @override
  State<SCompanyPage> createState() => _SCompanyPageState();
}

class _SCompanyPageState extends State<SCompanyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFollow = false;
  bool isTherePosts = true;
  bool bought = false;
  bool isDoRate = false;

  List locations = [
    "nasser city",
    "alf maskan"
  ]; //////////////////////////////////////////////////

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final controller = ScrollController();
  List<dynamic> posts = [];
  int offset = 0;
  bool isLoadingMore = false;
  int numberOfReviews = 0;
  double rate = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
    getNumberOfReviews();
    generatePostsList(10, 0);
    _tabController = TabController(length: 4, vsync: this);
    isFollowing();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future onScroll() async {
    if (isLoadingMore) return;

    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;

    if (maxScroll == currentScroll) {
      setState(() {
        isLoadingMore = true;
      });
      offset += 10;
      await generatePostsList(10, offset);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future generatePostsList(int limit, int offset) async {
    String url =
        '${globals.domain}/courses/infinite scroll/posts_the_company.php?id=${widget.companyData['company_id']}&limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      var state = json.decode(response.body);
      print(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['posts'];
        setState(() {
          posts = posts + list;
        });
      } else if (state['state'] == getStatusCodeValue(StatusCode.Empty)) {
        setState(() {
          isTherePosts = false;
        });
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      throw Exception('Failed to load data');
    }
  }

  Future refreshList() async {
    // await Future.delayed(Duration(seconds: 1));  //simulate delay

    setState(() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SCompanyPage(companyData: widget.companyData)));
    });

    return null;
  }

  // Future generatePostsList() async {
  //   print("${globals.student.id} ------------------");
  //   print("${response.statusCode} ======================");
  //   print("${response.body} ------------------------");
  //   if (response.statusCode == 200) {
  //     // print("Data sent successfully");
  //     var state = json.decode(response.body);
  //     if (state['state'] == 101) {
  //       List list = state['posts'];
  //       return list;
  //     } else if (state['state'] == 102) {
  //       return "no posts";
  //     } else {
  //       print("error");
  //     }
  //   } else {
  //     Alert.error(context, globals.globals.lang["check your network"]);
  //     // print("check your network");
  //   }
  // }

  Future generateCoursesList() async {
    final data = {
      'method': 'courses_to_company',
      'company_id': widget.companyData['company_id']
    };
    var response = await CallApi().postData(data);
    print("${globals.student.id} ------------------");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        List list = state['courses'];
        for (int i = 0; i < list.length; i++) {
          await wasItBought(list[i]['course_id']);
          list[i]['bought'] = bought;
        }
        return list;
      } else if (state['state'] == 102) {
        return "no courses";
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  Future isFollowing() async {
    Map data = {
      'method': 'is_follow_company',
      'student_id': globals.student.id,
      'company_id': '${widget.companyData['company_id']}'
    };

    var response = await CallApi().postData(data);
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        if (state['isFollow'] == "1") {
          print("is true ======================");
          setState(() {
            isFollow = true;
          });
        } else {
          print("is false ======================");
          setState(() {
            isFollow = false;
          });
        }
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
    }
  }

  Future followCompany() async {
    if (isFollow) {
      Map data = {
        'method': 'follow_company',
        'student_id': globals.student.id,
        'company_id': '${widget.companyData['company_id']}',
        'process': 'follow'
      };
      var response = await CallApi().postData(data);
    } else {
      print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
      Map data = {
        'method': 'follow_company',
        'student_id': globals.student.id,
        'company_id': '${widget.companyData['company_id']}',
        'process': 'unFollow'
      };
      var response = await CallApi().postData(data);
      print(response.body);
    }
  }

  Future wasItBought(var courseId) async {
    final data = {
      'method': 'wasItBought',
      'student_id': globals.student.id,
      'course_id': courseId
    };
    var response = await CallApi().postData(data);
    print("${globals.student.id} ------------------");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        bought = true;
      } else if (state['state'] == 102) {
        bought = false;
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  Future generateReviewsList() async {
    final data = {
      'method': 'reviews_to_student',
      'company_id': widget.companyData['company_id'],
      'student_id': globals.student.id
    };

    var response = await CallApi().postData(data);
    print("${globals.student.id} kmkmkmkmkmkmkmkmkmkmkmkmkm");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        List list = state['reviews'];
        if (list[0]['student_id'] == globals.student.id) {
          // setState(() {
          isDoRate = true;
          // });
        }
        return list;
      } else if (state['state'] == 102) {
        return "no reviews";
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

    Future getNumberOfReviews() async {
    final data = {
      'method': 'get_number_of_reviews',
      'company_id': widget.companyData['company_id']
    };
    var response = await CallApi().postData(data);
    print("${globals.student.id} ------------------");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      var state = json.decode(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['reviews'];
        int sumAllRates = 0;
        for (Map review in list) {
          sumAllRates += int.parse(review['rate']);
        }
        setState(() {
          numberOfReviews = list.length;
          rate = sumAllRates / list.length;
        });
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.companyData['company_img'] != ""
        ? "${globals.domain}/courses/upload/images/profiles/${widget.companyData['company_img']}"
        : "";

    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        bottom: true,
        top: true,
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
                child: imageUrl != ""
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: Dimensions.height(230),
                      )
                    : Container(
                        color: Colors.lightBlue,
                        child: Center(
                          child: Text(widget.companyData['company_name']),
                        ),
                      ),
              ),
            ),
            // back button
            MyBackButton(),
            // Reviews
            Positioned(
              top: Dimensions.height(185),
              left: globals.lang['lang'] == 'ar' ? 0 : null,
              right: globals.lang['lang'] == 'ar' ? null : 0,
              child: Container(
                height: Dimensions.height(31),
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
                    child: Row(
                      //  mainAxisAlignment: globals.lang['lang']=='ar'? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: SharedColors.star,
                          size: Dimensions.fontSize(14),
                        ),
                        SizedBox(width: Dimensions.width(3)),
                        MyText(
                          text: "${rate.toPrecision(1)} ($numberOfReviews ${lang['Reviews']})",
                          color: Colors.white,
                          lang: globals.lang['lang']!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // the name and follow
            Positioned(
              top: Dimensions.height(235),
              left: Dimensions.horizontal(17),
              right: Dimensions.horizontal(17),
              child: Directionality(
                textDirection: globals.lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: widget.companyData['company_name'],
                      lang: globals.lang['lang']!,
                      color: Colors.black,
                      font: Dimensions.fontSize(30),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isFollow = !isFollow;
                        });
                        await followCompany();
                      },
                      child: Container(
                        height: Dimensions.height(30),
                        width: Dimensions.width(105),
                        decoration: BoxDecoration(
                          color:
                              isFollow ? Color(0xFF262626) : Color(0xFF233974),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            isFollow
                                ? globals.lang['following']!
                                : globals.lang['follow']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: globals.lang['lang'] == 'ar'
                                  ? 'Cairo'
                                  : 'Varela',
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSize(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // taps
            Positioned(
              top: Dimensions.height(290),
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
                          isScrollable: true,
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
                                globals.lang['posts']!,
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
                                globals.lang['Courses']!,
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
                                globals.lang['about']!,
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
                                globals.lang['reviews']!,
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
                          ]),
                    ),
                    Container(
                      height: Dimensions.height(380),
                      width: double.infinity,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // all posts to this company
                          !isTherePosts && posts.isEmpty
                              ? Center(
                                  child: Text(
                                  globals.lang['There are no posts']!,
                                  style: TextStyle(
                                      fontSize: Dimensions.fontSize(18),
                                      fontWeight: FontWeight.w500),
                                ))
                              : posts.isEmpty
                                  ? Center(child: CircularProgressIndicator())
                                  : RefreshIndicator(
                                      key: refreshIndicatorKey,
                                      onRefresh: refreshList,
                                      child: ListView.builder(
                                        controller: controller,
                                        itemCount: isLoadingMore
                                            ? posts.length + 1
                                            : posts.length,
                                        itemBuilder: (context, index) {
                                          if (index < posts.length) {
                                            return PostToStudent(
                                              lang: globals.lang,
                                              post: posts[index],
                                            );
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                          // all courses to this company
                          FutureBuilder(
                            future: generateCoursesList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == 'no courses') {
                                  return Center(
                                      child: Text(
                                    globals.lang["There are no courses"]!,
                                    style: TextStyle(
                                        fontSize: Dimensions.fontSize(18),
                                        fontWeight: FontWeight.w500),
                                  ));
                                } else {
                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.horizontal(25)),
                                          child: CourseDesign(
                                            data: snapshot.data[index],
                                            wasItBought: snapshot.data[index]
                                                ['bought'],
                                          ),
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
                          // about page
                          About(
                            data: widget.companyData,
                            lang: globals.lang['lang']!,
                            locations: locations,
                          ),
                          // reviews
                          Container(
                            margin: EdgeInsets.only(top: Dimensions.height(5)),
                            child: Column(
                              children: [
                                isDoRate
                                    ? SizedBox()
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.horizontal(24)),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  globals.lang[
                                                      'Rate this center']!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle: Text(
                                                globals.lang[
                                                    'Tell others what you think']!,
                                                style: TextStyle(
                                                    fontSize:
                                                        Dimensions.fontSize(
                                                            13)),
                                              ),
                                            ),
                                            // SizedBox(height: Dimensions.height(5)),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              itemCount: 5,
                                              itemSize: Dimensions.fontSize(30),
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimensions.horizontal(
                                                          15)),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: Rate(
                                                      rate: rating,
                                                      data: widget.companyData,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(height: Dimensions.height(10)),
                                FutureBuilder(
                                  future: generateReviewsList(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data == 'no reviews') {
                                        return Center(
                                          child: Text(
                                            globals
                                                .lang["There are no reviews"]!,
                                            style: TextStyle(
                                                fontSize:
                                                    Dimensions.fontSize(18),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          height: isDoRate
                                              ? Dimensions.height(360)
                                              : Dimensions.height(250),
                                          child: ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return Review(
                                                review: snapshot.data[index],
                                                lang: globals.lang['lang']!,
                                                delete: snapshot.data[index]['student_id'] == globals.student.id,
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
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
      bottomNavigationBar: BottomBar(),
    );
  }
}
