import 'package:flutter/material.dart';

/// A simple global theme mode notifier used across the app.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

void toggleThemeMode() {
  themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}
