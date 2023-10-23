import 'package:courses/models/company_model.dart';
import 'package:courses/screens/login.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:page_transition/page_transition.dart';
import '../../shared/globals.dart' as globals;
import '../../shared/colors.dart';
import '../../shared/language/language.dart';
import '../../shared/widgets/awesome_dialog.dart';
import 'Account_page.dart';
import 'components/BottomBar.dart';
import 'home_page.dart';

class CSettings extends StatefulWidget {
  const CSettings({super.key});

  @override
  State<CSettings> createState() => _CSettingsState();
}

class _CSettingsState extends State<CSettings> {
  Map<String, String> lang = globals.lang; // to choose the language
  Company company = globals.company;
  String imageUrl =
      "${globals.domain}/courses/upload/images/profiles/${globals.company.img}";

  @override
  Widget build(BuildContext context) {
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
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: Dimensions.vertical(15)),
                      child: Text(
                        company.name,
                        style: TextStyle(
                            fontFamily:
                                lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                            fontSize: Dimensions.fontSize(17),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      // margin: EdgeInsets.symmetric(vertical: Dimensions.vertical(5)),
                      child: Text(
                        company.email,
                        style: TextStyle(
                            fontFamily:
                                lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                            fontSize: Dimensions.fontSize(15),
                            color: Color(0xFFb7b4b4)),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height(30)),
                  SingleSettings(
                      text: lang['Account']!, lang: lang, onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: CAccount()));
                      }),
                  SingleSettings(
                      text: lang['Payment Method']!, lang: lang, onTap: () {}),
                  SingleSettings(
                      text: lang['Invite friends']!, lang: lang, onTap: () {}),
                  SingleSettings(
                      text: lang['Language']!,
                      lang: lang,
                      onTap: () {
                        if (globals.lang == Language.ar) {
                          globals.lang = Language.en;
                        } else {
                          globals.lang = Language.ar;
                        }
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: CHomePage()));
                        // Alert.success(
                        //     context,
                        //     globals.lang[
                        //         "The language has been converted successfully"]!);
                      }),
                  SingleSettings(text: lang['Help']!, lang: lang, onTap: () {}),
                  SingleSettings(
                      text: lang['Report']!, lang: lang, onTap: () {}),
                  SingleSettings(
                      text: lang['Logout']!,
                      lang: lang,
                      onTap: () async {
                        await SessionManager().destroy();
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: LoginPage()));
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(active: "settings"),
    );
  }
}

class SingleSettings extends StatelessWidget {
  final Map<String, String> lang;
  final void Function() onTap;
  final String text;
  const SingleSettings(
      {super.key, required this.text, required this.lang, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ListTile(
            title: Text(
              text,
              style: TextStyle(
                  fontFamily: lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                  fontSize: Dimensions.fontSize(15),
                  color: Color(0xFF6e7170)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: Dimensions.fontSize(15),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(10)),
          child: Divider(
            thickness: 0.2,
            color: Color(0xFFb7b4b4),
            height: 1,
            // endIndent: 2,
          ),
        ),
      ],
    );
  }
}
