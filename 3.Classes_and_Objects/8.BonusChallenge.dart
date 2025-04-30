class Student {
  String name;
  List<int> marks;

  Student(this.name, this.marks);

  double calculateAverage() {
    if (marks.isEmpty) return 0;

    int total = 0;
    for (int i = 0; i < marks.length; i++) {
      total += marks[i];
    }

    return total / marks.length;
  }

  String getGrade() {
    double avg = calculateAverage();

    if (avg >= 90) {
      return "A";
    } else if (avg >= 80) {
      return "B";
    } else if (avg >= 70) {
      return "C";
    } else {
      return "F";
    }
  }

  void displayInfo() {
    print("Student: $name");
    print("Marks: $marks");
    print("Average: ${calculateAverage().toStringAsFixed(2)}");
    print("Grade: ${getGrade()}");
    print("-----------");
  }
}

void main() {
  var student1 = Student("Alice", [95, 88, 92]);
  var student2 = Student("Bob", [78, 74, 80]);
  var student3 = Student("Charlie", [60, 65, 70]);

  List<Student> students = [student1, student2, student3];

  for (var student in students) {
    student.displayInfo();
  }
}
