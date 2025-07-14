import 'package:flutter/material.dart';
import 'package:manajemen_keuangan/models/category.dart';

/// Model untuk data budget.
class Budget {
  final String id;
  final String name;
  final double amount;
  final Category category;
  final double spent;
  final DateTime date;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.spent,
    required this.date,
  });

  double get remaining => amount - spent;
  double get percentage => amount > 0 ? spent / amount : 0;
  bool get isOverBudget => spent > amount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category.index, // Simpan sebagai index enum
      'spent': spent,
      'date': date.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      category: Category.values[json['category']], // Ambil dari index enum
      spent: json['spent'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Budget copyWith({
    String? id,
    String? name,
    double? amount,
    Category? category,
    double? spent,
    DateTime? date,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      spent: spent ?? this.spent,
      date: date ?? this.date,
    );
  }
}
