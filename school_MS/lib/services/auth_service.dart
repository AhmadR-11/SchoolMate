import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class AuthService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String role) async {
    final path = await _localPath;
    // Roles will be student, teacher, admin
    // Creates files: students.txt, teachers.txt, admins.txt
    return File('$path/${role}s.txt');
  }

  Future<bool> signup(String name, String email, String password, String role) async {
    try {
      final file = await _getFile(role);
      
      // Check if user already exists
      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (var line in lines) {
          final parts = line.split(',');
          if (parts.length >= 2 && parts[1] == email) {
            return false; // Email already exists
          }
        }
      }

      // Add new user: name,email,password
      final userString = '$name,$email,$password\n';
      await file.writeAsString(userString, mode: FileMode.append);
      return true;
    } catch (e) {
      print('Signup Error: $e');
      return false;
    }
  }

  Future<UserModel?> login(String email, String password, String role) async {
    try {
      final file = await _getFile(role);
      if (!(await file.exists())) {
        return null; // File doesn't exist yet, no users registered for this role
      }

      final lines = await file.readAsLines();
      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length >= 3) {
          final savedName = parts[0];
          final savedEmail = parts[1];
          final savedPassword = parts[2];
          
          if (savedEmail == email && savedPassword == password) {
            return UserModel(name: savedName, email: savedEmail, role: role);
          }
        }
      }
      return null; // No matching user found
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers(String role) async {
    try {
      final file = await _getFile(role);
      if (!(await file.exists())) {
        return [];
      }

      final lines = await file.readAsLines();
      List<UserModel> users = [];
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts.length >= 3) {
          users.add(UserModel(
            name: parts[0],
            email: parts[1],
            role: role,
          ));
        }
      }
      return users;
    } catch (e) {
      print('Get Users Error: $e');
      return [];
    }
  }

  Future<bool> deleteUser(String email, String role) async {
    try {
      final file = await _getFile(role);
      if (!(await file.exists())) {
        return false;
      }

      final lines = await file.readAsLines();
      List<String> updatedLines = [];
      bool deleted = false;

      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts.length >= 2 && parts[1] == email) {
          deleted = true; // Skip this user to delete
        } else {
          updatedLines.add(line);
        }
      }

      if (deleted) {
        // Rewrite file with the deleted user removed
        await file.writeAsString(updatedLines.join('\n') + (updatedLines.isNotEmpty ? '\n' : ''));
        return true;
      }
      return false; // User not found
    } catch (e) {
      print('Delete User Error: $e');
      return false;
    }
  }
}
