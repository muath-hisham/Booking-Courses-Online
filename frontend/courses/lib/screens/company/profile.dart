import 'dart:convert';

import 'package:courses/screens/student/components/review.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:get/get.dart';
import '../../shared/call_api.dart';
import '../../shared/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:courses/shared/widgets/my_text.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';
import '../../shared/settings/status_codes.dart';
import '../../shared/widgets/awesome_dialog.dart';
import 'components/BottomBar.dart';
import 'components/about.dart';

class CProfile extends StatefulWidget {
  const CProfile({super.key});

  @override
  State<CProfile> createState() => _CProfileState();
}

class _CProfileState extends State<CProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFollow = false;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final controller = ScrollController();
  List<dynamic> reviews = [];
  int offset = 0;
  bool isLoadingMore = false;
  bool isTherereviews = true;
  int numberOfReviews = 0;
  double rate = 0;

  List locations = [
    "nasser city",
    "alf maskan"
  ]; //////////////////////////////////////////////////

  Future generateReviewsList() async {
    final data = {
      'method': 'reviews_the_company',
      'company_id': globals.company.id
    };
    var response = await CallApi().postData(data);
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        List list = state['reviews'];
        return list;
      } else if (state['state'] == 102) {
        return "no reviews";
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
    getNumberOfReviews();
    _tabController = TabController(length: 2, vsync: this);
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
        '${globals.domain}/courses/infinite scroll/reviews_to_company.php?id=${globals.company.id}&limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      var state = json.decode(response.body);
      print(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['reviews'];
        setState(() {
          reviews = reviews + list;
        });
      } else if (state['state'] == getStatusCodeValue(StatusCode.Empty)) {
        setState(() {
          isTherereviews = false;
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
          MaterialPageRoute(builder: (BuildContext context) => CProfile()));
    });

    return null;
  }

  Future getNumberOfReviews() async {
    final data = {
      'method': 'get_number_of_reviews',
      'company_id': globals.company.id
    };
    var response = await CallApi().postData(data);
    print("${globals.student.id} ------------------");
    print("${response.statusCode} ======================");
    print("${response.body} ------------------------");
    if (response.statusCode == getStatusCodeValue(StatusCode.ResponseSuccess)) {
      var state = json.decode(response.body);
      if (state['state'] == getStatusCodeValue(StatusCode.Success)) {
        List list = state['reviews'];
        int sumAllRates = 0;
        for (Map review in list) {
          sumAllRates += int.parse(review['rate']);
        }
        setState(() {
          numberOfReviews = list.length;
          rate = sumAllRates / list.length;
        });
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
      // print("check your network");
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = globals.company.img != ""
        ? "${globals.domain}/courses/upload/images/profiles/${globals.company.img}"
        : "";

    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Stack(
          children: [
            // the image
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                width: Dimensions.width(375),
                height: Dimensions.height(200),
                child: imageUrl != ""
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: Dimensions.height(230),
                      )
                    : Container(
                        color: Colors.lightBlue,
                        child: Center(
                          child: Text(globals.company.name),
                        ),
                      ),
              ),
            ),
            // Reviews
            Positioned(
              top: Dimensions.height(185),
              left: lang['lang'] == 'ar' ? 0 : null,
              right: lang['lang'] == 'ar' ? null : 0,
              child: Container(
                height: Dimensions.height(31),
                width: Dimensions.width(150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        lang['lang'] == 'ar' ? Radius.zero : Radius.circular(8),
                    bottomLeft:
                        lang['lang'] == 'ar' ? Radius.zero : Radius.circular(8),
                    topRight:
                        lang['lang'] == 'ar' ? Radius.circular(8) : Radius.zero,
                    bottomRight:
                        lang['lang'] == 'ar' ? Radius.circular(8) : Radius.zero,
                  ),
                  color: Color(0xff0c0c32),
                ),
                child: Directionality(
                  textDirection: lang['lang'] == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.horizontal(8)),
                    child: Row(
                      //  mainAxisAlignment: lang['lang']=='ar'? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: SharedColors.star,
                          size: Dimensions.fontSize(14),
                        ),
                        SizedBox(width: Dimensions.width(3)),
                        MyText(
                          text: "${rate.toPrecision(1)} ($numberOfReviews ${lang['Reviews']})",
                          color: Colors.white,
                          lang: lang['lang']!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // the name and follow
            Positioned(
              top: Dimensions.height(220),
              left: Dimensions.horizontal(17),
              right: Dimensions.horizontal(17),
              child: Directionality(
                textDirection: lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: globals.company.name,
                      lang: lang['lang']!,
                      color: Colors.black,
                      font: Dimensions.fontSize(30),
                    ),
                  ],
                ),
              ),
            ),
            // tags
            Positioned(
              top: Dimensions.height(260),
              left: Dimensions.horizontal(0),
              right: Dimensions.horizontal(0),
              child: Directionality(
                textDirection: lang['lang'] == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.horizontal(25)),
                      // color: Colors.redAccent,
                      child: TabBar(
                          //labelPadding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(30)),
                          controller: _tabController,
                          //indicatorColor: Colors.transparent,
                          labelColor: Color(0xFF1C1C3E),
                          //isScrollable: true,
                          //labelPadding: EdgeInsets.only(right: 45.0),
                          unselectedLabelColor: Color(0xFFCDCDCD),
                          tabs: [
                            Tab(
                              child: Text(
                                lang['about']!,
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontFamily:
                                      lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                                  //  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.fontSize(15),
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                lang['reviews']!,
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontFamily:
                                      lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                                  //  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.fontSize(15),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      height: Dimensions.height(400),
                      width: double.infinity,
                      child: TabBarView(controller: _tabController, children: [
                        // about page
                        CAbout(locations: locations),
                        // reviews
                        !isTherereviews && reviews.isEmpty
                            ? Center(
                                child: Text(
                                globals.lang['You don\'t have any reviews']!,
                                style: TextStyle(
                                    fontSize: Dimensions.fontSize(18),
                                    fontWeight: FontWeight.w500),
                              ))
                            : reviews.isEmpty
                                ? Center(child: CircularProgressIndicator())
                                : RefreshIndicator(
                                    key: refreshIndicatorKey,
                                    onRefresh: refreshList,
                                    child: ListView.builder(
                                      controller: controller,
                                      itemCount: isLoadingMore
                                          ? reviews.length + 1
                                          : reviews.length,
                                      itemBuilder: (context, index) {
                                        if (index < reviews.length) {
                                          return Review(
                                            review: reviews[index],
                                            lang: lang['lang']!,
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(active: "profile"),
    );
  }
}
