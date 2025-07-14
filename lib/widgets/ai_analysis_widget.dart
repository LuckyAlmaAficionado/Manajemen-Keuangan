import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';
import '../utils/currency_formatter.dart';
import '../routes/app_routes.dart';

class AIAnalysisWidget extends StatelessWidget {
  final UserProfile? profile;

  const AIAnalysisWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return _buildNoProfileCard(context);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'AI Analysis Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showFullAnalysisData(context),
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Detail Lengkap',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Completeness
            _buildCompletenessIndicator(),
            const SizedBox(height: 16),

            // Key Data Points
            _buildDataPoint('Wilayah', profile!.wilayah, Icons.location_on),
            _buildDataPoint(
              'Gaya Hidup',
              profile!.lifestyleDisplayName,
              Icons.style,
            ),
            _buildDataPoint(
              'Pemasukan',
              profile!.incomeProofImage != null
                  ? 'Bukti Gambar'
                  : CurrencyFormatter.format(profile!.monthlyIncome),
              Icons.attach_money,
            ),
            _buildDataPoint(
              'Cicilan',
              CurrencyFormatter.format(profile!.monthlyInstallments),
              Icons.payment,
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _copyAIPrompt(context),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy AI Prompt'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoProfileCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.person_add, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Profil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Setup profil Anda untuk mendapatkan analisis AI yang personal dan rekomendasi keuangan yang tepat.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
              icon: const Icon(Icons.add),
              label: const Text('Setup Profil Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletenessIndicator() {
    final completeness = profile!.calculateCompleteness();
    final percentage = (completeness * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kelengkapan Profil',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getCompletenessColor(completeness),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: completeness,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getCompletenessColor(completeness),
          ),
        ),
      ],
    );
  }

  Color _getCompletenessColor(double completeness) {
    if (completeness >= 0.8) return Colors.green;
    if (completeness >= 0.6) return Colors.orange;
    return Colors.red;
  }

  Widget _buildDataPoint(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  void _showFullAnalysisData(BuildContext context) {
    final analysisData = profile!.toAIAnalysisData();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Lengkap untuk AI'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnalysisSection('Location', analysisData['location']),
              const SizedBox(height: 12),
              _buildAnalysisSection(
                'Lifestyle',
                '${analysisData['lifestyle']['type']} - ${analysisData['lifestyle']['description']}',
              ),
              const SizedBox(height: 12),
              _buildAnalysisSection(
                'Income',
                'Monthly: ${analysisData['income']['monthly_amount']}\nHas Proof: ${analysisData['income']['has_proof']}',
              ),
              const SizedBox(height: 12),
              _buildAnalysisSection(
                'Installments',
                'Monthly: ${analysisData['installments']['monthly_amount']}\nTotal Months: ${analysisData['installments']['total_months']}\nTotal Amount: ${analysisData['installments']['total_amount']}',
              ),
              const SizedBox(height: 12),
              _buildAnalysisSection(
                'Completeness',
                '${(analysisData['profile_completeness'] * 100).toStringAsFixed(1)}%',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _copyAIPrompt(context);
            },
            child: const Text('Copy Prompt'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(content, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _copyAIPrompt(BuildContext context) {
    final prompt = UserProfileService().generateAIPrompt();
    Clipboard.setData(ClipboardData(text: prompt));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI Prompt berhasil disalin ke clipboard!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
