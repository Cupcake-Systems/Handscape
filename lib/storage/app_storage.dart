import 'package:shared_preferences/shared_preferences.dart';

abstract class AppStorage {
  static late final SharedPreferencesWithCache prefs;

  static Future<void> init() async {
    prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }
}
