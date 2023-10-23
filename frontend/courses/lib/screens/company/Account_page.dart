import 'package:courses/models/company_model.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:page_transition/page_transition.dart';
import '../../shared/globals.dart' as globals;
import '../../shared/colors.dart';
import 'components/BottomBar.dart';
import 'edit_profile.dart';

class CAccount extends StatefulWidget {
  const CAccount({super.key});

  @override
  State<CAccount> createState() => _CAccountState();
}

class _CAccountState extends State<CAccount> {
  Map<String, String> lang = globals.lang; // to choose the language
  Company company = globals.company;
  String imageUrl =
      "${globals.domain}/courses/upload/images/profiles/${globals.company.img}";

  @override
  Widget build(BuildContext context) {
    final intl.DateFormat formatter = intl.DateFormat('yyyy/MM/dd');
    final String timeToCreateAccount =
        formatter.format(globals.company.timeToCreateAccount);
    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(15)),
          child: SingleChildScrollView(
            child: Directionality(
              textDirection:
                  lang['lang'] == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: Dimensions.height(35)),
                      width: Dimensions.width(125),
                      height: Dimensions.height(125),
                      child: CircleAvatar(
                        foregroundImage:
                            company.img == "" ? null : NetworkImage(imageUrl),
                        backgroundColor: SharedColors.activeColor,
                        child: Text(
                          company.name.substring(0, 2).toUpperCase(),
                          style: TextStyle(
                              fontSize: Dimensions.fontSize(25),
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: CEditProfile()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.vertical(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Color(0xFF0093ED),
                          ),
                          Text(
                            globals.lang['Edit Profile']!,
                            style: TextStyle(
                                color: Color(0xFF0093ED),
                                fontSize: Dimensions.fontSize(10),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.vertical(15)),
                      child: Text(
                        "${globals.lang['Hi there']} ${company.name} !",
                        style: TextStyle(
                            fontFamily:
                                lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                            fontSize: Dimensions.fontSize(17),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height(20)),
                  DataDesign(
                    name: globals.lang['Name']!,
                    data: globals.company.name,
                  ),
                  DataDesign(
                    name: globals.lang['Email']!,
                    data: globals.company.email,
                  ),
                  DataDesign(
                    name: globals.lang['Phone number']!,
                    data: globals.company.phone1,
                  ),
                  globals.company.phone2 != ""
                      ? DataDesign(
                          name: globals.lang['secound Phone number']!,
                          data: globals.company.phone2,
                        )
                      : SizedBox(),
                  DataDesign(
                    name: globals.lang['Website']!,
                    data: globals.company.website,
                  ),
                  DataDesign(
                    name: globals.lang['Description']!,
                    data: globals.company.description,
                  ),
                  DataDesign(
                    name: globals.lang['Joined']!,
                    data: timeToCreateAccount,
                  ),
                  SizedBox(height: Dimensions.height(10)),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(active: "setting"),
    );
  }
}

class DataDesign extends StatelessWidget {
  final String name;
  final String data;
  const DataDesign({super.key, required this.name, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: Dimensions.horizontal(30),
        right: Dimensions.horizontal(30),
        top: Dimensions.vertical(15),
        bottom: Dimensions.vertical(15),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.horizontal(15),
        vertical: Dimensions.vertical(7),
      ),
      // height: globals.lang['lang'] == 'ar'
      //     ? Dimensions.height(72)
      //     : Dimensions.height(70),
      width: Dimensions.width(333),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: Dimensions.fontSize(13),
              color: Color(0xFFb7b4b4),
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontSize: Dimensions.fontSize(17),
            ),
          ),
        ],
      ),
    );
  }
}
