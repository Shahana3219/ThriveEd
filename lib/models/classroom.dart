// Import for date formatting

class Classroom {
  final String name;
  final String teacherName;
  final List<Assignment> assignments;
  final List<Note> notes;

  Classroom({
    required this.name,
    required this.teacherName,
    required this.assignments,
    required this.notes,
  });
}

class Assignment {
  final String title;
  final DateTime dueDate;

  Assignment({required this.title, required this.dueDate});
}

class Note {
  final String subject;
  final String content;

  Note({
    required this.subject,
    required this.content,
  });
}

// Sample Data
List<Classroom> classrooms = [
  Classroom(
    name: "Math 101",
    teacherName: "Mr. Smith",
    assignments: [
      Assignment(
          title: "Algebra Homework",
          dueDate: DateTime.now().add(const Duration(days: 7))),
      Assignment(
          title: "Geometry Project",
          dueDate: DateTime.now().add(const Duration(days: 14))),
    ],
    notes: [
      Note(subject: "Algebra", content: "Review Chapter 5 for next class."),
      Note(subject: "Geometry", content: "Bring ruler for project."),
    ],
  ),
  Classroom(
    name: "Physics 101",
    teacherName: "Ms. Johnson",
    assignments: [
      Assignment(
          title: "Lab Report", dueDate: DateTime.now().add(const Duration(days: 5))),
    ],
    notes: [
      Note(
          subject: "Physics", content: "Read Chapter 3 before the next class."),
    ],
  ),
];