import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FeesManagementScreen extends StatefulWidget {
  const FeesManagementScreen({super.key});

  @override
  _FeesManagementScreenState createState() => _FeesManagementScreenState();
}

class _FeesManagementScreenState extends State<FeesManagementScreen> {
  final _amountController = TextEditingController();
  final _classController = TextEditingController();

  List<String> _feeStructures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeeStructures();
  }

  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/fee_structure.txt');
  }

  void _loadFeeStructures() async {
    setState(() => _isLoading = true);
    try {
      final file = await _file;
      if (await file.exists()) {
        final lines = await file.readAsLines();
        setState(() {
          _feeStructures = lines.where((line) => line.trim().isNotEmpty).toList();
        });
      }
    } catch (e) {
      print('Load fee struct error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddFeeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Define Fee Structure'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Class Name (e.g., 10th)'),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Fee Amount (e.g., \$500)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final className = _classController.text.trim();
                final amount = _amountController.text.trim();

                if (className.isEmpty || amount.isEmpty) {
                  return;
                }

                try {
                  final file = await _file;
                  await file.writeAsString('$className,$amount\n', mode: FileMode.append);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fee structure defined')));
                    _loadFeeStructures();
                  }
                } catch (e) {
                  print('Error defining fee: $e');
                }
              },
              child: const Text('Save'),
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
        title: const Text('Fees Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddFeeDialog,
            tooltip: 'Define Fee',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _feeStructures.isEmpty
              ? const Center(child: Text('No fee structures defined yet.'))
              : ListView.builder(
                  itemCount: _feeStructures.length,
                  itemBuilder: (context, index) {
                    final parts = _feeStructures[index].split(',');
                    return ListTile(
                      leading: const Icon(Icons.monetization_on, color: Colors.green),
                      title: Text('Class: ${parts[0]}'),
                      subtitle: Text('Fee Amount: ${parts.length > 1 ? parts[1] : 'Unknown'}'),
                    );
                  },
                ),
    );
  }
}
