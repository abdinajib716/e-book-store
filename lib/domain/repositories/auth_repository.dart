import '../entities/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<void> sendVerificationEmail(String email);
  Future<bool> verifyEmail(String email, String code);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<User> updateProfile(User user);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> refreshToken();
}
