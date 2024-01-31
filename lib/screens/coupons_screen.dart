import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/controllers/coupan_methods.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/helper/firebase_features.dart';
import 'package:kokozaki_seller_panel/models/coupun_model.dart';
import 'package:uuid/uuid.dart';

class CouponsScreen extends StatelessWidget {
  CouponsScreen({super.key});
  final TextEditingController coupounController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var getWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 5),
                    ]),

                // margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: primaryColor),
                      child: const Text(
                        "Coupouns",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Sofia-pro',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: coupounController,
                            decoration: const InputDecoration(
                                hintText: 'Coupoun Name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Hind',
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: discountController,
                            decoration: const InputDecoration(
                                hintText: 'Discount',
                                hintStyle: TextStyle(
                                  fontFamily: 'Hind',
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              String randomId = const Uuid().v4();
                              CouponModel couponModel = CouponModel(
                                  userList: [],
                                  sellerId: currentUser,
                                  coupon: coupounController.text,
                                  couponId: randomId,
                                  couponDiscount:
                                      int.parse(discountController.text));
                              CoupanMethods()
                                  .createCoupan(couponModel, randomId);
                              coupounController.clear();
                              discountController.clear();
                            },
                            child: Container(
                              width: getWidth * 0.3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Create Coupon',
                                  style: TextStyle(
                                      fontFamily: 'Hind', color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('coupons')
                  .where('sellerId', isEqualTo: currentUser)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // final data =snapshot.data.docs;

                  return Container(
                    width: getWidth * .5,
                    margin: const EdgeInsets.symmetric(horizontal: 100)
                        .copyWith(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            blurRadius: 10,
                            offset: Offset(2, 2))
                      ],
                      borderRadius: BorderRadius.circular(20),

                      // border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index].data();
                          CouponModel couponModel = CouponModel.fromMap(data);
                          return Card(
                              child: ListTile(
                            leading: Text((index + 1).toString()),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  couponModel.coupon,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.06),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.green[300],
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      '${couponModel.couponDiscount}%',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('coupons')
                                      .doc(couponModel.couponId)
                                      .delete();
                                },
                                icon: const Icon(Icons.delete)),
                          ));
                        }),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
