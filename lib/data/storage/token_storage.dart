// lib/data/storage/token_storage.dart

import 'package:get_storage/get_storage.dart';

class TokenStorage {
  final GetStorage _storage = GetStorage();

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  /// Save access token with expiry
  Future<void> saveToken(String token, {DateTime? expiryDate}) async {
    await _storage.write(_tokenKey, token);

    if (expiryDate != null) {
      await _storage.write(_tokenExpiryKey, expiryDate.toIso8601String());
    }
  }

  /// Get access token
  Future<String?> getToken() async {
    // ✅ Check if token is expired
    if (isTokenExpired()) {
      await clearTokens();
      return null;
    }

    return _storage.read<String>(_tokenKey);
  }

  /// Check if token is expired
  bool isTokenExpired() {
    final expiryString = _storage.read<String>(_tokenExpiryKey);

    if (expiryString == null) return false;

    final expiryDate = DateTime.parse(expiryString);
    return DateTime.now().isAfter(expiryDate);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(_refreshTokenKey, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return _storage.read<String>(_refreshTokenKey);
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_tokenExpiryKey);
  }

  /// ✅ Check if user is logged in (Async method)
  Future<bool> isLoggedIn() async {
    final hasToken = _storage.hasData(_tokenKey);
    final notExpired = !isTokenExpired();
    return hasToken && notExpired;
  }

  /// ✅ Synchronous version (for quick checks without await)
  bool get isLoggedInSync {
    final hasToken = _storage.hasData(_tokenKey);
    final notExpired = !isTokenExpired();
    return hasToken && notExpired;
  }
}