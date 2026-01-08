import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Todo-Gotchi"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: Icon(Icons.pets, size: 80, color: Colors.blueAccent),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Todo-Gotchi v1.0",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 40),
          
          _buildInfoSection(
            "Cara Bermain",
            "Selesaikan tugas sebelum deadline untuk memberi makan pet Anda. "
            "Setiap tugas yang selesai memberikan +25 EXP.",
          ),
          
          _buildInfoSection(
            "Mekanik HP (Health)",
            "Jika tugas melewati deadline H+1 dan belum selesai, pet Anda akan kehilangan -20 HP. "
            "Jika HP mencapai 0, pet akan tiada.",
          ),

          _buildInfoSection(
            "Mekanik Level",
            "Kumpulkan 100 EXP untuk Level Up! Saat Level Up, HP pet Anda akan pulih sepenuhnya.",
          ),

          const SizedBox(height: 20),
          const Card(
            color: Colors.blueAccent,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Ingat: Produktivitas Anda adalah nyawa bagi pet Anda!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "Dibuat dengan ❤️ oleh Todo-Gotchi Team",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}