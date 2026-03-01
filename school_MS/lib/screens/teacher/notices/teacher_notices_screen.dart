import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../../models/notice_model.dart';
import '../../../../services/teacher_features_service.dart';

class TeacherNoticesScreen extends StatefulWidget {
  final UserModel user;
  const TeacherNoticesScreen({super.key, required this.user});

  @override
  _TeacherNoticesScreenState createState() => _TeacherNoticesScreenState();
}

class _TeacherNoticesScreenState extends State<TeacherNoticesScreen> {
  final TeacherFeaturesService _service = TeacherFeaturesService();
  List<NoticeModel> _notices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final data = await _service.getNotices(widget.user.email);
    if (mounted) {
      setState(() {
        _notices = data;
        _isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toLocal().toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Post Notice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: 3),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final model = NoticeModel(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  date: dateController.text.trim(),
                  teacherEmail: widget.user.email,
                );
                
                if (model.title.isEmpty || model.content.isEmpty) return;

                bool success = await _service.addNotice(model);
                if (!mounted) return;
                Navigator.pop(context);
                if (success) _loadData();
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(NoticeModel oldItem) {
    final titleController = TextEditingController(text: oldItem.title);
    final contentController = TextEditingController(text: oldItem.content);
    final dateController = TextEditingController(text: oldItem.date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Notice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: 3),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newItem = NoticeModel(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  date: dateController.text.trim(),
                  teacherEmail: widget.user.email,
                );
                
                if (newItem.title.isEmpty || newItem.content.isEmpty) return;

                bool success = await _service.updateNotice(oldItem, newItem);
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
        title: const Text('Notices'),
        actions: [
          IconButton(icon: const Icon(Icons.add_comment), onPressed: _showAddDialog)
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _notices.isEmpty
            ? const Center(child: Text('No Notices posted yet.'))
            : ListView.builder(
                itemCount: _notices.length,
                itemBuilder: (context, index) {
                  final item = _notices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.notifications, color: Colors.white)),
                      title: Text(item.title),
                      subtitle: Text('${item.date}\n${item.content}'),
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
