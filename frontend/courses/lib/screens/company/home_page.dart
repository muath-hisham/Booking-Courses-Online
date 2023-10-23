import 'dart:convert';

import 'package:courses/models/company_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../shared/dimensions.dart';
import '../../shared/globals.dart' as globals;
import 'package:http/http.dart' as http;

import '../../shared/colors.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import '../../shared/widgets/post_view_to_company.dart';
import '../company/components/BottomBar.dart';
import '../company/components/head_page.dart';
import 'components/create_post.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

class _CHomePageState extends State<CHomePage> {
  // get company data
  Future getData() async {
    if (globals.company.id == "") {
      globals.company =
          Company(json.decode(await SessionManager().get("company")));
    }
    return true;
  }

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final controller = ScrollController();
  List<dynamic> posts = [];
  int offset = 0;
  bool isLoadingMore = false;
  bool isTherePosts = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
    generatePostsList(10, 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future onScroll() async {
    if (isLoadingMore) return;

    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;

    if (maxScroll == currentScroll) {
      setState(() {
        isLoadingMore = true;
      });
      offset += 10;
      await generatePostsList(10, offset);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future generatePostsList(int limit, int offset) async {
    String url =
        '${globals.domain}/courses/infinite scroll/posts_the_company.php?id=${globals.company.id}&limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      var state = json.decode(response.body);
      print(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['posts'];
        setState(() {
          posts = posts + list;
        });
      } else if (state['state'] == getStatusCodeValue(StatusCode.Empty)) {
        setState(() {
          isTherePosts = false;
        });
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      throw Exception('Failed to load data');
    }
  }

  Future refreshList() async {
    // await Future.delayed(Duration(seconds: 1));  //simulate delay

    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => CHomePage()));
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        bottom: true,
        top: true,
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    HeadPage(),
                    SizedBox(height: Dimensions.height(15)),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateNewPost()),
                        );
                      },
                      child: Container(
                        alignment: globals.lang['lang'] == 'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        height: Dimensions.height(40),
                        width: Dimensions.width(270),
                        padding: EdgeInsets.only(
                          left: globals.lang['lang'] == 'ar'
                              ? 0
                              : Dimensions.width(15),
                          right: globals.lang['lang'] == 'ar'
                              ? Dimensions.width(15)
                              : 0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Text(
                          globals.lang["What's on your mind?"]!,
                          style: TextStyle(fontSize: Dimensions.fontSize(15)),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    Directionality(
                      textDirection: globals.lang['lang'] == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.height(1)),
                        height: Dimensions.height(600),
                        child: !isTherePosts && posts.isEmpty
                            ? Center(
                                child: Text(
                                globals.lang['Add post']!,
                                style: TextStyle(
                                    fontSize: Dimensions.fontSize(18),
                                    fontWeight: FontWeight.w500),
                              ))
                            : posts.isEmpty
                                ? Center(child: CircularProgressIndicator())
                                : RefreshIndicator(
                                    key: refreshIndicatorKey,
                                    onRefresh: refreshList,
                                    child: ListView.builder(
                                      controller: controller,
                                      itemCount: isLoadingMore
                                          ? posts.length + 1
                                          : posts.length,
                                      itemBuilder: (context, index) {
                                        if (index < posts.length) {
                                          return PostToCompany(
                                            lang: globals.lang,
                                            post: posts[index],
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              );
            }
            // print("1");
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: BottomBar(active: "home"),
    );
  }
}
