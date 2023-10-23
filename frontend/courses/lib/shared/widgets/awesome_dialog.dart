import 'package:awesome_dialog/awesome_dialog.dart';
import '../../shared/globals.dart' as globals;

Map<String, String> lang = globals.lang; // to choose the language

class Alert {
  static success(context, text) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      // title: lang['success'],
      desc: text,
      // useRootNavigator: true,
      // btnCancelOnPress: () {},
      // btnOkOnPress: () => Navigator.of(context).pop(),
    )..show();
  }

  static error(context, text) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      // title: lang['success'],
      desc: text,
      // useRootNavigator: true,
      // btnCancelOnPress: () {},
      // btnOkOnPress: () => Navigator.of(context).pop(),
    )..show();
  }

  static warning(context, text) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      // title: lang['success'],
      desc: text,
      // useRootNavigator: true,
      // btnCancelOnPress: () {},
      // btnOkOnPress: () => Navigator.of(context).pop(),
    )..show();
  }
}
