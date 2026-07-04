import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _termsAcceptedKey = 'terms_accepted';
  static const String _alertRadiusKey = 'alert_radius_km';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<void> setTermsAccepted(bool accepted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_termsAcceptedKey, accepted);
  }

  Future<bool> getTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_termsAcceptedKey) ?? false;
  }

  Future<void> saveAlertRadius(double radiusKm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_alertRadiusKey, radiusKm);
  }

  Future<double> getAlertRadius() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_alertRadiusKey) ?? 0.0;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_termsAcceptedKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
