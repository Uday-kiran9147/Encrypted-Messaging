// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmali;
  final String receiverId;
  final String message;
  final Timestamp timeStamp;
  Message({
    required this.senderId,
    required this.senderEmali,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmali': senderEmali,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timeStamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmali: map['senderEmali'],
      receiverId: map['receiverId'],
      message: map['message'],
      timeStamp: map['timeStamp'],
    );
  }
}
