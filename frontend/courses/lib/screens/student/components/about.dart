import 'package:courses/shared/dimensions.dart';
import 'package:courses/shared/widgets/my_text.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  final Map<String, dynamic> data;
  final List locations;
  final String lang;
  const About(
      {super.key,
      required this.data,
      required this.locations,
      required this.lang});

  launchURL(String uri) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(25)),
      padding: EdgeInsets.only(top: Dimensions.height(15)),
      child: ListView(
        children: [
          Row(
            children: [
              Icon(FontAwesome.envelope),
              SizedBox(width: Dimensions.width(15)),
              MyText(
                text: data['company_email'],
                lang: lang,
                color: Colors.black,
                font: 16,
              )
            ],
          ),
          SizedBox(height: Dimensions.height(15)),
          data['company_website'] != ""
              ? InkWell(
                  onTap: () async {
                    launchURL(data['company_website']);
                  },
                  child: Row(
                    children: [
                      Icon(FontAwesome.globe),
                      SizedBox(width: Dimensions.width(15)),
                      MyText(
                        text: data['company_website'],
                        lang: lang,
                        color: Colors.black,
                        font: 16,
                      )
                    ],
                  ),
                )
              : SizedBox(),
          SizedBox(height: Dimensions.height(15)),
          Builder(
            builder: (context) {
              List<Widget> output = [];
              locations.forEach((element) {
                output.add(Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                        ),
                        SizedBox(width: Dimensions.width(15)),
                        MyText(
                          text: element,
                          lang: lang,
                          color: Colors.black,
                          font: 16,
                        ),
                        // SizedBox(height: Dimensions.height(15)),
                      ],
                    ),
                    SizedBox(height: Dimensions.height(15)),
                  ],
                ));
              });
              Column column = Column(
                children: output,
              );
              return column;
            },
          ),
          SizedBox(height: Dimensions.height(15)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AntDesign.infocirlce),
              SizedBox(width: Dimensions.width(15)),
              MyText(
                text: data['company_description'],
                lang: lang,
                color: Colors.black,
                font: 16,
              )
            ],
          ),
        ],
      ),
    );
  }
}
