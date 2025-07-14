import 'package:flutter/material.dart';
import 'package:manajemen_keuangan/widgets/create_budget_form.dart';
import '../utils/currency_formatter.dart';
import '../routes/app_routes.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // Data dummy untuk demo budget
  final double _totalBudget = 8000000.0;
  final double _totalSpent = 3250000.0;

  // Budget per kategori
  final Map<String, Map<String, dynamic>> _budgetCategories = {
    'Makanan': {
      'budgetAmount': 2000000.0,
      'spentAmount': 1200000.0,
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    'Transportasi': {
      'budgetAmount': 1000000.0,
      'spentAmount': 500000.0,
      'icon': Icons.directions_car,
      'color': Colors.blue,
    },
    'Belanja': {
      'budgetAmount': 1500000.0,
      'spentAmount': 800000.0,
      'icon': Icons.shopping_bag,
      'color': Colors.purple,
    },
    'Hiburan': {
      'budgetAmount': 500000.0,
      'spentAmount': 350000.0,
      'icon': Icons.movie,
      'color': Colors.pink,
    },
    'Tagihan': {
      'budgetAmount': 800000.0,
      'spentAmount': 400000.0,
      'icon': Icons.receipt,
      'color': Colors.red,
    },
    'Tabungan': {
      'budgetAmount': 2200000.0,
      'spentAmount': 1500000.0,
      'icon': Icons.savings,
      'color': Colors.green,
    },
  };

  // Data dinamis untuk target tabungan
  final List<Map<String, dynamic>> _savingsGoals = [
    {
      'title': 'Emergency Fund',
      'targetAmount': 12000000.0,
      'currentAmount': 8000000.0,
      'icon': Icons.security,
      'color': Colors.green,
    },
    {
      'title': 'Liburan Bali',
      'targetAmount': 8000000.0,
      'currentAmount': 3200000.0,
      'icon': Icons.beach_access,
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Budget'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol analisis
          IconButton(
            onPressed: () => _showBudgetAnalytics(),
            icon: const Icon(Icons.analytics),
            tooltip: 'Analisis Budget',
          ),
          // Tombol pengaturan
          IconButton(
            onPressed: () => _showBudgetSettings(),
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBudgetData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Budget Overview Header
              _buildBudgetOverview(),

              // Main content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions
                    _buildQuickActions(),

                    const SizedBox(height: 24),

                    // Budget Categories
                    _buildBudgetCategories(),

                    const SizedBox(height: 24),

                    // Budget Insights
                    _buildBudgetInsights(),

                    const SizedBox(height: 24),

                    // Savings Goals
                    _buildSavingsGoals(),

                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBudgetModal(),
        icon: const Icon(Icons.add),
        label: const Text('Budget Baru'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
    );
  }

  // Budget Overview Header dengan progress
  Widget _buildBudgetOverview() {
    final double spentPercentage = (_totalSpent / _totalBudget) * 100;
    final double remaining = _totalBudget - _totalSpent;

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
            // Header info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget Juli 2025',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pantau pengeluaran Anda',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${spentPercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Budget amounts
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Budget',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        CurrencyFormatter.format(_totalBudget),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Tersisa',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        CurrencyFormatter.format(remaining),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terpakai: ${CurrencyFormatter.format(_totalSpent)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${spentPercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: spentPercentage / 100,
                  backgroundColor: Colors.white30,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    spentPercentage > 80 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quick Actions buttons
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Buat Budget',
                Icons.add_chart,
                Colors.blue,
                () => _showCreateBudgetModal(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Analisis',
                Icons.analytics,
                Colors.green,
                () => _showBudgetAnalytics(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Target Tabungan',
                Icons.savings,
                Colors.orange,
                () => _showAddSavingsGoalModal(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Quick action card
  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Budget Categories Section
  Widget _buildBudgetCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Budget per Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _showAllCategories(),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _budgetCategories.length,
          itemBuilder: (context, index) {
            final category = _budgetCategories.keys.elementAt(index);
            final data = _budgetCategories[category]!;

            return _buildBudgetCategoryCard(
              category,
              (data['budgetAmount'] as num).toDouble(),
              (data['spentAmount'] as num).toDouble(),
              data['icon'] as IconData,
              data['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  // Budget Category Card
  Widget _buildBudgetCategoryCard(
    String category,
    double budgetAmount,
    double spentAmount,
    IconData icon,
    Color color,
  ) {
    final double percentage = (spentAmount / budgetAmount) * 100;
    final double remaining = budgetAmount - spentAmount;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showCategoryDetails(category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Budget: ${CurrencyFormatter.format(budgetAmount)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: percentage > 100 ? Colors.red : color,
                        ),
                      ),
                      Text(
                        'Sisa: ${CurrencyFormatter.format(remaining)}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Terpakai: ${CurrencyFormatter.format(spentAmount)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        percentage > 100 ? '⚠️ Over Budget' : '✅ On Track',
                        style: TextStyle(
                          fontSize: 12,
                          color: percentage > 100 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage > 100 ? 1.0 : percentage / 100,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage > 100 ? Colors.red : color,
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

  // Budget Insights Section
  Widget _buildBudgetInsights() {
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lightbulb,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Insights Budget',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildInsightItem(
                '📊',
                'Budget Adherence',
                '82% (Baik)',
                Colors.green,
              ),
              _buildInsightItem(
                '⚠️',
                'Kategori Berisiko',
                'Makanan (120%)',
                Colors.red,
              ),
              _buildInsightItem(
                '💰',
                'Potensi Penghematan',
                'Rp 400.000/bulan',
                Colors.blue,
              ),
              _buildInsightItem(
                '🎯',
                'Rekomendasi',
                'Kurangi makan luar 3x/minggu',
                Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Insight Item
  Widget _buildInsightItem(
    String emoji,
    String title,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Savings Goals Section
  void _showAddSavingsGoalModal() {
    String title = '';
    double targetAmount = 0;
    IconData icon = Icons.savings;
    Color color = Colors.purple;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Wrap(
            children: [
              const Text(
                'Buat Target Tabungan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nama Target',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                onChanged: (v) => title = v,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nominal Target (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    targetAmount = double.tryParse(v.replaceAll('.', '')) ?? 0,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (title.isNotEmpty && targetAmount > 0) {
                        setState(() {
                          _savingsGoals.add({
                            'title': title,
                            'targetAmount': targetAmount,
                            'currentAmount': 0.0,
                            'icon': icon,
                            'color': color,
                          });
                        });
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Target Tabungan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _showAddSavingsGoalModal,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._savingsGoals.map(
          (goal) => Column(
            children: [
              _buildSavingsGoalCard(
                goal['title'],
                goal['targetAmount'],
                goal['currentAmount'],
                goal['icon'],
                goal['color'],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  // Savings Goal Card
  Widget _buildSavingsGoalCard(
    String title,
    double targetAmount,
    double currentAmount,
    IconData icon,
    Color color,
  ) {
    final double percentage = (currentAmount / targetAmount) * 100;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Target: ${CurrencyFormatter.format(targetAmount)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                  ),
                  tooltip: 'Update Progress',
                  onPressed: () => _showUpdateSavingsProgressModal(title),
                ),
              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terkumpul: ${CurrencyFormatter.format(currentAmount)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Sisa: ${CurrencyFormatter.format(targetAmount - currentAmount)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateSavingsProgressModal(String goalTitle) {
    double addAmount = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Wrap(
            children: [
              const Text(
                'Update Progress Tabungan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Target: $goalTitle'),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nominal Tambahan (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    addAmount = double.tryParse(v.replaceAll('.', '')) ?? 0,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (addAmount > 0) {
                        setState(() {
                          final idx = _savingsGoals.indexWhere(
                            (goal) => goal['title'] == goalTitle,
                          );
                          if (idx != -1) {
                            _savingsGoals[idx]['currentAmount'] += addAmount;
                          }
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Progress tabungan "$goalTitle" berhasil diupdate!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Event Handlers
  Future<void> _refreshBudgetData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // TODO: Refresh budget data
    });
  }

  void _showCreateBudgetModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: CreateBudgetForm(
            onSubmit: (budget) {
              // TODO: Integrasi dengan state management atau database
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Budget "${budget.name}" berhasil dibuat!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              setState(() {
                // Tambahkan ke data dummy jika ingin demo
                // _budgetCategories[budget.category.displayName] = {
                //   'budgetAmount': budget.amount,
                //   'spentAmount': 0.0,
                //   'icon': budget.category.icon,
                //   'color': budget.category.color,
                // };
              });
            },
          ),
        ),
      ),
    );
  }

  void _showBudgetAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Budget Analytics'),
        content: const Text('Fitur analisis budget akan segera tersedia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showBudgetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan Budget'),
        content: const Text('Fitur pengaturan budget akan segera tersedia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showBudgetReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Laporan Budget'),
        content: const Text('Fitur laporan budget akan segera tersedia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAllCategories() {
    Navigator.pushNamed(context, AppRoutes.expense);
  }

  void _showCategoryDetails(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Budget $category'),
        content: Text('Detail budget untuk kategori $category'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
