import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ClickTrackerApp());
}

class ClickTrackerApp extends StatefulWidget {
  @override
  _ClickTrackerAppState createState() => _ClickTrackerAppState();
}

class _ClickTrackerAppState extends State<ClickTrackerApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('darkMode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = _themeMode == ThemeMode.dark;
    await prefs.setBool('darkMode', !isDark);
    setState(() {
      _themeMode = !isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zen Click Tracker',
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: LoginScreen(onLogin: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TrackerScreen(toggleTheme: _toggleTheme),
          ),
        );
      }),
    );
  }
}
