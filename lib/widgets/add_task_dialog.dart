import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Fungsi untuk memunculkan kalender
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Tugas Baru"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Nama Tugas",
              hintText: "Contoh: Belajar Flutter",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text("Deadline: ${_selectedDate.toLocal()}".split(' ')[0]),
              const Spacer(),
              TextButton(
                onPressed: _pickDate,
                child: const Text("Pilih Tanggal"),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              // Memanggil fungsi addTask dari Provider
              context.read<GameProvider>().addTask(
                _controller.text,
                _selectedDate,
              );
              Navigator.pop(context);
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}