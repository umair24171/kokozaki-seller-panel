// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// import 'package:kokozaki_seller_panel/models/market_model.dart';

// class SellerProvider extends ChangeNotifier {
//   MarketModel seller = MarketModel(
//       category: '',
//       uid: '',
//       marketName: '',
//       email: '',
//       password: '',
//       isAdmin: false,
//       ratings: 0,
//       imageUrl: '',
//       status: false);
//   // MarketModel getSeller() => _seller;

//   Future<void> refereshUser() async {
//     DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//         .instance
//         .collection('sellers')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();
//     seller = MarketModel.fromMap(snapshot.data()!);

//     // print('seller data $seller');
//     notifyListeners();
//   }
// }
