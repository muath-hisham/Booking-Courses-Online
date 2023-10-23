import 'dart:convert';

import 'package:courses/screens/student/components/course_design.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;

import 'package:http/http.dart' as http;
import '../../shared/colors.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import 'components/BottomBar.dart';
import 'components/head_page.dart';

class SCoursesPage extends StatefulWidget {
  const SCoursesPage({super.key});

  @override
  State<SCoursesPage> createState() => _SCoursesPageState();
}

class _SCoursesPageState extends State<SCoursesPage> {
  final _searchController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final controller = ScrollController();
  List<dynamic> courses = [];
  int offset = 0;
  bool isLoadingMore = false;
  bool bought = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
    fetchData(10, 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  Future onScroll() async {
    if (isLoadingMore) return;

    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;

    if (maxScroll == currentScroll) {
      setState(() {
        isLoadingMore = true;
      });
      offset += 10;
      await fetchData(10, offset);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future fetchData(int limit, int offset) async {
    String url =
        '${globals.domain}/courses/infinite scroll/courses_to_student.php?id=${globals.student.id}&country=${globals.student.country}&limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      var state = json.decode(response.body);
      print(response.body);
      // myOffset = state['my_offset'];
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['courses'];
        for (int i = 0; i < list.length; i++) {
          await wasItBought(list[i]['course_id']);
          list[i]['bought'] = bought;
        }
        setState(() {
          courses = courses + list;
        });
      } else if (state['state'] == getStatusCodeValue(StatusCode.Empty)) {
        return "no courses";
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
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SCoursesPage()));
    });

    return null;
  }

  // Future generateCoursesList() async {
  //   final data = {
  //     'method': 'courses_to_student',
  //     'student_id': globals.student.id,
  //     'student_country': globals.student.country
  //   };
  //   var response = await CallApi().postData(data);
  //   print("${globals.student.id} ------------------");
  //   print("${response.statusCode} ======================");
  //   print("${response.body} ------------------------");
  //   if (response.statusCode == 200) {
  //     // print("Data sent successfully");
  //     var state = json.decode(response.body);
  //     if (state['state'] == 101) {
  //       List courses = state['courses'];
  //       return courses;
  //     } else if (state['state'] == 102) {
  //       return "no courses";
  //     } else {
  //       print("error");
  //     }
  //   } else {
  //     Alert.error(context, globals.lang["check your network"]);
  //     // print("check your network");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeadPage(),
              Directionality(
                textDirection: globals.lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  // height: Dimensions.height(90),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontal(31),
                      vertical: Dimensions.vertical(25)),
                  child: Row(
                    children: [
                      Expanded(
                        // width: Dimensions.width(262),
                        // height: Dimensions.height(41),
                        child: TextField(
                          controller: _searchController,
                          // scrollPadding: EdgeInsets.all(10),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.all(Dimensions.height(10.0)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            // labelText: "${globals.lang['Email']}",
                            fillColor: SharedColors.page,
                            filled: true,
                            prefixIcon: Icon(Icons.search),
                            hintText: lang["Search course"],
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width(10),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: Dimensions.height(52),
                          width: Dimensions.width(52),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                              border: Border.all(color: Colors.black)),
                          child: Icon(FontAwesome5Solid.sliders_h,
                              color: Colors.grey[500]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // SizedBox(height: Dimensions.height(4)),
              Container(
                width: double.infinity,
                height: Dimensions.height(555),
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.horizontal(31)),
                child: courses.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        key: refreshIndicatorKey,
                        onRefresh: refreshList,
                        child: ListView.builder(
                          controller: controller,
                          itemCount: isLoadingMore
                              ? courses.length + 1
                              : courses.length,
                          itemBuilder: (context, index) {
                            if (index < courses.length) {
                              return CourseDesign(
                                data: courses[index],
                                wasItBought: courses[index]['bought'],
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(active: "courses"),
    );
  }
}
