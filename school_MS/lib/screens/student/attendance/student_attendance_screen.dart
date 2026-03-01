import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentAttendanceScreen extends StatelessWidget {
  final UserModel user;
  const StudentAttendanceScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Attendance Rate', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text('92%', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.trending_up, color: Colors.white, size: 48),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildAttendanceRow('2026-03-01', 'Present'),
                  _buildAttendanceRow('2026-02-28', 'Present'),
                  _buildAttendanceRow('2026-02-27', 'Absent'),
                  _buildAttendanceRow('2026-02-26', 'Present'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRow(String date, String status) {
    return ListTile(
      title: Text(date),
      trailing: Chip(
        label: Text(status),
        backgroundColor: status == 'Present' ? Colors.green[100] : Colors.red[100],
        labelStyle: TextStyle(color: status == 'Present' ? Colors.green : Colors.red),
      ),
    );
  }
}
