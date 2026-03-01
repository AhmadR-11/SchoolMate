import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';
import '../student/profile/student_profile_screen.dart';
import '../student/attendance/student_attendance_screen.dart';
import '../student/subjects/student_subjects_screen.dart';
import '../student/assignments/student_assignments_screen.dart';
import '../student/results/student_results_screen.dart';
import '../student/timetable/student_timetable_screen.dart';
import '../student/notices/student_notices_screen.dart';
import '../student/fees/student_fees_screen.dart';

class StudentDashboard extends StatelessWidget {
  final UserModel user;
  const StudentDashboard({super.key, required this.user});

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
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  const Chip(
                    label: Text('Student'),
                    backgroundColor: Colors.blueAccent,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildActionCard(
            context,
            title: 'My Profile',
            subtitle: 'View class, section & details',
            icon: Icons.account_box,
            color: Colors.blue,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentProfileScreen(user: user)));
            },
          ),
          _buildActionCard(
            context,
            title: 'Attendance',
            subtitle: 'View daily & monthly reports',
            icon: Icons.calendar_month,
            color: Colors.green,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentAttendanceScreen(user: user)));
            },
          ),
          _buildActionCard(
            context,
            title: 'Subjects & Teachers',
            subtitle: 'View enrolled modules',
            icon: Icons.menu_book,
            color: Colors.orange,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentSubjectsScreen(user: user)));
            },
          ),
          _buildActionCard(
            context,
            title: 'Assignments',
            subtitle: 'Check & submit work',
            icon: Icons.assignment_turned_in,
            color: Colors.purple,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentAssignmentsScreen(user: user)));
            },
          ),
          _buildActionCard(
            context,
            title: 'Results & Grades',
            subtitle: 'View marks & GPA',
            icon: Icons.assessment,
            color: Colors.red,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentResultsScreen(user: user)));
            },
          ),
          _buildActionCard(
            context,
            title: 'Timetable',
            subtitle: 'Daily & weekly schedule',
            icon: Icons.schedule,
            color: Colors.teal,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentTimetableScreen(user: user)));
            },
          ),
          _buildActionCard(
            context,
            title: 'Notices',
            subtitle: 'School & class updates',
            icon: Icons.notifications_active,
            color: Colors.amber[800]!,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentNoticesScreen(user: user)));
            },
          ),
          _buildActionCard(
            context,
            title: 'Fees Management',
            subtitle: 'Balance & history',
            icon: Icons.payments,
            color: Colors.indigo,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StudentFeesScreen(user: user)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
