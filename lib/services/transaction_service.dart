import '../models/transaction.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  List<Transaction> get incomeTransactions =>
      _transactions.where((t) => t.type == TransactionType.income).toList();

  List<Transaction> get expenseTransactions =>
      _transactions.where((t) => t.type == TransactionType.expense).toList();

  double get totalIncome => incomeTransactions.fold(
    0.0,
    (sum, transaction) => sum + transaction.amount,
  );

  double get totalExpense => expenseTransactions.fold(
    0.0,
    (sum, transaction) => sum + transaction.amount,
  );

  double get balance => totalIncome - totalExpense;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
  }

  void updateTransaction(Transaction transaction) {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      _transactions.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
  }

  Transaction? getTransactionById(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  Map<String, double> getExpenseByCategory() {
    final Map<String, double> categoryTotals = {};

    for (final transaction in expenseTransactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }

  Map<String, double> getIncomeByCategory() {
    final Map<String, double> categoryTotals = {};

    for (final transaction in incomeTransactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }
}
