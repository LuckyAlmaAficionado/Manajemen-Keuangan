import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/user_info_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // User info with logout button
            UserInfoWidget(),
            SizedBox(height: 24),

            // Profile menu items
            _ProfileMenuItem(
              icon: Icons.account_balance_wallet,
              title: 'Profil Keuangan',
              route: AppRoutes.financialProfile,
            ),
            _ProfileMenuItem(
              icon: Icons.settings,
              title: 'Pengaturan',
              route: AppRoutes.settings,
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Bantuan',
              route: null,
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              route: null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? route;

  const _ProfileMenuItem({required this.icon, required this.title, this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.grey[50],
        onTap: () {
          if (route != null) {
            Navigator.pushNamed(context, route!);
          }
        },
      ),
    );
  }
}
