class Student {
  String name;
  int age;

  Student(this.name, this.age);

  void displayInfo() {
    print('Name: $name, Age: $age');
  }
}
void main() {
  Student student1 = Student('Vinh', 22);
  Student student2 = Student('Duc', 22);

  student1.displayInfo();
  student2.displayInfo();
}