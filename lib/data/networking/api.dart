import 'dart:convert';

import 'package:bank_todo/app/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class API {
  API();

  static const weatherAPIURL = 'api.weatherstack.com';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  String uidUser = "";

  static const String GET_CURRENT_WEATHER = '/current';

  Future login(String email, String password) async {
    final User user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;

    print(user);
    uidUser = user.uid.toString();

    return {'user': user, 'token': user != null ? await user.getIdToken() : ''};
  }

  Future getUserInfo() {
    return databaseReference
        .child(AppConstants.userDocument)
        .child(uidUser)
        .once();
  }

  Future getCurrentWeather(String apiKey, double lat, double lon) async {
    var url = Uri.http(weatherAPIURL, GET_CURRENT_WEATHER,
        {"access_key": apiKey, "query": '$lat,$lon'});

    print(url);
    MyHttpResponse response = await getRequest(url);

    return response;
  }
}

Future<MyHttpResponse> getRequest(Uri uri) async {
  var response = await http.get(uri);

  print(response.body);

  var data = json.decode(utf8.decode(response.bodyBytes));

  return MyHttpResponse(response.statusCode, data);
}

class MyHttpResponse {
  int statusCode;
  String message;
  dynamic data;

  MyHttpResponse(this.statusCode, this.data, {this.message});

  @override
  String toString() {
    return 'MyHttpResponse{statusCode: $statusCode, message: $message, data: $data}';
  }
}
