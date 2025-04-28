import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utills/ClientConfig.dart';
import '../ManagerModels/SettingsModel.dart';
import '../ManagerModels/AdminModel.dart';
import '../Views/RegisterScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsModel settings = SettingsModel();
  bool isLoading = false;
  AdminModel? adminInfo;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAdminInfo();
  }

  Future<void> _loadSettings() async {
    setState(() {
      isLoading = true;
    });

    try {
      // First try to load settings from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? settingsJson = prefs.getString('managerSettings');

      if (settingsJson != null) {
        Map<String, dynamic> settingsMap = json.decode(settingsJson);
        setState(() {
          settings = SettingsModel.fromJson(settingsMap);
        });
      }

      // Then try to get from server to ensure latest
      final response = await http.get(
        Uri.parse('${serverPath}settings/getSettings.php'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          settings = SettingsModel.fromJson(data);
          // Save to local storage
          prefs.setString('managerSettings', json.encode(data));
        });
      }
    } catch (e) {
      // If error, keep using local settings
      print('Error loading settings: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadAdminInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? adminId = prefs.getString('adminId');

      if (adminId == null) return;

      final response = await http.get(
        Uri.parse('${serverPath}admin/getAdminInfo.php?adminId=$adminId'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          adminInfo = AdminModel.fromJson(data);
        });
      }
    } catch (e) {
      print('Error loading admin info: $e');
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Save to local storage first
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('managerSettings', json.encode(settings.toJson()));

      // Then send to server
      final response = await http.post(
        Uri.parse('${serverPath}settings/updateSettings.php'),
        body: settings.toJson(),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings to server'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving settings: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to login screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Profile Card
            if (adminInfo != null)
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
                        child: Text(
                          adminInfo!.name != null && adminInfo!.name!.isNotEmpty
                              ? adminInfo!.name![0].toUpperCase()
                              : 'A',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        adminInfo!.name ?? 'Admin User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        adminInfo!.email ?? 'No email available',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Role: ${adminInfo!.role ?? 'Administrator'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          // Navigate to edit profile
                        },
                        child: Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ),

            // App Settings
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Dark Mode'),
                      subtitle: Text('Use dark theme throughout the app'),
                      value: settings.isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          settings = settings.copyWith(isDarkMode: value);
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Notifications'),
                      subtitle: Text('Enable push notifications'),
                      value: settings.notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          settings = settings.copyWith(notificationsEnabled: value);
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Automatic Backup'),
                      subtitle: Text('Automatically backup data'),
                      value: settings.automaticBackup,
                      onChanged: (value) {
                        setState(() {
                          settings = settings.copyWith(automaticBackup: value);
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Language'),
                      subtitle: Text(settings.selectedLanguage),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _showLanguageSelector();
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Actions
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.backup),
                      title: Text('Backup Data'),
                      onTap: () {
                        // Implement backup functionality
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.restore),
                      title: Text('Restore Data'),
                      onTap: () {
                        // Implement restore functionality
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text('Help & Support'),
                      onTap: () {
                        // Navigate to help & support
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: _signOut,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Save Settings'),
              ),
            ),

            SizedBox(height: 24),

            // App Info
            Center(
              child: Column(
                children: [
                  Text(
                    'AutoCare Manager',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    final languages = ['English', 'Arabic', 'French', 'Spanish'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) =>
              RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: settings.selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  if (value != null) {
                    setState(() {
                      settings = settings.copyWith(selectedLanguage: value);
                    });
                  }
                },
              ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}