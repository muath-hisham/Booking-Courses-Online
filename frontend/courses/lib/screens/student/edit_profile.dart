import 'dart:convert';
import 'dart:io';

import 'package:courses/models/student_model.dart';
import 'package:courses/screens/student/Account_page.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:courses/shared/widgets/my_backButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;
import 'package:http/http.dart' as http;
import '../../shared/colors.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';

class SEditProfile extends StatefulWidget {
  const SEditProfile({super.key});

  @override
  State<SEditProfile> createState() => _SEditProfileState();
}

class _SEditProfileState extends State<SEditProfile> {
  Student student = globals.student;
  String imageUrl =
      "${globals.domain}/courses/upload/images/profiles/${globals.student.img}";

  final _formKey = GlobalKey<FormState>();

  final fName = TextEditingController();
  final lName = TextEditingController();

  final password = TextEditingController();

  // to choose the company and city
  List<Map> countries = [];
  List<Map> statesMasters = [];
  List<Map> states = [];

  String? countryId;
  String? stateId;

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
    return 'image_$formatted';
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

  // to delete the old profile image
  Future<void> deleteOldImage(String imageName) async {
    var url = "${globals.domain}/courses/upload/images/delete_image.php";

    var response = await http.post(
      Uri.parse(url),
      body: {'image_name': imageName},
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('Image name sent successfully');
    } else {
      print('Failed to send image name');
    }
  }

  // to save data and create an account
  Future saveData() async {
    if (_formKey.currentState!.validate()) {
      if (password.text == globals.student.password) {
        _formKey.currentState!.save();

        if (file != null) {
          await uploadImage(file!);
          await deleteOldImage(globals.student.img);
        }

        // Collect the data
        Map<String, dynamic> data = {
          'method': 'update_student_account',
          'id': globals.student.id,
          'firstName': fName.text,
          'lastName': lName.text,
          'city': states[int.parse(stateId!) - 1]['name'],
          'country': countries[int.parse(countryId!) - 1]['name'],
          imageName == "" ? 'img' : imageName: globals.student.img
        };

        var response = await CallApi().postData(data);
        print("${response.statusCode} ======================");
        print("${response.body} ------------------------");
        if (response.statusCode ==
            getStatusCodeValue(StatusCode.ResponseSuccess)) {
          // print("Data sent successfully");
          var state = json.decode(response.body);
          if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
            globals.student.fName = fName.text;
            globals.student.lName = lName.text;
            if (imageName != "") globals.student.img = imageName;
            globals.student.country =
                countries[int.parse(countryId!) - 1]['name'];
            globals.student.city = states[int.parse(stateId!) - 1]['name'];
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: SAccount()));
          } else {
            print("error");
          }
        } else {
          Alert.error(context, globals.lang["check your network"]);
          // print("check your network");
        }

        print(data);
      } else {
        Alert.warning(context, globals.lang["the password is wrong!"]);
      }
    } else {
      // Show an error message or validation feedback
      print('Invalid input data');
      Alert.warning(context, globals.lang["Please enter all data"]);
    }
  }

  // set all data
  void setData() {
    countries = globals.countries;
    statesMasters = globals.companyStatesMasters;
    fName.text = globals.student.fName;
    lName.text = globals.student.lName;
    for (var country in countries) {
      if (country['name'] == globals.student.country) {
        countryId = country['id'].toString();
        break;
      }
    }
    states = statesMasters
        .where((element) =>
            element['countryId'].toString() == countryId.toString())
        .toList();
    for (var city in states) {
      if (city['name'] == globals.student.city) {
        stateId = city['id'].toString();
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

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
              textDirection: globals.lang['lang'] == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Stack(
                children: [
                  MyBackButton(),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.horizontal(30),
                          vertical: Dimensions.vertical(40)),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: Dimensions.height(35)),
                              width: Dimensions.width(140),
                              height: Dimensions.height(125),
                              child: InkWell(
                                onTap: () {
                                  pickerGalary();
                                },
                                child: CircleAvatar(
                                  backgroundImage: file == null
                                      ? student.img == ""
                                          ? null
                                          : NetworkImage(imageUrl)
                                      : FileImage(File(file!.path))
                                          as ImageProvider<Object>,
                                  backgroundColor: file == null
                                      ? SharedColors.activeColor
                                      : Colors.white,
                                  child: Stack(
                                    children: [
                                      student.img == ""
                                          ? Center(
                                              child: Text(
                                                "${student.fName.substring(0, 1).toUpperCase()}${student.lName.substring(0, 1).toUpperCase()}",
                                                style: TextStyle(
                                                    fontSize:
                                                        Dimensions.fontSize(25),
                                                    color: Colors.white),
                                              ),
                                            )
                                          : SizedBox(),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: Dimensions.horizontal(100),
                                          top: Dimensions.vertical(80),
                                        ),
                                        width: Dimensions.width(40),
                                        height: Dimensions.height(40),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Color(0xFF2e91ff)),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Color(0xFF1684ff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.height(40)),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: fName,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '${globals.lang["Please enter your first name"]}';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:
                                          "${globals.lang['First name']}"),
                                ),
                              ),
                              SizedBox(width: Dimensions.width(20)),
                              Expanded(
                                child: TextFormField(
                                  controller: lName,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '${globals.lang["Please enter your last name"]}';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:
                                          "${globals.lang['Last name']}"),
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
                                    print("$stateId =======================");
                                  });
                                }, (onValidateVal) {
                                  if (onValidateVal == null) {
                                    return "${globals.lang['Please, Select country']}";
                                  }
                                  return null;
                                },
                                    borderColor: Colors.grey,
                                    borderFocusColor:
                                        Theme.of(context).primaryColor,
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
                                    borderFocusColor:
                                        Theme.of(context).primaryColor,
                                    borderRadius: 6,
                                    paddingLeft: 2,
                                    paddingRight: 0),
                              )
                            ],
                          ),
                          SizedBox(height: Dimensions.height(15)),
                          TextFormField(
                            controller: password,
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
                          SizedBox(height: Dimensions.height(30)),
                          ElevatedButton(
                            onPressed: () async {
                              await saveData();
                            },
                            child: Text('${globals.lang['Update']}'),
                          ),
                        ],
                      ),
                    ),
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
