// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmali;
  final String receiverId;
  final String message;
  final String key;
  final Timestamp timeStamp;
  Message({
    required this.senderId,
    required this.senderEmali,
    required this.receiverId,
    required this.message,
    required this.key,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderEmali': senderEmali,
      'receiverId': receiverId,
      'message': message,
      'key': key,
      'timeStamp': timeStamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: (map["senderId"] ?? '') as String,
      senderEmali: (map["senderEmali"] ?? '') as String,
      receiverId: (map["receiverId"] ?? '') as String,
      message: map['message'],
      key: map['key']??'',
      timeStamp: map["timeStamp"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
