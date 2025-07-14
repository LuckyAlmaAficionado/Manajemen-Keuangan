import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../utils/currency_formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Data dummy untuk demo - nanti bisa diintegrasikan dengan database
  final double _monthlySalary = 8000000; // Gaji bulanan
  final double _totalExpenses = 3250000; // Total pengeluaran bulan ini
  final double _savings = 1500000; // Tabungan bulan ini

  // Data cicilan aktif - akan digunakan untuk menampilkan "Pengeluaran Tetap"
  final List<Map<String, dynamic>> _activeInstallments = [
    {
      'name': 'Cicilan Motor',
      'amount': 750000.0,
      'remainingMonths': 18,
      'totalMonths': 24,
      'icon': Icons.two_wheeler,
      'color': Colors.blue,
    },
    {
      'name': 'Cicilan Rumah',
      'amount': 2500000.0,
      'remainingMonths': 180,
      'totalMonths': 240,
      'icon': Icons.home,
      'color': Colors.green,
    },
    {
      'name': 'Cicilan Gadget',
      'amount': 450000.0,
      'remainingMonths': 6,
      'totalMonths': 12,
      'icon': Icons.smartphone,
      'color': Colors.purple,
    },
  ];

  // Getter untuk total cicilan bulanan
  double get _totalInstallments {
    return _activeInstallments.fold(
      0.0,
      (sum, installment) => sum + (installment['amount'] as double),
    );
  }

  // Getter untuk mengecek apakah ada cicilan aktif
  bool get _hasActiveInstallments => _activeInstallments.isNotEmpty;

  // Data pengeluaran per kategori
  final Map<String, Map<String, dynamic>> _expenseCategories = {
    'Makanan': {
      'amount': 1200000.0,
      'icon': Icons.restaurant,
      'color': Colors.orange,
      'percentage': 37.0,
    },
    'Transportasi': {
      'amount': 500000.0,
      'icon': Icons.directions_car,
      'color': Colors.blue,
      'percentage': 15.4,
    },
    'Belanja': {
      'amount': 800000.0,
      'icon': Icons.shopping_bag,
      'color': Colors.purple,
      'percentage': 24.6,
    },
    'Hiburan': {
      'amount': 350000.0,
      'icon': Icons.movie,
      'color': Colors.pink,
      'percentage': 10.8,
    },
    'Tagihan': {
      'amount': 400000.0,
      'icon': Icons.receipt,
      'color': Colors.red,
      'percentage': 12.2,
    },
  };

  // Data transaksi terbaru
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'title': 'Gojek - Makanan',
      'category': 'Makanan',
      'amount': -85000.0,
      'date': '14 Jul 2025',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    {
      'title': 'Grab - Transport',
      'category': 'Transportasi',
      'amount': -25000.0,
      'date': '14 Jul 2025',
      'icon': Icons.directions_car,
      'color': Colors.blue,
    },
    {
      'title': 'Gaji Bulanan',
      'category': 'Pemasukan',
      'amount': 8000000.0,
      'date': '1 Jul 2025',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'title': 'Shopee - Belanja',
      'category': 'Belanja',
      'amount': -150000.0,
      'date': '13 Jul 2025',
      'icon': Icons.shopping_bag,
      'color': Colors.purple,
    },
    {
      'title': 'Netflix Subscription',
      'category': 'Hiburan',
      'amount': -54000.0,
      'date': '12 Jul 2025',
      'icon': Icons.movie,
      'color': Colors.pink,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol notifikasi
          IconButton(
            onPressed: () => _showNotifications(),
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifikasi',
          ),
          // Tombol menu profil
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header dengan gradient background
              _buildHeaderSection(),

              // Main content dengan padding
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary cards - overview keuangan
                    _buildSummaryCards(),

                    const SizedBox(height: 24),

                    // AI Recommendation card
                    _buildAIRecommendationCard(),

                    const SizedBox(height: 24),

                    // Expense categories breakdown
                    _buildExpenseCategoriesSection(),

                    const SizedBox(height: 24),

                    // Recent transactions
                    _buildRecentTransactionsSection(),

                    const SizedBox(height: 24),

                    // Quick actions
                    _buildQuickActionsSection(),

                    const SizedBox(height: 100), // Extra space for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating action button untuk tambah transaksi
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTransaction),
        icon: const Icon(Icons.add),
        label: const Text('Transaksi'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
    );
  }

  // Header section dengan informasi saldo dan progress
  Widget _buildHeaderSection() {
    final double savingsPercentage = (_savings / _monthlySalary) * 100;
    final double expensePercentage = (_totalExpenses / _monthlySalary) * 100;
    ValueNotifier<bool> _isBalanceVisible = ValueNotifier<bool>(false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[900]!, Colors.blue[700]!],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting dan tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Siang! 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Minggu, 14 Juli 2025',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                // Quick balance visibility toggle
                IconButton(
                  onPressed: () {
                    _isBalanceVisible.value = !_isBalanceVisible.value;
                  },
                  icon: Icon(Icons.visibility, color: Colors.white),
                  tooltip: 'Sembunyikan Saldo',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Saldo utama
            const Text(
              'Saldo Tersedia',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            ValueListenableBuilder(
              valueListenable: _isBalanceVisible,
              builder: (context, value, child) {
                return Text(
                  value
                      ? CurrencyFormatter.format(
                          _monthlySalary - _totalExpenses,
                        )
                      : 'Rp ******',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Progress bars untuk savings dan expenses
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tabungan: ${savingsPercentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: savingsPercentage / 100,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengeluaran: ${expensePercentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: expensePercentage / 100,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Summary cards dengan informasi overview
  Widget _buildSummaryCards() {
    if (_hasActiveInstallments) {
      // Jika ada cicilan aktif, tampilkan 3 kartu dalam grid
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Gaji Bulan Ini',
                  CurrencyFormatter.format(_monthlySalary),
                  Icons.account_balance_wallet,
                  Colors.green,
                  'Diterima 1 Jul 2025',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Total Pengeluaran',
                  CurrencyFormatter.format(_totalExpenses),
                  Icons.money_off,
                  Colors.red,
                  '${_expenseCategories.length} kategori',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Kartu Pengeluaran Tetap (hanya muncul jika ada cicilan aktif)
          _buildSummaryCard(
            'Pengeluaran Tetap',
            CurrencyFormatter.format(_totalInstallments),
            Icons.credit_card,
            Colors.amber,
            '${_activeInstallments.length} cicilan aktif',
            onTap: () => _showActiveInstallments(),
          ),
        ],
      );
    } else {
      // Jika tidak ada cicilan aktif, tampilkan 2 kartu seperti biasa
      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Gaji Bulan Ini',
              CurrencyFormatter.format(_monthlySalary),
              Icons.account_balance_wallet,
              Colors.green,
              'Diterima 1 Jul 2025',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Total Pengeluaran',
              CurrencyFormatter.format(_totalExpenses),
              Icons.money_off,
              Colors.red,
              '${_expenseCategories.length} kategori',
            ),
          ),
        ],
      );
    }
  }

  // Individual summary card component
  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color color,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon dan title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  // Trend indicator (bisa ditambahkan nanti)
                  Icon(Icons.trending_up, color: color, size: 16),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),

              // Amount
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AI Recommendation card dengan saran harian
  Widget _buildAIRecommendationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[50]!, Colors.purple[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan AI icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Saran AI Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  // Refresh button untuk saran baru
                  IconButton(
                    onPressed: () => _refreshAIRecommendation(),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh Saran',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // AI Recommendation content
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main recommendation
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Colors.amber[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Pengeluaran makanan Anda sudah 37% dari total budget. Pertimbangkan untuk memasak di rumah 2-3 kali seminggu untuk menghemat Rp 300.000.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Actionable suggestions
                    Row(
                      children: [
                        Icon(
                          Icons.trending_down,
                          color: Colors.green[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Alokasikan ke tabungan: Rp 200.000 | Investasi: Rp 100.000',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.financialProfile,
                      ),
                      icon: const Icon(Icons.analytics, size: 16),
                      label: const Text('Analisis Lengkap'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple[700],
                        side: BorderSide(color: Colors.purple[700]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.budget),
                      icon: const Icon(Icons.savings, size: 16),
                      label: const Text('Atur Budget'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Expense categories breakdown section
  Widget _buildExpenseCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pengeluaran per Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.expense),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Categories grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4, // Increased aspect ratio to prevent overflow
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _expenseCategories.length,
          itemBuilder: (context, index) {
            final category = _expenseCategories.keys.elementAt(index);
            final data = _expenseCategories[category]!;

            return _buildExpenseCategoryCard(
              category,
              (data['amount'] as num).toDouble(),
              data['icon'] as IconData,
              data['color'] as Color,
              (data['percentage'] as num).toDouble(),
            );
          },
        ),

        const SizedBox(height: 24),

        // Fixed expenses card - Pengeluaran Tetap
        if (_hasActiveInstallments) _buildFixedExpensesCard(),
      ],
    );
  }

  // Individual expense category card
  Widget _buildExpenseCategoryCard(
    String category,
    double amount,
    IconData icon,
    Color color,
    double percentage,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showCategoryDetails(category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Added to prevent overflow
            children: [
              // Icon dan percentage
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6), // Reduced padding
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 18), // Smaller icon
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8), // Reduced height
              // Category name
              Text(
                category,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 2), // Reduced height
              // Amount
              Text(
                CurrencyFormatter.format(amount),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fixed expenses card - Pengeluaran Tetap
  Widget _buildFixedExpensesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Pengeluaran Tetap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                // Total installment amount
                Text(
                  CurrencyFormatter.format(_totalInstallments),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Active installments list
            Column(
              children: _activeInstallments.map((installment) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (installment['color'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          installment['icon'] as IconData,
                          color: installment['color'] as Color,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Installment details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              installment['name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sisa ${installment['remainingMonths']} bulan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Amount
                      Text(
                        CurrencyFormatter.format(installment['amount']),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: installment['color'],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Action button to manage installments
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.transaction),
              icon: const Icon(Icons.manage_accounts, size: 16),
              label: const Text('Kelola Cicilan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recent transactions section
  Widget _buildRecentTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.transaction),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Transactions list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentTransactions.length,
          itemBuilder: (context, index) {
            final transaction = _recentTransactions[index];
            return _buildTransactionItem(transaction);
          },
        ),
      ],
    );
  }

  // Individual transaction item
  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final bool isIncome = (transaction['amount'] as num).toDouble() > 0;
    final double amount = (transaction['amount'] as num).toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (transaction['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            transaction['icon'] as IconData,
            color: transaction['color'] as Color,
            size: 24,
          ),
        ),
        title: Text(
          transaction['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction['category'] as String,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              transaction['date'] as String,
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : ''}${CurrencyFormatter.format(amount.abs())}',
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        onTap: () => _showTransactionDetails(transaction),
      ),
    );
  }

  // Quick actions section
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Quick action buttons grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 1 / 1.2, // Adjusted aspect ratio for better fit
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildQuickActionButton(
              'Transfer',
              Icons.send,
              Colors.blue,
              () => _handleQuickAction('transfer'),
            ),
            _buildQuickActionButton(
              'Top Up',
              Icons.account_balance_wallet,
              Colors.green,
              () => _handleQuickAction('topup'),
            ),
            _buildQuickActionButton(
              'Bayar',
              Icons.payment,
              Colors.orange,
              () => _handleQuickAction('payment'),
            ),
            _buildQuickActionButton(
              'Lainnya',
              Icons.more_horiz,
              Colors.grey,
              () => _handleQuickAction('more'),
            ),
          ],
        ),
      ],
    );
  }

  // Individual quick action button
  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Event handlers dan utility methods

  // Refresh data dari server/database
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // TODO: Refresh data dari API
    });
  }

  // Refresh AI recommendation
  void _refreshAIRecommendation() {
    // TODO: Generate new AI recommendation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saran AI diperbarui'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Show notifications
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notifikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('Budget reminder'),
              subtitle: Text('Anda telah menggunakan 65% budget makanan'),
            ),
            const ListTile(
              leading: Icon(Icons.trending_up, color: Colors.green),
              title: Text('Tabungan mencapai target'),
              subtitle: Text('Selamat! Target tabungan bulan ini tercapai'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Show category details
  void _showCategoryDetails(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Kategori: $category'),
        content: Text('Fitur detail kategori akan segera tersedia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Show transaction details
  void _showTransactionDetails(Map<String, dynamic> transaction) {
    final double amount = (transaction['amount'] as num).toDouble();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori: ${transaction['category']}'),
            Text('Tanggal: ${transaction['date']}'),
            Text('Jumlah: ${CurrencyFormatter.format(amount)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Show active installments details
  void _showActiveInstallments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pengeluaran Tetap',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total pengeluaran tetap
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.amber),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pengeluaran Tetap',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        CurrencyFormatter.format(_totalInstallments),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Active installments list
            const Text(
              'Cicilan Aktif',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...List.generate(_activeInstallments.length, (index) {
              final installment = _activeInstallments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (installment['color'] as Color).withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      installment['icon'] as IconData,
                      color: installment['color'] as Color,
                    ),
                  ),
                  title: Text(
                    installment['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${installment['remainingMonths']} dari ${installment['totalMonths']} bulan',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        CurrencyFormatter.format(
                          (installment['amount'] as num).toDouble(),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: installment['color'] as Color,
                        ),
                      ),
                      const Text(
                        '/bulan',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.transaction);
                },
                icon: const Icon(Icons.list),
                label: const Text('Lihat Semua Transaksi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Handle quick actions
  void _handleQuickAction(String action) {
    switch (action) {
      case 'transfer':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur transfer akan segera tersedia')),
        );
        break;
      case 'topup':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur top up akan segera tersedia')),
        );
        break;
      case 'payment':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fitur pembayaran akan segera tersedia'),
          ),
        );
        break;
      case 'more':
        // Navigate to more options
        Navigator.pushNamed(context, AppRoutes.transaction);
        break;
    }
  }
}
