class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Auth Endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';

  // Transaction Endpoints
  static const String submitTransaction = '/transaction';
  static const String getTransactions = '/transactions'; // needs /{limit} param
  static const String getTransactionsByCategory = '/transactions-by-category';

  // Fixed Expense Endpoints
  static const String submitFixedExpense = '/fixed-expense';
  static const String checkFixedExpenseStatus = '/fixed-expense-status';
  static const String paymentFixedExpense = '/fixed-expense-payment';
}
