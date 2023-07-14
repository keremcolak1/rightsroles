import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

import '../dashboard/DashboardScreen.dart';

class SsiLoginPage extends StatefulWidget {
  const SsiLoginPage({Key? key}) : super(key: key);

  @override
  _SsiLoginPageState createState() => _SsiLoginPageState();
}

class _SsiLoginPageState extends State<SsiLoginPage> {
  late String _connectionId;
  late Future<Map<String, dynamic>> _invitationFuture;
  bool _isLoading = true;
  late String invitationUrl;

  @override
  void initState() {
    super.initState();
    _invitationFuture = _createInvitation();
  }

  Future<Map<String, dynamic>> _createInvitation() async {
    final url = Uri.parse(
        '$acapyAgentUrl/connections/create-invitation?auto_accept=true');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _connectionId = data['connection_id'];
      invitationUrl = data['invitation_url'];

      // Save connection ID to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('connectionId', _connectionId);
      print("Connection id: $_connectionId");

      setState(() {
        _isLoading = false;
      });

      return {
        'connectionId': _connectionId,
        'invitationUrl': invitationUrl,
      };
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to create invitation: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'SSI Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DashboardScreen.yaleBlue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Scan the QR code or click the link below to login with SSI:',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),
            _isLoading
                ? const CupertinoActivityIndicator()
                : FutureBuilder<Map<String, dynamic>>(
              future: _invitationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return QrImage(
                      data: snapshot.data!['invitationUrl'],
                      version: QrVersions.auto,
                      size: 400.0,
                    );
                  } else {
                    return const Text('Failed to create invitation');
                  }
                } else {
                  return const CupertinoActivityIndicator();
                }
              },
            ),
            const SizedBox(height: 50),
            CupertinoButton(child: Text('I have accepted the connection'), onPressed: (){



    Navigator.pushReplacement(
    context,
    CupertinoPageRoute(
    builder: (context) => const DashboardScreen(),
    ),
    );
            }),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Uri uri = Uri.parse(invitationUrl);
                String query = uri.query;
                String invitationParams = query.substring(query.indexOf("=") + 1);
                print(invitationParams); //only get the parameters to send it to the app, dont need the whole link
                String LissiURL = "esatus-wallet://aries_connection_invitation/?c_i=$invitationParams";
                print(LissiURL);
                print(invitationUrl);
                Uri uri1 = Uri.parse(LissiURL);
                launchUrl(uri1);

              },
              child: const Text(
                'Open in SSI Wallet (tap here)',
                style: TextStyle(
                  color: DashboardScreen.yaleBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}