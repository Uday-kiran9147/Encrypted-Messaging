// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

class User {
  final int public;
  final int private;

  User(this.public, this.private);

  @override
  String toString() => 'User(public: $public, private: $private)';
}
class EncryptionService{
List<int> encryptString(String input, int key) {
  List<int> encryptedValues = [];

  for (int i = 0; i < input.length; i++) {
    int charCode = input.codeUnitAt(i);
    int encryptedValue = charCode + key;
    encryptedValues.add(encryptedValue);
  }

  return encryptedValues;
}

String decryptString(List<int> encryptedValues, int key) {
  StringBuffer decryptedString = StringBuffer();

  for (int encryptedValue in encryptedValues) {
    int originalValue = encryptedValue - key;
    decryptedString.writeCharCode(originalValue);
  }

  return decryptedString.toString();
}

}

void main() {
  String inputString = "Hello, World!";
  int udayuserprivate = 23;
  int udayuserpublic = udayuserprivate* udayuserprivate;
  
  int nagampublic = 5;
  int nagamUserpublic = nagampublic*nagampublic;
  var udayuser = User(udayuserpublic, udayuserprivate);
  var nagamUser = User(nagamUserpublic, nagampublic);

  print('random user private : ${sqrt(nagamUser.public).toInt()}');
  print('curent user');
  print(udayuser.toString());
  print('random user');
  print(nagamUser.toString());
  EncryptionService em = EncryptionService();
  List<int> encryptedValues =em.encryptString(inputString, udayuser.public*nagamUser.public);

  print("Original String: $inputString");
  print("Encrypted Values: $encryptedValues");

  String decryptedString =em.decryptString(encryptedValues, nagamUser.private*nagamUser.private *udayuser.public);
  print("Decrypted String: $decryptedString");
}


