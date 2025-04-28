/*import 'package:final_project/Utills/DB.dart';
import 'package:final_project/Utills/Utills.dart';
import 'package:final_project/Views/CarScreen.dart';
import 'package:final_project/Views/HomePageScreen.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/UserModel.dart';
import 'package:final_project/Utills/ClientConfig.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _Name = TextEditingController();
  final _PhoneNumber = TextEditingController();
  final _Password = TextEditingController();
  final _ConfirmPassword = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;


  void _register() {
    // Implement registration logic
    if (_Password.text == _ConfirmPassword.text) {
      print('Name: ${_Name.text}');
      print('PhoneNumber: ${_PhoneNumber.text}');
      print('Password: ${_Password.text}');
    } else {
      // Show error that passwords don't match
    }
  }

  @override
  Widget build(BuildContext context) {



    Future insertUser(BuildContext context, String Name, String phoneNumber, String Password) async {
      print("my link:" + serverPath);
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //  String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
      var url = "users/insertUser.php?Name=" + Name + "&phoneNumber=" + phoneNumber +"&Password=" + Password ;
      final response = await http.get(Uri.parse(serverPath + url));
      print("my link:" + serverPath + url);
      // setState(() { });
      // Navigator.pop(context);
    }



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
                SizedBox(height: 60),
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
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
                          controller: _Name,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            hintText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _PhoneNumber,
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
                          controller: _Password,
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
                        SizedBox(height: 20),
                        TextField(
                          controller: _ConfirmPassword,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('name',_Name.text );
                            prefs.setString('phoneNumber',_PhoneNumber.text );
                            prefs.setString('password',_Password.text );
                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                             insertUser(context, _Name.text, _PhoneNumber.text ,_Password.text );
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4568DC),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Sign Up',
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
                        'Or Sign Up With',
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
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        // Navigate to login page
                      },
                      child: Text(
                        'Sign In',
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
          // Social signup logic
        },
      ),
    );
  }
}*/
import 'package:final_project/Utills/DB.dart';
import 'package:final_project/Utills/Utills.dart';
import 'package:final_project/Views/CarScreen.dart';
import 'package:final_project/Views/HomePageScreen.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/UserModel.dart';
import 'package:final_project/Utills/ClientConfig.dart';
import '../Utills/ApiService.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _Name = TextEditingController();
  final _PhoneNumber = TextEditingController();
  final _Password = TextEditingController();
  final _ConfirmPassword = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _register() async {
    // Validate form
    if (_Name.text.isEmpty || _PhoneNumber.text.isEmpty || _Password.text.isEmpty) {
      _showErrorSnackBar('All fields are required');
      return;
    }

    if (_Password.text != _ConfirmPassword.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    if (_Password.text.length < 6) {
      _showErrorSnackBar('Password should be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.register(
          _Name.text,
          _PhoneNumber.text,
          _Password.text
      );

      if (result['result'] == '1') {
        // Registration successful
        _showSuccessSnackBar('Registration successful!');

        // Save user info and log in
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', _Name.text);
        prefs.setString('phoneNumber', _PhoneNumber.text);
        prefs.setString('password', _Password.text);

        if (result['insertID'] != null) {
          prefs.setString('token', result['insertID'].toString());
        }

        // Navigate to home page after a short delay
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage())
          );
        });
      } else {
        // Registration failed
        _showErrorSnackBar(result['message'] ?? 'Failed to register');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 60),
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
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
                          controller: _Name,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            hintText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _PhoneNumber,
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
                          controller: _Password,
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
                        SizedBox(height: 20),
                        TextField(
                          controller: _ConfirmPassword,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4568DC),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            'Sign Up',
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
                        'Or Sign Up With',
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
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: Text(
                        'Sign In',
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
          // Social signup logic
        },
      ),
    );
  }
}