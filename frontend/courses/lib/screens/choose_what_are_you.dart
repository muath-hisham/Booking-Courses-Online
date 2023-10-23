import 'package:courses/screens/company_create_account.dart';
import 'package:courses/screens/student_create_account.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../shared/globals.dart' as globals;

class ChooseWhatAreYou extends StatelessWidget {
  const ChooseWhatAreYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.redAccent,
        height: double.infinity,
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Dimensions.width(200),
                height: Dimensions.height(45),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: StudentCreateAccount()));
                  },
                  child: Text("${globals.lang['Student']}"),
                ),
              ),
              SizedBox(height: Dimensions.height(40)),
              Container(
                width: Dimensions.width(200),
                height: Dimensions.height(45),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: CompanyCreateAccount()));
                  },
                  child: Text("${globals.lang['Company']}"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
