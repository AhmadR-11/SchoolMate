import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentFeesScreen extends StatelessWidget {
  final UserModel user;
  const StudentFeesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fees Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              color: Colors.indigo,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('Total Pending', style: TextStyle(color: Colors.white70)),
                    Text('Rs. 5,500', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Academic Year: 2023-2024', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildFeeTile('Admission Fee', 'Rs. 2,000', 'Paid', Colors.green),
                  _buildFeeTile('March Tuition', 'Rs. 3,500', 'Pending', Colors.red),
                  _buildFeeTile('Feb Tuition', 'Rs. 3,500', 'Paid', Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeTile(String title, String amount, String status, Color color) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(amount),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
