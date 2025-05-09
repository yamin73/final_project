import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ManagerViews/AdminDashboard.dart';
import '../Utills/ClientConfig.dart';
import '../main.dart';
import 'HomePageScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Just show splash screen for a couple seconds, then go to login
    Timer(Duration(seconds: 2), () {
      // Always navigate to LoginPage without checking credentials
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.build_circle,
                size: 80,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'AutoCare',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Garage Management',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}