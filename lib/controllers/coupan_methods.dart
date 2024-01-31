import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kokozaki_seller_panel/helper/snackbar.dart';
import 'package:kokozaki_seller_panel/models/coupun_model.dart';

class CoupanMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  createCoupan(CouponModel couponModel, String randomId) async {
    try {
      await _firestore
          .collection('coupons')
          .doc(randomId)
          .set(couponModel.toMap());
      showSnackBar('Coupon addded Successfully', '');
    } catch (e) {
      showSnackBar(e.toString(), 'Error');
    }
  }
}
