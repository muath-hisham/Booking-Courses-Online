import 'dart:convert';
import 'dart:io';
import 'package:courses/screens/student/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../shared/globals.dart' as globals;
import 'package:intl/intl.dart' as intl;

import '../models/student_model.dart';
import '../shared/call_api.dart';
import '../shared/settings/status_codes.dart';
import '../shared/widgets/awesome_dialog.dart';

class StudentCreateAccount extends StatefulWidget {
  const StudentCreateAccount({super.key});

  @override
  State<StudentCreateAccount> createState() => _StudentCreateAccountState();
}

class _StudentCreateAccountState extends State<StudentCreateAccount> {
  final _formKey = GlobalKey<FormState>();

  final studentFName = TextEditingController();
  final studentLName = TextEditingController();
  final studentEmail = TextEditingController();
  final studentPassword = TextEditingController();
  final studentPassword2 = TextEditingController();
  final studentDOB = TextEditingController();
  final studentPhone = TextEditingController();
  String studentGender = "male";

  List countries = [];
  List statesMasters = [];
  List states = [];

  String? countryId;
  String? stateId;
  bool myRest = false;

  @override
  void initState() {
    super.initState();
    countries = globals.countries;
    statesMasters = globals.companyStatesMasters;
  }

  // to upload image from gallery
  XFile? file;
  Future pickerGalary() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image!.path != "") {
      setState(() {
        file = image;
      });
    }
  }

  // create unique name to image
  String createImageName(String imgName) {
    var now = DateTime.now();
    var formatter = intl.DateFormat('yyyyMMddHHmmss');
    String formatted = formatter.format(now) + imgName;
    return 'image_$formatted.jpg';
  }

  // upload the image to server
  String imageName = "";
  Future<void> uploadImage(XFile? image) async {
    var url =
        Uri.parse("${globals.domain}/courses/upload/images/upload_images.php");
    var request = http.MultipartRequest('POST', url);
    imageName = createImageName(image!.name);
    request.files.add(await http.MultipartFile.fromPath('file', image.path,
        filename: imageName));

    var response = await request.send();

    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      print("Image uploaded");
    } else {
      print("Image not uploaded. Status code: ${response.statusCode}");
      print("Response body: ${await response.stream.bytesToString()}");
    }
  }

  // to save data and create an account
  Future saveData() async {
    if (_formKey.currentState!.validate()) {
      if (studentPassword.text == studentPassword2.text) {
        _formKey.currentState!.save();

        if (file != null) {
          await uploadImage(file!);
        }

        // Collect the data
        Map<String, dynamic> data = {
          'method': 'create_student_account',
          'firstName': studentFName.text,
          'lastName': studentLName.text,
          'email': studentEmail.text,
          'password': studentPassword.text,
          'gender': studentGender,
          'city': states[int.parse(stateId!) - 1]['name'],
          'country': countries[int.parse(countryId!) - 1]['name'],
          'dateOfBirth': studentDOB.text,
          'Phone': studentPhone.text,
          'img': imageName
        };

        var response = await CallApi().postData(data);
        print("${response.statusCode} ======================");
        print("${response.body} ------------------------");
        if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
          // print("Data sent successfully");
          var state = json.decode(response.body);
          if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
            Student student = Student(state['user']);
            await SessionManager().set('user', 'student');
            await SessionManager().set('email', studentEmail.text);
            await SessionManager().set('password', studentPassword.text);
            globals.student = student;
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: SHomePage()));
          } else if (state['state'] == getStatusCodeValue(StatusCode.Failed)) {
          } else {
            print("error");
          }
        } else {
          Alert.error(context, globals.lang["check your network"]);
          // print("check your network");
        }

        print(data);
      } else {
        Alert.warning(context, globals.lang["Please enter correct password"]);
      }
    } else {
      // Show an error message or validation feedback
      print('Invalid input data');
      Alert.warning(context, globals.lang["Please enter all data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: globals.lang['lang'] == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Container(
              width: double.infinity,
              margin:
                  EdgeInsets.symmetric(horizontal: Dimensions.horizontal(30)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.height(20)),
                    InkWell(
                      onTap: () {
                        pickerGalary();
                      },
                      child: file == null
                          ? Container(
                              height: Dimensions.height(150),
                              width: Dimensions.width(150),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                color: Colors.grey,
                              ),
                              child: Center(
                                child: Icon(Icons.person_add, size: 40),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: Image.file(
                                File(file!.path),
                                height: Dimensions.height(150),
                                width: Dimensions.width(150),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(height: Dimensions.height(20)),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              controller: studentFName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '${globals.lang["Please enter your first name"]}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "${globals.lang['First name']}"),
                            ),
                          ),
                        ),
                        SizedBox(width: Dimensions.width(10)),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              controller: studentLName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '${globals.lang["Please enter your last name"]}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "${globals.lang['Last name']}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    Row(
                      children: [
                        Expanded(
                          child: FormHelper.dropDownWidget(
                              context,
                              "${globals.lang['Country']}",
                              countryId,
                              countries, (onChangedVal) {
                            setState(() {
                              countryId = onChangedVal;
                              print("selected country is $countryId");
                              states = statesMasters
                                  .where((element) =>
                                      element['countryId'].toString() ==
                                      onChangedVal.toString())
                                  .toList();
                              stateId = null;
                              myRest = true;
                              print("$stateId =======================");
                            });
                          }, (onValidateVal) {
                            if (onValidateVal == null) {
                              return "${globals.lang['Please, Select country']}";
                            }
                            return null;
                          },
                              borderColor: Colors.grey,
                              borderFocusColor: Theme.of(context).primaryColor,
                              borderRadius: 6,
                              paddingLeft: 0,
                              paddingRight: 2),
                        ),
                        SizedBox(width: Dimensions.width(15)),
                        Expanded(
                          child: FormHelper.dropDownWidget(
                              context,
                              "${globals.lang['State']}",
                              stateId,
                              states, (onChanged) {
                            // if (myRest == true) {
                            //   print("i am here===========");
                            //   onChanged = null;
                            //   myRest = false;
                            // }
                            // print("$onChanged ---------------------- b");
                            stateId = onChanged;
                            // print("$onChanged ---------------------- a");
                            print("Selected state is $stateId");
                          }, (onValidateVal) {
                            if (onValidateVal == null) {
                              return "${globals.lang['Please, Select state']}";
                            }
                            return null;
                          },
                              borderColor: Colors.grey,
                              borderFocusColor: Theme.of(context).primaryColor,
                              borderRadius: 6,
                              paddingLeft: 2,
                              paddingRight: 0),
                        )
                      ],
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(
                              right: globals.lang['lang'] == 'ar'
                                  ? Dimensions.horizontal(0)
                                  : Dimensions.horizontal(10),
                              left: globals.lang['lang'] == 'ar'
                                  ? Dimensions.horizontal(10)
                                  : Dimensions.horizontal(0),
                            ),
                            child: RadioListTile(
                              title: Text(
                                "${globals.lang['Male']}",
                                style: TextStyle(
                                    fontSize: Dimensions.fontSize(15)),
                              ),
                              value: "male",
                              groupValue: studentGender,
                              onChanged: (value) {
                                setState(() {
                                  studentGender = value.toString();
                                  print(studentGender);
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(
                              right: globals.lang['lang'] == 'ar'
                                  ? Dimensions.horizontal(10)
                                  : Dimensions.horizontal(0),
                              left: globals.lang['lang'] == 'ar'
                                  ? Dimensions.horizontal(0)
                                  : Dimensions.horizontal(10),
                            ),
                            child: RadioListTile(
                              title: Text(
                                "${globals.lang['Female']}",
                                style: TextStyle(
                                    fontSize: Dimensions.fontSize(15)),
                              ),
                              value: "female",
                              groupValue: studentGender,
                              onChanged: (value) {
                                setState(() {
                                  studentGender = value.toString();
                                  print(studentGender);
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    TextFormField(
                      controller: studentEmail,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '${globals.lang["Please enter your email"]}';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "${globals.lang['Email']}"),
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    TextFormField(
                      controller: studentPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '${globals.lang["Please enter your password"]}';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "${globals.lang['Password']}"),
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    TextFormField(
                      controller: studentPassword2,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '${globals.lang["Please enter your password"]}';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "${globals.lang['Confirm Password']}"),
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: studentPhone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '${globals.lang["Please enter your phone"]}';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "${globals.lang['Phone Number']}"),
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            studentDOB.text = intl.DateFormat('yyyy-MM-dd')
                                .format(pickedDate);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: studentDOB,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '${globals.lang["Please enter your date of birth"]}';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "${globals.lang['Date of Birth']}",
                          ),
                          readOnly: true,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    ElevatedButton(
                      onPressed: () async {
                        await saveData();
                      },
                      child: Text('${globals.lang['Create the Account']}'),
                    ),
                    SizedBox(height: Dimensions.height(20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
