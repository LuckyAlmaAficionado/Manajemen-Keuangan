# Manajemen Keuangan

Aplikasi manajemen keuangan pribadi yang dibuat dengan Flutter untuk membantu mengelola pemasukan, pengeluaran, dan budget secara efektif dengan dukungan AI Analysis untuk rekomendasi personal.

## 🎯 Fitur Utama

- 📊 **Dashboard** - Ringkasan keuangan dan transaksi terbaru
- 💰 **Manajemen Transaksi** - Tambah, edit, dan hapus transaksi pemasukan/pengeluaran
- 📈 **Budget Tracking** - Pantau budget per kategori
- 📋 **Laporan Keuangan** - Analisis keuangan bulanan dan tahunan
- 👤 **Profil & Pengaturan** - Kelola data pribadi dan preferensi aplikasi
- 🤖 **AI Analysis** - Setup profil lengkap untuk rekomendasi keuangan AI

## 🆕 Fitur Baru: AI Analysis Setup

### Setup Profil Keuangan

Fitur baru yang memungkinkan pengguna mengatur profil lengkap untuk mendapatkan analisis AI yang personal:

#### 📍 **Input Wilayah**

- Pilih wilayah tempat tinggal dari dropdown
- Support custom input untuk wilayah yang tidak tersedia
- Digunakan untuk analisis biaya hidup regional

#### 🎨 **Deskripsi Gaya Hidup**

- **Tipe Gaya Hidup**: Sederhana, Moderat, Mewah, Hemat, Aktif
- **Deskripsi Detail**: Input bebas untuk menjelaskan aktivitas sehari-hari, hobi, kebiasaan belanja
- Minimal 10 karakter untuk validasi

#### 💵 **Input Pemasukan**

Dua metode input yang fleksibel:

- **Input Manual**: Ketik langsung nominal gaji/pemasukan bulanan
- **Upload Gambar**: Upload bukti gaji (slip gaji, kontrak kerja, dll)
  - Support galeri dan kamera
  - Auto resize dan compress gambar
  - Format yang didukung: JPG, PNG

#### 💳 **Cicilan Bulanan**

- Input total cicilan bulanan (KPR, cicilan mobil, dll)
- Periode cicilan dengan date picker
- Auto kalkulasi total cicilan dan durasi
- Support input 0 jika tidak ada cicilan

### 🤖 AI Analysis Features

#### **Data Export untuk AI**

- Generate structured data untuk AI analysis
- Format JSON yang comprehensive
- Include semua parameter profil dan preferensi

#### **AI Prompt Generator**

- Auto generate prompt lengkap untuk AI
- Include konteks lokasi, gaya hidup, income, dan installments
- Copy to clipboard untuk digunakan di ChatGPT/AI lainnya
- Template prompt yang sudah terstruktur

#### **Profile Completeness Indicator**

- Progress bar kelengkapan profil
- Scoring system berdasarkan data yang diisi
- Rekomendasi data yang masih perlu dilengkapi

## 📁 Struktur Proyek (Updated)

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/                   # Data models
│   ├── transaction.dart      # Model transaksi
│   ├── budget.dart          # Model budget
│   └── user_profile.dart    # Model profil pengguna (NEW)
├── screens/                  # UI Screens
│   ├── splash_screen.dart   # Splash screen
│   ├── home_screen.dart     # Main navigation screen
│   ├── dashboard_screen.dart # Dashboard utama dengan AI setup banner
│   ├── add_transaction_screen.dart # Form tambah transaksi
│   ├── edit_transaction_screen.dart # Form edit transaksi
│   ├── transaction_detail_screen.dart # Detail transaksi
│   ├── income_screen.dart   # Screen pemasukan
│   ├── expense_screen.dart  # Screen pengeluaran
│   ├── transaction_screen.dart # Daftar transaksi
│   ├── budget_screen.dart   # Manajemen budget
│   ├── report_screen.dart   # Laporan keuangan
│   ├── profile_screen.dart  # Profil pengguna dengan AI widget
│   ├── settings_screen.dart # Pengaturan aplikasi
│   └── user_profile_setup_screen.dart # Setup profil AI (NEW)
├── widgets/                  # Reusable widgets
│   ├── summary_card.dart    # Widget kartu ringkasan
│   ├── transaction_item.dart # Widget item transaksi
│   └── ai_analysis_widget.dart # Widget AI analysis (NEW)
├── services/                 # Business logic & services
│   ├── transaction_service.dart # Service manajemen transaksi
│   └── user_profile_service.dart # Service profil pengguna (NEW)
├── utils/                    # Utility functions
│   ├── currency_formatter.dart # Format mata uang
│   └── date_formatter.dart  # Format tanggal
└── routes/                   # Navigation & routing
    ├── app_routes.dart      # Definisi routes
    └── app_router.dart      # Router configuration
