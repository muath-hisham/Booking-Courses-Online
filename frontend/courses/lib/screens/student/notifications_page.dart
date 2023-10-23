import 'dart:convert';

import 'package:courses/shared/colors.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import '../../shared/widgets/notification.dart';
import 'components/BottomBar.dart';

class SNotifications extends StatefulWidget {
  const SNotifications({super.key});

  @override
  State<SNotifications> createState() => _SNotificationsState();
}

class _SNotificationsState extends State<SNotifications> {
  Map<String, String> lang = globals.lang; // to choose the language

  // get all Notifications to this student
  Future notificationsList() async {
    final data = {
      'method': 'notifications_student',
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
        List list = state['notifications'];
        return list;
      } else if (state['state'] == getStatusCodeValue(StatusCode.Empty)) {
        return "no notifications";
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
        bottom: true,
        top: true,
        child: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: Dimensions.height(65),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: SharedColors.activeColor),
                child: Text(
                  lang['Notification']!,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                      fontSize: 18),
                )),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: Dimensions.height(70),
            child: Directionality(
              textDirection:
                  lang['lang'] == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: Container(
                width: double.infinity,
                height: Dimensions.height(645),
                child: FutureBuilder(
                  future: notificationsList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == 'no notifications') {
                        return Center(
                            child: Text(
                          globals.lang["You don't have any notifications"]!,
                          style: TextStyle(
                              fontSize: Dimensions.fontSize(18),
                              fontWeight: FontWeight.w500),
                        ));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return MyNotification(
                              lang: lang['lang']!,
                              notification: snapshot.data[index],
                            );
                          },
                        );
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomBar(active: "notification"),
    );
  }
}
