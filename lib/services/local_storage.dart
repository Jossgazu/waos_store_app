import 'package:hive/hive.dart';

class LocalStorage {
  static late Box _box;

  static Future<void> init() async {
    // Para Linux, especifica una ruta válida
    Hive.init('/home/joss/github/waos_store_app/nada');
    _box = await Hive.openBox('appData');
  }

  static Future<void> save(String key, dynamic value) async {
    await _box.put(key, value);
  }

  static dynamic get(String key) {
    return _box.get(key);
  }

  static Future<void> delete(String key) async {
    await _box.delete(key);
  }

  static Future<void> clear() async {
    await _box.clear();
  }
}