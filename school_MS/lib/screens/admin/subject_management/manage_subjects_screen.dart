import 'package:flutter/material.dart';
import '../../../models/subject_model.dart';
import '../../../models/class_model.dart';
import '../../../models/user_model.dart';
import '../../../services/subject_service.dart';
import '../../../services/class_service.dart';
import '../../../services/auth_service.dart';

class ManageSubjectsScreen extends StatefulWidget {
  const ManageSubjectsScreen({super.key});

  @override
  _ManageSubjectsScreenState createState() => _ManageSubjectsScreenState();
}

class _ManageSubjectsScreenState extends State<ManageSubjectsScreen> {
  final SubjectService _subjectService = SubjectService();
  final ClassService _classService = ClassService();
  final AuthService _authService = AuthService();
  
  List<SubjectModel> _subjects = [];
  List<ClassModel> _classes = [];
  List<UserModel> _teachers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final subjects = await _subjectService.getAllSubjects();
    final classes = await _classService.getAllClasses();
    final teachers = await _authService.getAllUsers('teacher');
    
    if (mounted) {
      setState(() {
        _subjects = subjects;
        _classes = classes;
        _teachers = teachers;
        _isLoading = false;
      });
    }
  }

  void _showAddSubjectDialog() {
    if (_teachers.isEmpty || _classes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one teacher and one class first.')),
      );
      return;
    }

    final subjectController = TextEditingController();
    String? selectedTeacherEmail = _teachers.first.email;
    String? selectedClassString = '${_classes.first.className}-${_classes.first.section}';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add Subject'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(labelText: 'Subject Name'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedTeacherEmail,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Assign to Teacher',
                        border: OutlineInputBorder(),
                      ),
                      items: _teachers.map((teacher) {
                        return DropdownMenuItem<String>(
                          value: teacher.email,
                          child: Text('${teacher.name}', overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          selectedTeacherEmail = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedClassString,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Assign to Class',
                        border: OutlineInputBorder(),
                      ),
                      items: _classes.map((cls) {
                        final val = '${cls.className}-${cls.section}';
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text('Class ${cls.className} - ${cls.section}', overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          selectedClassString = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final subjectName = subjectController.text.trim();

                    if (subjectName.isEmpty || selectedTeacherEmail == null || selectedClassString == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fill all fields')));
                      return;
                    }

                    final parts = selectedClassString!.split('-');
                    final className = parts[0];
                    final section = parts[1];

                    final success = await _subjectService.createSubject(subjectName, selectedTeacherEmail!, className, section);
                    if (!mounted) return;
                    Navigator.pop(context);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Subject added successfully')));
                      _loadData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add. Might already exist.')));
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(String subjectName, String className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Subject'),
          content: Text('Are you sure you want to delete $subjectName for $className?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await _subjectService.deleteSubject(subjectName, className);
                if (mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subject deleted')));
                    _loadData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete subject')));
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddSubjectDialog,
            tooltip: 'Add Subject',
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subjects.isEmpty
              ? const Center(child: Text('No subjects added.'))
              : ListView.builder(
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final item = _subjects[index];
                    final teacher = _teachers.firstWhere((t) => t.email == item.teacherEmail, orElse: () => UserModel(name: 'Unknown', email: '', role: ''));

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(item.subjectName[0].toUpperCase())),
                        title: Text('${item.subjectName} (Class ${item.className}-${item.section})'),
                        subtitle: Text('Taught by: ${teacher.name}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(item.subjectName, item.className),
                          tooltip: 'Delete Subject',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
