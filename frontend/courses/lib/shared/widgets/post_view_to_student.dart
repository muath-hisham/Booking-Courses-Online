import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:courses/shared/diff.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:courses/shared/widgets/exandable_text.dart';
import 'package:courses/shared/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import '../../screens/student/components/add_comment.dart';
import '../../shared/globals.dart' as globals;

import '../../screens/student/company_details_page.dart';
import '../call_api.dart';
import '../colors.dart';
import '../settings/dropdown_menu/menu_item.dart';
import '../settings/dropdown_menu/menu_items.dart';
import 'awesome_dialog.dart';
import 'package:share_plus/share_plus.dart';

class PostToStudent extends StatefulWidget {
  final Map<String, dynamic> post;
  final Map<String, dynamic> lang;
  const PostToStudent({super.key, required this.post, required this.lang});

  @override
  State<PostToStudent> createState() => _PostToStudentState();
}

class _PostToStudentState extends State<PostToStudent> {
  List<String> comments = [];
  bool showTextField = false;

  TextEditingController commentController = TextEditingController();
  Future likePost(id) async {
    if (isFav) {
      Map data = {
        'method': 'like_post',
        'student_id': globals.student.id,
        'post_id': '$id',
        'process': 'add'
      };
      var response = await CallApi().postData(data);
    } else {
      Map data = {
        'method': 'like_post',
        'student_id': globals.student.id,
        'post_id': '$id',
        'process': 'remove'
      };
      var response = await CallApi().postData(data);
    }
  }

  void addComment() {
    String comment = commentController.text;
    setState(() {
      comments.add(comment);
      commentController.clear();
    });
  }

  Future isFavPost() async {
    Map data = {
      'method': 'is_fav_post',
      'student_id': globals.student.id,
      'post_id': '${widget.post['post_id']}'
    };
    var response = await CallApi().postData(data);
    print("${response.body} ------------------------");
    if (response.statusCode == 200) {
      // print("Data sent successfully");
      var state = json.decode(response.body);
      if (state['state'] == 101) {
        if (state['isFav'] == "1") {
          print("is true ======================");
          setState(() {
            isFav = true;
          });
        } else {
          print("is false ======================");
          setState(() {
            isFav = false;
          });
        }
      } else {
        print("error");
      }
    } else {
      Alert.error(context, globals.lang["check your network"]);
    }
  }

  @override
  void initState() {
    super.initState();
    isFavPost();
  }

  bool isFav = false;

  // dorpdown menu
  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            SizedBox(width: Dimensions.width(12)),
            Text(globals.lang[item.text]!),
          ],
        ),
      );

  Future onSelected(BuildContext context, MenuItem item, String text) async {
    switch (item) {
      case MenuItems.itemCopy:
        await FlutterClipboard.copy(text);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(globals.lang['Copied to clipboard']!)));
        break;
      case MenuItems.itemShare:
        Share.share(
            'check out my website https://pub.dev/packages/share_plus'); //////////////////////////////////
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "${globals.domain}/courses/upload/images/profiles/${widget.post['company_img']}";
    String imageStudent =
        "${globals.domain}/courses/upload/images/profiles/${globals.student.img}";
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.vertical(8),
        horizontal: Dimensions.horizontal(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Row(children: [
              Container(
                height: Dimensions.height(40),
                width: Dimensions.width(40),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: SCompanyPage(companyData: widget.post)));
                  },
                  child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                ),
              ),
              Container(
                height: Dimensions.height(40),
                margin: widget.lang['lang'] == 'ar'
                    ? EdgeInsets.only(right: Dimensions.width(10))
                    : EdgeInsets.only(left: Dimensions.width(10)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: widget.post['company_name'],
                        lang: widget.lang['lang'],
                        color: Colors.black,
                        font: 14,
                      ),
                      widget.lang['lang'] == 'ar'
                          ? SizedBox(
                              height: Dimensions.height(0),
                            )
                          : SizedBox(
                              height: Dimensions.height(5),
                            ),
                      MyText(
                        text: differenceDate(widget.post['post_time']),
                        lang: widget.lang['lang'],
                        color: Colors.black,
                        font: 10,
                      ),
                    ]),
              ),
            ]),
            trailing: PopupMenuButton<MenuItem>(
              padding: EdgeInsets.zero,
              onSelected: (item) =>
                  onSelected(context, item, widget.post['post_content']),
              itemBuilder: (context) => [
                ...MenuItems.items.map(buildItem).toList(),
              ],
            ),
          ),
          ExandableText(text: widget.post['post_content'], lang: widget.lang),
          SizedBox(
            height: Dimensions.height(10),
          ),
          Builder(
            builder: (context) {
              if (widget.post['photos'].isNotEmpty) {
                // print("Iam here ===================");
                return Container(
                  height: Dimensions.height(250),
                  child: ImageSlider(context, widget.post['photos']),
                );
              }
              // print("Iam out ===================");
              return SizedBox();
            },
          ),
          SizedBox(
            height: Dimensions.height(10),
          ),
          ListTile(
            title: Row(children: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    isFav = !isFav;
                  });
                  likePost(widget.post['post_id']);
                },
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showTextField = !showTextField;
                  });
                },
                icon: Icon(
                  FontAwesome.comment_o,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: showTextField
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                              ),
                            ),
                          ),
                          Container(
                            width: Dimensions.width(20),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: addComment,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ]),
            // trailing: IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.push_pin_outlined,
            //     color: Colors.black,
            //   ),
            // ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(32)),
            child: Text(
              isFav
                  ? "${int.parse(widget.post['post_number_of_likes']) + 1} ${widget.lang['likes']}"
                  : "${widget.post['post_number_of_likes']} ${widget.lang['likes']}",
              style: TextStyle(
                  fontFamily: widget.lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                  fontSize: Dimensions.fontSize(13),
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: Dimensions.height(15),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(20)),
                      child: ListTile(
                        leading: CircleAvatar(
                          foregroundImage: globals.student.img == ""
                              ? null
                              : NetworkImage(imageStudent),
                          backgroundColor: SharedColors.activeColor,
                          child: Text(
                            "${globals.student.fName.substring(0, 1).toUpperCase()}${globals.student.lName.substring(0, 1).toUpperCase()}",
                            style: TextStyle(
                                fontSize: Dimensions.fontSize(15),
                                color: Colors.white),
                          ),
                        ),
                        title: Text("${globals.student.fName} ${globals.student.lName}"),
                        subtitle: Text(comments[index]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dimensions.height(15),
          ),
          Divider(
            color: Color(0xFF707070),
            height: 0.5,
          )
        ],
      ),
    );
  }
}

Swiper ImageSlider(context, List photos) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      String imageUrl = "${globals.domain}/courses/upload/images/posts/" +
          photos[index]['post_img'];
      return Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        // errorBuilder: (context, error, stackTrace) {
        //   return Container(
        //     color: Colors.grey[500],
        //     alignment: Alignment.center,
        //     child: const Text(
        //       'Whoops! cheek',
        //       style: TextStyle(fontSize: 30),
        //     ),
        //   );
        // },
      );
    },
    itemCount: photos.length,
    viewportFraction: 1,
    scale: 0.7,
    pagination: const SwiperPagination(
      alignment: Alignment.topRight,
      builder: FractionPaginationBuilder(
        color: Colors.black,
        activeFontSize: 18,
        fontSize: 18,
      ),
    ),
  );
}
