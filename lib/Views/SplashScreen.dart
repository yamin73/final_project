import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ManagerViews/AdminDashboard.dart';
import '../Utills/ClientConfig.dart';
import '../main.dart';
import 'HomePageScreen.dart';
import 'package:final_project/ManagerViews/AdminDashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Add a small delay to show the splash screen
    await Future.delayed(Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? phoneNumber = prefs.getString('phoneNumber');
    String? password = prefs.getString('password');

    if (token != null && phoneNumber != null && password != null) {
      // User was previously logged in, verify credentials
      try {
        var url = "login/checkLogin.php?phoneNumber=$phoneNumber&password=$password";
        final response = await http.get(Uri.parse(serverPath + url));

        if (response.statusCode == 200) {
          final loginData = checkLoginModel.fromJson(jsonDecode(response.body));

          if (loginData.userID != 0) {
            // Valid credentials, check if admin
            if (loginData.userID == 1 || loginData.userID == 2) {
              // Admin user - navigate to admin dashboard
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard())
              );
              return;
            } else {
              // Regular user - navigate to regular home page
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage())
              );
              return;
            }
          }
        }
      } catch (e) {
        print("Auto-login error: $e");
      }
    }

    // If no valid session or auto-login failed, go to login page
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
    );
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