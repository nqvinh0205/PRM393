import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';

const _transactionCategories = [
  'Salary',
  'Food',
  'Transport',
  'Shopping',
  'Health',
  'Other',
];

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
    this.transaction,
    this.initialType,
  });

  final TransactionModel? transaction;
  final TransactionType? initialType;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.transaction?.type ?? widget.initialType ?? TransactionType.income;
    _selectedCategory = widget.transaction?.category;
    _selectedDate = widget.transaction?.date;
    _amountController.text = widget.transaction?.amount.toString() ?? '';
    _noteController.text = widget.transaction?.subtitle ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      return;
    }

    final transaction = TransactionModel(
      id: widget.transaction?.id ?? 'tx${DateTime.now().millisecondsSinceEpoch}',
      title: _selectedCategory!,
      subtitle: _noteController.text.trim().isEmpty ? _selectedCategory! : _noteController.text.trim(),
      category: _selectedCategory!,
      amount: amount,
      date: _selectedDate!,
      type: _selectedType,
      icon: _selectedType == TransactionType.income
          ? Icons.arrow_circle_up
          : Icons.arrow_circle_down,
      color: _selectedType == TransactionType.income ? Colors.green : Colors.red,
    );

    Navigator.of(context).pop(transaction);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'Select transaction date'
        : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? 'Add Transaction' : 'Edit Transaction'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaction Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      selected: _selectedType == TransactionType.income,
                      label: const Text('Income'),
                      selectedColor: Colors.green.shade100,
                      onSelected: (_) {
                        setState(() {
                          _selectedType = TransactionType.income;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      selected: _selectedType == TransactionType.outcome,
                      label: const Text('Expense'),
                      selectedColor: Colors.red.shade100,
                      onSelected: (_) {
                        setState(() {
                          _selectedType = TransactionType.outcome;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Transaction amount',
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
              const SizedBox(height: 24),
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _transactionCategories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Transaction category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Date Picker',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Select transaction date',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(text: dateText),
                    validator: (_) {
                      if (_selectedDate == null) {
                        return 'Transaction date is required.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Note',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Additional information',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Save transaction'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
