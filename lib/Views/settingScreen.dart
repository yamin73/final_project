import 'package:flutter/material.dart';
import 'editProfileScreen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSection(
            'Profile Settings',
            [
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text('Edit Profile'),
                subtitle: const Text('Change your personal information'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                  // Navigate to profile edit screen
                },
              ),
            ],
          ),

          // Preferences Section
          _buildSection(
            'Preferences',
            [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive booking updates and offers'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Location Services'),
                subtitle: const Text('Enable location-based services'),
                value: _locationEnabled,
                onChanged: (value) {
                  setState(() {
                    _locationEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch to dark theme'),
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
            ],
          ),

          // Language and Region
          _buildSection(
            'Language & Region',
            [
              ListTile(
                title: const Text('Language'),
                subtitle: Text(_selectedLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showLanguageSelector(),
              ),
              ListTile(
                title: const Text('Currency'),
                subtitle: Text(_selectedCurrency),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showCurrencySelector(),
              ),
            ],
          ),

          // Payment Section
          _buildSection(
            'Payment',
            [
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Payment Methods'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to payment methods screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Booking History'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to booking history screen
                },
              ),
            ],
          ),

          // Support Section
          _buildSection(
            'Support',
            [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help Center'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to help center
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to privacy policy
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to terms of service
                },
              ),
            ],
          ),

          // App Info
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  void _showLanguageSelector() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    _showSelector('Select Language', languages, _selectedLanguage,
            (String value) {
          setState(() {
            _selectedLanguage = value;
          });
        });
  }

  void _showCurrencySelector() {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CNY'];
    _showSelector('Select Currency', currencies, _selectedCurrency,
            (String value) {
          setState(() {
            _selectedCurrency = value;
          });
        });
  }

  void _showSelector(String title, List<String> options, String selectedValue,
      Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((option) => ListTile(
                title: Text(option),
                trailing: selectedValue == option
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }
}