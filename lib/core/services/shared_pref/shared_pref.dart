import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  // Private constructor
  SharedPref._internal();

  // Singleton instance
  static final SharedPref _instance = SharedPref._internal();

  // Factory constructor to return the same instance
  factory SharedPref() {
    return _instance;
  }

  // SharedPreferences instance
  static SharedPreferences? _sharedPreferences;

  // Check if SharedPreferences is initialized
  bool get isInitialized => _sharedPreferences != null;

  // Initialize SharedPreferences
  Future<void> instantiatePreferences() async {
    if (_sharedPreferences != null) return;
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      rethrow;
    }
  }

  // Return the SharedPreference instance
  SharedPreferences? getPreferenceInstance() {
    return _sharedPreferences;
  }

  // Set string value
  Future<bool> setString(String key, String stringValue) async {
    if (_sharedPreferences == null) {
      await instantiatePreferences();
    }
    try {
      return await _sharedPreferences!.setString(key, stringValue);
    } catch (e) {
      print('Error setting string value: $e');
      return false;
    }
  }

  // Get string value
  String? getString(String key) {
    if (_sharedPreferences == null) return null;
    try {
      return _sharedPreferences!.getString(key);
    } catch (e) {
      print('Error getting string value: $e');
      return null;
    }
  }

  // Set boolean value
  Future<bool> setBool(String key, bool booleanValue) async {
    if (_sharedPreferences == null) {
      await instantiatePreferences();
    }
    try {
      return await _sharedPreferences!.setBool(key, booleanValue);
    } catch (e) {
      print('Error setting boolean value: $e');
      return false;
    }
  }

  // Get boolean value
  bool? getBool(String key) {
    if (_sharedPreferences == null) return null;
    try {
      return _sharedPreferences!.getBool(key);
    } catch (e) {
      print('Error getting boolean value: $e');
      return null;
    }
  }

  // Set double value
  Future<bool> setDouble(String key, double doubleValue) async {
    if (_sharedPreferences == null) {
      await instantiatePreferences();
    }
    try {
      return await _sharedPreferences!.setDouble(key, doubleValue);
    } catch (e) {
      print('Error setting double value: $e');
      return false;
    }
  }

  // Get double value
  double? getDouble(String key) {
    if (_sharedPreferences == null) return null;
    try {
      return _sharedPreferences!.getDouble(key);
    } catch (e) {
      print('Error getting double value: $e');
      return null;
    }
  }

  // Set int value
  Future<bool> setInt(String key, int intValue) async {
    if (_sharedPreferences == null) {
      await instantiatePreferences();
    }
    try {
      return await _sharedPreferences!.setInt(key, intValue);
    } catch (e) {
      print('Error setting int value: $e');
      return false;
    }
  }

  // Get int value
  int? getInt(String key) {
    if (_sharedPreferences == null) return null;
    try {
      return _sharedPreferences!.getInt(key);
    } catch (e) {
      print('Error getting int value: $e');
      return null;
    }
  }

  // Remove preference
  Future<bool> removePreference(String key) async {
    if (_sharedPreferences == null) return false;
    try {
      return await _sharedPreferences!.remove(key);
    } catch (e) {
      print('Error removing preference: $e');
      return false;
    }
  }

  // Check if preference exists
  bool containPreference(String key) {
    if (_sharedPreferences == null) return false;
    try {
      return _sharedPreferences!.containsKey(key);
    } catch (e) {
      print('Error checking preference: $e');
      return false;
    }
  }

  // Clear all preferences
  Future<bool> clearPreferences() async {
    if (_sharedPreferences == null) return false;
    try {
      return await _sharedPreferences!.clear();
    } catch (e) {
      print('Error clearing preferences: $e');
      return false;
    }
  }
}
