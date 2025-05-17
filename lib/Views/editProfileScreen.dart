import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as
http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _userId ='0' ;
  String _userName = 'yamin';
  String _userPhone = '0584309774';
  String _userPassword = 'yamin';

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // Text editing controllers - declare without initial values
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _fullNameController = TextEditingController(text: _userName);
    _phoneController = TextEditingController(text: _userPhone);
    _passwordController = TextEditingController(text: _userPassword);

    // Load user preferences
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        _userId= prefs.getString('token')!;
        _userName = prefs.getString('name') ?? 'John Doe';
        _userPhone = prefs.getString('phoneNumber') ?? 'john.doe@example.com';
        _userPassword = prefs.getString('password') ?? '11223';

        // Update controller values after loading from SharedPreferences
        _fullNameController.text = _userName;
        _phoneController.text = _userPhone;
        _passwordController.text = _userPassword;
      });
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _fullNameController.text = _userName;
    _phoneController.text = _userPhone;
    _passwordController.text = _userPassword;
  }

  Future<void> _updateUserProfile() async {
    // Your PHP server URL
    final String baseUrl = 'https://darkgray-hummingbird-925566.hostingersite.com/yamen/users';

    // Create URL with GET parameters
    final url = Uri.parse('$baseUrl/updateUser.php'
        '?userID=$_userId'
        '&Name=${Uri.encodeComponent(_fullNameController.text)}'
        '&PhoneNumber=${Uri.encodeComponent(_phoneController.text)}'
        '&Password=${Uri.encodeComponent(_passwordController.text)}');
    print(url);

    // Make the HTTP request to your PHP backend
    final response = await http.get(url);

    // Process the response...
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      print('Form submitted with:');
      print('Full Name: ${_fullNameController.text}');
      print('Phone: ${_phoneController.text}');
      print('Password: ${_passwordController.text}');

      // Save the updated values to SharedPreferences
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', _fullNameController.text);
        await prefs.setString('phoneNumber', _phoneController.text);
        await prefs.setString('password', _passwordController.text);

        // Update the cached values
        setState(() {
          _userName = _fullNameController.text;
          _userPhone = _phoneController.text;
          _userPassword = _passwordController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        print('Error saving preferences: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile changes')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full Name Field
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 2) {
                      return 'Full name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _resetForm,
                      child: const Text('Reset'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _updateUserProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
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
}