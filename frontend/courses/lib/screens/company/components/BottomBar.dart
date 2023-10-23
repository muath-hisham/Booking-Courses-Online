import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../shared/colors.dart';
import '../../../shared/dimensions.dart';
import '../../../shared/globals.dart' as globals;
import '../courses_company.dart';
import '../home_page.dart';
import '../notifications_company.dart';
import '../profile.dart';
import '../settings_company.dart';

class BottomBar extends StatefulWidget {
  final String active;

  const BottomBar({super.key, required this.active});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool home = false;
  bool yourCourses = false;
  bool settings = false;
  bool notifications = false;
  bool profile = false;

  @override
  _BottomBarState();

  whoIsActive() {
    if (widget.active == "home") {
      home = true;
    } else if (widget.active == "yourCourses") {
      yourCourses = true;
    } else if (widget.active == "settings") {
      settings = true;
    } else if (widget.active == "notifications") {
      notifications = true;
    } else if (widget.active == "profile") {
      profile = true;
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
          globals.lang['lang'] == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: Dimensions.height(70),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              color: Colors.white),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: Dimensions.height(50),
              width: Dimensions.width(155),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: CHomePage()));
                      },
                      icon:
                          (home) ? Icon(Icons.home) : Icon(Icons.home_outlined),
                      color: (home) ? SharedColors.activeColor : Colors.black),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: CProfile()));
                    },
                    icon: (profile)
                        ? Icon(Icons.person)
                        : Icon(Icons.person_outline),
                    color: (profile) ? SharedColors.activeColor : Colors.black,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: CCoursesPage()));
              },
              icon: Icon(Icons.bookmark_outline),
              color: Colors.black,
              iconSize: (yourCourses) ? 0 : null,
            ),
            Container(
              height: Dimensions.height(50),
              width: Dimensions.width(155),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: CNotifications()));
                    },
                    icon: (notifications)
                        ? Icon(Icons.notifications)
                        : Icon(Icons.notifications_outlined),
                    color: (notifications)
                        ? SharedColors.activeColor
                        : Colors.black,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: CSettings()));
                    },
                    icon: (settings)
                        ? Icon(Icons.settings)
                        : Icon(Icons.settings_outlined),
                    color: (settings) ? SharedColors.activeColor : Colors.black,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
