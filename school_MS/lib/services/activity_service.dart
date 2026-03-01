import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ActivityService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _localPath;
    return File('$path/activity_log.txt');
  }

  Future<void> logAction(String email, String role, String action) async {
    try {
      final file = await _file;
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final logEntry = '[$timestamp] $role ($email): $action\n';
      
      await file.writeAsString(logEntry, mode: FileMode.append);
      print('Logged action: $logEntry');
    } catch (e) {
      print('Error logging action: $e');
    }
  }

  Future<List<String>> getLogs() async {
    try {
      final file = await _file;
      if (await file.exists()) {
        return await file.readAsLines();
      }
    } catch (e) {
      print('Error reading logs: $e');
    }
    return [];
  }

  Future<void> clearLogs() async {
    try {
      final file = await _file;
      if (await file.exists()) {
        await file.writeAsString('');
      }
    } catch (e) {
      print('Error clearing logs: $e');
    }
  }
}
