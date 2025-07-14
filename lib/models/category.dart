import 'package:flutter/material.dart';

/// Enum untuk kategori budget dengan properti tambahan.
enum Category { makanan, transportasi, belanja, hiburan, tagihan, lainnya }

/// Extension untuk menambahkan properti seperti nama tampilan, ikon, dan warna ke enum [Category].
extension CategoryExtension on Category {
  String get displayName {
    switch (this) {
      case Category.makanan:
        return 'Makanan & Minuman';
      case Category.transportasi:
        return 'Transportasi';
      case Category.belanja:
        return 'Belanja';
      case Category.hiburan:
        return 'Hiburan';
      case Category.tagihan:
        return 'Tagihan & Utilitas';
      case Category.lainnya:
        return 'Lainnya';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.makanan:
        return Icons.restaurant;
      case Category.transportasi:
        return Icons.directions_car;
      case Category.belanja:
        return Icons.shopping_bag;
      case Category.hiburan:
        return Icons.movie;
      case Category.tagihan:
        return Icons.receipt;
      case Category.lainnya:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case Category.makanan:
        return Colors.orange;
      case Category.transportasi:
        return Colors.blue;
      case Category.belanja:
        return Colors.purple;
      case Category.hiburan:
        return Colors.pink;
      case Category.tagihan:
        return Colors.red;
      case Category.lainnya:
        return Colors.grey;
    }
  }
}
