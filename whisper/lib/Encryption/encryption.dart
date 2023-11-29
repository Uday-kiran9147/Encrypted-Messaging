import 'dart:math';

class SimpleEncryption {
  static String generateRandomHexKey(int length) {
    final random = Random.secure();
    List<int> keyBytes =
        List.generate(length ~/ 2, (index) => random.nextInt(256));
    return keyBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

StringBuffer encrypt(String message, String key) {
  StringBuffer encryptedMessage = StringBuffer();
  int keyLength = key.length;

  for (int i = 0; i < message.length; i++) {
    encryptedMessage.writeCharCode(
        message.codeUnitAt(i) ^ key.codeUnitAt(i % keyLength));
  }

  return encryptedMessage;
}


  StringBuffer decryptMessage(String encryptedMessage, String key) {
    StringBuffer decryptedMessage = StringBuffer();
    int keyLength = key.length;
    for (int i = 0; i < encryptedMessage.length; i++) {
      decryptedMessage.writeCharCode(
          encryptedMessage.codeUnitAt(i) ^ key.codeUnitAt(i % keyLength));
    }

    return decryptedMessage;
  }
}
