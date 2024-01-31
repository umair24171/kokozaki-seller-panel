import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String name;
  final String message;
  final DateTime time;
  final String avatarUrl;
  final String senderId;
  final String receiverId;

  ChatModel(
      {required this.id,
      required this.name,
      required this.message,
      required this.time,
      required this.avatarUrl,
      required this.senderId,
      required this.receiverId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'message': message,
      'time': time,
      'avatarUrl': avatarUrl,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      name: map['name'] as String,
      message: map['message'] as String,
      time: (map['time'] as Timestamp).toDate(),
      avatarUrl: map['avatarUrl'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum MessageType { text, image }
