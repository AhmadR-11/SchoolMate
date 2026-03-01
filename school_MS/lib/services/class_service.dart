import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/class_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class ClassService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _localPath;
    return File('$path/classes.txt');
  }

  Future<bool> createClass(String className, String section, String teacherEmail) async {
    try {
      final file = await _file;
      
      // Check if class and section already exist
      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (var line in lines) {
          final parts = line.split(',');
          if (parts.length >= 2 && parts[0] == className && parts[1] == section) {
            return false; // Class + Section already exists
          }
        }
      }

      // Format: className,section,teacherEmail
      final classString = '$className,$section,$teacherEmail\n';
      await file.writeAsString(classString, mode: FileMode.append);
      return true;
    } catch (e) {
      print('Create Class Error: $e');
      return false;
    }
  }

  Future<List<ClassModel>> getAllClasses() async {
    try {
      final file = await _file;
      if (!(await file.exists())) {
        return [];
      }

      final lines = await file.readAsLines();
      List<ClassModel> classes = [];
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts.length >= 3) {
          classes.add(ClassModel(
            className: parts[0],
            section: parts[1],
            teacherEmail: parts[2],
          ));
        }
      }
      return classes;
    } catch (e) {
      print('Get Classes Error: $e');
      return [];
    }
  }

  Future<bool> deleteClass(String className, String section) async {
    try {
      final file = await _file;
      if (!(await file.exists())) {
        return false;
      }

      final lines = await file.readAsLines();
      List<String> updatedLines = [];
      bool deleted = false;

      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts.length >= 2 && parts[0] == className && parts[1] == section) {
          deleted = true; // Skip
        } else {
          updatedLines.add(line);
        }
      }

      if (deleted) {
        await file.writeAsString(updatedLines.join('\n') + (updatedLines.isNotEmpty ? '\n' : ''));
        return true;
      }
      return false;
    } catch (e) {
      print('Delete Class Error: $e');
      return false;
    }
  }
}
