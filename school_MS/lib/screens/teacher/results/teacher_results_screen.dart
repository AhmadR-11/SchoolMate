import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../../models/result_model.dart';
import '../../../../services/teacher_features_service.dart';

class TeacherResultsScreen extends StatefulWidget {
  final UserModel user;
  const TeacherResultsScreen({super.key, required this.user});

  @override
  _TeacherResultsScreenState createState() => _TeacherResultsScreenState();
}

class _TeacherResultsScreenState extends State<TeacherResultsScreen> {
  final TeacherFeaturesService _service = TeacherFeaturesService();
  List<ResultModel> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final data = await _service.getResults(widget.user.email);
    if (mounted) {
      setState(() {
        _results = data;
        _isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    final examController = TextEditingController();
    final studentEmailController = TextEditingController();
    final subjectController = TextEditingController();
    final marksController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exam Result'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: examController, decoration: const InputDecoration(labelText: 'Exam Name (e.g. Midterm)')),
                TextField(controller: studentEmailController, decoration: const InputDecoration(labelText: 'Student Email')),
                TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject Name')),
                TextField(controller: marksController, decoration: const InputDecoration(labelText: 'Marks Obtained (e.g. 85/100)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final model = ResultModel(
                  examName: examController.text.trim(),
                  studentEmail: studentEmailController.text.trim(),
                  subject: subjectController.text.trim(),
                  marks: marksController.text.trim(),
                  teacherEmail: widget.user.email,
                );
                
                if (model.examName.isEmpty || model.studentEmail.isEmpty) return;

                bool success = await _service.addResult(model);
                if (!mounted) return;
                Navigator.pop(context);
                if (success) _loadData();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(ResultModel oldItem) {
    final examController = TextEditingController(text: oldItem.examName);
    final studentEmailController = TextEditingController(text: oldItem.studentEmail);
    final subjectController = TextEditingController(text: oldItem.subject);
    final marksController = TextEditingController(text: oldItem.marks);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Exam Result'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: examController, decoration: const InputDecoration(labelText: 'Exam Name (e.g. Midterm)')),
                TextField(controller: studentEmailController, decoration: const InputDecoration(labelText: 'Student Email')),
                TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject Name')),
                TextField(controller: marksController, decoration: const InputDecoration(labelText: 'Marks Obtained (e.g. 85/100)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newItem = ResultModel(
                  examName: examController.text.trim(),
                  studentEmail: studentEmailController.text.trim(),
                  subject: subjectController.text.trim(),
                  marks: marksController.text.trim(),
                  teacherEmail: widget.user.email,
                );
                
                if (newItem.examName.isEmpty || newItem.studentEmail.isEmpty) return;

                bool success = await _service.updateResult(oldItem, newItem);
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
        title: const Text('Exam & Results'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog)
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _results.isEmpty
            ? const Center(child: Text('No Results added yet.'))
            : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.assessment, color: Colors.redAccent),
                      title: Text('${item.subject} - ${item.examName}'),
                      subtitle: Text('Student: ${item.studentEmail} \nMarks: ${item.marks}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(item),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
