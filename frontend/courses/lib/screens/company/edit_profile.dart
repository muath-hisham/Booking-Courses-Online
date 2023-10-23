import 'dart:convert';
import 'dart:io';

import 'package:courses/models/company_model.dart';
import 'package:courses/models/company_model.dart';
import 'package:courses/screens/company/Account_page.dart';
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

class CEditProfile extends StatefulWidget {
  const CEditProfile({super.key});

  @override
  State<CEditProfile> createState() => _CEditProfileState();
}

class _CEditProfileState extends State<CEditProfile> {
  String imageUrl =
      "${globals.domain}/courses/upload/images/profiles/${globals.company.img}";

  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final des = TextEditingController();
  final website = TextEditingController();
  final phone1 = TextEditingController();
  final phone2 = TextEditingController();

  final password = TextEditingController();

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
      if (password.text == globals.company.password) {
        _formKey.currentState!.save();

        if (file != null) {
          await uploadImage(file!);
          await deleteOldImage(globals.company.img);
        }

        // Collect the data
        Map<String, dynamic> data = {
          'method': 'update_company_account',
          'id': globals.company.id,
          'name': name.text,
          'des': des.text,
          'website': website.text,
          'phone1': phone1.text,
          'phone2': phone2.text,
          imageName == "" ? 'img' : imageName: globals.company.img
        };

        var response = await CallApi().postData(data);
        print("${response.statusCode} ======================");
        print("${response.body} ------------------------");
        if (response.statusCode ==
            getStatusCodeValue(StatusCode.ResponseSuccess)) {
          // print("Data sent successfully");
          var state = json.decode(response.body);
          if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
            globals.company.name = name.text;
            globals.company.description = des.text;
            globals.company.website = website.text;
            globals.company.phone1 = phone1.text;
            globals.company.phone2 = phone2.text;
            if (imageName != "") globals.company.img = imageName;
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: CAccount()));
          } else {
            print("error");
          }
        } else {
          Alert.error(context, globals.lang["check your network"]);
          // print("check your network");
        }

        // print(data);
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
    name.text = globals.company.name;
    website.text = globals.company.website;
    des.text = globals.company.description;
    phone1.text = globals.company.phone1;
    phone2.text = globals.company.phone2;
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
                                      ? globals.company.img == ""
                                          ? null
                                          : NetworkImage(imageUrl)
                                      : FileImage(File(file!.path))
                                          as ImageProvider<Object>,
                                  backgroundColor: file == null
                                      ? SharedColors.activeColor
                                      : Colors.white,
                                  child: Stack(
                                    children: [
                                      globals.company.img == ""
                                          ? Center(
                                              child: Text(
                                                globals.company.name
                                                    .substring(0, 2)
                                                    .toUpperCase(),
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
                          TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '${globals.lang["Please enter company name"]}';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "${globals.lang['Company name']}"),
                          ),
                          SizedBox(height: Dimensions.height(30)),
                          TextFormField(
                            controller: des,
                            maxLines: 8,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '${globals.lang["Please enter company Description"]}';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "${globals.lang['Description']}"),
                          ),
                          SizedBox(height: Dimensions.height(30)),
                          TextFormField(
                            controller: website,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    "${globals.lang['Website (optional)']}"),
                          ),
                          SizedBox(height: Dimensions.height(30)),
                          TextFormField(
                            controller: phone1,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '${globals.lang["Please enter phone number"]}';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "${globals.lang['Phone number']}"),
                          ),
                          SizedBox(height: Dimensions.height(30)),
                          TextFormField(
                            controller: phone2,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    "${globals.lang['secound Phone number (optional)']}"),
                          ),
                          SizedBox(height: Dimensions.height(30)),
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
