class Task {
  final int id;
  final String title;
  final String course;
  final String deadline;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
  });

  factory Task.fromJson(
      Map<String, dynamic> json) {

    return Task(
      id: json['id'],
      title: json['title'],
      course: json['course'],
      deadline: json['deadline'],
      status: json['status'],
    );
  }
}