import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Settings Screen - Under Development')),
    );
  }
}
