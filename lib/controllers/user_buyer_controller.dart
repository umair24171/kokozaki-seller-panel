import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/helper/firebase_features.dart';
import 'package:kokozaki_seller_panel/models/order.dart';

class UserBuyerController extends GetxController {
  Rx<List<OrderModel>> orders = Rx<List<OrderModel>>([]);
  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  getOrders() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .where('marketId', arrayContains: currentUser)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        orders.value =
            value.docs.map((e) => OrderModel.fromMap(e.data())).toList();
        update(); // Notify listeners
      } else {
        orders.value = [];
      }
    });
  }
}
