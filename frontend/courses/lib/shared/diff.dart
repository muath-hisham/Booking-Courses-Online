import 'globals.dart' as globals;

String differenceDate(String date) {
  final date2 = DateTime.now();
  final difference = date2.difference(DateTime.parse(date));
  if(difference.inMinutes < 1){
    return "${difference.inSeconds.toString()} ${globals.lang['s']}";
  }else if(difference.inHours < 1){
    return "${difference.inMinutes.toString()} ${globals.lang['m']}";
  }else if(difference.inDays < 1){
    return "${difference.inHours.toString()} ${globals.lang['h']}";
  }else{
    return "${difference.inDays.toString()} ${globals.lang['d']}";
  }
}