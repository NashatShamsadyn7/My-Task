import 'package:shared_preferences/shared_preferences.dart';

/// Small local persistence seam. Feature repositories depend on this contract,
/// so it can be replaced by a queryable local database without changing UI.
abstract interface class LocalKeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
}

class SharedPreferencesStore implements LocalKeyValueStore {
  SharedPreferencesStore(this._preferences);

  final SharedPreferencesAsync _preferences;

  factory SharedPreferencesStore.create() => SharedPreferencesStore(SharedPreferencesAsync());

  @override
  Future<String?> read(String key) => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) => _preferences.setString(key, value);

  @override
  Future<void> remove(String key) => _preferences.remove(key);
}
