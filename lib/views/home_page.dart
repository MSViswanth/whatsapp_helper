import 'package:flutter/material.dart';
import 'package:whatsapp_helper/views/history_screen.dart';
import 'package:whatsapp_helper/views/home_screen.dart';
import 'package:whatsapp_helper/views/settings_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;

  List _children = [
    HomeScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  _onTap(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _currentTab,
        onTap: _onTap,
      ),
      body: _children[_currentTab],
    );
  }
}
