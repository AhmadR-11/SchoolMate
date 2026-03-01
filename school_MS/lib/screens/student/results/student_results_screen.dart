import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentResultsScreen extends StatelessWidget {
  final UserModel user;
  const StudentResultsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results & Grades')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.redAccent,
              child: Text('3.8', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const Text('Current GPA', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 30),
            _buildResultTile('Mathematics', '92/100', 'A'),
            _buildResultTile('Physics', '85/100', 'B+'),
            _buildResultTile('Computer Science', '95/100', 'A+'),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile(String subject, String marks, String grade) {
    return Card(
      child: ListTile(
        title: Text(subject),
        subtitle: Text('Marks: $marks'),
        trailing: Text(grade, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
      ),
    );
  }
}
