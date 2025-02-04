import 'package:final_project/Utills/DB.dart';
import 'package:final_project/Utills/Utills.dart';
import 'package:final_project/Views/CarScreen.dart';
import 'package:flutter/material.dart';
import 'BookingScreen.dart';
import 'homeView.dart';
import 'HistoryScreen.dart';
import 'BookingScreen.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _selectedIndex = 0;

  // Pages to be shown when navigation items are tapped
  static List<Widget> _pages = <Widget>[
    HomePages(),
    BookingScreen(),
    BookingHistoryScreen(),
    Center(child: Text('Settings Page', style: TextStyle(fontSize: 24))),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'history',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Required when more than 3 items
        backgroundColor: Colors.white,
        elevation: 8,
        showUnselectedLabels: true,
      ),
    );
  }
}