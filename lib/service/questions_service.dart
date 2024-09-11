import 'dart:convert';
import 'package:audio_transcription_app/modle/questionblank.dart';
import 'package:audio_transcription_app/modle/questionmcq.dart';
import 'package:audio_transcription_app/modle/questionwh.dart';
import 'package:audio_transcription_app/modle/textmodle.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class questionserv{
  Future<List<questionmcq>?>question_mcq_get({required List<textmodle>?topics})async{
     String? token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('http://192.168.137.93:8000/api/generate_mcq_questions'));
    request.body =
        json.encode({"topics": topics});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     var responseData = await http.Response.fromStream(response);
      var decodedResponse = jsonDecode(utf8.decode(responseData.bodyBytes));
      return (decodedResponse as List)
          .map((data) => questionmcq.fromJson(data))
          .toList();
    } else {
      var responseBody = await http.Response.fromStream(response);
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');
      return null;
    }
  }
    Future<List<questionblank>?>question_blank_get({required List<textmodle>?topics})async{
     String? token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('http://192.168.137.93:8000/api/generate_blank_questions'));
    request.body =
        json.encode({"topics": topics});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     var responseData = await http.Response.fromStream(response);
      var decodedResponse = jsonDecode(utf8.decode(responseData.bodyBytes));
      return (decodedResponse as List)
          .map((data) => questionblank.fromJson(data))
          .toList();
    } else {
      var responseBody = await http.Response.fromStream(response);
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${responseBody.body}');
      return null;
    }
  }
      Future<List<questionwh>?>question_wh_get({required List<textmodle>?topics})async{
     String? token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('http://192.168.137.93:8000/api/generate_questions'));
    request.body =
        json.encode({"topics": topics});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     var responseData = await http.Response.fromStream(response);
      var decodedResponse = jsonDecode(utf8.decode(responseData.bodyBytes));
      return (decodedResponse as List)
          .map((data) => questionwh.fromJson(data))
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