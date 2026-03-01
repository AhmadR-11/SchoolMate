import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentProfileScreen extends StatelessWidget {
  final UserModel user;
  const StudentProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: Icon(Icons.person, size: 80),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 18,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(Icons.badge, 'Name', user.name),
            _buildInfoCard(Icons.email, 'Email', user.email),
            _buildInfoCard(Icons.school, 'Class', '10th (Demo)'),
            _buildInfoCard(Icons.grid_view, 'Section', 'A'),
            _buildInfoCard(Icons.numbers, 'Roll Number', 'SM-2024-042'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
