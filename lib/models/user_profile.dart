import 'dart:io';

enum LifestyleType { sederhana, moderat, mewah, hemat, aktif }

class UserProfile {
  final String id;
  final String wilayah;
  final LifestyleType lifestyleType;
  final String lifestyleDescription;
  final double monthlyIncome;
  final File? incomeProofImage;
  final double monthlyInstallments;
  final DateTime installmentStartDate;
  final DateTime installmentEndDate;
  final Map<String, dynamic> additionalData;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.wilayah,
    required this.lifestyleType,
    required this.lifestyleDescription,
    required this.monthlyIncome,
    this.incomeProofImage,
    required this.monthlyInstallments,
    required this.installmentStartDate,
    required this.installmentEndDate,
    this.additionalData = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wilayah': wilayah,
      'lifestyleType': lifestyleType.name,
      'lifestyleDescription': lifestyleDescription,
      'monthlyIncome': monthlyIncome,
      'incomeProofImagePath': incomeProofImage?.path,
      'monthlyInstallments': monthlyInstallments,
      'installmentStartDate': installmentStartDate.toIso8601String(),
      'installmentEndDate': installmentEndDate.toIso8601String(),
      'additionalData': additionalData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      wilayah: json['wilayah'],
      lifestyleType: LifestyleType.values.firstWhere(
        (e) => e.name == json['lifestyleType'],
      ),
      lifestyleDescription: json['lifestyleDescription'],
      monthlyIncome: json['monthlyIncome'].toDouble(),
      incomeProofImage: json['incomeProofImagePath'] != null
          ? File(json['incomeProofImagePath'])
          : null,
      monthlyInstallments: json['monthlyInstallments'].toDouble(),
      installmentStartDate: DateTime.parse(json['installmentStartDate']),
      installmentEndDate: DateTime.parse(json['installmentEndDate']),
      additionalData: json['additionalData'] ?? {},
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  UserProfile copyWith({
    String? id,
    String? wilayah,
    LifestyleType? lifestyleType,
    String? lifestyleDescription,
    double? monthlyIncome,
    File? incomeProofImage,
    double? monthlyInstallments,
    DateTime? installmentStartDate,
    DateTime? installmentEndDate,
    Map<String, dynamic>? additionalData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      wilayah: wilayah ?? this.wilayah,
      lifestyleType: lifestyleType ?? this.lifestyleType,
      lifestyleDescription: lifestyleDescription ?? this.lifestyleDescription,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      incomeProofImage: incomeProofImage ?? this.incomeProofImage,
      monthlyInstallments: monthlyInstallments ?? this.monthlyInstallments,
      installmentStartDate: installmentStartDate ?? this.installmentStartDate,
      installmentEndDate: installmentEndDate ?? this.installmentEndDate,
      additionalData: additionalData ?? this.additionalData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  String get lifestyleDisplayName {
    switch (lifestyleType) {
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

  int get installmentMonths {
    return installmentEndDate.difference(installmentStartDate).inDays ~/ 30;
  }

  double get totalInstallments {
    return monthlyInstallments * installmentMonths;
  }

  // Format data untuk AI analysis
  Map<String, dynamic> toAIAnalysisData() {
    return {
      'location': wilayah,
      'lifestyle': {
        'type': lifestyleDisplayName,
        'description': lifestyleDescription,
      },
      'income': {
        'monthly_amount': monthlyIncome,
        'has_proof': incomeProofImage != null,
      },
      'installments': {
        'monthly_amount': monthlyInstallments,
        'total_months': installmentMonths,
        'total_amount': totalInstallments,
        'start_date': installmentStartDate.toIso8601String(),
        'end_date': installmentEndDate.toIso8601String(),
      },
      'profile_completeness': calculateCompleteness(),
    };
  }

  double calculateCompleteness() {
    double score = 0.0;
    if (wilayah.isNotEmpty) score += 0.2;
    if (lifestyleDescription.isNotEmpty) score += 0.2;
    if (monthlyIncome > 0) score += 0.3;
    if (monthlyInstallments >= 0) score += 0.2;
    if (installmentStartDate.isBefore(installmentEndDate)) score += 0.1;
    return score;
  }
}
