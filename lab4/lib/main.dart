import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'debug_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'scaffold_demo.dart';
import 'theme_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          themeMode: mode,
          home: const MyHomePage(title: 'Lab 4 Home'),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Lab 4 Flutter UI Fundamentals', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Choose an exercise demo below.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              _demoButton(context, 'Exercise 1 - Core Widgets', const CoreWidgetsDemo()),
              const SizedBox(height: 12),
              _demoButton(context, 'Exercise 2 - Input Controls', const InputControlsDemo()),
              const SizedBox(height: 12),
              _demoButton(context, 'Exercise 3 - Layout Demo', const LayoutDemo()),
              const SizedBox(height: 12),
              _demoButton(context, 'Exercise 4 - Scaffold & Theme', const ScaffoldDemo()),
              const SizedBox(height: 12),
              _demoButton(context, 'Exercise 5 - Debug & Fix', const DebugDemo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demoButton(BuildContext context, String label, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
      child: Text(label),
    );
  }
}
