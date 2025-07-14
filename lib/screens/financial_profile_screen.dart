import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';
import '../utils/currency_formatter.dart';

class FinancialProfileScreen extends StatefulWidget {
  const FinancialProfileScreen({super.key});

  @override
  State<FinancialProfileScreen> createState() => _FinancialProfileScreenState();
}

class _FinancialProfileScreenState extends State<FinancialProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  UserProfile? _currentProfile;
  bool _isLoading = false;
  bool _isEditing = false;

  // Form Controllers
  final _wilayahController = TextEditingController();
  final _lifestyleDescController = TextEditingController();
  final _incomeController = TextEditingController();

  // Form Values
  LifestyleType _selectedLifestyle = LifestyleType.moderat;
  File? _incomeProofImage;
  bool _useImageProof = false;

  // Multiple Installments
  List<InstallmentItem> _installments = [];

  final List<String> _wilayahOptions = [
    'DKI Jakarta',
    'Jawa Barat',
    'Jawa Tengah',
    'Jawa Timur',
    'Sumatera Utara',
    'Sumatera Barat',
    'Sumatera Selatan',
    'Bali',
    'Kalimantan Timur',
    'Sulawesi Selatan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await UserProfileService().loadProfile();
      if (profile != null) {
        setState(() {
          _currentProfile = profile;
          _populateForm(profile);
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateForm(UserProfile profile) {
    _wilayahController.text = profile.wilayah;
    _lifestyleDescController.text = profile.lifestyleDescription;
    _selectedLifestyle = profile.lifestyleType;
    _incomeController.text = profile.monthlyIncome > 0
        ? profile.monthlyIncome.toString()
        : '';
    _incomeProofImage = profile.incomeProofImage;
    _useImageProof = profile.incomeProofImage != null;

    // Convert single installment to list format
    if (profile.monthlyInstallments > 0) {
      _installments = [
        InstallmentItem(
          name: 'Cicilan',
          amount: profile.monthlyInstallments,
          startDate: profile.installmentStartDate,
          endDate: profile.installmentEndDate,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Keuangan'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          if (_currentProfile != null)
            IconButton(
              onPressed: () => _copyAIPrompt(),
              icon: const Icon(Icons.copy),
              tooltip: 'Copy AI Prompt',
            ),
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            tooltip: _isEditing ? 'Simpan' : 'Edit',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentProfile == null && !_isEditing
          ? _buildEmptyState()
          : _buildProfileContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Setup Profil Keuangan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Atur profil keuangan Anda untuk mendapatkan analisis AI yang personal dan rekomendasi keuangan yang tepat.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Setup Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentProfile != null && !_isEditing) ...[
              _buildProfileSummaryCard(),
              const SizedBox(height: 16),
              _buildInstallmentsSummaryCard(),
              const SizedBox(height: 16),
              _buildAIAnalysisCard(),
              const SizedBox(height: 16),
            ],

            if (_isEditing) ...[
              _buildWilayahSection(),
              const SizedBox(height: 24),
              _buildLifestyleSection(),
              const SizedBox(height: 24),
              _buildIncomeSection(),
              const SizedBox(height: 24),
              _buildInstallmentsSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Ringkasan Keuangan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDataRow(
              'Wilayah',
              _currentProfile!.wilayah,
              Icons.location_on,
            ),
            _buildDataRow(
              'Gaya Hidup',
              _currentProfile!.lifestyleDisplayName,
              Icons.style,
            ),
            _buildDataRow(
              'Pemasukan',
              _currentProfile!.incomeProofImage != null
                  ? 'Bukti Gambar'
                  : CurrencyFormatter.format(_currentProfile!.monthlyIncome),
              Icons.attach_money,
            ),
            _buildDataRow(
              'Total Cicilan',
              CurrencyFormatter.format(_getTotalInstallments()),
              Icons.payment,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _currentProfile!.calculateCompleteness(),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getCompletenessColor(_currentProfile!.calculateCompleteness()),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelengkapan Data: ${(_currentProfile!.calculateCompleteness() * 100).toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _getCompletenessColor(
                  _currentProfile!.calculateCompleteness(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentsSummaryCard() {
    if (_installments.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.orange[700]),
                const SizedBox(width: 8),
                const Text(
                  'Daftar Cicilan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._installments.map(
              (installment) => _buildInstallmentSummaryItem(installment),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total per Bulan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  CurrencyFormatter.format(_getTotalInstallments()),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentSummaryItem(InstallmentItem installment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  installment.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${_formatDate(installment.startDate)} - ${_formatDate(installment.endDate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(installment.amount),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Cicilan Bulanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              onPressed: _addInstallment,
              icon: const Icon(Icons.add_circle),
              tooltip: 'Tambah Cicilan',
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_installments.isEmpty)
          Card(
            color: Colors.grey[100],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('Belum ada cicilan. Tap + untuk menambah.'),
                ],
              ),
            ),
          )
        else
          ..._installments.asMap().entries.map((entry) {
            int index = entry.key;
            InstallmentItem installment = entry.value;
            return _buildInstallmentCard(installment, index);
          }),

        if (_installments.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Cicilan per Bulan:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(_getTotalInstallments()),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInstallmentCard(InstallmentItem installment, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    installment.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => _editInstallment(index),
                  icon: const Icon(Icons.edit, size: 20),
                ),
                IconButton(
                  onPressed: () => _removeInstallment(index),
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.payment, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('Amount: ${CurrencyFormatter.format(installment.amount)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${_formatDate(installment.startDate)} - ${_formatDate(installment.endDate)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, IconData icon) {
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

  Widget _buildAIAnalysisCard() {
    return Card(
      color: Colors.purple[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple[700]),
                const SizedBox(width: 8),
                const Text(
                  'AI Analysis Ready',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Data keuangan Anda siap untuk analisis AI. Dapatkan rekomendasi personal untuk pengelolaan keuangan yang lebih baik.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _copyAIPrompt,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy AI Prompt'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showAIPromptDialog,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Preview'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ... existing build methods for wilayah, lifestyle, income sections ...

  Widget _buildWilayahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wilayah Tempat Tinggal',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _wilayahOptions.contains(_wilayahController.text)
              ? _wilayahController.text
              : null,
          decoration: const InputDecoration(
            labelText: 'Pilih Wilayah',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          items: _wilayahOptions.map((wilayah) {
            return DropdownMenuItem(value: wilayah, child: Text(wilayah));
          }).toList(),
          onChanged: (value) {
            if (value == 'Lainnya') {
              _showCustomWilayahDialog();
            } else {
              _wilayahController.text = value ?? '';
            }
          },
          validator: (value) {
            if (_wilayahController.text.isEmpty) {
              return 'Wilayah harus dipilih';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLifestyleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gaya Hidup',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: LifestyleType.values.map((type) {
            return ChoiceChip(
              label: Text(_getLifestyleDisplayName(type)),
              selected: _selectedLifestyle == type,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedLifestyle = type;
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lifestyleDescController,
          decoration: const InputDecoration(
            labelText: 'Deskripsi Gaya Hidup',
            hintText:
                'Ceritakan aktivitas sehari-hari, hobi, kebiasaan belanja, dll.',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().length < 10) {
              return 'Deskripsi minimal 10 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildIncomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pemasukan Bulanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Input Manual'),
                value: false,
                groupValue: _useImageProof,
                onChanged: (value) {
                  setState(() {
                    _useImageProof = value!;
                    if (!_useImageProof) {
                      _incomeProofImage = null;
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Upload Gambar'),
                value: true,
                groupValue: _useImageProof,
                onChanged: (value) {
                  setState(() {
                    _useImageProof = value!;
                    if (_useImageProof) {
                      _incomeController.clear();
                    }
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (!_useImageProof) ...[
          TextFormField(
            controller: _incomeController,
            decoration: const InputDecoration(
              labelText: 'Pemasukan Bulanan',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (!_useImageProof && (value == null || value.isEmpty)) {
                return 'Pemasukan harus diisi';
              }
              return null;
            },
          ),
        ] else ...[
          InkWell(
            onTap: () => _showImagePickerDialog(),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _incomeProofImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_incomeProofImage!, fit: BoxFit.cover),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap untuk upload bukti gaji'),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickIncomeProofImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeri'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickIncomeProofImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Kamera'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveProfile,
        icon: const Icon(Icons.save),
        label: const Text('Simpan Profil Keuangan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  // Installment Management Methods
  void _addInstallment() {
    _showInstallmentDialog();
  }

  void _editInstallment(int index) {
    _showInstallmentDialog(installment: _installments[index], index: index);
  }

  void _removeInstallment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cicilan'),
        content: Text(
          'Apakah Anda yakin ingin menghapus cicilan "${_installments[index].name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _installments.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showInstallmentDialog({InstallmentItem? installment, int? index}) {
    final nameController = TextEditingController(text: installment?.name ?? '');
    final amountController = TextEditingController(
      text: installment?.amount.toString() ?? '',
    );
    DateTime startDate = installment?.startDate ?? DateTime.now();
    DateTime endDate =
        installment?.endDate ?? DateTime.now().add(const Duration(days: 365));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(installment == null ? 'Tambah Cicilan' : 'Edit Cicilan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Cicilan',
                    hintText: 'KPR, Mobil, dll.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah per Bulan',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 10),
                            ),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              startDate = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Mulai',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(_formatDate(startDate)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: endDate,
                            firstDate: startDate,
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 10),
                            ),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              endDate = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Selesai',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(_formatDate(endDate)),
                        ),
                      ),
                    ),
                  ],
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
                if (nameController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  final newInstallment = InstallmentItem(
                    name: nameController.text,
                    amount: double.parse(amountController.text),
                    startDate: startDate,
                    endDate: endDate,
                  );

                  setState(() {
                    if (index != null) {
                      _installments[index] = newInstallment;
                    } else {
                      _installments.add(newInstallment);
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(installment == null ? 'Tambah' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  double _getTotalInstallments() {
    return _installments.fold(
      0,
      (sum, installment) => sum + installment.amount,
    );
  }

  // Helper Methods
  Color _getCompletenessColor(double completeness) {
    if (completeness >= 0.8) return Colors.green;
    if (completeness >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _getLifestyleDisplayName(LifestyleType type) {
    switch (type) {
      case LifestyleType.sederhana:
        return 'Sederhana';
      case LifestyleType.moderat:
        return 'Moderat';
      case LifestyleType.mewah:
        return 'Mewah';
      case LifestyleType.hemat:
        return 'Hemat';
      case LifestyleType.aktif:
        return 'Aktif';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showImagePickerDialog() {
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
                _pickIncomeProofImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickIncomeProofImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomWilayahDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Wilayah'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nama Wilayah',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _wilayahController.text = controller.text;
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIncomeProofImage([ImageSource? source]) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source ?? ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _incomeProofImage = File(image.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar berhasil dipilih'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final profile = UserProfile(
        id:
            _currentProfile?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        wilayah: _wilayahController.text,
        lifestyleType: _selectedLifestyle,
        lifestyleDescription: _lifestyleDescController.text,
        monthlyIncome: _useImageProof
            ? 0
            : (double.tryParse(_incomeController.text) ?? 0),
        incomeProofImage: _incomeProofImage,
        monthlyInstallments: _getTotalInstallments(),
        installmentStartDate: _installments.isNotEmpty
            ? _installments.first.startDate
            : DateTime.now(),
        installmentEndDate: _installments.isNotEmpty
            ? _installments.last.endDate
            : DateTime.now(),
        createdAt: _currentProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await UserProfileService().saveProfile(profile);

      setState(() {
        _currentProfile = profile;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil keuangan berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyAIPrompt() {
    final prompt = UserProfileService().generateAIPrompt();
    Clipboard.setData(ClipboardData(text: prompt));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI Prompt berhasil disalin ke clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAIPromptDialog() {
    final prompt = UserProfileService().generateAIPrompt();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Prompt Preview'),
        content: SingleChildScrollView(
          child: Text(prompt, style: const TextStyle(fontSize: 12)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _copyAIPrompt();
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _wilayahController.dispose();
    _lifestyleDescController.dispose();
    _incomeController.dispose();
    super.dispose();
  }
}

class InstallmentItem {
  final String name;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;

  InstallmentItem({
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });
}
