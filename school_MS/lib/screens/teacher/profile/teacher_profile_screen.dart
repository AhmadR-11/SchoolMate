import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../../models/subject_model.dart';
import '../../../../services/subject_service.dart';

class TeacherProfileScreen extends StatefulWidget {
  final UserModel user;
  const TeacherProfileScreen({super.key, required this.user});

  @override
  _TeacherProfileScreenState createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final SubjectService _subjectService = SubjectService();
  List<SubjectModel> _assignedSubjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() async {
    final allSubjects = await _subjectService.getAllSubjects();
    if (mounted) {
      setState(() {
        _assignedSubjects = allSubjects.where((sub) => sub.teacherEmail == widget.user.email).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Profile')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 40)),
                  title: Text(widget.user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  subtitle: Text(widget.user.email, style: const TextStyle(fontSize: 16)),
                ),
                const Divider(height: 32, thickness: 2),
                const Text('Assigned Subjects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: _assignedSubjects.isEmpty
                      ? const Text('No subjects currently assigned.')
                      : ListView.builder(
                          itemCount: _assignedSubjects.length,
                          itemBuilder: (context, index) {
                            final sub = _assignedSubjects[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.book, color: Colors.blue),
                                title: Text(sub.subjectName),
                                subtitle: Text('Class: ${sub.className} - ${sub.section}'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
    );
  }
}
