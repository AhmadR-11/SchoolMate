import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';
import '../teacher/profile/teacher_profile_screen.dart';
import '../teacher/attendance/teacher_attendance_screen.dart';
import '../teacher/assignments/teacher_assignments_screen.dart';
import '../teacher/results/teacher_results_screen.dart';
import '../teacher/timetable/teacher_timetable_screen.dart';
import '../teacher/notices/teacher_notices_screen.dart';

class TeacherDashboard extends StatelessWidget {
  final UserModel user;
  const TeacherDashboard({super.key, required this.user});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Welcome, ${user.name}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            _buildActionCard(
              context,
              title: 'Profile',
              subtitle: 'View Profile & Subjects',
              icon: Icons.person,
              color: Colors.blue,
              destination: TeacherProfileScreen(user: user),
            ),
            _buildActionCard(
              context,
              title: 'Attendance Management',
              subtitle: 'Mark & Edit Attendance',
              icon: Icons.check_circle,
              color: Colors.teal,
              destination: TeacherAttendanceScreen(user: user),
            ),
            _buildActionCard(
              context,
              title: 'Assignments',
              subtitle: 'Create & Grade Assignments',
              icon: Icons.assignment,
              color: Colors.orange,
              destination: TeacherAssignmentsScreen(user: user),
            ),
            _buildActionCard(
              context,
              title: 'Results',
              subtitle: 'Add Exam Marks & Publish',
              icon: Icons.assessment,
              color: Colors.redAccent,
              destination: TeacherResultsScreen(user: user),
            ),
            _buildActionCard(
              context,
              title: 'Timetable',
              subtitle: 'View own Timetable',
              icon: Icons.schedule,
              color: Colors.purple,
              destination: TeacherTimetableScreen(user: user),
            ),
            _buildActionCard(
              context,
              title: 'Notices',
              subtitle: 'Post Class Notices',
              icon: Icons.notifications,
              color: Colors.amber,
              destination: TeacherNoticesScreen(user: user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required Widget destination}) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Icon(icon, size: 40, color: color),
            title: Text(title, style: const TextStyle(fontSize: 20)),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
