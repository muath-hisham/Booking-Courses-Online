import 'package:get/get.dart';

class Dimensions {
  static final double _screenHeight = Get.context!.height;
  static final double _screenWidth = Get.context!.width;

  static double get getScreenHeight => _screenHeight;
  static double get getScreenWidth => _screenWidth;

  static double height(double x) {
    return _screenHeight / (812 / x);
  }

  static double width(double x) {
    return _screenWidth / (375 / x);
  }

  static double vertical(double x) {
    return _screenHeight / (812 / x);
  }

  static double horizontal(double x) {
    return _screenWidth / (375 / x);
  }

  static double fontSize(double x) {
    return _screenHeight / (812 / x);
  }
}
