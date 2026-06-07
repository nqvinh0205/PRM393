class User {
  String name;
  String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}

class UserRepository {
  Future<List<User>> getUsers() async {
    await Future.delayed(Duration(seconds: 1));

    List<Map<String, dynamic>> jsonList = [
      {'name': 'Hung', 'email': 'hung@gmail.com'},
      {'name': 'Alice', 'email': 'alice@gmail.com'},
      {'name': 'John', 'email': 'john@gmail.com'},
    ];

    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}

Future<void> main() async {
  UserRepository repo = UserRepository();

  List<User> users = await repo.getUsers();

  for (var user in users) {
    print(user);
  }
}
