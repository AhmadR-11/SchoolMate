import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentSubjectsScreen extends StatelessWidget {
  final UserModel user;
  const StudentSubjectsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects & Teachers')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSubjectTile('Mathematics', 'Sir Ahmad', Colors.blue),
          _buildSubjectTile('Physics', 'Miss Sara', Colors.orange),
          _buildSubjectTile('Computer Science', 'Sir Khalid', Colors.purple),
          _buildSubjectTile('English', 'Miss Maria', Colors.green),
        ],
      ),
    );
  }

  Widget _buildSubjectTile(String subject, String teacher, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: const Icon(Icons.book, color: Colors.white)),
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Teacher: $teacher'),
        trailing: const Icon(Icons.info_outline),
      ),
    );
  }
}
