import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/models/product.dart';

class DealsController extends GetxController {
  Rx<List<Product>> deals = Rx<List<Product>>([]);

  getAllDeals() async {
    await FirebaseFirestore.instance
        .collection('products')
        .where('isDeal', isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        deals.value = value.docs.map((e) => Product.fromMap(e.data())).toList();
        update(); // Notify listeners
      } else {
        deals.value = [];
      }
    });
  }
}
