class Todo {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['is_completed'] == 1 || map['is_completed'] == true,
    );
  }
}
