import 'package:flutter/material.dart';

enum TransactionType { income, outcome }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final int amount;
  final DateTime date;
  final TransactionType type;
  final IconData icon;
  final Color color;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.icon,
    required this.color,
  });

  String get formattedAmount {
    final sign = type == TransactionType.income ? '+' : '-';
    return '$sign${_formatCurrency(amount)} ₫';
  }

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String _formatCurrency(int value) {
    final text = value.abs().toString();
    return text.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }
}
