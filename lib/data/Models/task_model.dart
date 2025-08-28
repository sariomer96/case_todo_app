class Task {
  int? id;
  String taskName;
  String? taskComment;
  String lastDate;
  String priority;
  String category;
  bool isFinished;

  Task({
    this.id,
    required this.taskName,
    this.taskComment,
    required this.lastDate,
    required this.priority,
    required this.category,
    this.isFinished = false,
  });

  Task copyWith({
    int? id,
    String? taskName,
    String? taskComment,
    required String lastDate,
    String? priority,
    String? category,
    bool? isFinished,
  }) {
    return Task(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      taskComment: taskComment ?? this.taskComment,
      lastDate: lastDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_name': taskName,
      'task_comment': taskComment,
      'last_date': lastDate,
      'priority': priority,
      'category': category,
      'is_finished': isFinished ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      taskName: map['task_name'],
      taskComment: map['task_comment'],
      lastDate: map['last_date'],
      priority: map['priority'],
      category: map['category'],
      isFinished: map['is_finished'] == 1,
    );
  }
}
