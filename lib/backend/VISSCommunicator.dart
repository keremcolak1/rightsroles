import 'dart:convert';
import 'package:http/http.dart' as http;
import '../rights/RightsManager.dart';

import '../main/config.dart';

class VissCommunicator {
  late RightsManager rightsManager;
  late String scope;
  late String username;
  late String password;

  VissCommunicator(String tokenUrl, String clientId, String clientSecret) {
    rightsManager = RightsManager(tokenUrl, clientId, clientSecret);
    scope = '';
    username ="WBA51EH010HY00928"; //subject to change
    password ="pwd";
  }



  //also should add logic to rightsmanager to check if the user SHOULD have access to the values and scopes

  Future<String?> getValue(String endpointPath) async { //add post

    scope = rightsManager.scopePicker(endpointPath);
    if(await rightsManager.hasScope(scope)){
      //do nothing
    } else { //retrieve the token first, then continue
      rightsManager.retrieveToken(username, password, scope);
    }
    final accessToken = await rightsManager.retrieveAccessToken(scope);
    if (accessToken != null) {

      final url = '$VissUrl/${endpointPath.startsWith('/') ? endpointPath.substring(1) : endpointPath}';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['value'];
      } else {
        print('Failed to retrieve value: ${response.statusCode} - ${response.body}');
      }
    }
    return null;
  }
}