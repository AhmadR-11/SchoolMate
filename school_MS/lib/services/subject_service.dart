import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/subject_model.dart';

class SubjectService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _localPath;
    return File('$path/subjects.txt');
  }

  Future<bool> createSubject(String subjectName, String teacherEmail, String className, String section) async {
    try {
      final file = await _file;
      
      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (var line in lines) {
          final parts = line.split(',');
          // If a subject is identically mapped to the exact teacher and exactly that class
          if (parts.length >= 4 && parts[0] == subjectName && parts[2] == className && parts[3] == section) {
            return false; 
          }
        }
      }

      final classString = '$subjectName,$teacherEmail,$className,$section\n';
      await file.writeAsString(classString, mode: FileMode.append);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<SubjectModel>> getAllSubjects() async {
    try {
      final file = await _file;
      if (!(await file.exists())) return [];

      final lines = await file.readAsLines();
      List<SubjectModel> items = [];
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts.length >= 4) {
          items.add(SubjectModel(
            subjectName: parts[0],
            teacherEmail: parts[1],
            className: parts[2],
            section: parts[3]
          ));
        }
      }
      return items;
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteSubject(String subjectName, String className) async {
    try {
      final file = await _file;
      if (!(await file.exists())) return false;

      final lines = await file.readAsLines();
      List<String> updatedLines = [];
      bool deleted = false;

      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts.length >= 3 && parts[0] == subjectName && parts[2] == className) {
          deleted = true; 
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
      return false;
    }
  }
}
