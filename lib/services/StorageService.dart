import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService sharedInstance = StorageService._();

  StorageService._();

  Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
