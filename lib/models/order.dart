import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String email;
  final String marketId;
  final String marketName;
  final String userName;
  final DateTime orderDate;
  final String orderId;
  List<String> productIds;
  final double totalPrice;
  final int quantity;
  final int status;
  bool referalLink;
  String userAddress;

  OrderModel(
      {required this.email,
      required this.marketId,
      required this.marketName,
      required this.userName,
      required this.orderDate,
      required this.orderId,
      required this.totalPrice,
      required this.productIds,
      required this.quantity,
      required this.status,
      required this.userAddress,
      required this.referalLink});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'marketId': marketId,
      'marketName': marketName,
      'name': userName,
      'orderDate': orderDate,
      'orderId': orderId,
      'totalPrice': totalPrice,
      'quantity': quantity,
      'status': status,
      'referalLink': referalLink,
      'productIds': productIds,
      'userAddress': userAddress
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      email: map['email'] as String,
      marketId: map['marketId'] as String,
      marketName: map['marketName'] as String,
      userName: map['name'] as String,
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      orderId: map['orderId'] as String,
      totalPrice: map['totalPrice'] as double,
      quantity: map['quantity'] as int,
      status: map['status'] as int,
      referalLink: map['referalLink'] as bool,
      userAddress: map['userAddress'] as String,
      productIds: List<String>.from(map['productIds'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
