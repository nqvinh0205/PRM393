class Settings {
  static final Settings _instance = Settings._internal();

  String theme = "dark";

  Settings._internal();

  factory Settings() {
    return _instance;
  }
}

void main() {
  Settings a = Settings();
  Settings b = Settings();

  print(identical(a, b)); // true

  a.theme = "light";

  print(b.theme); // light
}
