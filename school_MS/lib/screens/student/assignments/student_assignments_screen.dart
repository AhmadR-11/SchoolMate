import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentAssignmentsScreen extends StatelessWidget {
  final UserModel user;
  const StudentAssignmentsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAssignmentCard(context, 'Calculus HW #1', '2026-03-05', 'Pending'),
          _buildAssignmentCard(context, 'Physics Lab Report', '2026-02-28', 'Submitted'),
          _buildAssignmentCard(context, 'English Essay', '2026-03-10', 'Pending'),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, String title, String due, String status) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('Due: $due'),
        trailing: Text(status, style: TextStyle(color: status == 'Pending' ? Colors.orange : Colors.green)),
        onTap: () {
          _showSubmitSheet(context, title);
        },
      ),
    );
  }

  void _showSubmitSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Submit $title', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File / Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Submit Assignment'),
            ),
          ],
        ),
      ),
    );
  }
}
