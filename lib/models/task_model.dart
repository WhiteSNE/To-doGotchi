class Task {
  int? id;
  String title;
  DateTime deadline;
  bool isCompleted;
  bool healthDeducted; // Flag agar nyawa tidak berkurang berkali-kali untuk tugas yang sama

  Task({
    this.id,
    required this.title,
    required this.deadline,
    this.isCompleted = false,
    this.healthDeducted = false,
  });

  // Konversi untuk Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'healthDeducted': healthDeducted ? 1 : 0,
    };
  }
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      deadline: DateTime.parse(map['deadline']),
      isCompleted: map['isCompleted'] == 1,
      healthDeducted: map['healthDeducted'] == 1,
    );
  }
}