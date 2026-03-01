import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../../models/assignment_model.dart';
import '../../../../services/teacher_features_service.dart';

class TeacherAssignmentsScreen extends StatefulWidget {
  final UserModel user;
  const TeacherAssignmentsScreen({super.key, required this.user});

  @override
  _TeacherAssignmentsScreenState createState() => _TeacherAssignmentsScreenState();
}

class _TeacherAssignmentsScreenState extends State<TeacherAssignmentsScreen> {
  final TeacherFeaturesService _service = TeacherFeaturesService();
  List<AssignmentModel> _assignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final data = await _service.getAssignments(widget.user.email);
    if (mounted) {
      setState(() {
        _assignments = data;
        _isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final classController = TextEditingController();
    final sectionController = TextEditingController();
    final dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Assignment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class (e.g., 10th)')),
                TextField(controller: sectionController, decoration: const InputDecoration(labelText: 'Section (e.g., A)')),
                TextField(controller: dueDateController, decoration: const InputDecoration(labelText: 'Due Date')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final model = AssignmentModel(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  className: classController.text.trim(),
                  section: sectionController.text.trim(),
                  dueDate: dueDateController.text.trim(),
                  teacherEmail: widget.user.email,
                );
                
                if (model.title.isEmpty || model.className.isEmpty) return;

                bool success = await _service.addAssignment(model);
                if (!mounted) return;
                Navigator.pop(context);
                if (success) _loadData();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(AssignmentModel oldItem) {
    final titleController = TextEditingController(text: oldItem.title);
    final descController = TextEditingController(text: oldItem.description);
    final classController = TextEditingController(text: oldItem.className);
    final sectionController = TextEditingController(text: oldItem.section);
    final dueDateController = TextEditingController(text: oldItem.dueDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Assignment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class (e.g., 10th)')),
                TextField(controller: sectionController, decoration: const InputDecoration(labelText: 'Section (e.g., A)')),
                TextField(controller: dueDateController, decoration: const InputDecoration(labelText: 'Due Date')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newItem = AssignmentModel(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                  className: classController.text.trim(),
                  section: sectionController.text.trim(),
                  dueDate: dueDateController.text.trim(),
                  teacherEmail: widget.user.email,
                );
                
                if (newItem.title.isEmpty || newItem.className.isEmpty) return;

                bool success = await _service.updateAssignment(oldItem, newItem);
                if (!mounted) return;
                Navigator.pop(context);
                if (success) _loadData();
              },
              child: const Text('Update'),
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
        title: const Text('Assignments Management'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog)
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _assignments.isEmpty
            ? const Center(child: Text('No Assignments created yet.'))
            : ListView.builder(
                itemCount: _assignments.length,
                itemBuilder: (context, index) {
                  final item = _assignments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.assignment, color: Colors.orange),
                      title: Text(item.title),
                      subtitle: Text('Class: ${item.className}-${item.section} \nDue: ${item.dueDate}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditDialog(item)),
                          IconButton(icon: const Icon(Icons.info), onPressed: () {
                            showDialog(context: context, builder: (_) => AlertDialog(
                              title: Text(item.title),
                              content: Text(item.description),
                            ));
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
