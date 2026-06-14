import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';
import '../../data/transaction_data.dart';
import '../../models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late List<TransactionModel> _transactions;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _transactions = List.of(sampleTransactions);
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TransactionType get _selectedType {
    return _tabController.index == 0
        ? TransactionType.income
        : TransactionType.outcome;
  }

  List<TransactionModel> get _filteredTransactions {
    final query = _searchText.trim().toLowerCase();
    return _transactions.where((transaction) {
      final matchesType = transaction.type == _selectedType;
      if (!matchesType) return false;
      if (query.isEmpty) return true;

      final text = '${transaction.title} ${transaction.subtitle} ${transaction.formattedAmount}'
          .toLowerCase();
      return text.contains(query);
    }).toList();
  }

  Future<void> _openAddTransactionScreen() async {
    final transaction = await Navigator.of(context).push<TransactionModel?>(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(initialType: _selectedType),
      ),
    );

    if (transaction != null) {
      setState(() {
        _transactions.insert(0, transaction);
      });
    }
  }

  void _updateTransaction(TransactionModel updated) {
    setState(() {
      final index = _transactions.indexWhere((item) => item.id == updated.id);
      if (index != -1) {
        _transactions[index] = updated;
      }
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((item) => item.id == id);
    });
  }

  void _openTransactionDetail(TransactionModel transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TransactionDetailScreen(
          transaction: transaction,
          onUpdate: _updateTransaction,
          onDelete: () => _deleteTransaction(transaction.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    final activeType = _selectedType;
    final activeLabel = activeType == TransactionType.income ? 'Income' : 'Outcome';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() {
                    _searchText = value;
                  }),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search transactions',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Income'),
                    Tab(text: 'Outcome'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No $activeLabel transactions found.',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final transaction = filtered[index];
                      return _TransactionTile(
                        transaction: transaction,
                        onTap: () => _openTransactionDetail(transaction),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    this.onTap,
  });

  final TransactionModel transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: transaction.color.withValues(alpha: 0.15),
          child: Icon(
            transaction.icon,
            color: transaction.color,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${transaction.subtitle} · ${transaction.formattedDate}'),
        trailing: Text(
          transaction.formattedAmount,
          style: TextStyle(
            color: transaction.type == TransactionType.income ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
