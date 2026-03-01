import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../../models/attendance_model.dart';
import '../../../../services/teacher_features_service.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  final UserModel user;
  const TeacherAttendanceScreen({super.key, required this.user});

  @override
  _TeacherAttendanceScreenState createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final TeacherFeaturesService _service = TeacherFeaturesService();
  List<AttendanceModel> _attendance = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final data = await _service.getAttendance(widget.user.email);
    if (mounted) {
      setState(() {
        _attendance = data;
        _isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    final dateController = TextEditingController(text: DateTime.now().toLocal().toString().split(' ')[0]);
    final studentEmailController = TextEditingController();
    String? status = "Present";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Mark Attendance'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
                  TextField(controller: studentEmailController, decoration: const InputDecoration(labelText: 'Student Email')),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: ['Present', 'Absent', 'Late'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => status = v),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final model = AttendanceModel(
                    date: dateController.text.trim(),
                    studentEmail: studentEmailController.text.trim(),
                    status: status ?? 'Present',
                    teacherEmail: widget.user.email,
                  );
                  
                  if (model.studentEmail.isEmpty) return;

                  bool success = await _service.addAttendance(model);
                  if (!mounted) return;
                  Navigator.pop(context);
                  if (success) _loadData();
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showEditDialog(AttendanceModel oldItem) {
    final dateController = TextEditingController(text: oldItem.date);
    final studentEmailController = TextEditingController(text: oldItem.studentEmail);
    String? status = oldItem.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Attendance'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
                  TextField(controller: studentEmailController, decoration: const InputDecoration(labelText: 'Student Email')),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: ['Present', 'Absent', 'Late'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => status = v),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final newItem = AttendanceModel(
                    date: dateController.text.trim(),
                    studentEmail: studentEmailController.text.trim(),
                    status: status ?? 'Present',
                    teacherEmail: widget.user.email,
                  );
                  
                  if (newItem.studentEmail.isEmpty) return;

                  bool success = await _service.updateAttendance(oldItem, newItem);
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
        title: const Text('Attendance Management'),
        actions: [
          IconButton(icon: const Icon(Icons.add_task), onPressed: _showAddDialog, tooltip: 'Mark Attendance')
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _attendance.isEmpty
            ? const Center(child: Text('No attendance records marked yet.'))
            : ListView.builder(
                itemCount: _attendance.length,
                itemBuilder: (context, index) {
                  final item = _attendance[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        item.status == 'Present' ? Icons.check_circle : (item.status == 'Late' ? Icons.access_time_filled : Icons.cancel), 
                        color: item.status == 'Present' ? Colors.green : (item.status == 'Late' ? Colors.orange : Colors.red)
                      ),
                      title: Text(item.studentEmail),
                      subtitle: Text('Date: ${item.date} \nStatus: ${item.status}'),
                      trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditDialog(item)),
                    ),
                  );
                },
              ),
    );
  }
}
