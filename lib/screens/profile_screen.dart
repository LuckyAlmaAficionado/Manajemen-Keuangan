import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'John Doe';
  String _userEmail = 'john.doe@email.com';
  String _userPhone = '+62 812 3456 7890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.teal[700],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _changeProfilePicture,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.teal[700],
                            ),
                            iconSize: 20,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActionCard(
                    'Profil Keuangan',
                    'Atur data keuangan untuk AI analysis',
                    Icons.account_balance_wallet,
                    Colors.green,
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.financialProfile,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Edit Profil Personal',
                    'Ubah nama, email, dan informasi personal',
                    Icons.edit,
                    Colors.blue,
                    () => _showEditProfileDialog(),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Keamanan',
                    'Ganti password dan pengaturan keamanan',
                    Icons.security,
                    Colors.orange,
                    () => _showSecurityOptions(),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Notifikasi',
                    'Atur preferensi notifikasi',
                    Icons.notifications,
                    Colors.purple,
                    () => _showNotificationSettings(),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Bantuan & Dukungan',
                    'FAQ, kontak support, dan panduan',
                    Icons.help,
                    Colors.indigo,
                    () => _showHelpSupport(),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Tentang Aplikasi',
                    'Versi aplikasi dan informasi developer',
                    Icons.info,
                    Colors.grey,
                    () => _showAboutDialog(context),
                  ),
                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showLogoutDialog,
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Keluar', style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement image picker from gallery
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur akan segera tersedia')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera capture
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur akan segera tersedia')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Hapus Foto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement remove profile picture
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Foto profil dihapus')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telefon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text;
                _userEmail = emailController.text;
                _userPhone = phoneController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil berhasil diperbarui'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showSecurityOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Keamanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Ganti Password'),
              onTap: () {
                Navigator.pop(context);
                _showChangePasswordDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Autentikasi Biometrik'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Implement biometric toggle
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Verifikasi 2 Langkah'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: Implement 2FA toggle
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ganti Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Saat Ini',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password change logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password berhasil diubah'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Ubah'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Pengaturan Notifikasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: const Text('Notifikasi Transaksi'),
              subtitle: const Text('Notifikasi saat ada transaksi baru'),
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
            ),
            SwitchListTile(
              title: const Text('Reminder Budget'),
              subtitle: const Text('Pengingat saat mendekati batas budget'),
              value: true,
              onChanged: (value) {
                // TODO: Implement budget reminder toggle
              },
            ),
            SwitchListTile(
              title: const Text('Laporan Bulanan'),
              subtitle: const Text('Laporan keuangan setiap akhir bulan'),
              value: false,
              onChanged: (value) {
                // TODO: Implement monthly report toggle
              },
            ),
            SwitchListTile(
              title: const Text('Tips Keuangan'),
              subtitle: const Text('Tips dan rekomendasi keuangan harian'),
              value: true,
              onChanged: (value) {
                // TODO: Implement financial tips toggle
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showHelpSupport() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Bantuan & Dukungan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('FAQ'),
              subtitle: const Text('Pertanyaan yang sering diajukan'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to FAQ screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('FAQ akan segera tersedia')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Hubungi Support'),
              subtitle: const Text('Chat dengan tim support kami'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open contact support
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support: support@manajemen-keuangan.com'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Panduan Pengguna'),
              subtitle: const Text('Tutorial lengkap penggunaan aplikasi'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to user guide
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Panduan akan segera tersedia')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Beri Feedback'),
              subtitle: const Text('Bantu kami meningkatkan aplikasi'),
              onTap: () {
                Navigator.pop(context);
                _showFeedbackDialog();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Beri Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Bagaimana pengalaman Anda menggunakan aplikasi ini?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setDialogState(() {
                        rating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Feedback (opsional)',
                  border: OutlineInputBorder(),
                  hintText: 'Ceritakan pengalaman Anda...',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terima kasih atas feedback Anda!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Berhasil keluar'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Manajemen Keuangan',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.account_balance_wallet,
        size: 48,
        color: Colors.teal[700],
      ),
      children: [
        const Text(
          'Aplikasi manajemen keuangan pribadi dengan fitur AI analysis untuk rekomendasi keuangan yang personal.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Fitur utama:\n'
          '• Tracking pemasukan & pengeluaran\n'
          '• Budget management\n'
          '• Multiple installments tracking\n'
          '• AI analysis & recommendations\n'
          '• Laporan keuangan\n'
          '• Export data',
        ),
        const SizedBox(height: 16),
        const Text(
          'Developed with ❤️ by Your Development Team\n'
          'Copyright © 2025',
        ),
      ],
    );
  }
}
