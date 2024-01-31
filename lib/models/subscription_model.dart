// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final DateTime duration;
  // final String imageUrl;
  final bool status;

  SubscriptionModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.duration,
      // required this.imageUrl,
      required this.status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      // 'imageUrl': imageUrl,
      'status': status,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      duration: (map['duration'] as Timestamp).toDate(),
      // imageUrl: map['imageUrl'] as String,
      status: map['status'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) =>
      SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
