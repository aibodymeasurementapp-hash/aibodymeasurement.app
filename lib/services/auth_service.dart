import '../models/user_profile.dart';

class AuthService {
  // Mock authentication delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<UserProfile> login(String emailOrPhone, String password) async {
    await _simulateNetworkDelay();
    
    // Mock validation - in real app, this would validate against backend
    if (password.length < 6) {
      throw Exception('Invalid credentials');
    }

    return UserProfile(
      id: 'user_123',
      fullName: 'John Doe',
      email: emailOrPhone.contains('@') ? emailOrPhone : 'john@example.com',
      phone: emailOrPhone.contains('@') ? '+1234567890' : emailOrPhone,
      gender: Gender.male,
      heightCm: 175,
      weightKg: 70,
    );
  }

  Future<UserProfile> register(UserProfile userProfile, String password) async {
    await _simulateNetworkDelay();
    
    // Mock validation
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Return the user profile with a generated ID
    return userProfile.copyWith(id: 'user_${DateTime.now().millisecondsSinceEpoch}');
  }

  Future<void> logout() async {
    await _simulateNetworkDelay();
    // Mock logout
  }
}
