library globals;

import 'package:courses/models/student_model.dart';

import '../models/company_model.dart';
import 'language/language.dart';

Map<String, String> lang = Language.en;
String pytonServer = "http://192.168.43.247:5000/";
String domain = "http://192.168.43.247";
String linkTheApp = "https://pub.dev/packages/share_plus";
// my home ip addrees: http://192.168.1.5
Student student = Student.empty();
Company company = Company.empty();

List<Map> countries = [
  {"id": 1, "name": 'Egypt'},
  // {"id": 2, "name": 'Palestine'}
];

List<Map> companyStatesMasters = [
  {'id': 1, 'name': 'Cairo', "countryId": 1},
  {'id': 2, 'name': 'Giza', "countryId": 1},
  {'id': 3, 'name': 'Alexandria', "countryId": 1},
  {'id': 4, 'name': 'Dakahlia', "countryId": 1},
  {'id': 5, 'name': 'Red Sea', "countryId": 1},
  {'id': 6, 'name': 'Beheira', "countryId": 1},
  {'id': 7, 'name': 'Fayoum', "countryId": 1},
  {'id': 8, 'name': 'Gharbiya', "countryId": 1},
  {'id': 9, 'name': 'Ismailia', "countryId": 1},
  {'id': 10, 'name': 'Menofia', "countryId": 1},
  {'id': 11, 'name': 'Minya', "countryId": 1},
  {'id': 12, 'name': 'Qaliubiya', "countryId": 1},
  {'id': 13, 'name': 'New Valley', "countryId": 1},
  {'id': 14, 'name': 'Suez', "countryId": 1},
  {'id': 15, 'name': 'Aswan', "countryId": 1},
  {'id': 16, 'name': 'Assiut', "countryId": 1},
  {'id': 17, 'name': 'Beni Suef', "countryId": 1},
  {'id': 18, 'name': 'Port Said', "countryId": 1},
  {'id': 19, 'name': 'Damietta', "countryId": 1},
  {'id': 20, 'name': 'Sharkia', "countryId": 1},
  {'id': 21, 'name': 'South Sinai', "countryId": 1},
  {'id': 22, 'name': 'Kafr Al sheikh', "countryId": 1},
  {'id': 23, 'name': 'Matrouh', "countryId": 1},
  {'id': 24, 'name': 'Luxor', "countryId": 1},
  {'id': 25, 'name': 'Qena', "countryId": 1},
  {'id': 26, 'name': 'North Sinai', "countryId": 1},
  {'id': 27, 'name': 'Sohag', "countryId": 1},
  {'id': 1, 'name': 'Rafah', "countryId": 2},
  {'id': 2, 'name': 'Khan Yunis', "countryId": 2},
  {'id': 3, 'name': 'Deir El Balah', "countryId": 2},
  {'id': 4, 'name': 'Gaza City', "countryId": 2},
  {'id': 5, 'name': 'North Gaza', "countryId": 2},
];
