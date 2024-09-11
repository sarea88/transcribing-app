import 'dart:convert';
import 'package:audio_transcription_app/modle/usermodle.dart';
import 'package:http/http.dart' as http;


class userserv {
Future<Usermodleres?> authUser(loginreqmod authModel) async {
  try {
    http.Response response = await http.post(
      Uri.parse('http://192.168.137.93:8000/api/auth/login'),
      body: {
        'email': '${authModel.email}',
        'password': '${authModel.password}'
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);
      return Usermodleres.fromJson(user);
    } else {
      Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Unknown error occurred');
    }
  } catch (e) {
    print(e);
    return Future.error(e.toString());
  }
}


  Future<bool?> logout(String token) async {
    http.Response response = await http
        .post(Uri.parse('http://192.168.137.93:8000/api/auth/logout'), body: {'api_token': token});
    if (response.statusCode == 200) {
      return true;
    }else {
      return false;
    }
  }
Future<Usermodleres?> regesUser(signupreqmod authModel) async {
    http.Response response = await http.post(
        // ignore: unnecessary_brace_in_string_interps
        Uri.parse('http://192.168.137.93:8000/api/auth/register'),
        body: {
          'name':'${authModel.name}',
          'email':'${authModel.email}',
          'phone_number':'${authModel.phoneNumber}',
          'password':'${authModel.password}',
          'password_confirmation':'${authModel.passwordConfirmation}'
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);
      return Usermodleres.fromJson(user);
      
    } else if((response.statusCode == 401)) {
      print('object');
      return null;
    }
  }


}
