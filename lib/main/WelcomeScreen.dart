
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/dashboard/DashboardScreen.dart';
import 'package:myfirstapp/main/registrationPage.dart';
import 'loginPage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);



  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  bool _isLoggedIn = false; // add a variable to keep track of login status

  @override
  Widget build(BuildContext context) {
    // check whether the user is logged in

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: DashboardScreen.yaleBlue,
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    color: DashboardScreen.yaleBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    borderRadius: BorderRadius.circular(8.0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const RegisterPage()),
                      ).then((value) {
                        if (value != null && value) {
                          setState(() {
                            _isLoggedIn = true; // set the login status to true
                          });
                        }
                      });
                      // navigate to registration screen
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CupertinoButton(
                    color: DashboardScreen.lightBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    borderRadius: BorderRadius.circular(8.0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const LoginPage()),
                      ).then((value) {
                        if (value != null && value) {
                          setState(() {
                            _isLoggedIn = true; // set the login status to true
                          });
                        }
                      });
                      // navigate to login screen
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
