import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _greeting = '';
  String _name = '';

  @override
  void initState() {


      super.initState();
      _loadPreferences().then((_) {
        _updateGreeting();
      });


  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    if (name != null) {
      print('Name loaded from SharedPreferences: $name');
      setState(() {
        _name = name;
      });
    }
  }

  void _updateGreeting() {
    final currentTime = DateTime.now();
    final currentHour = currentTime.hour;
    final formatter = DateFormat.yMMMMd();
    final dateString = formatter.format(currentTime);

    setState(() {
      if (currentHour < 3) {
        _greeting = 'Good Night';
      } else if (currentHour < 12) {
        _greeting = 'Good Morning';
      } else if (currentHour < 18) {
        _greeting = 'Good Afternoon';
      }else if (currentHour <23){
        _greeting = 'Good Evening';
      }
      _greeting += ', $_name!';
    });

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Today is ${DateFormat('EEEE, MMMM d').format(DateTime.now())}',
                    style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Featured',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFeaturedItem(),
                    _buildFeaturedItem(),
                    _buildFeaturedItem(),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Placeholder for Home Screen content'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CupertinoColors.secondarySystemBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(CupertinoIcons.star_fill),
            SizedBox(height: 8),
            Text('Featured Item'),
          ],
        ),
      ),
    );
  }
}