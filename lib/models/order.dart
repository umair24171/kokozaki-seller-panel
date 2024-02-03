class OrderModel {
  List<String> marketId;
  bool referalLink;
  Map<String, dynamic> productQuantity;
  String email;
  String userName;
  String orderId;
  List<String> productIds;
  double totalPrice;
  String userAddress;
  int quantity;
  String deliveryOption;
  int status;
  DateTime orderDate;

  OrderModel({
    required this.marketId,
    required this.referalLink,
    required this.productQuantity,
    required this.email,
    required this.userName,
    required this.orderId,
    required this.productIds,
    required this.totalPrice,
    required this.userAddress,
    required this.quantity,
    required this.deliveryOption,
    required this.status,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'marketId': marketId,
      'referalLink': referalLink,
      'productQuantity': productQuantity,
      'email': email,
      'userName': userName,
      'orderId': orderId,
      'productIds': productIds,
      'totalPrice': totalPrice,
      'userAddress': userAddress,
      'quantity': quantity,
      'deliveryOption': deliveryOption,
      'status': status,
      'orderDate': orderDate,
    };
  }

  static OrderModel fromMap(Map<String, dynamic> map) {
    return OrderModel(
      marketId: List<String>.from(map['marketId']),
      referalLink: map['referalLink'],
      productQuantity: Map<String, dynamic>.from(map['productQuantity']),
      email: map['email'],
      userName: map['userName'],
      orderId: map['orderId'],
      productIds: List<String>.from(map['productIds']),
      totalPrice: map['totalPrice'],
      userAddress: map['userAddress'],
      quantity: map['quantity'],
      deliveryOption: map['deliveryOption'],
      status: map['status'],
      orderDate: map['orderDate'].toDate(),
    );
  }
}
