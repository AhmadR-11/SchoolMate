import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentNoticesScreen extends StatelessWidget {
  final UserModel user;
  const StudentNoticesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notices')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNoticeCard('Annual Sports Meet', '2026-03-10', 'School', 'The annual sports meet will be held on the school grounds...'),
          _buildNoticeCard('Math Extra Class', '2026-03-02', 'Class', 'Reminder: Math extra class tomorrow at 02:00 PM for Section A.'),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(String title, String date, String category, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(category), backgroundColor: category == 'School' ? Colors.blue[100] : Colors.amber[100]),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
