import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../constants/auth_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  _checkAuthenticationStatus() async {
    // Show splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // Check if user is logged in
      bool isLoggedIn = await AuthConstants.isLoggedIn();

      if (isLoggedIn) {
        // Navigate to home screen if user is logged in
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // Navigate to login screen if user is not logged in
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Manajemen Keuangan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
