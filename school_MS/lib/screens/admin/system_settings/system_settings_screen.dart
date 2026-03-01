import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  _SystemSettingsScreenState createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  final _schoolNameController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/settings.txt');
  }

  void _loadSettings() async {
    try {
      final file = await _file;
      if (await file.exists()) {
        final lines = await file.readAsLines();
        if (lines.isNotEmpty) {
          final parts = lines[0].split('|');
          if (parts.length >= 3) {
            _schoolNameController.text = parts[0];
            _academicYearController.text = parts[1];
            _addressController.text = parts[2];
          }
        }
      }
    } catch (e) {
      print('Load settings error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _saveSettings() async {
    try {
      final file = await _file;
      final settingsString = '${_schoolNameController.text.trim()}|${_academicYearController.text.trim()}|${_addressController.text.trim()}\n';
      await file.writeAsString(settingsString);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings Saved Successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save settings.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Settings')),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text('School Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _schoolNameController,
                    decoration: const InputDecoration(labelText: 'School Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _academicYearController,
                    decoration: const InputDecoration(labelText: 'Academic Year (e.g., 2026-2027)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'School Address', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Save Settings', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
    );
  }
}
