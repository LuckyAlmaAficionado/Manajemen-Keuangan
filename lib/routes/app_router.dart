import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/income_screen.dart';
import '../screens/expense_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/budget_screen.dart';
import '../screens/report_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/financial_profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/add_transaction_screen.dart';
import '../screens/edit_transaction_screen.dart';
import '../screens/transaction_detail_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case AppRoutes.income:
        return MaterialPageRoute(builder: (_) => const IncomeScreen());

      case AppRoutes.expense:
        return MaterialPageRoute(builder: (_) => const ExpenseScreen());

      case AppRoutes.transaction:
        return MaterialPageRoute(builder: (_) => const TransactionScreen());

      case AppRoutes.budget:
        return MaterialPageRoute(builder: (_) => const BudgetScreen());

      case AppRoutes.report:
        return MaterialPageRoute(builder: (_) => const ReportScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.addTransaction:
        return MaterialPageRoute(builder: (_) => const AddTransactionScreen());

      case AppRoutes.editTransaction:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditTransactionScreen(
            transactionId: args?['transactionId'] ?? '',
          ),
        );

      case AppRoutes.financialProfile:
        return MaterialPageRoute(
          builder: (_) => const FinancialProfileScreen(),
        );

      case AppRoutes.transactionDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TransactionDetailScreen(
            transactionId: args?['transactionId'] ?? '',
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
