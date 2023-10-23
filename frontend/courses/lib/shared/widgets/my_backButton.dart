import 'package:flutter/material.dart';

import '../dimensions.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: Dimensions.height(45),
      width: Dimensions.width(45),
      top: Dimensions.vertical(10),
      left: Dimensions.horizontal(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.height(50)),
          color: const Color(0xFFF1F1F1),
        ),
        child: Center(
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: Dimensions.fontSize(16),
              color: const Color(0xff756d54),
            ),
          ),
        ),
      ),
    );
  }
}
