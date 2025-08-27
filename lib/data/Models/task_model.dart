class Task {
  int? id;
  String task_name;
  String task_comment;
  String last_date;
  String priority;
  String category;

  Task({
    this.id,
    required this.task_name,
    required this.task_comment,
    required this.last_date,
    required this.priority,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'task_name': task_name,
      'task_comment': task_comment,
      'last_date': last_date,
      'priority': priority,
      'category': category,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      task_name: map['task_name'],
      task_comment: map['task_comment'],
      last_date: map['last_date'],
      priority: map['priority'],
      category: map['category'],
    );
  }
}
