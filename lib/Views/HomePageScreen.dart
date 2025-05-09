import 'package:final_project/Utills/DB.dart';
import 'package:final_project/Utills/Utills.dart';
import 'package:final_project/Views/CarScreen.dart';
import 'package:flutter/material.dart';
import 'BookingScreen.dart';
import 'homeView.dart';
import 'HistoryScreen.dart';
import 'BookingScreen.dart';
import 'settingScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _selectedIndex = 0;

  // Pages to be shown when navigation items are tapped
  final List<Widget> _pages = <Widget>[
    HomePages(),
    BookingScreen(),
    BookingHistoryScreen(),
    SettingsPage(),
  ];

  final List<String> _titles = [
    'Home',
    'Book',
    'History',
    'Settings',
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_today_rounded,
    Icons.history_rounded,
    Icons.settings_rounded,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            items: List.generate(
              _icons.length,
                  (index) => BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Icon(_icons[index]),
                ),
                label: _titles[index],
              ),
            ),
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF2563EB), // Blue-600
            unselectedItemColor: Color(0xFF9CA3AF), // Gray-400
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
          ),
        ),
      ),
      // Floating action button for quick booking
    /*  floatingActionButton: _selectedIndex != 1 ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = 1; // Navigate to Booking screen
          });
        },
       /* backgroundColor: Color(0xFF2563EB), // Blue-600
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),*/
        elevation: 4,
      ) : null,*/
    );
  }
}