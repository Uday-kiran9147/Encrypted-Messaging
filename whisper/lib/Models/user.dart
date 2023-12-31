// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppUser {
  final String id;
  final String name;
  final String bio;
  final String about;
  final String image;
  final String email;
  final String password;
  final int private_key;
  final int public_key;
  const AppUser({
    required this.id,
    required this.name,
    required this.bio,
    required this.about,
    required this.image,
    required this.email,
    required this.password,
    required this.private_key,
    required this.public_key,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bio': bio,
      'about': about,
      'image': image,
      'email': email,
      'password': password,
      'private_key': private_key,
      'public_key': public_key,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: (map["id"] ?? '') as String,
      name: (map["name"] ?? '') as String,
      bio: (map["bio"] ?? '') as String,
      about: (map["about"] ?? '') as String,
      image: (map["image"] ?? '') as String,
      email: (map["email"] ?? '') as String,
      password: (map["password"] ?? '') as String,
      private_key: (map["private_key"] ?? 0) as int,
      public_key: (map["public_key"] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
