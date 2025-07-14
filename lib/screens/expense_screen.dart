import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Expense Screen - Under Development')),
    );
  }
}
