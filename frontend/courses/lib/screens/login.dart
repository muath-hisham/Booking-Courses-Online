import 'dart:convert';
import 'package:courses/models/company_model.dart';
import 'package:courses/models/student_model.dart';
import 'package:courses/screens/choose_what_are_you.dart';
import 'package:courses/screens/student/home_page.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../shared/globals.dart' as globals;
import '../shared/call_api.dart';
import '../shared/settings/status_codes.dart';
import '../shared/settings/user_controller.dart';
import '../shared/settings/user_types.dart';
import '../shared/widgets/awesome_dialog.dart';
import 'company/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  late UserType userType;

  void _initializeUserType() async {
    if (await SessionManager().get('user') != null) {
      String userTypeString = await SessionManager().get('user');
      userType = userTypeFromString(userTypeString);
      _email = await SessionManager().get('email');
      _password = (await SessionManager().get('password')).toString();
      UserController userController = UserController();
      userController.autoLogin(context, userType, _email, _password);
    }
  }

  // when the user click on login button
  Future<void> checkLogin(String email, String password) async {
    final data = {'method': 'login', 'email': email, 'password': password};
    var response = await CallApi().postData(data);
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      // print("++++++++++++++++ ${response.body} +++++++++++++++++++++");
      var state = json.decode(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        Map<String, dynamic> user = state['user'];
        // ممكن اليوزر يكون واحد من 3 انواع
        if (state['type_of_user'] == 'student') {
          Student student = Student(user);
          await SessionManager().set('user', 'student');
          await SessionManager().set('email', email);
          await SessionManager().set('password', password);
          globals.student = student;
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: SHomePage()));
        } else if (state['type_of_user'] == 'company') {
          Company company = Company(user);
          await SessionManager().set('user', 'company');
          await SessionManager().set('email', email);
          await SessionManager().set('password', password);
          globals.company = company;
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: CHomePage()));
        } else if (state['type_of_user'] == 'admin') {
          Company company = Company(user);
          await SessionManager().set('user', 'company');
          await SessionManager().set('email', email);
          await SessionManager().set('password', password);
          globals.company = company;
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: CHomePage()));
        }
      } else if (state['state'] ==
          getStatusCodeValue(StatusCode.InvalidEmailOrPassword)) {
        // print("user name or password is wrong!");
        Alert.error(context, lang["email or password is wrong!"]);
      } else {
        print("some thing is wrong");
      }
    } else {
      Alert.error(context, lang["check your network"]);
      // print("check your network");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Image.asset(
                  //   'assets/logo.png', ///////////////////////////////// logo
                  //   height: 100,
                  //   width: 100,
                  // ),
                  SizedBox(height: 32.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: '${globals.lang['Email']}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${globals.lang['Please enter your email']}';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '${globals.lang['Password']}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${globals.lang['Please enter your password']}';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!.trim();
                    },
                  ),
                  SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          checkLogin(_email, _password);
                        }
                      },
                      child: Text('${globals.lang['LOGIN']}'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      //TODO: navigate to forgot password screen
                    },
                    child: Text(
                      '${globals.lang['Forgot Password?']}',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text('${globals.lang['or']}'),
                  SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: ChooseWhatAreYou()));
                    },
                    icon: Icon(Icons.person_add),
                    label: Text('${globals.lang['Create an Account']}'),
                  ),
                  SizedBox(height: 20.0),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () {
                      // _showButtonPressDialog(context, 'Google');
                    },
                    text: '${globals.lang['Login with Google']}',
                  ),
                  SizedBox(height: 20.0),
                  SignInButton(
                    Buttons.FacebookNew,
                    onPressed: () {},
                    text: '${globals.lang['Login with Facebook']}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
