import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../../shared/globals.dart' as globals;
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import '../../shared/call_api.dart';
import '../../shared/dimensions.dart';
import '../../shared/widgets/awesome_dialog.dart';
import 'courses_company.dart';

class AddNewCourse extends StatefulWidget {
  const AddNewCourse({super.key});

  @override
  State<AddNewCourse> createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {
  Map<String, String> lang = globals.lang; // to choose the language

  final _formKey = GlobalKey<FormState>();

  final courseName = TextEditingController();
  final courseDes = TextEditingController();
  final priceBefore = TextEditingController();
  final priceAfter = TextEditingController();
  final courseContent = TextEditingController();

  List courseType = [];
  List interest = [];

  String courseTypeId = "";
  String interestId = "";

  bool isLoading = false;

  // Enter the data of courseType and interest
  void fillData() async {
    // Collect the data
    Map<String, dynamic> data = {'method': 'course_type_and_interest'};

    var response = await CallApi().postData(data);
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        print(state['interest']);
        setState(() {
          interest = state['interest'];
          courseType = state['coursetype'];
        });
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  // to upload files
  List<String> filesName = [];
  List<PlatformFile> files = [];
  void selectPDFFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      files = result.files;
    }
  }

  // upload files to storag
  List<String> fileCurrentName = [];
  Future uploadSelectedFilesToServer() async {
    List<Future<http.StreamedResponse>> uploadRequests = [];

    files.forEach((file) {
      fileCurrentName.add(file.name);
      String fileName = createFileName(file.name);
      filesName.add(fileName);
      var request = http.MultipartRequest('POST',
          Uri.parse('${globals.domain}/courses/upload/books/upload_books.php'));
      request.files.add(
        http.MultipartFile('pdf', File(file.path!).readAsBytes().asStream(),
            File(file.path!).lengthSync(),
            filename: fileName),
      );

      uploadRequests.add(request.send());
    });

    var responses = await Future.wait(uploadRequests);

    responses.forEach((response) {
      if (response.statusCode == 200) {
        print("Uploaded!");
      } else {
        print("Upload failed.");
      }
    });
  }

  // create unique name to files
  String createFileName(String fileName) {
    var now = DateTime.now();
    var formatter = intl.DateFormat('yyyyMMddHHmmss');
    String formatted = formatter.format(now) + fileName;
    return 'file_$formatted';
  }

