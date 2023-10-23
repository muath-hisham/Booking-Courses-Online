import 'package:clipboard/clipboard.dart';
import 'package:courses/shared/diff.dart';
import 'package:courses/shared/dimensions.dart';
import 'package:courses/shared/widgets/exandable_text.dart';
import 'package:courses/shared/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../../shared/globals.dart' as globals;

import '../settings/dropdown_menu/menu_item.dart';
import '../settings/dropdown_menu/menu_items.dart';
import 'package:share_plus/share_plus.dart';

class PostToCompany extends StatefulWidget {
  final Map<String, dynamic> post;
  final Map<String, dynamic> lang;
  const PostToCompany({super.key, required this.post, required this.lang});

  @override
  State<PostToCompany> createState() => _PostToCompanyState();
}

class _PostToCompanyState extends State<PostToCompany> {
  // get the profile image to company
  String imageUrl =
      "${globals.domain}/courses/upload/images/profiles/${globals.company.img}";

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
                child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(32)),
            child: Text(
              "${widget.post['post_number_of_likes']} ${widget.lang['likes']}",
              style: TextStyle(
                  fontFamily: widget.lang['lang'] == 'ar' ? 'Cairo' : 'Varela',
                  fontSize: Dimensions.fontSize(13),
                  color: Colors.black),
            ),
          ),
          SizedBox(height: Dimensions.height(15)),
          /////////////////////////////////////////////////////////////////////////////////comments
          SizedBox(height: Dimensions.height(15)),
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
