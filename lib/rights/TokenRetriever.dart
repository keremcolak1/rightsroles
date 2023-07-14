import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TokenRetriever {
  String tokenUrl;
  String clientId;
  String clientSecret;

  TokenRetriever(this.tokenUrl, this.clientId, this.clientSecret);

  Future<Map<String, dynamic>> retrieveToken(String username, String password, String scope) async {
    final response = await http.post(
      Uri.parse("$tokenUrl/token"),
      headers: {'content-type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'scope': scope,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );
    if (response.statusCode == 200) {
      //save the token response body for the current scope
      final prefs = await SharedPreferences.getInstance();
      final responseJson = json.decode(response.body);
      await prefs.setString(scope, json.encode(responseJson));

      return responseJson;
    } else {
      throw Exception('Failed to retrieve token');
    }
  }
/*
  Future<Map<String, dynamic>?> getTokenFromStorage(String scope) async { //not used yet
    final prefs = await SharedPreferences.getInstance();
    final responseJson = prefs.getString(scope);
    if (responseJson != null) {
      return json.decode(responseJson);
    }
    return null;
  }
  */
}