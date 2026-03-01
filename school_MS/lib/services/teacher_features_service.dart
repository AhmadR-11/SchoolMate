import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'activity_service.dart';
import '../models/assignment_model.dart';
import '../models/result_model.dart';
import '../models/attendance_model.dart';
import '../models/timetable_model.dart';
import '../models/notice_model.dart';

class TeacherFeaturesService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // --- Assignments ---
  Future<List<AssignmentModel>> getAssignments(String teacherEmail) async {
    final path = await _localPath;
    final file = File('$path/assignments.txt');
    if (!(await file.exists())) return [];
    
    final lines = await file.readAsLines();
    List<AssignmentModel> list = [];
    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length >= 6 && parts[5] == teacherEmail) {
        list.add(AssignmentModel(title: parts[0], description: parts[1], className: parts[2], section: parts[3], dueDate: parts[4], teacherEmail: parts[5]));
      }
    }
    return list;
  }

  Future<bool> addAssignment(AssignmentModel item) async {
    try {
      final path = await _localPath;
      final file = File('$path/assignments.txt');
      await file.writeAsString('${item.title},${item.description},${item.className},${item.section},${item.dueDate},${item.teacherEmail}\n', mode: FileMode.append);
      await ActivityService().logAction(item.teacherEmail, 'teacher', 'Added assignment: ${item.title}');
      return true;
    } catch(e) { return false; }
  }

  Future<bool> updateAssignment(AssignmentModel oldItem, AssignmentModel newItem) async {
    try {
      final path = await _localPath;
      final file = File('$path/assignments.txt');
      if (!(await file.exists())) return false;
      final lines = await file.readAsLines();
      final oldStr = '${oldItem.title},${oldItem.description},${oldItem.className},${oldItem.section},${oldItem.dueDate},${oldItem.teacherEmail}';
      final newStr = '${newItem.title},${newItem.description},${newItem.className},${newItem.section},${newItem.dueDate},${newItem.teacherEmail}';
      bool updated = false;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i] == oldStr) {
          lines[i] = newStr;
          updated = true;
          break;
        }
      }
      if (updated) {
        await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));
        await ActivityService().logAction(newItem.teacherEmail, 'teacher', 'Updated assignment: ${newItem.title}');
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  // --- Results ---
  Future<List<ResultModel>> getResults(String teacherEmail) async {
    final path = await _localPath;
    final file = File('$path/results.txt');
    if (!(await file.exists())) return [];
    
    final lines = await file.readAsLines();
    List<ResultModel> list = [];
    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length >= 5 && parts[4] == teacherEmail) {
        list.add(ResultModel(examName: parts[0], studentEmail: parts[1], subject: parts[2], marks: parts[3], teacherEmail: parts[4]));
      }
    }
    return list;
  }

  Future<bool> addResult(ResultModel item) async {
    try {
      final path = await _localPath;
      final file = File('$path/results.txt');
      await file.writeAsString('${item.examName},${item.studentEmail},${item.subject},${item.marks},${item.teacherEmail}\n', mode: FileMode.append);
      await ActivityService().logAction(item.teacherEmail, 'teacher', 'Added result for: ${item.studentEmail}');
      return true;
    } catch(e) { return false; }
  }

  Future<bool> updateResult(ResultModel oldItem, ResultModel newItem) async {
    try {
      final path = await _localPath;
      final file = File('$path/results.txt');
      if (!(await file.exists())) return false;
      final lines = await file.readAsLines();
      final oldStr = '${oldItem.examName},${oldItem.studentEmail},${oldItem.subject},${oldItem.marks},${oldItem.teacherEmail}';
      final newStr = '${newItem.examName},${newItem.studentEmail},${newItem.subject},${newItem.marks},${newItem.teacherEmail}';
      bool updated = false;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i] == oldStr) {
          lines[i] = newStr;
          updated = true;
          break;
        }
      }
      if (updated) {
        await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));
        await ActivityService().logAction(newItem.teacherEmail, 'teacher', 'Updated result for: ${newItem.studentEmail}');
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  // --- Attendance ---
  Future<List<AttendanceModel>> getAttendance(String teacherEmail) async {
    final path = await _localPath;
    final file = File('$path/attendance.txt');
    if (!(await file.exists())) return [];
    
    final lines = await file.readAsLines();
    List<AttendanceModel> list = [];
    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length >= 4 && parts[3] == teacherEmail) {
        list.add(AttendanceModel(date: parts[0], studentEmail: parts[1], status: parts[2], teacherEmail: parts[3]));
      }
    }
    return list;
  }

  Future<bool> addAttendance(AttendanceModel item) async {
    try {
      final path = await _localPath;
      final file = File('$path/attendance.txt');
      await file.writeAsString('${item.date},${item.studentEmail},${item.status},${item.teacherEmail}\n', mode: FileMode.append);
      await ActivityService().logAction(item.teacherEmail, 'teacher', 'Marked attendance: ${item.studentEmail} is ${item.status}');
      return true;
    } catch(e) { return false; }
  }

  Future<bool> updateAttendance(AttendanceModel oldItem, AttendanceModel newItem) async {
    try {
      final path = await _localPath;
      final file = File('$path/attendance.txt');
      if (!(await file.exists())) return false;
      final lines = await file.readAsLines();
      final oldStr = '${oldItem.date},${oldItem.studentEmail},${oldItem.status},${oldItem.teacherEmail}';
      final newStr = '${newItem.date},${newItem.studentEmail},${newItem.status},${newItem.teacherEmail}';
      bool updated = false;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i] == oldStr) {
          lines[i] = newStr;
          updated = true;
          break;
        }
      }
      if (updated) {
        await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));
        await ActivityService().logAction(newItem.teacherEmail, 'teacher', 'Updated attendance: ${newItem.studentEmail} is ${newItem.status}');
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  // --- Timetable ---
  Future<List<TimetableModel>> getTimetable(String teacherEmail) async {
    final path = await _localPath;
    final file = File('$path/timetable.txt');
    if (!(await file.exists())) return [];
    
    final lines = await file.readAsLines();
    List<TimetableModel> list = [];
    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length >= 6 && parts[5] == teacherEmail) {
        list.add(TimetableModel(day: parts[0], time: parts[1], subject: parts[2], className: parts[3], section: parts[4], teacherEmail: parts[5]));
      }
    }
    return list;
  }

  Future<bool> addTimetable(TimetableModel item) async {
    try {
      final path = await _localPath;
      final file = File('$path/timetable.txt');
      await file.writeAsString('${item.day},${item.time},${item.subject},${item.className},${item.section},${item.teacherEmail}\n', mode: FileMode.append);
      await ActivityService().logAction(item.teacherEmail, 'teacher', 'Added timetable entry: ${item.subject}');
      return true;
    } catch(e) { return false; }
  }

  Future<bool> updateTimetable(TimetableModel oldItem, TimetableModel newItem) async {
    try {
      final path = await _localPath;
      final file = File('$path/timetable.txt');
      if (!(await file.exists())) return false;
      final lines = await file.readAsLines();
      final oldStr = '${oldItem.day},${oldItem.time},${oldItem.subject},${oldItem.className},${oldItem.section},${oldItem.teacherEmail}';
      final newStr = '${newItem.day},${newItem.time},${newItem.subject},${newItem.className},${newItem.section},${newItem.teacherEmail}';
      bool updated = false;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i] == oldStr) {
          lines[i] = newStr;
          updated = true;
          break;
        }
      }
      if (updated) {
        await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));
        await ActivityService().logAction(newItem.teacherEmail, 'teacher', 'Updated timetable entry: ${newItem.subject}');
        return true;
      }
      return false;
    } catch (e) { return false; }
  }

  // --- Notices ---
  Future<List<NoticeModel>> getNotices(String teacherEmail) async {
    final path = await _localPath;
    final file = File('$path/notices.txt');
    if (!(await file.exists())) return [];
    
    final lines = await file.readAsLines();
    List<NoticeModel> list = [];
    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length >= 4 && parts[3] == teacherEmail) {
        list.add(NoticeModel(title: parts[0], content: parts[1], date: parts[2], teacherEmail: parts[3]));
      }
    }
    return list;
  }

  Future<bool> addNotice(NoticeModel item) async {
    try {
      final path = await _localPath;
      final file = File('$path/notices.txt');
      await file.writeAsString('${item.title},${item.content},${item.date},${item.teacherEmail}\n', mode: FileMode.append);
      await ActivityService().logAction(item.teacherEmail, 'teacher', 'Posted notice: ${item.title}');
      return true;
    } catch(e) { return false; }
  }

  Future<bool> updateNotice(NoticeModel oldItem, NoticeModel newItem) async {
    try {
      final path = await _localPath;
      final file = File('$path/notices.txt');
      if (!(await file.exists())) return false;
      final lines = await file.readAsLines();
      final oldStr = '${oldItem.title},${oldItem.content},${oldItem.date},${oldItem.teacherEmail}';
      final newStr = '${newItem.title},${newItem.content},${newItem.date},${newItem.teacherEmail}';
      bool updated = false;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i] == oldStr) {
          lines[i] = newStr;
          updated = true;
          break;
        }
      }
      if (updated) {
        await file.writeAsString(lines.join('\n') + (lines.isNotEmpty ? '\n' : ''));
        await ActivityService().logAction(newItem.teacherEmail, 'teacher', 'Updated notice: ${newItem.title}');
        return true;
      }
      return false;
    } catch (e) { return false; }
  }
}
