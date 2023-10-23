import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';

import '../../shared/call_api.dart';
import '../../shared/colors.dart';
import '../../shared/dimensions.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import '../../shared/widgets/my_backButton.dart';
import '../../shared/globals.dart' as globals;
import 'company_details_page.dart';

class Rate extends StatefulWidget {
  final Map<String, dynamic> data;
  final double rate;
  const Rate({super.key, required this.data, required this.rate});

  @override
  State<Rate> createState() => _RateState();
}

class _RateState extends State<Rate> {
  String imageUrl = "";
  late double myRating;
  final _formKey = GlobalKey<FormState>();

  final desExperience = TextEditingController();

  Future addRate() async {
    _formKey.currentState!.save();

    // Collect the data
    Map<String, dynamic> data = {
      'method': 'rate_company',
      'student_id': globals.student.id,
      'company_id': widget.data['company_id'],
      'rating': myRating,
      'des_experience': desExperience.text,
    };

    var response = await CallApi().postData(data);
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: SCompanyPage(companyData: widget.data)));
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  @override
  void initState() {
    super.initState();
    myRating = widget.rate;
    imageUrl = widget.data['company_img'] != ""
        ? "${globals.domain}/courses/upload/images/profiles/${widget.data['company_img']}"
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Directionality(
          textDirection: globals.lang['lang'] == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              // back button
              MyBackButton(),

              // the company data
              Positioned(
                top: Dimensions.height(80),
                right: Dimensions.width(50),
                left: Dimensions.width(50),
                child: Center(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.lightBlue,
                        foregroundImage: NetworkImage(imageUrl),
                        child: Text(widget.data['company_name']),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            widget.data['company_name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(globals.lang['Rate this center']!),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: Dimensions.height(220),
                right: Dimensions.width(25),
                left: Dimensions.width(25),
                child: RatingBar.builder(
                  initialRating: widget.rate,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: Dimensions.fontSize(35),
                  itemPadding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontal(14)),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    myRating = rating;
                  },
                ),
              ),
              Positioned(
                top: Dimensions.height(290),
                right: Dimensions.width(25),
                left: Dimensions.width(25),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLines: 5,
                    controller: desExperience,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            "${globals.lang['Describe your experience (optional)']}"),
                  ),
                ),
              ),
              Positioned(
                top: Dimensions.height(500),
                right: Dimensions.width(50),
                left: Dimensions.width(50),
                child: ElevatedButton(
                  onPressed: () async {
                    await addRate();
                  },
                  child: Text('${globals.lang['Post']}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
