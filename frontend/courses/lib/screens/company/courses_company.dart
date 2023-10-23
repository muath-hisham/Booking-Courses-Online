import 'dart:convert';

import 'package:courses/screens/company/components/course_design.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;

import '../../shared/colors.dart';
import '../../shared/widgets/awesome_dialog.dart';
import 'add_new_course.dart';
import 'components/BottomBar.dart';
import 'components/head_page.dart';

class CCoursesPage extends StatefulWidget {
  const CCoursesPage({super.key});

  @override
  State<CCoursesPage> createState() => _CCoursesPageState();
}

class _CCoursesPageState extends State<CCoursesPage> {
  final _searchController = TextEditingController();
  Map<String, String> lang = globals.lang; // to choose the language

  Future generateCoursesList() async {
    final data = {
      'method': 'courses_to_company',
      'company_id': globals.company.id
    };
    var response = await CallApi().postData(data);
    print("${globals.student.id} ------------------");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        List courses = state['courses'];
        return courses;
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
              SizedBox(height: Dimensions.height(10)),
              Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height - Dimensions.height(170),
                padding: EdgeInsets.only(
                    left: Dimensions.horizontal(17),
                    right: Dimensions.horizontal(7)),
                child: FutureBuilder(
                  future: generateCoursesList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == 'no courses') {
                        return Center(
                            child: Text(
                          globals.lang["Add Course"]!,
                          style: TextStyle(
                              fontSize: Dimensions.fontSize(18),
                              fontWeight: FontWeight.w500),
                        ));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            // print("${snapshot.data.length} =======================");
                            return CourseDesign(
                              data: snapshot.data[index],
                            );
                          },
                        );
                      }
                    }
                    // print("1");
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              // ListView.builder(
              //   itemCount: courses.length,
              //   itemBuilder: (context, index) {
              //     // if (courses[index]['isAproved'] == true) {
              //     return CourseDesign(data: courses[index]);
              //     // return Text("data");
              //     // }
              //   },
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddNewCourse(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            },
          ));
        },
        backgroundColor: Color(0xFFF17532),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(active: "yourCourses"),
    );
  }
}
