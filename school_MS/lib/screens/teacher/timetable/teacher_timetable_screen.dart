import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../../models/timetable_model.dart';
import '../../../../services/teacher_features_service.dart';

class TeacherTimetableScreen extends StatefulWidget {
  final UserModel user;
  const TeacherTimetableScreen({super.key, required this.user});

  @override
  _TeacherTimetableScreenState createState() => _TeacherTimetableScreenState();
}

class _TeacherTimetableScreenState extends State<TeacherTimetableScreen> {
  final TeacherFeaturesService _service = TeacherFeaturesService();
  List<TimetableModel> _schedule = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final data = await _service.getTimetable(widget.user.email);
    if (mounted) {
      setState(() {
        _schedule = data;
        _isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    String? day = "Monday";
    final timeController = TextEditingController();
    final subjectController = TextEditingController();
    final classController = TextEditingController();
    final sectionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Schedule Entry'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   DropdownButtonFormField<String>(
                    value: day,
                    decoration: const InputDecoration(labelText: 'Day of Week'),
                    items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => day = v),
                  ),
                  TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Time (e.g. 09:00 AM)')),
                  TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject (e.g. Math)')),
                  TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class (e.g. 10th)')),
                  TextField(controller: sectionController, decoration: const InputDecoration(labelText: 'Section (e.g. A)')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final model = TimetableModel(
                    day: day ?? 'Monday',
                    time: timeController.text.trim(),
                    subject: subjectController.text.trim(),
                    className: classController.text.trim(),
                    section: sectionController.text.trim(),
                    teacherEmail: widget.user.email,
                  );
                  
                  if (model.subject.isEmpty || model.time.isEmpty) return;

                  bool success = await _service.addTimetable(model);
                  if (!mounted) return;
                  Navigator.pop(context);
                  if (success) _loadData();
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showEditDialog(TimetableModel oldItem) {
    String? day = oldItem.day;
    final timeController = TextEditingController(text: oldItem.time);
    final subjectController = TextEditingController(text: oldItem.subject);
    final classController = TextEditingController(text: oldItem.className);
    final sectionController = TextEditingController(text: oldItem.section);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Schedule Entry'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   DropdownButtonFormField<String>(
                    value: day,
                    decoration: const InputDecoration(labelText: 'Day of Week'),
                    items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => day = v),
                  ),
                  TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Time (e.g. 09:00 AM)')),
                  TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject (e.g. Math)')),
                  TextField(controller: classController, decoration: const InputDecoration(labelText: 'Class (e.g. 10th)')),
                  TextField(controller: sectionController, decoration: const InputDecoration(labelText: 'Section (e.g. A)')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final newItem = TimetableModel(
                    day: day ?? 'Monday',
                    time: timeController.text.trim(),
                    subject: subjectController.text.trim(),
                    className: classController.text.trim(),
                    section: sectionController.text.trim(),
                    teacherEmail: widget.user.email,
                  );
                  
                  if (newItem.subject.isEmpty || newItem.time.isEmpty) return;

                  bool success = await _service.updateTimetable(oldItem, newItem);
                  if (!mounted) return;
                  Navigator.pop(context);
                  if (success) _loadData();
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timetable'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog)
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _schedule.isEmpty
            ? const Center(child: Text('No Timetable schedule found.'))
            : ListView.builder(
                itemCount: _schedule.length,
                itemBuilder: (context, index) {
                  final item = _schedule[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.schedule, color: Colors.white)),
                      title: Text('${item.subject} (${item.className}-${item.section})'),
                      subtitle: Text('${item.day} at ${item.time}'),
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
