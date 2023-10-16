import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class EncryptionService {
  String _generateKeyFromPin(String pin) {
    // Pad the pin to ensure it's at least 16 characters long
    String paddedPin = pin.padRight(16);

    // Convert the padded pin to UTF-8 bytes
    List<int> utf8Bytes = utf8.encode(paddedPin);

    // Take the first 16 bytes as the key
    var key = utf8Bytes.sublist(0, 16);
    return base64.encode(key);
  }

  Encrypted encrypt(String pin, String plainText) {
    final keyString = _generateKeyFromPin(pin);
    final key = Key.fromUtf8(keyString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(keyString.substring(0, 16));
    Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  String decrypt(String pin, Encrypted encryptedData) {
    final keyString = _generateKeyFromPin(pin);
    final key = Key.fromUtf8(keyString);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(keyString.substring(0, 16));
    return encrypter.decrypt(encryptedData, iv: initVector);
  }
}