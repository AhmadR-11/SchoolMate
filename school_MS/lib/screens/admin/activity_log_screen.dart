import 'package:flutter/material.dart';
import '../../services/activity_service.dart';

class ActivityLogScreen extends StatefulWidget {
  @override
  _ActivityLogScreenState createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final ActivityService _activityService = ActivityService();
  List<String> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    final logs = await _activityService.getLogs();
    setState(() {
      _logs = logs.reversed.toList(); // Newest first
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () async {
              await _activityService.clearLogs();
              _loadLogs();
            },
            tooltip: 'Clear Logs',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadLogs,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? Center(child: Text('No activity recorded yet.'))
              : ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: _logs.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return Text(
                      _logs[index],
                      style: TextStyle(fontFamily: 'monospace', fontSize: 13),
                    );
                  },
                ),
    );
  }
}
