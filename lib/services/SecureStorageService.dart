import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = FlutterSecureStorage();

  Future<bool> isMasterPasswordSet() async {
    String? storedPassword = await _secureStorage.read(key: 'master_password');
    return storedPassword != null && storedPassword.isNotEmpty;
  }

  Future<void> saveMasterPassword(String password) async {
    await _secureStorage.write(key: 'master_password', value: password);
  }

  Future<String?> getMasterPassword() async {
    return await _secureStorage.read(key: 'master_password');
  }
}