import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utills/ClientConfig.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  bool automaticBackup = true;
  String selectedLanguage = 'English';
  bool isLoading = false;
  Map<String, dynamic> adminInfo = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAdminInfo();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      automaticBackup = prefs.getBool('automaticBackup') ?? true;
      selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
    await prefs.setBool('notifications', notificationsEnabled);
    await prefs.setBool('automaticBackup', automaticBackup);
    await prefs.setString('language', selectedLanguage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings updated successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadAdminInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final adminId = prefs.getString('adminId');

      if (adminId == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${serverPath}admins/getAdminInfo.php?adminId=$adminId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          adminInfo = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear user data
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              // Navigate to login screen
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin profile card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.purple.shade100,
                      child: Text(
                        adminInfo['name'] != null && adminInfo['name'].toString().isNotEmpty
                            ? adminInfo['name'][0].toUpperCase()
                            : 'A',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade800,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      adminInfo['name'] ?? 'Admin User',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      adminInfo['email'] ?? 'admin@example.com',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 16),
                    OutlinedButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text('Edit Profile'),
                      onPressed: () {
                        // Navigate to profile edit screen
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            Text(
              'App Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            SizedBox(height: 16),

            // App Settings List
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Dark Mode'),
                    subtitle: Text('Switch between light and dark theme'),
                    secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                  Divider(),
                  SwitchListTile(
                    title: Text('Notifications'),
                    subtitle: Text('Enable push notifications'),
                    secondary: Icon(notificationsEnabled ? Icons.notifications_active : Icons.notifications_off),
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Language'),
                    subtitle: Text('Select your preferred language'),
                    leading: Icon(Icons.language),
                    trailing: DropdownButton<String>(
                      value: selectedLanguage,
                      underline: SizedBox(),
                      items: ['English', 'Arabic', 'Hebrew']
                          .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedLanguage = value;
                          });
                        }
                      },
                    ),
                  ),
                  Divider(),
                  SwitchListTile(
                    title: Text('Automatic Backup'),
                    subtitle: Text('Backup data daily to cloud'),
                    secondary: Icon(Icons.backup),
                    value: automaticBackup,
                    onChanged: (value) {
                      setState(() {
                        automaticBackup = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Garage Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            SizedBox(height: 16),

            // Garage Settings List
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Business Hours'),
                    subtitle: Text('Set your garage operating hours'),
                    leading: Icon(Icons.access_time),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to business hours screen
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Service Types'),
                    subtitle: Text('Manage available service types'),
                    leading: Icon(Icons.build),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to service types screen
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Manage Staff'),
                    subtitle: Text('Add or remove garage staff'),
                    leading: Icon(Icons.people),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to staff management screen
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            SizedBox(height: 16),

            // Data Management List
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Backup Data'),
                    subtitle: Text('Manually backup all data to cloud'),
                    leading: Icon(Icons.cloud_upload),
                    onTap: () {
                      // Perform manual backup
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Backup started...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Restore Data'),
                    subtitle: Text('Restore data from backup'),
                    leading: Icon(Icons.cloud_download),
                    onTap: () {
                      // Show restore options
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Export Data'),
                    subtitle: Text('Export data to CSV or Excel'),
                    leading: Icon(Icons.file_download),
                    onTap: () {
                      // Show export options
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Save and Logout Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text('Save Settings'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveSettings,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.red),
                    ),
                    onPressed: _logout,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // App Info
            Center(
              child: Column(
                children: [
                  Text(
                    'Garage Management App',
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

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}