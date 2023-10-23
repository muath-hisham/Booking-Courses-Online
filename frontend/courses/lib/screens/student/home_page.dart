import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../models/student_model.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;
import '../../shared/colors.dart';
import '../../shared/dimensions.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import '../../shared/widgets/post_view_to_student.dart';
import 'components/BottomBar.dart';
import 'components/head_page.dart';

// import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SHomePage extends StatefulWidget {
  const SHomePage({super.key});

  @override
  State<SHomePage> createState() => _SHomePageState();
}

class _SHomePageState extends State<SHomePage> {
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
    fetchData(10, 0);
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
      await fetchData(10, offset);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future fetchData(int limit, int offset) async {
    String url =
        '${globals.domain}/courses/infinite scroll/posts_to_student.php?id=${globals.student.id}&limit=$limit&offset=$offset';
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
        isTherePosts = false;
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
          MaterialPageRoute(builder: (BuildContext context) => SHomePage()));
    });

    return null;
  }

  Future getData() async {
    if (globals.student.id == "") {
      globals.student =
          Student(json.decode(await SessionManager().get("student")));
    }
    return true;
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
                    Directionality(
                      textDirection: globals.lang['lang'] == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.height(1)),
                        height: Dimensions.height(658),
                        child: !isTherePosts && posts.isEmpty
                            ? Center(
                                child: Text(
                                globals.lang['Follow some centers']!,
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
                                          return PostToStudent(
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
                    )
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
