import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_flutter_proxy/custom_proxy.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'dashboard/DashboardScreen.dart';
import 'main/WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final initialScreen = isLoggedIn ? const DashboardScreen() : const WelcomeScreen();


  bool enabled = false;
  String? host;
  int? port;
  try {
    ProxySetting settings = await NativeProxyReader.proxySetting;
    enabled = settings.enabled; //cntlm
    host = settings.host; //localhost
    port = settings.port; //3128
    print(host);
  } catch (e) {
    print(e);
  }
  if (enabled && host != null) {
    final proxy = CustomProxy(ipAddress: host, port: port);
    proxy.enable();
    print("proxy enabled");
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'My iOS App',
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: DashboardScreen.yaleBlue,
        textTheme: CupertinoTextThemeData(
          actionTextStyle: TextStyle(color: DashboardScreen.yaleBlue),
          navActionTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: initialScreen,
    );
  }
}