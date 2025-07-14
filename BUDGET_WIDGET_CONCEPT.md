# Konsep Widget: "Buat Budget Baru"

Berikut adalah ide dan konsep untuk widget "Buat Budget Baru" yang akan diimplementasikan di dalam menu "Atur Budget".

## 🎯 Tujuan Widget

- Memberikan antarmuka yang **intuitif dan mudah digunakan** bagi pengguna untuk membuat budget baru untuk kategori pengeluaran.
- Memastikan semua data yang diperlukan (nama, jumlah, ikon, warna) dapat diinput dengan validasi yang tepat.
- Terintegrasi secara mulus dengan `BudgetScreen` yang sudah ada.

## ✨ Desain Antarmuka (UI)

Widget ini akan muncul sebagai **modal bottom sheet** yang dapat di-scroll, berisi sebuah form dengan komponen berikut:

1.  **Nama Kategori (`TextFormField`)**

    - Input teks untuk nama budget (e.g., "Pendidikan", "Hadiah").
    - Validasi: Tidak boleh kosong.

2.  **Jumlah Budget (`TextFormField`)**

    - Input angka untuk menentukan alokasi dana.
    - Menggunakan `CurrencyFormatter` untuk format Rupiah.
    - Validasi: Tidak boleh kosong dan harus lebih dari 0.

3.  **Pilihan Ikon (`Wrap` of `GestureDetector`)**

    - Grid berisi berbagai ikon yang relevan untuk kategori budget.
    - Pengguna dapat memilih satu ikon yang paling sesuai.
    - Ikon yang dipilih akan memiliki highlight (border atau background) untuk feedback visual.

4.  **Pilihan Warna (`Wrap` of `GestureDetector`)**

    - Grid berisi palet warna yang menarik.
    - Pengguna dapat memilih satu warna untuk merepresentasikan budget tersebut di seluruh aplikasi.
    - Warna yang dipilih akan memiliki highlight.

5.  **Tombol "Simpan Budget" (`ElevatedButton`)**
    - Tombol utama untuk memvalidasi form dan menyimpan data budget baru.
    - Setelah disimpan, modal akan tertutup dan `BudgetScreen` akan diperbarui.

## ⚙️ Logika dan Fungsionalitas

1.  **State Management**: Widget akan menggunakan `StatefulWidget` untuk mengelola input dari form (controller, ikon terpilih, warna terpilih).
2.  **Validasi Form**: Menggunakan `GlobalKey<FormState>` untuk memastikan semua input valid sebelum data disimpan.
3.  **Callback Function**: Widget akan menerima fungsi `onSave` dari `BudgetScreen`. Ketika form disimpan, data (kategori, jumlah, ikon, warna) akan dikirim kembali ke `BudgetScreen` melalui callback ini.
4.  **Pembaruan UI**: `BudgetScreen` akan menerima data baru, menambahkannya ke dalam list `_budgetCategories`, dan memanggil `setState` untuk secara otomatis me-render ulang daftar budget dengan item yang baru.
5.  **Modularitas**: Widget ini akan dibuat dalam file terpisah (`lib/widgets/create_budget_form.dart`) agar kode tetap bersih dan mudah dikelola.

## 📊 Data yang Diperlukan

Berdasarkan data yang ada di `BudgetScreen`, widget ini akan mengumpulkan data berikut untuk membuat entri baru di `_budgetCategories`:

- **`category` (String)**: Kunci utama untuk map budget.
- **`budgetAmount` (double)**: Jumlah dana yang dialokasikan.
- **`icon` (IconData)**: Ikon untuk representasi visual.
- **`color` (Color)**: Warna untuk representasi visual.
- **`spentAmount` (double)**: Akan diinisialisasi dengan nilai `0.0` secara default untuk budget baru.

Dengan konsep ini, fitur "Buat Budget" akan menjadi sangat fungsional, interaktif, dan memperkaya pengalaman pengguna dalam mengelola keuangan mereka.
