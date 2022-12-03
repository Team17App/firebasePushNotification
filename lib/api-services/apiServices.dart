// ignore_for_file: file_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  //---- HEADERs
  // ignore: non_constant_identifier_names
  static final HEADERS_SIMPLE = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Map<String, String> headersAuth(String value) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": value,
    };
  }

  static Map<String, String> headersAuthFirebase(String key) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": 'key=$key',
    };
  }

  //----- Query's
  static String queryFromJson(Map<String, dynamic> json) {
    String querry = '';
    var keys = json.keys;
    var values = json.values;
    for (int i = 0; i < keys.length; i++) {
      if (i == 0) querry += '?${keys.first}=${values.first}';
      if (i != 0) querry += '&${keys.elementAt(i)}=${values.elementAt(i)}';
    }
    return querry;
  }

  //---- URL
  static Uri getUrl({required String url, required endpoint, dynamic params}) =>
      params != null
          ? Uri.https(url, endpoint, params)
          : Uri.https(url, endpoint);
  //--------
  static getBody(http.Response response) {
    String b = utf8.decode(response.bodyBytes);
    final json = jsonDecode(b);
    return json;
  }

  static Future<Uint8List> getResponse(String path) async {
    final url = Uri.parse(path);
    final response = await http.get(url);
    return response.bodyBytes;
  }

  // GET
// ignore: non_constant_identifier_names
  static Future<http.Response?> GET({
    required Uri url,
    bool printResp = false,
    Map<String, String>? header,
    int timeout = 80,
  }) async {
    try {
      var response = await http
          .get(
            url,
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeout));
      debugPrint('Response status: ${response.statusCode} || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

  // POST
// ignore: non_constant_identifier_names
  static Future<http.Response?> POST({
    required Uri url,
    required bodyy,
    bool printResp = false,
    Map<String, String>? header,
    int timeOut = 80,
  }) async {
    try {
      var response = await http
          .post(
            url,
            body: jsonEncode(bodyy),
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeOut));
      debugPrint('Response status: ${response.statusCode}  || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

  // PUT
// ignore: non_constant_identifier_names
  static Future<http.Response?> PUT({
    required Uri url,
    required bodyy,
    bool printResp = false,
    Map<String, String>? header,
    int timeOut = 80,
    bool hasEncode = true,
  }) async {
    try {
      //var body = EncryptData.encryptAESObj2(bodyy);
      var response = await http
          .put(
            url,
            body: hasEncode ? jsonEncode(bodyy) : bodyy,
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeOut));
      debugPrint('Response status: ${response.statusCode}  || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

// DELETE

  // ignore: non_constant_identifier_names
  static Future<http.Response?> DELETE({
    required Uri url,
    bool printResp = false,
    Map<String, String>? header,
    int timeout = 300,
  }) async {
    try {
      var response = await http
          .delete(
            url,
            headers: header ?? HEADERS_SIMPLE,
          )
          .timeout(Duration(seconds: timeout));
      debugPrint('Response status: ${response.statusCode} || ${url.path}');
      if (printResp) debugPrint('Response body: ${response.body}');
      return response;
    } catch (_) {
      return null;
    }
  }

// notificaction push services
  static Future<void> sendMenssageFirebaseCloud(
      {required String tokenSend,
      required String authorization,
      String title = '',
      String content = '',
      Map<String, dynamic>? data,
      bool printResp = false,
      int timeOut = 300}) async {
    // header
    Map<String, String> headersAuth = {
      "Authorization": authorization,
      "Content-Type": 'application/json',
    };

    // body send
    Map<String, dynamic> body = {
      "to": tokenSend,
      "notification": {"title": title, "body": content},
      "mutable_content": true,
      "sound": "Tri-tone",
      "data": data ?? {}
    };

    try {
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var response = await http
          .post(
            url,
            body: jsonEncode(body),
            headers: headersAuth,
          )
          .timeout(Duration(seconds: timeOut));
      debugPrint('Response status: ${response.statusCode}');
      if (printResp) debugPrint('Response body: ${response.body}');
    } catch (_) {}
  }
}//....
