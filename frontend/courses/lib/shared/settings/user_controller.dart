import 'dart:convert';

import 'package:courses/shared/settings/status_codes.dart';
import 'package:courses/shared/settings/user_types.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../models/company_model.dart';
import '../../models/student_model.dart';
import '../../screens/company/home_page.dart';
import '../../screens/student/home_page.dart';
import '../../shared/globals.dart' as globals;

import '../call_api.dart';

class UserController {
  // This function attempts to log in automatically using the provided user type, email, and password.
  // Returns true if login is successful, otherwise returns false.
  Future<bool> autoLogin(
      context, UserType type, String email, String password) async {
    // Prepare the login request payload.
    final data = {
      'method': 'autoLogin',
      'email': email,
      'password': password,
      'user_type': userTypeToString(type)
    };

    // Send the login request to the server.
    var response = await CallApi().postData(data);


    print(response.body);
    // Parse the response from the server.
    var state = json.decode(response.body);


    // If the response status code indicates a successful login (101),
    if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
      // Extract the user data from the response.
      Map<String, dynamic> user = state['user'];

      // Depending on the user type, save the user data to a global variable and navigate to the correct home page.
      switch (type) {
        case UserType.Student:
          globals.student = Student(user);
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: SHomePage()));
          break;
        case UserType.Company:
          globals.company = Company(user);
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: CHomePage()));
          break;
        case UserType.Admin:
          // Add admin handling code here.
          break;
      }

      // Return true indicating a successful login.
      return true;
    }

    // If the login was not successful, return false.
    return false;
  }
}