  // // to save data and create an account
  Future validateAndSaveFormData() async {
    if (_formKey.currentState!.validate()) {
      if (!(filesName == null &&
          courseType[int.parse(courseTypeId)]['course_type'] == "book")) {
        _formKey.currentState!.save();

        setState(() {
          isLoading = true;
        });

        await uploadSelectedFilesToServer();

        Map<String, dynamic> data = {
          'files': filesName,
        };

        final response = await http.post(
          Uri.parse(globals.pytonServer),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        print("${response.statusCode} ======================");
        print('Status code: ${response.statusCode}');
        print('Headers: ${response.headers}');
        print('Body: ${response.body}');
        print("------------------------");
        if (response.statusCode == 200) {
          // print("Data sent successfully");
          var state = json.decode(response.body);
          if (state['state'] == 101) {
            List result = state['result'];
            
            // print("hiiiiiiiiiiiiiiiiiiiiii ${courseTypeId}");
            // Collect the data
            Map<String, dynamic> data = {
              'method': 'add_new_course',
              'company_id': globals.company.id,
              'course_name': courseName.text,
              'course_description': courseDes.text,
              'course_price_before_discount': priceBefore.text,
              'course_price_after_discount': priceAfter.text,
              'course_content': courseContent.text,
              'course_type_id': courseTypeId,
              'interest_id': interestId,
              'files': filesName,
              'files_name': fileCurrentName,
              'number_of_pages': result,
            };
            var response = await CallApi().postData(data);
            print("${response.statusCode} ======================");
            print("${response.body} ------------------------");
            if (response.statusCode == 200) {
              // print("Data sent successfully");
              var state = json.decode(response.body);
              if (state['state'] == 101) {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: CCoursesPage()));
              } else {
                print("error1");
                fileCurrentName = [];
                files = [];
                filesName = [];
              }
            } else {
              Alert.error(context, globals.lang["check your network"]);
              // print("check your network");
              fileCurrentName = [];
              files = [];
              filesName = [];
            }
          } else {
            print("error2");
            fileCurrentName = [];
            files = [];
            filesName = [];
          }
        } else {
          Alert.error(context, globals.lang["check your network"]);
          // print("check your network");
          fileCurrentName = [];
          files = [];
          filesName = [];
        }
      } else {
        Alert.warning(context, globals.lang["Please enter any book"]);
      }
    } else {
      // Show an error message or validation feedback
      print('Invalid input data');
      Alert.warning(context, globals.lang["Please enter all data"]);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fillData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SafeArea(
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
                      SizedBox(height: Dimensions.height(30)),
                      TextFormField(
                        controller: courseName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '${globals.lang["Please enter course name"]}';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "${globals.lang['Course name']}"),
                      ),
                      SizedBox(height: Dimensions.height(15)),
                      TextFormField(
                        maxLines: 5,
                        controller: courseDes,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '${globals.lang["Please enter course description"]}';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "${globals.lang['Course description']}"),
                      ),
                      SizedBox(height: Dimensions.height(15)),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: priceBefore,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '${globals.lang["Please enter the price before discount"]}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText:
                                      "${globals.lang['Price before discount']}"),
                            ),
                          ),
                          SizedBox(width: Dimensions.width(10)),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: priceAfter,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '${globals.lang["Please enter the price after discount"]}';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText:
                                      "${globals.lang['Price after discount']}"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.height(15)),
                      TextFormField(
                        maxLines: 5,
                        controller: courseContent,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '${globals.lang["Please enter course content"]}';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "${globals.lang['Course content']}"),
                      ),
                      SizedBox(height: Dimensions.height(15)),
                      FormHelper.dropDownWidget(
                          context,
                          "${globals.lang['Course type']}",
                          courseTypeId,
                          courseType, (onChangedVal) {
                        setState(() {
                          courseTypeId = onChangedVal;
                          print("selected type is $courseTypeId");
                        });
                      }, (onValidateVal) {
                        if (onValidateVal == null) {
                          return "${globals.lang['Please, Select course type']}";
                        }
                        return null;
                      },
                          borderColor: Colors.grey,
                          borderFocusColor: Theme.of(context).primaryColor,
                          borderRadius: 6,
                          paddingLeft: 0,
                          paddingRight: 2,
                          optionValue: "course_type_id",
                          optionLabel: "course_type"),
                      SizedBox(height: Dimensions.height(15)),
                      FormHelper.dropDownWidget(
                          context,
                          "${globals.lang['Category']}",
                          interestId,
                          interest, (onChangedVal) {
                        setState(() {
                          interestId = onChangedVal;
                          print("selected Category is $interestId");
                        });
                      }, (onValidateVal) {
                        if (onValidateVal == null) {
                          return "${globals.lang['Please, Select category']}";
                        }
                        return null;
                      },
                          borderColor: Colors.grey,
                          borderFocusColor: Theme.of(context).primaryColor,
                          borderRadius: 6,
                          paddingLeft: 0,
                          paddingRight: 2,
                          optionValue: "interest_id",
                          optionLabel: "interest_name"),
                      SizedBox(height: Dimensions.height(25)),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orangeAccent)),
                        child: ListTile(
                          leading: Icon(Icons.upload),
                          title: Text("${globals.lang['Upload books']}"),
                        ),
                        onPressed: () async {
                          selectPDFFiles();
                        },
                      ),
                      SizedBox(height: Dimensions.height(30)),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text("${globals.lang['Confirm']}"),
                              onPressed: () async {
                                validateAndSaveFormData();
                              },
                            ),
                          ),
                          SizedBox(width: Dimensions.width(15)),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey)),
                              child: Text("${globals.lang['Back']}"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          // SizedBox(height: Dimensions.height(40)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // loading
        if (isLoading) Center(child: CircularProgressIndicator()),
      ],
    ));
  }
}
