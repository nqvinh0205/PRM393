// Exercise 3 – Control Flow & Functions

// 1. If/else block to check score
void checkScore(double score) {
  if (score >= 8.5) {
    print("Excellent");
  } else if (score >= 7.0) {
    print("Good");
  } else if (score >= 5.0) {
    print("Pass");
  } else {
    print("Fail");
  }
}

// 2. Switch case for day of week
void getDayName(int day) {
  switch (day) {
    case 1:
      print("Monday");
      break;
    case 2:
      print("Tuesday");
      break;
    case 3:
      print("Wednesday");
      break;
    case 4:
      print("Thursday");
      break;
    case 5:
      print("Friday");
      break;
    case 6:
      print("Saturday");
      break;
    case 7:
      print("Sunday");
      break;
    default:
      print("Invalid day");
  }
}

// 3. Loops through collections
void demonstrateLoops() {
  List<String> fruits = ["Apple", "Banana", "Orange"];
  
  // For loop
  print("For loop:");
  for (int i = 0; i < fruits.length; i++) {
    print(fruits[i]);
  }
  
  // For-in loop
  print("For-in loop:");
  for (String fruit in fruits) {
    print(fruit);
  }
  
  // forEach loop
  print("forEach loop:");
  fruits.forEach((fruit) {
    print(fruit);
  });
}

// 4. Functions - normal syntax
void greetNormal(String name) {
  print("Hello, $name!");
}

// 4. Functions - arrow syntax
String getGreeting(String name) => "Hi, $name!";

void main() {
  print("=== Exercise 3 ===\n");
  
  // Test if/else
  print("1. Check Score:");
  checkScore(8.5);
  checkScore(7.0);
  checkScore(5.0);
  checkScore(3.5);
  
  // Test switch
  print("\n2. Day of Week:");
  getDayName(1);
  getDayName(5);
  getDayName(7);
  
  // Test loops
  print("\n3. Loops:");
  demonstrateLoops();
  
  // Test functions
  print("\n4. Functions:");
  greetNormal("Alice");
  print(getGreeting("Bob"));
}
