import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Report Screen - Under Development')),
    );
  }
}
