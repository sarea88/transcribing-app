import 'dart:convert';
import 'dart:io';
import 'package:audio_transcription_app/modle/archive.dart';
import 'package:audio_transcription_app/modle/summarymodle.dart';
import 'package:audio_transcription_app/modle/textmodle.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataSender {
  Future<List<textmodle>?> sendData(
      {required File? dir, required String type}) async {
    if (dir == null) {
      return null;
    }

    String? token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    var url = Uri.parse('http://192.168.137.93:8000/api/extract');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('dir', dir.path));
    request.fields['type'] = type;

    // Debugging information
    print('URL: $url');
    print('Headers: ${request.headers}');
    print('Fields: ${request.fields}');
    print('File: ${dir.path}');

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var decodedResponse = jsonDecode(utf8.decode(responseData.bodyBytes));
      // String? responseText = decodedResponse['text'];
      print('Response: ${responseData.body}');
      return (decodedResponse as List)
          .map((data) => textmodle.fromJson(data))
          .toList();
    } else {
      var responseBody = await http.Response.fromStream(response);
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');
      return null;
    }
  }

  Future<String> pdf(
      {required String title,
      required String date,
      required List<textmodle> content}) async {
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      return 'Token is not available';
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('http://192.168.137.93:8000/api/generate-pdf'));
    request.body =
        json.encode({"title": title, "date": date, "content": content});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var decodedResponse = jsonDecode(responseData.body);
      String responsePath = decodedResponse['path'];
      print('Response: ${responseData.body}');
      return responsePath;
    } else {
      var responseBody = await http.Response.fromStream(response);
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');
      return 'Request failed with status: ${response.statusCode}';
    }
  }

  Future<List<archive>?> archiveget() async {
    String? token = await getToken();

    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('http://192.168.137.93:8000/api/archive'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var decodedResponse = jsonDecode(utf8.decode(responseData.bodyBytes));
      return (decodedResponse as List)
          .map((data) => archive.fromJson(data))
          .toList();
    } else {
      return null;
    }
  }

  Future<List<summarymodle>?> summary({required List<textmodle> content}) async {
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('http://192.168.137.93:8000/api/summry'));
    request.body = json.encode({"topics": content});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var decodedResponse = jsonDecode(utf8.decode(responseData.bodyBytes));
      // String? responseText = decodedResponse['text'];
      print('Response: ${responseData.body}');
      return (decodedResponse as List)
          .map((data) => summarymodle.fromJson(data))
          .toList();
    } else {
      var responseBody = await http.Response.fromStream(response);
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');
      return null;
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      print('Token not found');
      return null;
    }
    print('Token: $token');
    return token;
  }
}
