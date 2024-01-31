import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/models/market_model.dart';

class SellerControllers extends GetxController {
  MarketModel? seller;

  getUserData() {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
