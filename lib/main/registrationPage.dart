import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfirstapp/dashboard/DashboardScreen.dart';

import 'package:myfirstapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/RegisterBackend.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool shouldBypassRegistration = true; // Set to true to bypass registration for testing purposes.

  Future<void> _saveUserInformation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('surname', _surname);
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);

    bool isRegistrationSuccessful = false;
    int retryCount = 0;

    if (shouldBypassRegistration) {
      // Registration is bypassed.
      isRegistrationSuccessful = true;
    } else {
      while (!isRegistrationSuccessful && retryCount < 3) {
        // Show a loading indicator.
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const CupertinoAlertDialog(
              title: Text('Registering...'),
              content: SizedBox(
                height: 48,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
          },
        );

        try {
          // Call the registerUser() method in the RegisterBackend class to send the registration request.
          await RegisterBackend.registerUser(
            name: _name,
            surname: _surname,
            email: _email,
            password: _password,
          );

          // Registration was successful.
          isRegistrationSuccessful = true;
          await prefs.setBool('isLoggedIn', true);

          // Close the loading indicator.
          Navigator.pop(context);

          // Show a dialog to indicate that registration was successful.
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Registration Successful'),
                content: const Text('Your information has been saved.'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } catch (e) {
          // Registration failed.
          isRegistrationSuccessful = false;
          retryCount++;

          // Close the loading indicator.
          Navigator.pop(context);


          // Show a dialog with a retry option.
          final shouldRetry = await showCupertinoDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Registration Failed'),
                content: const Text(
                    'There was an error registering your account. Please try again.'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  CupertinoDialogAction(
                    child: const Text('Retry'),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              );
            },
          );

          if (!shouldRetry!) {
            break;
          }
        }
      }
    }

    await prefs.setBool('isLoggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Register',
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
                'Complete these steps for registration.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CupertinoFormSection(
                header: const Text('Personal Information'),
                children: [
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      placeholder: 'Name',
                      onSaved: (value) => _name = value!,
                    ),
                  ),
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      placeholder: 'Surname',
                      onSaved: (value) => _surname = value!,
                    ),
                  ),
                ],
              ),
              CupertinoFormSection(
                header: const Text('Account Information'),
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
                  CupertinoFormRow(
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      placeholder: 'Confirm Password',
                      obscureText: true,
                      onSaved: (value) => _confirmPassword = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                child: const Text('Register'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveUserInformation();
                  }
                },
              ),
              if (shouldBypassRegistration)
                CupertinoButton(
                  child: const Text('Bypass Registration'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('name', _name);
                    await prefs.setString('surname', _surname);
                    await prefs.setString('email', _email);
                    await prefs.setString('password', _password);
                    await prefs.setBool('isLoggedIn', true);

                    print(
                        'Name saved: ${prefs.getString('name')}'); //bunlar doesnt work
                    print('Surname saved: ${prefs.getString('surname')}');
                    print('Email saved: ${prefs.getString('email')}');
                    print('Password saved: ${prefs.getString('password')}');
                    print('isLoggedIn saved: ${prefs.getBool('isLoggedIn')}');

                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('Registration Successful'),
                          content:
                              const Text('Your information has been saved.'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const DashboardScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
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
