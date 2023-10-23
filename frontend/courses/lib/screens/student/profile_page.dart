import 'dart:convert';

import 'package:courses/models/student_model.dart';
import 'package:courses/screens/student/components/course_design.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:courses/shared/widgets/my_backButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:page_transition/page_transition.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;
import '../../shared/colors.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import 'components/BottomBar.dart';
import 'components/interest_design.dart';
import 'edit_profile.dart';

class SProfile extends StatefulWidget {
  const SProfile({super.key});

  @override
  State<SProfile> createState() => _SProfileState();
}

class _SProfileState extends State<SProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Student student = globals.student;
  String imageUrl =
      "${globals.domain}/courses/upload/images/profiles/${globals.student.img}";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // get all Notifications to this student
  Future generateCoursesList() async {
    final data = {
      'method': 'own_student_courses',
      'student_id': globals.student.id
    };
    var response = await CallApi().postData(data);
    // print("${globals.student.id} ------------------");
    // print("${response.statusCode} ======================");
    // print("${response.body} ------------------------");
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['courses'];
        return list;
      } else if (state['state'] == getStatusCodeValue(StatusCode.Empty)) {
        return "no courses";
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  // get all Interesting to this student
  Future interestingList() async {
    final data = {
      'method': 'student_interesting_from_all_interesting',
      'student_id': globals.student.id
    };
    var response = await CallApi().postData(data);
    print("${globals.student.id} ------------------");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['interesting'];
        return list;
      } else if (state['state'] == getStatusCodeValue(StatusCode.Empty)) {
        return "no interesting";
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
    final intl.DateFormat formatter = intl.DateFormat('yyyy/MM/dd');
    final String DOB = formatter.format(globals.student.DOB);
    final String timeToCreateAccount =
        formatter.format(globals.student.timeToCreateAccount);
    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        top: true,
        bottom: true,
        // child: Container(
        //   padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(15)),
        //   child: SingleChildScrollView(
        child: Directionality(
          textDirection: globals.lang['lang'] == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              MyBackButton(),
              Positioned(
                top: Dimensions.height(0),
                left: Dimensions.horizontal(0),
                right: Dimensions.horizontal(0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.height(35)),
                        width: Dimensions.width(125),
                        height: Dimensions.height(125),
                        child: CircleAvatar(
                          foregroundImage:
                              student.img == "" ? null : NetworkImage(imageUrl),
                          backgroundColor: SharedColors.activeColor,
                          child: Text(
                            "${student.fName.substring(0, 1).toUpperCase()}${student.lName.substring(0, 1).toUpperCase()}",
                            style: TextStyle(
                                fontSize: Dimensions.fontSize(25),
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height(25)),
                    Center(
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: Dimensions.vertical(15)),
                        child: Text(
                          "${student.fName} ${student.lName}",
                          style: TextStyle(
                              fontSize: Dimensions.fontSize(17),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height(20)),
                    // taps
                    Directionality(
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
                                      globals.lang['Interesting']!,
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
                            height: Dimensions.height(485),
                            width: double.infinity,
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // all courses to this student
                                  FutureBuilder(
                                    future: generateCoursesList(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data == 'no courses') {
                                          return Center(
                                              child: Text(
                                            globals.lang[
                                                "You don\'t have any course"]!,
                                            style: TextStyle(
                                                fontSize:
                                                    Dimensions.fontSize(18),
                                                fontWeight: FontWeight.w500),
                                          ));
                                        } else {
                                          return ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimensions.horizontal(
                                                              25)),
                                                  child: CourseDesign(
                                                    data: snapshot.data[index],
                                                    wasItBought: true,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }
                                      // print("1");
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                  // all interesting to this student
                                  FutureBuilder(
                                    future: interestingList(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Widget> allData = [];
                                        for (var data in snapshot.data) {
                                          Widget interest = InterestDesign(
                                            data: data,
                                          );
                                          allData.add(interest);
                                        }
                                        return Column(
                                          children: [
                                            SizedBox(height: Dimensions.height(15)),
                                            Wrap(
                                              children: allData,
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //   ),
        // ),
      ),
    );
  }
}
