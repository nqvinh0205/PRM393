import 'package:flutter/material.dart';

class SpendingPool {
  final String name;
  final int amount;
  final String note;

  SpendingPool({
    required this.name,
    required this.amount,
    required this.note,
  });
}

class GoalItem {
  final String title;
  final int amount;
  final String poolName;
  final String note;
  final DateTime createdAt;

  GoalItem({
    required this.title,
    required this.amount,
    required this.poolName,
    required this.note,
    required this.createdAt,
  });
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<SpendingPool> _pools = [
    SpendingPool(name: 'Food', amount: 1500000, note: 'Quỹ ăn uống hàng tháng'),
    SpendingPool(name: 'Transport', amount: 800000, note: 'Chi phí đi lại'),
  ];
  final List<GoalItem> _goals = [];

  void _showAddPoolSheet() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Spending Pool',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Pool name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pool name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final amount = int.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Amount must be greater than 0.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      setState(() {
                        _pools.add(SpendingPool(
                          name: nameController.text.trim(),
                          amount: int.parse(amountController.text.trim()),
                          note: noteController.text.trim(),
                        ));
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Save Pool'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddGoalSheet() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String? selectedPool = _pools.isNotEmpty ? _pools.first.name : null;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Goal name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Goal name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPool,
                  decoration: const InputDecoration(
                    labelText: 'Select pool',
                    border: OutlineInputBorder(),
                  ),
                  items: _pools
                      .map(
                        (pool) => DropdownMenuItem(
                          value: pool.name,
                          child: Text(pool.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedPool = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please choose a pool.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final amount = int.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Amount must be greater than 0.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      setState(() {
                        _goals.add(GoalItem(
                          title: titleController.text.trim(),
                          amount: int.parse(amountController.text.trim()),
                          poolName: selectedPool!,
                          note: noteController.text.trim(),
                          createdAt: DateTime.now(),
                        ));
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Save Goal'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spending Pools',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                OutlinedButton.icon(
                  onPressed: _showAddPoolSheet,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Pool'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_pools.isEmpty)
              const Text('No spending pools yet.')
            else
              Column(
                children: _pools.map((pool) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(pool.name),
                      subtitle: Text(pool.note.isEmpty ? 'No note' : pool.note),
                      trailing: Text('${pool.amount} ₫'),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Goals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                OutlinedButton.icon(
                  onPressed: _pools.isEmpty ? null : _showAddGoalSheet,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Goal'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_goals.isEmpty)
              const Text('No goals yet. Create a goal from one of your pools.')
            else
              Column(
                children: _goals.map((goal) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(goal.title),
                      subtitle: Text('${goal.poolName} · ${goal.note.isEmpty ? 'No note' : goal.note}'),
                      trailing: Text('${goal.amount} ₫'),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
