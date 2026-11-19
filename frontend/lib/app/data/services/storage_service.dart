import 'package:get_storage/get_storage.dart';

class StorageService {
  static final Map<String, dynamic> _memoryFallback = {};
  static bool _hasStorage = true;

  static GetStorage get _box => GetStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _phoneKey = 'phone';

  static dynamic _read(String key) {
    try {
      if (_hasStorage) {
        return _box.read(key);
      }
    } catch (_) {
      _hasStorage = false;
    }
    return _memoryFallback[key];
  }

  static void _write(String key, dynamic value) {
    _memoryFallback[key] = value;
    try {
      if (_hasStorage) {
        _box.write(key, value);
      }
    } catch (_) {
      _hasStorage = false;
    }
  }

  // Token
  static String? get token => _read(_tokenKey) as String?;
  static set token(String? value) => _write(_tokenKey, value);

  // Phone
  static String? get phone => _read(_phoneKey) as String?;
  static set phone(String? value) => _write(_phoneKey, value);

  // Login Status
  static bool get isLoggedIn => (_read(_isLoggedInKey) as bool?) ?? false;
  static set isLoggedIn(bool value) => _write(_isLoggedInKey, value);

  // User Data (JSON map)
  static Map<String, dynamic>? get userData {
    final data = _read(_userKey);
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
  }

  static set userData(Map<String, dynamic>? value) => _write(_userKey, value);

  // Clear all data (logout)
  static Future<void> clearAll() async {
    _memoryFallback.clear();
    try {
      if (_hasStorage) {
        await _box.erase();
      }
    } catch (_) {}
  }

  // Remove specific key
  static Future<void> remove(String key) async {
    _memoryFallback.remove(key);
    try {
      if (_hasStorage) {
        await _box.remove(key);
      }
    } catch (_) {}
  }
}
