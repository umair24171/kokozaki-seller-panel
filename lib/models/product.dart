// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kokozaki_seller_panel/models/variations.dart';

class Product {
  final String id;
  final String sellerId;
  final String name;
  final String description;
  final double oldPrice;
  final double newPrice;
  final String category;
  final String imageUrl;
  bool isStatus;
  final double rating;
  Variations variations;
  bool isDeal;

  Product(
      {required this.id,
      required this.sellerId,
      required this.name,
      required this.description,
      required this.oldPrice,
      required this.newPrice,
      required this.category,
      required this.imageUrl,
      required this.isStatus,
      required this.variations,
      required this.isDeal,
      required this.rating});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'category': category,
      'imageUrl': imageUrl,
      'isDeal': isDeal,
      'isStatus': isStatus,
      'rating': rating,
      'variations': variations.toMap()
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'] as String,
        sellerId: map['sellerId'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        oldPrice: map['oldPrice'] as double,
        newPrice: map['newPrice'] as double,
        isDeal: map['isDeal'] as bool,
        category: map['category'] as String,
        imageUrl: map['imageUrl'] as String,
        isStatus: map['isStatus'] as bool,
        variations:
            Variations.fromMap(map['variations'] as Map<String, dynamic>),
        rating: map['rating'] as double);
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
