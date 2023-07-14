import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterBackend {
  static const String _baseUrl =
      'https://customer-i.bmwgroup.com/gcdm/public/v4/bmwlabs/default/customers';

  static Future<void> registerUser({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    print("sending");
    final url = Uri.parse(_baseUrl);
    final captcha = {'userInput': '20000000-aaaa-bbbb-cccc-000000000002'};
    final userAccount = {'mail': email, 'password': password};
    final businessPartner = {
      'partnerCategory': 'PERSON',
      'salutation': 'SAL_MR',
      'givenName': name,
      'surname': surname,
      'correspondLanguageISO': 'DE',
      'homeMarket': 'DE'
    };
    final body = {
      'userAccount': userAccount,
      'businessPartner': businessPartner,
      'captcha': captcha
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // or maybe read the errors in the response body
      // Registration successful //get ids etcc
      final responseBody = jsonDecode(response.body);
      final gcid = responseBody['gcid'];
      final consGuid = responseBody['businessPartner']['communications']
          ['communicationEMails'][0]['consGUID'];
      final ucid = responseBody['ucid'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gcid', gcid);
      await prefs.setString('consGuid', consGuid);
      await prefs.setString('ucid', ucid);
     // await prefs.setString(, value)
      print('Registration Successful');
      print(gcid);
      print(responseBody.toString());
    } else {
      // Registration failed
      final responseBody = jsonDecode(response.body);
      print('Registration Failed');
      print(responseBody.toString());
    }
  }
}
