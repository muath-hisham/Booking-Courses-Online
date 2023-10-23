import 'package:courses/shared/dimensions.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;

import '../../../shared/call_api.dart';

class InterestDesign extends StatefulWidget {
  final Map<String, dynamic> data;
  const InterestDesign({super.key, required this.data});

  @override
  State<InterestDesign> createState() => _InterestDesignState();
}

class _InterestDesignState extends State<InterestDesign> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    widget.data['isInterest'] == "true"
        ? isSelected = true
        : isSelected = false;
  }

  Future addOrRemoveInteresting() async {
    if (isSelected) {
      Map data = {
        'method': 'interest_progress',
        'student_id': globals.student.id,
        'interest_id': widget.data['interest_id'],
        'process': 'addInt'
      };
      var response = await CallApi().postData(data);
      print(response.body);
    } else {
      Map data = {
        'method': 'interest_progress',
        'student_id': globals.student.id,
        'interest_id': widget.data['interest_id'],
        'process': 'removeInt'
      };
      var response = await CallApi().postData(data);
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.horizontal(10),
        vertical: Dimensions.vertical(5),
      ),
      child: ChoiceChip(
        label: Text(widget.data['interest_name']),
        selected: isSelected,
        selectedColor: Colors.orangeAccent,
        onSelected: (value) async {
          setState(() {
            isSelected = value;
          });
          await addOrRemoveInteresting();
        },
      ),
    );
  }
}
