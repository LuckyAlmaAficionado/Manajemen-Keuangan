import 'package:flutter/material.dart';

class EditTransactionScreen extends StatefulWidget {
  final String transactionId;

  const EditTransactionScreen({super.key, required this.transactionId});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaksi'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Edit Transaction Screen - ID: ${widget.transactionId}'),
      ),
    );
  }
}
