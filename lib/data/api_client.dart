import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

//import 'dart:ffi';

// import 'package:buysellbiz/Data/AppData/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zurumi/screens/basic/login_screen.dart';
import 'package:zurumi/screens/side_menu/side_menu.dart';
// import 'package:http/http.dart';

class ApiService {
  static Map<String, String> _authMiddleWare() {
    return {
      'Content-Type': 'application/json',
    };
  }

  static Future<Map<String, dynamic>> get(String url,
      {Map<String, String>? headers}) async {
    try {
      log(_authMiddleWare().toString());

      http.Response res = await http.get(
        Uri.parse(url),
        headers: headers ?? _authMiddleWare(),
      );
      log("GET: $url");
      log("BODY:${res.body}");
      debugPrint("Here is Date $url ${res.statusCode} ${res.body}");
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }

      debugPrint("Here is status code ${res.statusCode}");

      return {
        "success": false,
        "error": "${res.statusCode} ${res.reasonPhrase}",
        "body": res.body
      };
    } on SocketException catch (e) {
      print('in socet');
      // Handle SocketException here.
      return {
        "success": false,
        "error": 'No Internet Please Connect To Internet',
        "status": 30
      };

      print('SocketException: $e');
      // You can display an error message to the user or perform other actions.
    } on TimeoutException catch (e) {
      // Handle SocketException here.
      return {
        "success": false,
        "error":
            "Oops! We're experiencing technical difficulties at the moment. Our servers are currently not responding. Please try again later.",
        "status": 31
      };
    } on HttpException catch (e) {
      // Handle HttpException (e.g., invalid URL) here.
      return {
        "success": false,
        "error":
            "Oops! We're experiencing technical difficulties at the moment. Our servers are currently not responding. Please try again later.",
        "status": 32
      };
    } catch (e) {
      return Future.error(e);
    }
  }

  static getCat(String url, {Map<String, String>? header}) async {
    try {
      var request = http.Request('GET', Uri.parse(url));

      request.headers.addAll(header ?? _authMiddleWare());

      var response = await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // print();
        return await response.stream.bytesToString();
      } else if (response.statusCode == 401) {
        print(response.reasonPhrase);
        return 401;
      }
    } on SocketException catch (e) {
      // Handle SocketException here.
      return {
        "success": false,
        "error": 'No Internet Please Connect To Internet',
        "status": 30
      };

      print('SocketException: $e');
      // You can display an error message to the user or perform other actions.
    } on TimeoutException catch (e) {
      // Handle SocketException here.
      return {
        "success": false,
        "error":
            "Oops! We're experiencing technical difficulties at the moment. Our servers are currently not responding. Please try again later.",
        "status": 31
      };
    } on HttpException catch (e) {
      // Handle HttpException (e.g., invalid URL) here.
      return {
        "success": false,
        "error":
            "Oops! We're experiencing technical difficulties at the moment. Our servers are currently not responding. Please try again later.",
        "status": 32
      };
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> post(
      String url, Map<String, dynamic> body,
      {Map<String, String>? header,BuildContext? context}) async {
    log(url);
    print(header.toString());
    try {
      // final headers = {'Content-Type': 'application/json'};

      http.Response res = await http.post(
        Uri.parse(url),
        headers: header ?? _authMiddleWare(),
        body: body.isNotEmpty? jsonEncode(body):{},
      );
      print(
          "API IN SERViCe =>> Status Code ${res.statusCode} Response ${res.body}");
      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> decode = jsonDecode(res.body);
        return decode;
      } else if (res.statusCode == 401) {
        Map<String, dynamic> decode = jsonDecode(res.body);
        print(
            "API IN SERViCe =>> Status Code ${decode['message']}");

        if (decode['message'] == "Unauthenticated.") {

          print("Unauthenticated");

          Navigator.of(context!).pushAndRemoveUntil(
            MaterialPageRoute(
              // TODO:SET MYMAP
              builder: (BuildContext context) => const Login_Screen(),
            ),
                (Route route) => false,
          );
          return {
            "success": false,
            "error": "Unauthenticated",
            "body": res.body
          };
        }
      }
      debugPrint("Here is data ${res.statusCode} ${res.body}");

      return {
        "success": false,
        "error": "${res.statusCode} ${res.reasonPhrase}",
        "body": res.body
      };
    } on SocketException catch (e) {
      print('in socet');
      // Handle SocketException here.
      return {
        "success": false,
        "error": 'No Internet Connection',
        "status": 30
      };

      print('SocketException: $e');
      // You can display an error message to the user or perform other actions.
    } on TimeoutException catch (e) {
      print('in timeout');
      // Handle SocketException here.
      return {
        "success": false,
        "error":
            "Oops! We're experiencing technical difficulties at the moment. Our servers are currently not responding. Please try again later.",
        "status": 31
      };
    } on HttpException catch (e) {
      // Handle HttpException (e.g., invalid URL) here.
      return {
        "success": false,
        "error":
            "Oops! We're experiencing technical difficulties at the moment. Our servers are currently not responding. Please try again later.",
        "status": 32
      };
    } catch (e) {
      return Future.error(e);
    }
  }

 static Future callLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

  }
  static Future<Map<String, dynamic>> postMultipart(
      String url, Map<String, dynamic> body, List<String?> filesPath,
      {Map<String, String>? header,
      String? requestMethod,
      String? imagePathName}) async {
    try {
      print("URL:$url");
      // //  UserData? us = SharedPrefs.getUserLoginData();
      //   print(us?.token);
      //   print(us?.user.id);
      // final headers = {'authorization': 'Bearer ${us!.token}'};
      var request =
          http.MultipartRequest(requestMethod ?? 'POST', Uri.parse(url));
      //request.fields.addAll(body);

      for (var str in body.entries) {
        if (str.value != null) {
          if (str.value.runtimeType is bool || str.key.runtimeType is bool) {
            request.fields[str.key.toString()] = str.value.toString();
          } else {
            request.fields[str.key] = str.value;
          }
        }
      }

      // request.fields.addEntries(body.entries);

      request.headers.addAll(header ?? _authMiddleWare());
      if (filesPath.isNotEmpty) {
        for (String? e in filesPath) {
          //print(e);
          request.files.add(
              await http.MultipartFile.fromPath(imagePathName ?? 'files', e!));
        }
      }
      http.StreamedResponse res = await request.send();
      // print(res.statusCode.toString() +"status code");
      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> decode =
            jsonDecode(await res.stream.bytesToString());
        return decode;
      }

      return {
        "success": false,
        "error": "${res.statusCode} ${res.reasonPhrase}",
        "body": null
      };
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> postMultipartFeedback(
      String url,
      Map<String, dynamic> body,
      List<String?> filesPath,
      List<String?> thumbnailImages,
      {Map<String, String>? header,
      String? requestMethod,
      String? imagePathName}) async {
    try {
      // print("here2");
      // UserData? us = SharedPrefs.getUserLoginData();
      // print(us?.token);
      // print(us?.user.id);
      //     final headers = {'authorization': 'Bearer ${us!.token}'};
      var request =
          http.MultipartRequest(requestMethod ?? 'POST', Uri.parse(url));
      //request.fields.addAll(body);

      for (var str in body.entries) {
        if (str.value != null) {
          if (str.value.runtimeType is bool || str.key.runtimeType is bool) {
            // print("herewe");
            request.fields[str.key.toString()] = str.value.toString();
          } else {
            request.fields[str.key] = str.value;
          }
          //  print(str.key);
        }
      }
      // request.fields.addEntries(body.entries);

      //  request.headers.addAll(headers);

      if (filesPath.isNotEmpty) {
        for (String? e in filesPath) {
          //print(e);
          request.files.add(
              await http.MultipartFile.fromPath(imagePathName ?? 'files', e!));
        }
      }
      if (thumbnailImages.isNotEmpty) {
        for (String? e in thumbnailImages) {
          //print(e);
          request.files.add(await http.MultipartFile.fromPath('thumbnail', e!));
        }
      }

      http.StreamedResponse res = await request.send();
      // print(res.statusCode.toString() +"status code");
      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> decode =
            jsonDecode(await res.stream.bytesToString());
        return decode;
      }

      return {
        "success": false,
        "error": "${res.statusCode} ${res.reasonPhrase}",
        "body": jsonDecode(await res.stream.bytesToString())
      };
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> putMultipart(
      String url, Map<String, dynamic> body, List<String?> filesPath,
      {Map<String, String>? header, String? imagePathName}) async {
    try {
      print("URL:$url");
      // //  UserData? us = SharedPrefs.getUserLoginData();
      //   print(us?.token);
      //   print(us?.user.id);
      // final headers = {'authorization': 'Bearer ${us!.token}'};
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      //request.fields.addAll(body);

      for (var str in body.entries) {
        if (str.value != null) {
          if (str.value.runtimeType is bool || str.key.runtimeType is bool) {
            request.fields[str.key.toString()] = str.value.toString();
          } else {
            request.fields[str.key] = str.value;
          }
        }
      }

      // request.fields.addEntries(body.entries);
      request.headers.addAll(_authMiddleWare());
      if (filesPath.isNotEmpty) {
        for (String? e in filesPath) {
          //print(e);
          request.files.add(
              await http.MultipartFile.fromPath(imagePathName ?? 'files', e!));
        }
      }
      http.StreamedResponse res = await request.send();
      print("STATUS CODE: ${res.statusCode}");
      // print("RESPONSE: ${await res.stream.bytesToString()}");
      if (res.statusCode == 200 || res.statusCode == 201) {
        // Map<String, dynamic> decode =
        //     jsonDecode(await res.stream.bytesToString());
        return jsonDecode(await res.stream.bytesToString());
      }

      return {
        "success": false,
        "error": "${res.statusCode} ${res.reasonPhrase}",
        "body": null
      };
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> put(
      String url, Map<String, dynamic>? body,
      {Map<String, String>? headers}) async {
    try {
      //print(body);
      http.Response res = await http.put(
        Uri.parse(url),
        headers: headers ?? _authMiddleWare(),
        body: jsonEncode(body),
        //encoding: Encoding.getByName("application/x-www-form-urlencoded")
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> decode = jsonDecode(res.body);
        return decode;
      }

      return {
        "success": false,
        "error": "${res.statusCode} ${res.reasonPhrase}",
        "body": null
      };
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<int> putPublic(String url, Map<String, dynamic>? body,
      {Map<String, String>? headers}) async {
    try {
      //print(body);
      http.Response res = await http.put(
        Uri.parse(url),
        // headers: headers ?? _authMiddleWare(),
        //body: jsonEncode(body),
        //encoding: Encoding.getByName("application/x-www-form-urlencoded")
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> decode = jsonDecode(res.body);
      }

      return res.statusCode;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> delete(String url,
      {Map<String, String>? headers}) async {
    try {
      http.Response res = await http.delete(
        Uri.parse(url),
        headers: headers ?? _authMiddleWare(),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> decode = jsonDecode(res.body);
        return decode;
      }
      return {
        "success": false,
        "error": "${res.statusCode} ${res.reasonPhrase}",
        "body": null
      };
    } catch (e) {
      return Future.error(e);
    }
  }
}
