import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfirstapp/dashboard/DashboardScreen.dart';

import 'SsiLoginPage.dart';
import '../main.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _login() async {
    // Perform login here using email and password
    // If login is successful, save the user information using SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);

    // Show a dialog to indicate that login was successful.
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Login Successful'),
          content: const Text('Welcome back!'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                // Pop the LoginPage.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DashboardScreen.yaleBlue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Please enter your email and password to login',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CupertinoFormSection(
                children: [
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value!,
                    ),
                  ),
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      placeholder: 'Password',
                      obscureText: true,
                      onSaved: (value) => _password = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                child: const Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _login();
                  }
                },
              ), const SizedBox(height: 16),
              CupertinoButton.filled(
                child: const Text('SSI Login'),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => SsiLoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
