import 'dart:convert';
import 'dart:io';

import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../../shared/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../models/company_model.dart';
import '../shared/call_api.dart';
import '../shared/settings/status_codes.dart';
import '../shared/widgets/awesome_dialog.dart';
import 'company/home_page.dart';

class CompanyCreateAccount extends StatefulWidget {
  const CompanyCreateAccount({super.key});

  @override
  State<CompanyCreateAccount> createState() => _CompanyCreateAccountState();
}

class _CompanyCreateAccountState extends State<CompanyCreateAccount> {
  final _formKey = GlobalKey<FormState>();

  final companyName = TextEditingController();
  final companyDes = TextEditingController();
  final companyWebsite = TextEditingController();
  final companyEmail = TextEditingController();
  final companyPassword = TextEditingController();
  final companyPassword2 = TextEditingController();

  final companyPhone1 = TextEditingController();
  final companyPhone2 = TextEditingController();

  List countries = [];
  List statesMasters = [];
  List states = [];

  String? countryId;
  // String? stateId;
  bool myRest = false;

  // locations
  List<Widget> locations_Widget = [];
  List locations = [];

  // Payment Method
  List<Widget> paymentMethods_Widget = [];
  List paymentMethods = [];

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
      if (companyPassword.text == companyPassword2.text) {
        _formKey.currentState!.save();

        if (file != null) {
          await uploadImage(file!);
        }

        // Collect the data
        Map<String, dynamic> data = {
          'method': 'create_company_account',
          'name': companyName.text,
          'des': companyDes.text,
          'website': companyWebsite.text,
          'country': countries[int.parse(countryId!) - 1]['name'],
          'email': companyEmail.text,
          'password': companyPassword.text,
          'phone1': companyPhone1.text,
          'phone2': companyPhone2.text,
          'img': imageName,
          'locations': locations,
          'payment_methods': paymentMethods
        };

        var response = await CallApi().postData(data);
        print("${response.statusCode} ======================");
        print("${response.body} ------------------------");
        if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
          // print("Data sent successfully");
          var state = json.decode(response.body);
          if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
            Company company = Company(state['user']);
            await SessionManager().set('user', 'company');
            await SessionManager().set('email', companyEmail.text);
            await SessionManager().set('password', companyPassword.text);
            globals.company = company;

            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: CHomePage()));
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

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text("${globals.lang['Company Info']}"),
            content: Container(
              child: Column(
                children: [
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
                  TextFormField(
                    controller: companyName,
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
                  SizedBox(height: Dimensions.height(15)),
                  FormHelper.dropDownWidget(
                    context,
                    "${globals.lang['Country']}",
                    countryId,
                    countries,
                    (onChangedVal) {
                      setState(() {
                        countryId = onChangedVal;
                        print("selected country is $countryId");
                        states = statesMasters
                            .where((element) =>
                                element['countryId'].toString() ==
                                onChangedVal.toString())
                            .toList();
                        // stateId = null;
                        myRest = true;
                      });
                    },
                    (onValidateVal) {
                      if (onValidateVal == null) {
                        return "${globals.lang['Please, Select country']}";
                      }
                      return null;
                    },
                    borderColor: Colors.grey,
                    borderFocusColor: Theme.of(context).primaryColor,
                    borderRadius: 6,
                    paddingLeft: 0,
                    paddingRight: 2,
                  ),
                  SizedBox(height: Dimensions.height(15)),
                  TextFormField(
                    controller: companyDes,
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
                  SizedBox(height: Dimensions.height(15)),
                  TextFormField(
                    controller: companyWebsite,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "${globals.lang['Website (optional)']}"),
                  ),
                ],
              ),
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text("${globals.lang['Locations']}"),
            content: Container(
              child: Column(
                children: [
                  Column(
                    children: locations_Widget,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        locations_Widget.add(LocationDesign());
                      });
                    },
                    icon: Icon(Icons.add),
                    label: Text("${globals.lang['Add location']}"),
                  ),
                ],
              ),
            )),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text("${globals.lang['Account']}"),
            content: Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: companyEmail,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${globals.lang["Please enter email"]}';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "${globals.lang['Email']}"),
                  ),
                  SizedBox(height: Dimensions.height(15)),
                  TextFormField(
                    controller: companyPassword,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${globals.lang["Please enter password"]}';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "${globals.lang['Password']}"),
                  ),
                  SizedBox(height: Dimensions.height(15)),
                  TextFormField(
                    controller: companyPassword2,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '${globals.lang["Please enter password"]}';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "${globals.lang['Confirm  Password']}"),
                  ),
                  SizedBox(height: Dimensions.height(15)),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: companyPhone1,
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
                  SizedBox(height: Dimensions.height(15)),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: companyPhone2,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            "${globals.lang['secound Phone number (optional)']}"),
                  ),
                ],
              ),
            )),
        Step(
            state: currentStep > 3 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 3,
            title: Text("${globals.lang['Payment Method']}"),
            content: Container()),
      ];

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Directionality(
          textDirection: globals.lang['lang'] == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height - 30,
                child: Stepper(
                  type: StepperType.vertical,
                  steps: getSteps(),
                  currentStep: currentStep,
                  onStepContinue: () async {
                    final isLastStep = currentStep == getSteps().length - 1;
                    if (isLastStep) {
                      await saveData();
                    } else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  },
                  onStepTapped: (step) => setState(() => currentStep = step),
                  onStepCancel: currentStep == 0
                      ? null
                      : () {
                          setState(() {
                            currentStep -= 1;
                          });
                        },
                  controlsBuilder: (context, details) {
                    final isLastStep = currentStep == getSteps().length - 1;
                    return Container(
                      margin: EdgeInsets.only(top: Dimensions.height(50)),
                      child: Row(children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text(isLastStep
                                ? "${globals.lang['Confirm']}"
                                : "${globals.lang['Next']}"),
                            onPressed: details.onStepContinue,
                          ),
                        ),
                        SizedBox(width: Dimensions.width(12)),
                        if (currentStep != 0)
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey)),
                              child: Text("${globals.lang['Back']}"),
                              onPressed: details.onStepCancel,
                            ),
                          ),
                      ]),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LocationDesign extends StatefulWidget {
  const LocationDesign({super.key});

  @override
  State<LocationDesign> createState() => _LocationDesignState();
}

class _LocationDesignState extends State<LocationDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(vertical: Dimensions.vertical(10)),
      padding: EdgeInsets.all(Dimensions.height(10)),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(children: []),
    );
  }
}
