import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/helper/firebase_features.dart';
import 'package:kokozaki_seller_panel/models/market_model.dart';

class SellerController extends GetxController {
  Rx<MarketModel?> seller = Rx<MarketModel?>(null);
  @override
  void onInit() {
    super.onInit();
    getSellerData();
  }

  Future<void> getSellerData() async {
    try {
      var value = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(currentUser)
          .get();

      if (value.exists) {
        seller.value = MarketModel.fromMap(value.data()!);
        update(); // Notify listeners
      } else {
        seller.value = null;
      }
    } catch (e) {
      print("Error fetching seller data: $e");
      seller.value = null;
    }
  }

  updateUserSubscriptions() async {
    DateTime currentDate = DateTime.now();
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('sellers')
        .doc(currentUser)
        .get();
    MarketModel seller = MarketModel.fromMap(snapshot.data()!);
    DateTime duration = seller.subscription!.duration;
    // print('Duration $duration');
    // print('Current Date $currentDate');
    if (currentDate.isAfter(duration)) {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(currentUser)
          .update({
        'subscription': {
          'id': currentUser,
          'status': false,
          'price': 0,
          'duration': currentDate,
          'title': 'Subscription Ended',
          'description': 'Subscription Ended'
        }
      });
    }
  }
}
