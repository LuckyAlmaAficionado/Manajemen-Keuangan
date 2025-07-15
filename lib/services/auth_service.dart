import '../constants/auth_constants.dart';

class AuthService {
  // Simulate login API call
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation (in real app, this would be API call)
    if (email.isNotEmpty && password.isNotEmpty) {
      // Simulate successful login
      final userData = {
        'success': true,
        'token': 'fake_token_${DateTime.now().millisecondsSinceEpoch}',
        'userId': '123',
        'userName': email.split('@')[0],
        'userEmail': email,
      };

      // Save to local storage
      await AuthConstants.saveToken(userData['token'] as String);
      await AuthConstants.saveUserData(
        userId: userData['userId'] as String,
        userName: userData['userName'] as String,
        userEmail: userData['userEmail'] as String,
      );

      return userData;
    } else {
      return {
        'success': false,
        'message': 'Email dan password tidak boleh kosong',
      };
    }
  }

  // Simulate register API call
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation (in real app, this would be API call)
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      // Simulate successful registration
      final userData = {
        'success': true,
        'token': 'fake_token_${DateTime.now().millisecondsSinceEpoch}',
        'userId': '123',
        'userName': name,
        'userEmail': email,
      };

      // Save to local storage
      await AuthConstants.saveToken(userData['token'] as String);
      await AuthConstants.saveUserData(
        userId: userData['userId'] as String,
        userName: userData['userName'] as String,
        userEmail: userData['userEmail'] as String,
      );

      return userData;
    } else {
      return {'success': false, 'message': 'Semua field harus diisi'};
    }
  }

  // Logout
  static Future<void> logout() async {
    await AuthConstants.clearAuthData();
  }
}
