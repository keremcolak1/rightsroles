import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ShopScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSettingItem(
                context,
                'SSI Connection',
                CupertinoIcons.person_fill,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SSIConnectScreen()),
                  );
                },
              ),
              _buildSettingItem(
                context,
                'Manage My Car',
                CupertinoIcons.car_detailed,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ManageMyCarScreen()),
                  );
                },
              ),
              // Add more setting items here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          CupertinoButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const Icon(CupertinoIcons.right_chevron),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class SSIConnectScreen extends StatelessWidget {
  const SSIConnectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("SSI Connection",style: TextStyle(
            color: Colors.white,
          )),
          backgroundColor: ShopScreen.yaleBlue,
        ),
        child: Center(
          child: Text('SSi Login Screen'),
        ),
      );
    } catch (e) {
      return Center(
        child: Text('Error: $e'),
      );
    }
  }
}

class ManageMyCarScreen extends StatelessWidget {
  const ManageMyCarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Manage My Car'),
      ),
      child: Center(
        child: Text('Manage My Car Screen'),
      ),
    );
  }
}