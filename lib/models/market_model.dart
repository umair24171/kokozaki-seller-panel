import 'dart:convert';
import 'package:kokozaki_seller_panel/models/subscription_model.dart';

class MarketModel {
  final String uid;
  final String marketName;
  final String email;
  final String password;
  final int sellerBalance;
  bool status;
  bool isAdmin;
  String imageUrl;
  Map<String, dynamic> location;
  List<String> coupons = [];
  List<Map<String, dynamic>> couponDiscount = [{}];
  double hmRatings;
  SubscriptionModel? subscription;
  String category;
  double ratings;

  // DateTime registeredAt = DateTime.now();

  MarketModel(
      {required this.uid,
      required this.marketName,
      required this.email,
      required this.password,
      required this.isAdmin,
      required this.status,
      required this.coupons,
      required this.couponDiscount,
      required this.hmRatings,
      required this.imageUrl,
      required this.category,
      required this.ratings,
      required this.sellerBalance,
      required this.location,
      this.subscription});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'marketName': marketName,
      'email': email,
      'password': password,
      'status': status,
      'isAdmin': isAdmin,
      'coupons': coupons,
      'couponDiscount': couponDiscount,
      'hmRatings': hmRatings,
      'category': category,
      'imageUrl': imageUrl,
      'ratings': ratings,
      'sellerBalance': sellerBalance,
      'location': location,
      'subscription': subscription?.toMap() ?? '',
    };
  }

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    return MarketModel(
        uid: map['uid'] ?? '',
        marketName: map['marketName'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
        isAdmin: map['isAdmin'] ?? false,
        imageUrl: map['imageUrl'] ?? '',
        status: map['status'] ?? false,
        sellerBalance: map['sellerBalance'] ?? 0,
        ratings: map['ratings'] ?? 0,
        location: map['location'] ?? {},
        coupons: map['coupons'] != null
            ? List<String>.from(map['coupons'] as List<dynamic>)
            : [],
        couponDiscount: map['couponDiscount'] != null
            ? List<Map<String, dynamic>>.from(
                map['couponDiscount'] as List<dynamic>)
            : [{}],
        hmRatings: map['hmRatings'] ?? 0,
        category: map['category'] ?? '',
        subscription: map['subscription'] != ''
            ? SubscriptionModel.fromMap(
                map['subscription'] as Map<String, dynamic>)
            : null);
  }
  // static MarketModel fromSNap(DocumentSnapshot snapshot) {
  //   Object snap = snapshot.data() as Map<String, dynamic>;
  //   return MarketModel(
  //       uid: (snap as Map<String, dynamic>)['uid'],
  //       marketName: snap['marketName'],
  //       email: snap['email'],
  //       password: snap['password'],
  //       isAdmin: snap['isAdmin'],
  //       subscription: snap['subscription']);
  // }

  String toJson() => json.encode(toMap());

  factory MarketModel.fromJson(String source) =>
      MarketModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
