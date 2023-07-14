import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/dashboard/DashboardScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main/WelcomeScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Profile',style: TextStyle(
          color: Colors.white,
        )),
        backgroundColor: DashboardScreen.yaleBlue,
        border: null,
        leading: Builder(
          builder: (BuildContext context) {
            return CupertinoNavigationBarBackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (snapshot.hasData) {
            final prefs = snapshot.data!;
            final name = prefs.getString('name');
            final surname = prefs.getString('surname') ?? '';
            final email = prefs.getString('email') ?? '';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    color: DashboardScreen.yaleBlue,
                    size: 128,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$name $surname',
                    style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  ),
                  const SizedBox(height: 32),
                  CupertinoButton(
                    child: const Text('Sign Out'),
                    onPressed: () {
                      prefs.setBool('isLoggedIn', false);
                      Navigator.of(context, rootNavigator: true).pushReplacement(
                        MaterialPageRoute(builder: (context) => WelcomeScreen()), //burda bi sikinti var arada error veriyo manyak gibi
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Failed to load data'),
            );
          }
        },
      ),
    );
  }
}