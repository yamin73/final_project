import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/Views/HomePageScreen.dart';
import 'package:flutter/material.dart';
import 'ManagerViews/AdminDashboard.dart';
import 'Utills/ClientConfig.dart';
import 'Utills/Utills.dart';
import 'Views/RegisterScreen.dart';
import 'package:http/http.dart' as http;

import 'Views/SplashScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoCare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

 /* Future _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "login/checkLogin.php?phoneNumber=" + _phoneNumberController.text+ "&password=" + _passwordController.text;
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    // setState(() { });
    // Navigator.pop(context);

    if(checkLoginModel.fromJson(jsonDecode(response.body)).userID == 0)
    {
      // return 'שם משתמש ו/או הסיסמה שגויים';
      var uti = new Utils();
      uti.showMyDialog(context, "Error", " user name or password is wrong");
    }
    else {
      // print("SharedPreferences 1");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', checkLoginModel
          .fromJson(jsonDecode(response.body))
          .userID!.toString());

      await prefs.setString('phoneNumber', _phoneNumberController.text);
      await prefs.setString('password', _passwordController.text);

      print('phoneNumber: ${_phoneNumberController.text}');
      print('Password: ${_passwordController.text}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }*/


  Future _login() async {
    setState(() {});

    try {
      var url = "login/checkLogin.php?phoneNumber=" + _phoneNumberController.text + "&password=" + _passwordController.text;
      final response = await http.get(Uri.parse(serverPath + url));
      print(serverPath + url);

      if (response.statusCode == 200) {
        final loginData = checkLoginModel.fromJson(jsonDecode(response.body));

        if (loginData.userID == 0) {
          // Invalid credentials
          var uti = new Utils();
          //uti.showMyDialog(context, "Error", "Username or password is wrong");
        } else {
          // Login successful
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', loginData.userID.toString());
          await prefs.setString('phoneNumber', _phoneNumberController.text);
          await prefs.setString('password', _passwordController.text);
         // await prefs.setString('name', loginData.Name ?? "User");

          // Check if user is admin (ID 1 or 2)
          if (loginData.userID == 1 || loginData.userID == 2) {
            // Admin user - navigate to admin dashboard
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard())
            );
          } else {
            // Regular user - navigate to regular home page
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage())
            );
          }
        }
      } else {
        // Server error
        var uti = new Utils();
        uti.showMyDialog(context, "Error", "Server error. Please try again later.");
      }
    } catch (e) {
      // Network or other error
      var uti = new Utils();
      uti.showMyDialog(context, "Error", "Connection error: $e");
    } finally {
      setState(() {});
    }
  }





  fillSavedPars()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _phoneNumberController.text = prefs.get("phoneNumber").toString();
    _passwordController.text = prefs.get("password").toString();
    if(_phoneNumberController.text != "" && _passwordController.text != "")
    {
      _login();
    }
  }



  checkConction() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected to internet');// print(result);// return 1;
      }
    } on SocketException catch (_) {
      print('not connected to internet');// print(result);
      var uti = new Utils();
      uti.showMyDialog(context, "אין אינטרנט", "האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה");
      // exit(0);
      // return;
    }
  }



  @override
  Widget build(BuildContext context) {
    checkConction();
    //fillSavedPars();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4568DC),
              Color(0xFF6A11CB),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 80),
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_outlined),
                            hintText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Forgot password logic
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4568DC),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white54)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or Sign In With',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white54)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(Icons.g_mobiledata),
                    SizedBox(width: 20),
                    _buildSocialButton(Icons.apple),
                    SizedBox(width: 20),
                    _buildSocialButton(Icons.facebook),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));

                        // Sign up logic
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.blue),
        onPressed: () {
          // Social login logic
        },
      ),
    );
  }
}
class checkLoginModel {
  int? userID;
  String? phoneNumber;


  checkLoginModel({
    this.userID,
    this.phoneNumber,

  });

  factory checkLoginModel.fromJson(Map<String, dynamic> json) {
    return checkLoginModel(
      userID: json['userID'] != null ? int.parse(json['userID'].toString()) : 0,
      phoneNumber: json['phoneNumber'],

    );
  }
}

/*class checkLoginModel {
  int? userID;
  // String? userTypeID;
  String? Name;

  checkLoginModel({
    this.userID,
    // this.userTypeID,
    this.Name,
  });

  factory checkLoginModel.fromJson(Map<String, dynamic> json) {
    return checkLoginModel(
      userID: json['userID'],
      // userTypeID: json['userTypeID'],
      Name: json['Name'],
    );
  }
}*/


