import 'dart:convert';

import 'package:http/http.dart';

class RequestAssistant {
  static Future<dynamic> receivedRequest(String url) async {
    try {
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        String responseData = response.body;
        var decodeResponse = jsonDecode(responseData);
        return decodeResponse;
      } else {
        return "Error Occured, Failed. No Response";
      }
    } catch (e) {
      return "Error Occured, Failed. No Response";
    }
  }
}
