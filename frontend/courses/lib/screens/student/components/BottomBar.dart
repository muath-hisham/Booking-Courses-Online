import 'package:courses/screens/student/courses_page.dart';
import 'package:courses/screens/student/home_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../shared/globals.dart' as globals;

import '../../../shared/colors.dart';
import '../../../shared/dimensions.dart';
import '../../../shared/globals.dart';
import '../../../shared/search_controller.dart';
import '../notifications_page.dart';
import '../setting_page.dart';

class BottomBar extends StatefulWidget {
  final String active;
  const BottomBar({super.key, this.active = "null"});

  @override
  State<BottomBar> createState() => _BottomBarState(this.active);
}

class _BottomBarState extends State<BottomBar> {
  String active;
  bool home = false;
  bool search = false;
  bool courses = false;
  bool notification = false;
  bool setting = false;

  @override
  _BottomBarState(this.active);

  whoIsActive() {
    if (active == "home") {
      home = true;
    } else if (active == "search") {
      search = true;
    } else if (active == "courses") {
      courses = true;
    } else if (active == "notification") {
      notification = true;
    } else if (active == "setting") {
      setting = true;
    }
  }

  @override
  void initState() {
    super.initState();
    whoIsActive();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          lang['lang'] == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: Dimensions.height(70),
          color: SharedColors.page,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade, child: SHomePage()));
                },
                icon: home ? Icon(Icons.home) : Icon(Icons.home_outlined),
                color: home ? SharedColors.activeColor : Colors.black,
              ),
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
                icon: Icon(Icons.search),
                color: search ? SharedColors.activeColor : Colors.black,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: SCoursesPage()));
                },
                icon: courses
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_outline),
                color: courses ? SharedColors.activeColor : Colors.black,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: SNotifications()));
                },
                icon: notification
                    ? Icon(Icons.notifications)
                    : Icon(Icons.notifications_outlined),
                color: notification ? SharedColors.activeColor : Colors.black,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade, child: SSettings()));
                },
                icon: setting
                    ? Icon(Icons.settings)
                    : Icon(Icons.settings_outlined),
                color: setting ? SharedColors.activeColor : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
