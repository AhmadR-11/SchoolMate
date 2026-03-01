import 'package:flutter/material.dart';
import '../../../models/class_model.dart';
import '../../../models/user_model.dart';
import '../../../services/class_service.dart';
import '../../../services/auth_service.dart';

class ManageClassesScreen extends StatefulWidget {
  const ManageClassesScreen({super.key});

  @override
  _ManageClassesScreenState createState() => _ManageClassesScreenState();
}

class _ManageClassesScreenState extends State<ManageClassesScreen> {
  final ClassService _classService = ClassService();
  final AuthService _authService = AuthService();
  
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
    final classes = await _classService.getAllClasses();
    final teachers = await _authService.getAllUsers('teacher');
    
    if (mounted) {
      setState(() {
        _classes = classes;
        _teachers = teachers;
        _isLoading = false;
      });
    }
  }

  void _showAddClassDialog() {
    if (_teachers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add teachers first before creating a class.')),
      );
      return;
    }

    final classController = TextEditingController();
    final sectionController = TextEditingController();
    String? selectedTeacherEmail = _teachers.first.email;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Create Class'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: classController,
                      decoration: const InputDecoration(labelText: 'Class Name (e.g., 10th)'),
                    ),
                    TextField(
                      controller: sectionController,
                      decoration: const InputDecoration(labelText: 'Section (e.g., A)'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedTeacherEmail,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Assign Class Teacher',
                        border: OutlineInputBorder(),
                      ),
                      items: _teachers.map((teacher) {
                        return DropdownMenuItem<String>(
                          value: teacher.email,
                          child: Text('${teacher.name} (${teacher.email})', overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          selectedTeacherEmail = newValue;
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
                    final className = classController.text.trim();
                    final section = sectionController.text.trim();

                    if (className.isEmpty || section.isEmpty || selectedTeacherEmail == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fill all fields')));
                      return;
                    }

                    final success = await _classService.createClass(className, section, selectedTeacherEmail!);
                    if (!mounted) return;
                    Navigator.pop(context);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Class added successfully')));
                      _loadData(); // refresh list
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add. Class/Section might already exist.')));
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(String className, String section) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Class'),
          content: Text('Are you sure you want to delete class $className section $section?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await _classService.deleteClass(className, section);
                if (mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Class deleted')));
                    _loadData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete class')));
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
        title: const Text('Manage Classes & Sections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddClassDialog,
            tooltip: 'Add Class',
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _classes.isEmpty
              ? const Center(child: Text('No Classes found.'))
              : ListView.builder(
                  itemCount: _classes.length,
                  itemBuilder: (context, index) {
                    final cls = _classes[index];
                    
                    // Find teacher name
                    final teacher = _teachers.firstWhere(
                      (t) => t.email == cls.teacherEmail, 
                      orElse: () => UserModel(name: 'Unknown or Deleted', email: cls.teacherEmail, role: 'teacher')
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(cls.section),
                        ),
                        title: Text('Class ${cls.className}'),
                        subtitle: Text('Teacher: ${teacher.name}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(cls.className, cls.section),
                          tooltip: 'Delete Class',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
