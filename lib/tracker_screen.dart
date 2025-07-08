import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  TrackerScreen({required this.toggleTheme});

  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  int count = 0;
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      count = prefs.getInt('count') ?? 0;
      logs = prefs.getStringList('logs') ?? [];
    });
  }

  void _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('count', count);
    await prefs.setStringList('logs', logs);
  }

  void _increment() {
    setState(() {
      count++;
      logs.add("Clicked at ${DateTime.now().toString()}");
    });
    _saveState();
  }

  void _clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      count = 0;
      logs.clear();
    });
    await prefs.remove('count');
    await prefs.remove('logs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zen Click Tracker'),
        actions: [
          IconButton(onPressed: widget.toggleTheme, icon: Icon(Icons.brightness_6)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Count: $count', style: TextStyle(fontSize: 24)),
            ElevatedButton(onPressed: _increment, child: Text('Increase Count')),
            ElevatedButton(onPressed: _clearLogs, child: Text('Clear Logs')),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (_, i) => ListTile(title: Text(logs[logs.length - 1 - i])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
