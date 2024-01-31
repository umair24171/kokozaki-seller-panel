// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Deal {
  final String id;
  final String sellerId;
  final String name;
  final String description;
  final double discount;
  final double newPrice;
  DateTime publishedDate;
  DateTime expireDate;
  final int people;
  final String imageUrl;
  bool isStatus;

  Deal(
      {required this.id,
      required this.sellerId,
      required this.name,
      required this.description,
      required this.discount,
      required this.newPrice,
      required this.people,
      required this.imageUrl,
      required this.isStatus,
      required this.expireDate,
      required this.publishedDate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'discount': discount,
      'newPrice': newPrice,
      'category': people,
      'imageUrl': imageUrl,
      'isStatus': isStatus,
      'publishedDate': publishedDate,
      'expireDate': expireDate
    };
  }

  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      id: map['id'] as String,
      sellerId: map['sellerId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      discount: map['discount'] as double,
      newPrice: map['newPrice'] as double,
      people: map['category'] as int,
      imageUrl: map['imageUrl'] as String,
      isStatus: map['isStatus'] as bool,
      expireDate: (map['expireDate'] as Timestamp).toDate(),
      publishedDate: (map['publishedDate'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Deal.fromJson(String source) =>
      Deal.fromMap(json.decode(source) as Map<String, dynamic>);
}
