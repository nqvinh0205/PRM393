import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _switchValue = false;
  String _radioValue = 'A';
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 - Input Controls Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Slider value: ${_sliderValue.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                min: 0,
                max: 100,
                divisions: 100,
                value: _sliderValue,
                label: _sliderValue.toStringAsFixed(0),
                onChanged: (v) => setState(() => _sliderValue = v),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable feature'),
                  Switch(
                    value: _switchValue,
                    onChanged: (v) => setState(() => _switchValue = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const Text('Choose option:'),
              RadioListTile<String>(
                title: const Text('Option A'),
                value: 'A',
                groupValue: _radioValue,
                onChanged: (v) => setState(() => _radioValue = v ?? 'A'),
              ),
              RadioListTile<String>(
                title: const Text('Option B'),
                value: 'B',
                groupValue: _radioValue,
                onChanged: (v) => setState(() => _radioValue = v ?? 'A'),
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _pickDate(),
                child: const Text('Pick a date'),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              Text('Current values:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Slider: ${_sliderValue.toStringAsFixed(0)}'),
              Text('Switch: ${_switchValue ? 'ON' : 'OFF'}'),
              Text('Radio: $_radioValue'),
              Text('Date: ${_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ').first : 'Not selected'}'),
            ],
          ),
        ),
      ),
    );
  }
}
