// ignore_for_file: public_member_api_docs, sort_constructors_first

class Keys {
   int public;
   int private;

  Keys(this.public, this.private);

  @override
  String toString() => 'User(public: $public, private: $private)';
}
class EncryptionService{
List<int> encrypt(String message, String key) {
  List<int> encryptedMessage = [];

  int keyLength = key.length;

  for (int i = 0; i < message.length; i++) {
    encryptedMessage.add(
        message.codeUnitAt(i) ^ key.codeUnitAt(i % keyLength));
  }

  return encryptedMessage;
}

String decryptMessage(List<int> encryptedMessage, String key) {
  StringBuffer decryptedMessage = StringBuffer();
  int keyLength = key.length;

  for (int i = 0; i < encryptedMessage.length; i++) {
    decryptedMessage.writeCharCode(
        encryptedMessage[i] ^ key.codeUnitAt(i % keyLength));
  }

  return decryptedMessage.toString();
}

}