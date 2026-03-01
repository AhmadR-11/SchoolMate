import 'package:flutter/material.dart';
import 'package:school_ms/models/user_model.dart';
import 'package:school_ms/services/activity_service.dart';
import '../admin/class_management/manage_classes_screen.dart';
import '../admin/user_management/manage_users_screen.dart';
import '../admin/subject_management/manage_subjects_screen.dart';
import '../admin/attendance_control/attendance_control_screen.dart';
import '../admin/exam_results/exam_results_screen.dart';
import '../admin/fees_management/fees_management_screen.dart';
import '../admin/system_settings/system_settings_screen.dart';
import '../admin/activity_log_screen.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatelessWidget {
  final UserModel? user;
  const AdminDashboard({super.key, this.user});

  void _logout(BuildContext context) {
    ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Logged out');
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
        title: const Text('Admin Dashboard'),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Welcome, Admin!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people, size: 40, color: Colors.blue),
                title: const Text('Manage Students', style: TextStyle(fontSize: 20)),
                subtitle: const Text('Add, View, or Block Students'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to Manage Students');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageUsersScreen(role: 'student', admin: user),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, size: 40, color: Colors.orange),
                title: const Text('Manage Teachers', style: TextStyle(fontSize: 20)),
                subtitle: const Text('Add, View, or Block Teachers'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to Manage Teachers');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageUsersScreen(role: 'teacher', admin: user),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.class_, size: 40, color: Colors.green),
                title: const Text('Manage Classes', style: TextStyle(fontSize: 20)),
                subtitle: const Text('Create Classes & Assign Teachers'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to Manage Classes');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageClassesScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book, size: 40, color: Colors.purple),
                title: const Text('Subject Management', style: TextStyle(fontSize: 20)),
                subtitle: const Text('Add & Assign Subjects'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to Subject Management');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageSubjectsScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle, size: 40, color: Colors.teal),
                title: const Text('Attendance Control', style: TextStyle(fontSize: 20)),
                subtitle: const Text('View full attendance & edit records'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to Attendance Control');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceControlScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.assessment, size: 40, color: Colors.redAccent),
                title: const Text('Exam & Results', style: TextStyle(fontSize: 20)),
                subtitle: const Text('Create exams & track results'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to Exam & Results');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamResultsScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.monetization_on, size: 40, color: Colors.amber),
                title: const Text('Fees Management', style: TextStyle(fontSize: 20)),
                subtitle: const Text('Define fee structure & track payments'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to Fees Management');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FeesManagementScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings, size: 40, color: Colors.grey),
                title: const Text('System Settings', style: TextStyle(fontSize: 20)),
                subtitle: const Text('Manage Academic year & School info'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ActivityService().logAction(user?.email ?? 'Unknown', 'admin', 'Navigated to System Settings');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SystemSettingsScreen()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history, size: 40, color: Colors.blueGrey),
                title: const Text('Activity Log', style: TextStyle(fontSize: 20)),
                subtitle: const Text('View system-wide actions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityLogScreen()));
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
