import 'package:courses/shared/dimensions.dart';
import 'package:courses/shared/widgets/my_text.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/globals.dart' as globals;

class CAbout extends StatelessWidget {
  final List locations;
  const CAbout({
    super.key,
    required this.locations,
  });

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
                text: globals.company.email,
                lang: globals.lang['lang']!,
                color: Colors.black,
                font: 16,
              )
            ],
          ),
          SizedBox(height: Dimensions.height(15)),
          globals.company.website != ""
              ? InkWell(
                  onTap: () async {
                    launchURL(globals.company.website);
                  },
                  child: Row(
                    children: [
                      Icon(FontAwesome.globe),
                      SizedBox(width: Dimensions.width(15)),
                      MyText(
                        text: globals.company.website,
                        lang: globals.lang['lang']!,
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
                          lang: globals.lang['lang']!,
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
                text: globals.company.description,
                lang: globals.lang['lang']!,
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
