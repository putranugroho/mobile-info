// ignore: library_prefixes
import 'package:encrypt/encrypt.dart' as AESEncryptor;

class EncryptInterface {
  static String decrypt(String? value) {
    var target = AESEncryptor.Encrypted.fromBase64(value!);
    final encrypter = AESEncryptor.Encrypter(AESEncryptor.AES(
        AESEncryptor.Key.fromUtf8("UTRDjbZO8vD6UwjNPQXsPusN2l7w3hXV")));
    var result = encrypter.decrypt(target, iv: AESEncryptor.IV.fromLength(16));
    return result;
  }

  static String encrypt(String? value) {
    final encrypter = AESEncryptor.Encrypter(AESEncryptor.AES(
        AESEncryptor.Key.fromUtf8("UTRDjbZO8vD6UwjNPQXsPusN2l7w3hXV")));
    var result = encrypter.encrypt(value!, iv: AESEncryptor.IV.fromLength(16));
    return result.toString();
  }
}
