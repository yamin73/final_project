import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RegisterScreen.dart';
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
  bool _biometricEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';
  String _userName = 'yamin';
  String _userPhone = '0584309774';

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        _notificationsEnabled = prefs.getBool('notifications') ?? true;
        _locationEnabled = prefs.getBool('location') ?? true;
        _darkModeEnabled = prefs.getBool('darkMode') ?? false;
        _biometricEnabled = prefs.getBool('biometric') ?? false;
        _selectedLanguage = prefs.getString('language') ?? 'English';
        _selectedCurrency = prefs.getString('currency') ?? 'USD';
        _userName = prefs.getString('name') ?? 'John Doe';
        _userPhone = prefs.getString('phoneNumber') ?? '0584309774';
      });
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  Future<void> _savePreference(String key, dynamic value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }

      // Show save confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Settings saved'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      print('Error saving preference: $e');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save settings'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade800, Colors.blue],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    top: -20,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -50,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile card
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _buildProfileCard(),
            ),
          ),

          // Settings sections
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle('Preferences'),
              _buildPreferencesSection(),

              _buildSectionTitle('Language & Region'),
              _buildLanguageSection(),

              _buildSectionTitle('Payment & History'),
              _buildPaymentSection(),

              _buildSectionTitle('Security'),
              _buildSecuritySection(),

              _buildSectionTitle('Support'),
              _buildSupportSection(),

              _buildSectionTitle('About'),
              _buildAboutSection(),

              // Logout button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle logout
                    _showLogoutConfirmation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Version info
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.shade100,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _userPhone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive booking updates and offers',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _savePreference('notifications', value);
            },
            icon: Icons.notifications,
          ),
          _buildDivider(),
          _buildSwitchTile(
            title: 'Location Services',
            subtitle: 'Enable location-based services',
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
              _savePreference('location', value);
            },
            icon: Icons.location_on,
          ),
          _buildDivider(),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              _savePreference('darkMode', value);
            },
            icon: Icons.dark_mode,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTapTile(
            title: 'Language',
            subtitle: _selectedLanguage,
            onTap: () => _showLanguageSelector(),
            icon: Icons.language,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Currency',
            subtitle: _selectedCurrency,
            onTap: () => _showCurrencySelector(),
            icon: Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTapTile(
            title: 'Payment Methods',
            subtitle: 'Add or edit payment methods',
            onTap: () {
              // Navigate to payment methods screen
            },
            icon: Icons.credit_card,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Booking History',
            subtitle: 'View your past bookings',
            onTap: () {
              // Navigate to booking history screen
            },
            icon: Icons.history,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Invoices',
            subtitle: 'View and download invoices',
            onTap: () {
              // Navigate to invoices screen
            },
            icon: Icons.receipt_long,
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTapTile(
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              // Navigate to change password screen
            },
            icon: Icons.lock,
          ),
          _buildDivider(),
          _buildSwitchTile(
            title: 'Biometric Login',
            subtitle: 'Use fingerprint or face ID',
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() {
                _biometricEnabled = value;
              });
              _savePreference('biometric', value);
            },
            icon: Icons.fingerprint,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Privacy Settings',
            subtitle: 'Manage your data',
            onTap: () {
              // Navigate to privacy settings
            },
            icon: Icons.privacy_tip,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTapTile(
            title: 'Help Center',
            subtitle: 'Get answers to common questions',
            onTap: () {
              // Navigate to help center
            },
            icon: Icons.help_outline,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Contact Support',
            subtitle: 'Get in touch with our team',
            onTap: () {
              // Navigate to contact support
            },
            icon: Icons.support_agent,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Report an Issue',
            subtitle: 'Let us know if something isn\'t working',
            onTap: () {
              // Navigate to report issue
            },
            icon: Icons.bug_report,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTapTile(
            title: 'About Us',
            subtitle: 'Learn more about AutoCare',
            onTap: () {
              // Navigate to about us
            },
            icon: Icons.info,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: () {
              // Navigate to terms of service
            },
            icon: Icons.description,
          ),
          _buildDivider(),
          _buildTapTile(
            title: 'Privacy Policy',
            subtitle: 'Learn how we handle your data',
            onTap: () {
              // Navigate to privacy policy
            },
            icon: Icons.policy,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.blue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildTapTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.blue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      endIndent: 0,
      color: Colors.grey.shade100,
    );
  }

  void _showLanguageSelector() {
    final languages = ['English', 'Arabic', 'Spanish', 'French', 'German', 'Chinese'];
    _showSelector('Select Language', languages, _selectedLanguage, (String value) {
      setState(() {
        _selectedLanguage = value;
      });
      _savePreference('language', value);
    });
  }

  void _showCurrencySelector() {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CNY', 'AED'];
    _showSelector('Select Currency', currencies, _selectedCurrency, (String value) {
      setState(() {
        _selectedCurrency = value;
      });
      _savePreference('currency', value);
    });
  }

  void _showSelector(
      String title,
      List<String> options,
      String selectedValue,
      Function(String) onSelect
      ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = selectedValue == option;

                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : Colors.grey.shade800,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Colors.blue)
                          : null,
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle logout logic here
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => RegisterPage()));
                // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}