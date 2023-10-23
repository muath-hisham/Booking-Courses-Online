import 'dart:convert';

import 'package:courses/shared/dimensions.dart';
import 'package:courses/shared/settings/status_codes.dart';
import 'package:courses/shared/widgets/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../../shared/globals.dart' as globals;
import '../screens/student/company_details_page.dart';
import 'call_api.dart';

class DataSearch extends SearchDelegate {
  List dataList = [];

  DataSearch() {
    getBooks();
  }

  Future getBooks() async {
    final data = {
      'method': 'get_companies',
      'country': globals.student.country
    };
    var response = await CallApi().postData(data);
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        dataList = state['companies'];
      } else {
        print("error");
      }
    } else {
      // Alert.error(context, globals.lang["check your network"]);
      print("check your network");
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result based on the selection
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    final suggestionList = query.isEmpty
        ? dataList
        : dataList.where((p) => p['company_name'].startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => Directionality(
        textDirection: globals.lang['lang'] == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.vertical(6),
              horizontal: Dimensions.height(5)),
          child: ListTile(
            onTap: () {
              // showResults(context);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: SCompanyPage(companyData: suggestionList[index])));
            },
            leading: CircleAvatar(
              foregroundImage: suggestionList[index]['company_img'] != ""
                  ? NetworkImage(
                      "${globals.domain}/courses/upload/images/profiles/${suggestionList[index]['company_img']}")
                  : null,
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index]['company_name']
                    .substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index]['company_name']
                        .substring(query.length),
                    style: TextStyle(color: Colors.grey),
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
