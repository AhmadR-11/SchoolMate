import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class StudentTimetableScreen extends StatelessWidget {
  final UserModel user;
  const StudentTimetableScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Timetable'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDayList(),
            _buildDayList(),
            _buildDayList(),
            _buildDayList(),
            _buildDayList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSlot('08:00 AM', 'Mathematics', 'Room 101'),
        _buildSlot('09:00 AM', 'Physics', 'Lab A'),
        _buildSlot('10:00 AM', 'Break', ''),
        _buildSlot('11:00 AM', 'Computer Science', 'Room 204'),
      ],
    );
  }

  Widget _buildSlot(String time, String subject, String room) {
    return Card(
      child: ListTile(
        leading: Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
        title: Text(subject),
        subtitle: room.isNotEmpty ? Text(room) : null,
      ),
    );
  }
}