```

## 🎛️ Cara Menggunakan AI Analysis

### 1. Setup Profil

1. Buka aplikasi dan lihat banner "Setup Profil untuk AI Analysis" di Dashboard
2. Klik tombol "Setup" atau akses dari Profile → Setup Profil Keuangan
3. Isi data secara bertahap:
   - **Step 1**: Pilih wilayah tempat tinggal
   - **Step 2**: Pilih tipe gaya hidup dan deskripsi detail
   - **Step 3**: Input pemasukan (manual atau upload gambar)
   - **Step 4**: Input cicilan bulanan dan periode

### 2. Generate AI Prompt

1. Setelah setup selesai, buka Profile screen
2. Lihat widget "AI Analysis Data"
3. Klik tombol "Copy AI Prompt"
4. Paste prompt ke ChatGPT atau AI assistant lainnya

### 3. Contoh AI Prompt yang Dihasilkan

```
User Financial Profile Analysis Request:

Location: DKI Jakarta
Lifestyle: Moderat - Suka makan di restoran, hobi nonton film, belanja bulanan di mall

Income Information:
- Monthly Income: Rp 8,000,000
- Income Verification: Self-reported

Installment Information:
- Monthly Installments: Rp 2,500,000
- Duration: 24 months
- Total Amount: Rp 60,000,000
- Period: 2025-01-15 to 2027-01-15

Profile Completeness: 85.0%

Please provide:
1. Budget allocation recommendations
2. Savings strategy based on location and lifestyle
3. Financial goals suggestions
4. Risk assessment for current financial situation
5. Monthly expense categories and recommended limits
```

## � Screenshots & Navigation

### Dashboard dengan AI Setup Banner

- Banner promosi setup profil AI
- Quick access button untuk setup
- Summary cards tetap tersedia

### Multi-step Profile Setup

- Progress indicator 4 langkah
- Validasi di setiap step
- Support back/next navigation
- Auto-save di akhir

### Profile Screen dengan AI Widget

- Display kelengkapan profil
- Preview data yang akan dikirim ke AI
- Quick actions: Copy prompt, Edit profil
- Integration dengan settings

## 🔧 Dependencies Baru

```yaml
dependencies:
  intl: ^0.19.0 # Internationalization dan format currency
  image_picker: ^1.0.4 # Upload gambar dari galeri/kamera
  shared_preferences: ^2.2.2 # Local storage (future use)
```

## 🚀 Instalasi & Menjalankan

1. **Clone repository**

   ```bash
   git clone <repository-url>
   cd manajemen_keuangan
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run aplikasi**

   ```bash
   flutter run
   ```

4. **Setup profil AI** (Opsional)
   - Buka aplikasi
   - Klik "Setup" di banner Dashboard
   - Ikuti 4 langkah setup
   - Copy AI prompt untuk analysis

## 💡 Tips Penggunaan AI Analysis

### Untuk Hasil Terbaik:

1. **Lengkapi semua field** - Semakin lengkap data, semakin akurat rekomendasi
2. **Deskripsi detail** - Jelaskan gaya hidup dengan spesifik
3. **Update berkala** - Update profil jika ada perubahan income/lifestyle
4. **Gunakan prompt** - Copy prompt ke ChatGPT untuk rekomendasi personal

### Contoh Pertanyaan Follow-up untuk AI:

- "Berapa idealnya emergency fund berdasarkan profil saya?"
- "Rekomendasikan alokasi budget bulanan yang optimal"
- "Strategi investasi yang cocok untuk profil risiko saya"
- "Tips menghemat pengeluaran di Jakarta dengan gaya hidup moderat"

## 🛡️ Privacy & Security

- **Data Local**: Semua data profil disimpan lokal di device
- **No Cloud Sync**: Tidak ada sinkronisasi ke server external
- **Manual Export**: User kontrol penuh kapan data dibagikan ke AI
- **Image Storage**: Gambar bukti gaji disimpan lokal, tidak diunggah

## 🔮 Roadmap

### Phase 1 - MVP (✅ COMPLETED)

- ✅ Setup struktur proyek
- ✅ Routing dan navigasi
- ✅ UI template screens
- ✅ Model data dasar
- ✅ Service layer dasar
- ✅ AI Analysis setup flow
- ✅ Profile management
- ✅ Image upload functionality

### Phase 2 - Data Integration

- [ ] SQLite database integration
- [ ] Data persistence
- [ ] Transaction CRUD dengan database
- [ ] Profile sync dengan transactions

### Phase 3 - AI Enhancement

- [ ] Direct AI integration (OpenAI API)
- [ ] Real-time analysis
- [ ] Automated recommendations
- [ ] Budget optimization suggestions

### Phase 4 - Advanced Features

- [ ] Export data ke CSV/PDF
- [ ] Cloud backup (optional)
- [ ] Multi-currency support
- [ ] Investment tracking
- [ ] Goal planning dengan AI

## 🤝 Kontribusi

Proyek ini terbuka untuk kontribusi. Fitur AI Analysis masih bisa dikembangkan lebih lanjut:

### Areas for Improvement:

- Direct AI API integration
- More sophisticated prompt engineering
- Real-time analysis dashboard
- Machine learning untuk pattern recognition
- Advanced visualization untuk AI insights

## 📄 Lisensi

MIT License - Silakan gunakan untuk keperluan pribadi atau komersial.

---

**⚡ Quick Start untuk AI Analysis:**

1. Run app → 2. Klik "Setup" di Dashboard → 3. Isi 4 langkah setup → 4. Copy AI prompt dari Profile → 5. Paste ke ChatGPT!
