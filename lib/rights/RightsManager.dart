import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'tokenRetriever.dart';

class RightsManager {
  late TokenRetriever tokenRetriever;

  RightsManager(String tokenUrl, String clientId, String clientSecret) {
    tokenRetriever = TokenRetriever(tokenUrl, clientId, clientSecret);
  }

  Future<Map<String, dynamic>> retrieveToken(
      String username, String password, String scope) {
    return tokenRetriever.retrieveToken(username, password, scope);
  }

  Future<bool> hasRights(String scope) async {
    //should check from wallet if we have rights or not!
    return true;
  }

  String scopePicker(String endpointPath) {
    //PICK THE RIGHT SCOPE FOR THE ENDPOINT!!!! more to come
    if (endpointPath.contains('Navigation/DestinationSet/Latitude')) {
      return 'write-wo-versionvss';
    } else if (endpointPath.contains('Navigation/DestinationSet/Longitude')) {
      return 'gps-read';
    } else if (endpointPath.contains('Cabin/SeatHeating')) {
      return 'seatheating';
    } else if (endpointPath
        .contains('Vehicle/Cabin/Infotainment/IsMobilePhoneConnected')) {
      return 'all-write';
    }
    return 'write-wo-versionvss';
  }

  Future<bool> hasScope(String scope) async {
    //confirm a scope exists, there is a problem here?
    final prefs = await SharedPreferences.getInstance();
    final tokenJson = prefs.getString(scope);
    if (tokenJson != null) {
      final token = Map<String, dynamic>.from(json.decode(tokenJson));
      final token1 = token['scope'];

      return token1.contains(scope);
    }
    return false;
  }

  Future<String?> retrieveAccessToken(String scope) async {
    //return the access token from storage
    if (await hasScope(scope)) {
      final prefs = await SharedPreferences.getInstance();
      final tokenJson = prefs.getString(scope);
      if (tokenJson != null) {
        final token = Map<String, dynamic>.from(json.decode(tokenJson));
        final accessToken = token['access_token'];
        if (accessToken is String) {
          return accessToken;
        }
      }
    }
    return null;
  }
}
