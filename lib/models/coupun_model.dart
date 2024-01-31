class CouponModel {
  List<String> userList;
  String sellerId;
  String coupon;
  String couponId;
  int couponDiscount;

  CouponModel({
    required this.userList,
    required this.sellerId,
    required this.coupon,
    required this.couponId,
    required this.couponDiscount,
  });

  Map<String, dynamic> toMap() {
    return {
      'userList': userList,
      'sellerId': sellerId,
      'coupon': coupon,
      'couponId': couponId,
      'couponDiscount': couponDiscount,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      userList: List<String>.from(map['userList']),
      sellerId: map['sellerId'],
      coupon: map['coupon'],
      couponId: map['couponId'],
      couponDiscount: map['couponDiscount'],
    );
  }
}
