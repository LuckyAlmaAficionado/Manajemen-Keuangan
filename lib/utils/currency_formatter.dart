class CurrencyFormatter {
  static String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}';
  }

  // Alias for formatCurrency to match the usage in other files
  static String format(double amount) {
    return formatCurrency(amount);
  }

  static String formatCurrencyWithSign(double amount, {bool isIncome = false}) {
    final sign = isIncome ? '+' : '-';
    return '$sign ${formatCurrency(amount.abs())}';
  }

  static double parseCurrency(String text) {
    // Remove 'Rp', spaces, and dots
    final cleanText = text
        .replaceAll('Rp', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');

    return double.tryParse(cleanText) ?? 0.0;
  }
}
