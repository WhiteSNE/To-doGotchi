import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamagochi/screens/about_screen.dart';
import '../providers/game_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/debug_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan state dari GameProvider
    final game = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
  title: const Text("Todo-Gotchi"),
  centerTitle: true,
  backgroundColor: Colors.blueAccent,
  foregroundColor: Colors.white,
  actions: [ // Tambahkan ini
    IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
      },
    ),
  ],
),
      body: Column(
        children: [
          // 1. Bagian Visual Pet (Diberikan context agar bisa memicu Debug Menu)
          _buildPetSection(context, game),

          const Divider(),

          // Pesan Kematian: Muncul hanya jika Health <= 0
          if (game.health <= 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Pet Anda telah tiada karena tugas yang terbengkalai.\n"
                "Selesaikan tugas tepat waktu di kehidupan selanjutnya!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

          // Tombol Revive: Muncul hanya jika Health <= 0
          if (game.health <= 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton.icon(
                onPressed: () => game.revivePet(),
                icon: const Icon(Icons.refresh),
                label: const Text("Revive Pet"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          // 3. Daftar Tugas (Menggunakan Expanded agar bisa di-scroll)
          Expanded(
            child: game.tasks.isEmpty
                ? const Center(
                    child: Text("Belum ada tugas hari ini. Yuk tambah!"),
                  )
                : ListView.builder(
                    itemCount: game.tasks.length,
                    itemBuilder: (context, index) {
                      final task = game.tasks[index];
                      return Dismissible(
                        key: Key(task.id.toString()),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Tugas?"),
                              content: const Text(
                                "Tugas ini akan dihapus secara permanen.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          game.removeTask(index);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          leading: Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: task.isCompleted ? Colors.green : Colors.grey,
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            "Deadline: ${task.deadline.toString().split(' ')[0]}",
                          ),
                          trailing: task.isCompleted
                              ? null
                              : IconButton(
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => game.completeTask(index),
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Widget Helper untuk Dashboard Pet ---
  Widget _buildPetSection(BuildContext context, GameProvider game) {
    String petImage;
    if (game.health <= 0) {
      petImage = 'assets/pet_dead.gif';
    } else if (game.health <= 40) {
      petImage = 'assets/pet_sick.gif';
    } else {
      petImage = 'assets/pet_normal.gif';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: game.health <= 0 ? Colors.red : Colors.blueAccent,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Level & Status Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onLongPress: () => showDebugMenu(context),
                child: Text(
                  "LEVEL: ${game.level}",
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
              Icon(
                game.health <= 0
                    ? Icons.heart_broken
                    : Icons.battery_charging_full,
                color: game.health > 20 ? Colors.green : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Layar Konsol Pet
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: game.health <= 0 ? Colors.grey[400] : Colors.green[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26, width: 2),
            ),
            child: Center(
              child: Image.asset(petImage),
            ),
          ),
          const SizedBox(height: 15),
          // Progress Bars
          _StatBar(
            label: "HP",
            value: game.health / 100,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 8),
          _StatBar(
            label: "EXP",
            value: game.productive / 100,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}

// --- Widget Helper untuk Progress Bar ---
class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 12,
              color: color,
              backgroundColor: color.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }
}