import 'dart:convert';
import '../models/user_profile.dart';

class UserProfileService {
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal();

  UserProfile? _currentProfile;

  UserProfile? get currentProfile => _currentProfile;

  // Save user profile
  Future<void> saveProfile(UserProfile profile) async {
    _currentProfile = profile;

    // In a real app, you would save this to a database or shared preferences
    // For now, we'll just store it in memory and simulate a delay
    await Future.delayed(const Duration(milliseconds: 500));

    print('Profile saved: ${jsonEncode(profile.toJson())}');
    print('AI Analysis Data: ${jsonEncode(profile.toAIAnalysisData())}');
  }

  // Load user profile
  Future<UserProfile?> loadProfile() async {
    // In a real app, you would load this from a database or shared preferences
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentProfile;
  }

  // Update profile
  Future<void> updateProfile(UserProfile profile) async {
    _currentProfile = profile.copyWith(updatedAt: DateTime.now());
    await Future.delayed(const Duration(milliseconds: 500));
    print('Profile updated: ${jsonEncode(_currentProfile!.toJson())}');
  }

  // Delete profile
  Future<void> deleteProfile() async {
    _currentProfile = null;
    await Future.delayed(const Duration(milliseconds: 300));
    print('Profile deleted');
  }

  // Check if profile exists
  bool hasProfile() {
    return _currentProfile != null;
  }

  // Get AI analysis data
  Map<String, dynamic>? getAIAnalysisData() {
    return _currentProfile?.toAIAnalysisData();
  }

  // Get profile completion percentage
  double getProfileCompleteness() {
    return _currentProfile?.calculateCompleteness() ?? 0.0;
  }

  // Validate profile for AI analysis
  bool isProfileValidForAI() {
    if (_currentProfile == null) return false;

    return _currentProfile!.wilayah.isNotEmpty &&
        _currentProfile!.lifestyleDescription.isNotEmpty &&
        (_currentProfile!.monthlyIncome > 0 ||
            _currentProfile!.incomeProofImage != null);
  }

  // Generate AI prompt from profile data
  String generateAIPrompt() {
    if (_currentProfile == null) {
      return 'No user profile available for analysis.';
    }

    final profile = _currentProfile!;
    final analysisData = profile.toAIAnalysisData();

    return '''
User Financial Profile Analysis Request:

Location: ${analysisData['location']}
Lifestyle: ${analysisData['lifestyle']['type']} - ${analysisData['lifestyle']['description']}

Income Information:
- Monthly Income: ${profile.monthlyIncome > 0 ? 'Rp ${profile.monthlyIncome}' : 'Provided via image proof'}
- Income Verification: ${analysisData['income']['has_proof'] ? 'Verified with document' : 'Self-reported'}

Installment Information:
- Monthly Installments: Rp ${profile.monthlyInstallments}
- Duration: ${analysisData['installments']['total_months']} months
- Total Amount: Rp ${analysisData['installments']['total_amount']}
- Period: ${analysisData['installments']['start_date']} to ${analysisData['installments']['end_date']}

Profile Completeness: ${(analysisData['profile_completeness'] * 100).toStringAsFixed(1)}%

Please provide:
1. Budget allocation recommendations
2. Savings strategy based on location and lifestyle
3. Financial goals suggestions
4. Risk assessment for current financial situation
5. Monthly expense categories and recommended limits
''';
  }
}
