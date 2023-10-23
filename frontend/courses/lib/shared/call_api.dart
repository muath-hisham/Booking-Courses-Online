import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../shared/globals.dart' as globals;

class CallApi {
  final url = Uri.parse('${globals.domain}/courses/go.php');
  Future<http.Response> postData(Map data) async {
    return await http.post(
      url,
      body: jsonEncode(data),
      headers: headers
    );
  }

  final Map<String, String> headers = {'Content-Type': 'application/json; charset=UTF-8'};
}
