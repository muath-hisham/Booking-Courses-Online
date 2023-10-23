import 'dart:convert';

import 'package:courses/screens/company/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/call_api.dart';
import '../../../shared/colors.dart';
import '../../../shared/dimensions.dart';
import '../../../shared/globals.dart' as globals;
import '../../../shared/widgets/awesome_dialog.dart';
import '../../../shared/widgets/my_backButton.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;

class CreateNewPost extends StatefulWidget {
  const CreateNewPost({super.key});

  @override
  State<CreateNewPost> createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  Map<String, String> lang = globals.lang; // to choose the language
  final postContant = TextEditingController();

  // to upload images from gallery
  List<XFile>? files;
  Future pickerGallery() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        files = images;
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

  // upload the images to server
  Future<String> uploadImage(XFile? image) async {
    String imageName = "";
    var url = Uri.parse(
        "${globals.domain}/courses/upload/images/upload_images_to_posts.php");
    var request = http.MultipartRequest('POST', url);
    imageName = createImageName(image!.name);
    request.files.add(await http.MultipartFile.fromPath('file', image.path,
        filename: imageName));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image uploaded");
    } else {
      print("Image not uploaded. Status code: ${response.statusCode}");
      print("Response body: ${await response.stream.bytesToString()}");
    }
    return imageName;
  }

  // to save data and create an account
  Future saveData() async {
    if (files != null || postContant.text != "") {
      // to upload all images
      List<String> images = [];
      if (files != null) {
        for (int i = 0; i < files!.length; i++) {
          images.add(await uploadImage(files![i]));
        }
      }

      // Collect the data
      Map<String, dynamic> data = {
        'method': 'create_post',
        'company_id': globals.company.id,
        'post_content': postContant.text,
        'imgs': images,
      };

      print(data);
      var response = await CallApi().postData(data);
      print("${response.statusCode} ======================");
      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print("${response.body} ------------------------");
      if (response.statusCode == 200) {
        // print("Data sent successfully");
        var state = json.decode(response.body);
        if (state['state'] == 101) {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CHomePage()),
          );
        } else {
          print("error");
        }
      } else {
        Alert.error(context, globals.lang["check your network"]);
        // print("check your network");
      }

      print(data);
    } else {
      Alert.warning(context, globals.lang["Please enter any data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.page,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Stack(
          children: [
            // back button
            MyBackButton(),

            // next
            Positioned(
              top: Dimensions.vertical(10),
              right: Dimensions.horizontal(10),
              child: ElevatedButton(
                child: Text("${globals.lang['Next']}"),
                onPressed: () async {
                  saveData();
                },
              ),
            ),
            Positioned(
              left: Dimensions.horizontal(5),
              right: Dimensions.horizontal(5),
              top: Dimensions.vertical(80),
              child: TextFormField(
                controller: postContant,
                maxLines: 10,
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return '${globals.lang["Please enter company Description"]}';
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: "${globals.lang['Description']}",
                ),
              ),
            ),
            Positioned(
              top: Dimensions.vertical(350),
              left: Dimensions.horizontal(50),
              child: InkWell(
                onTap: () async {
                  pickerGallery();
                },
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: Dimensions.height(70),
                  width: Dimensions.width(280),
                  child: Icon(Icons.image_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
