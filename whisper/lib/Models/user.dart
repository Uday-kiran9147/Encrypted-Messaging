// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppUser {
  final String id;
  final String name;
  final String phoneNumber;
  final int private_key;
  final int public_key;
  const AppUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.private_key,
    required this.public_key,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'private_key': private_key,
      'public_key': public_key,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: (map["id"] ?? '') as String,
      name: (map["name"] ?? '') as String,
      phoneNumber: (map["phoneNumber"] ?? '') as String,
      private_key: (map["private_key"] ?? 0) as int,
      public_key: (map["public_key"] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
