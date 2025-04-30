class Employee {
  String name;
  double salary;

  Employee(this.name, this.salary);

  void displayInfo() {
    print("Name: $name");
    print("Salary: \$${salary.toStringAsFixed(2)}");
    // Check if salary has decimal part
    //if (salary == salary.toInt()) {
    //  print('Salary: \$${salary.toInt()}');
    // } else {
    //  print('Salary: \$${salary.toStringAsFixed(2)}');
    //}
    //}
  }
}

//subclass Manager
class Manager extends Employee {
  String department;

  Manager(String name, double salary, this.department) : super(name, salary);

  @override
  void displayInfo() {
    super.displayInfo();
    print("Department: $department");
  }
}

//subclass Developer
class Developer extends Employee {
  String programmingLanguage;

  Developer(String name, double salary, this.programmingLanguage)
    : super(name, salary);

  @override
  void displayInfo() {
    super.displayInfo();
    print("Programming Language: $programmingLanguage");
  }
}

void main() {
  // creating instances
  var manager1 = Manager("Ivana Georgiev", 5800, "HR");
  var dev1 = Developer("John Wick", 5800, "JavaScript");
  var dev2 = Developer("Kole Ivanow", 6000, "Java");
  var manager2 = Manager("Rosen Cekov", 3200, "Logistick");

  List<Employee> employees = [manager2, dev2, dev1, manager1];

  //display info for everyone
  print("****Employee Details****");
  for (var employee in employees) {
    print("");
    employee.displayInfo();
  }
}
