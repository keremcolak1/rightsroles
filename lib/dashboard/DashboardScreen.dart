import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/dashboard/MyItemsScreen.dart';
import 'package:myfirstapp/dashboard/ProfileScreen.dart';
import 'package:myfirstapp/dashboard/SettingsScreen.dart';
import 'package:myfirstapp/dashboard/ShopScreen.dart';
import 'package:myfirstapp/dashboard/HomeScreen.dart';
import 'package:myfirstapp/wallet/WalletCommunicator.dart';

class DashboardScreen extends StatelessWidget {


  const DashboardScreen({Key? key}) : super(key: key);

  static const yaleBlue = Color(0xff16588E);
  static const lightBlue = Color(0xff81C4FF);
  static const grey = Color(0xffE5E5EA);


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: yaleBlue,
        trailing: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Icon(
            CupertinoIcons.person_fill,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
        ),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_arrow_right),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.collections),
              label: 'My Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          Widget child;
          String title;
          switch (index) {
            case 0:
              child = const HomeScreen();
              title = 'Dashboard';
              break;
            case 1:
              child = const ShopScreen();
              title = 'Shop';
              break;
            case 2:
              child = MyItemsScreen();
              title = 'My Car';
              break;
            case 3:
              child = const SettingsScreen();
              title = 'Settings';
              break;
            default:
              throw Exception('Invalid tab index $index');
          }
          return CupertinoTabView(
            builder: (BuildContext context) {
              return CupertinoPageScaffold(
                child: child,

              );
            },
          );
        },
      ),
    );
  }
}