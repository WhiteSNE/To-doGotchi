import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

void showDebugMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      // Menggunakan context.read karena kita hanya ingin memicu aksi, bukan mendengarkan perubahan
      final game = context.read<GameProvider>();
      
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "DEBUG MENU", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.heart_broken, color: Colors.red),
              title: const Text("Set HP to 10% (Sick State)"),
              onTap: () { // Perbaikan: Gunakan onTap
                game.debugSetHealth(10);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dangerous, color: Colors.black),
              title: const Text("Set HP to 0% (Dead State)"),
              onTap: () { // Perbaikan: Gunakan onTap
                game.debugSetHealth(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bolt, color: Colors.yellow),
              title: const Text("Add +50 EXP"),
              onTap: () { // Perbaikan: Gunakan onTap
                game.debugAddProductive(50);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.orange),
              title: const Text("Clear All Tasks"),
              onTap: () { // Perbaikan: Gunakan onTap
                game.debugClearAllTasks();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.blue),
              title: const Text("Full Reset (Revive)"),
              onTap: () { // Perbaikan: Gunakan onTap
                game.revivePet();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}