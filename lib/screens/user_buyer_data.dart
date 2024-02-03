// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/controllers/seller_controllers.dart';
import 'package:kokozaki_seller_panel/controllers/user_buyer_controller.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/models/order.dart';
// import 'package:kokzaki_admin_panel/helper/colors.dart';

class UserBuyerData extends StatefulWidget {
  const UserBuyerData({super.key});
  @override
  State<UserBuyerData> createState() => _UserBuyerDataState();
}

class _UserBuyerDataState extends State<UserBuyerData> {
  @override
  Widget build(BuildContext context) {
    var seller = Get.put(SellerController());

    seller.getSellerData();
    var ordersData = Get.put(UserBuyerController());

    ordersData.getOrders();
    seller.updateUserSubscriptions();
    return Scaffold(
      body: Obx(
        () => seller.seller.value == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : seller.seller.value!.subscription!.title != 'Professional' &&
                    seller.seller.value!.subscription!.title != 'Big Business'
                ? const Center(
                    child: Text(
                      'You need to purchase Professional plan to see this data',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                    showBottomBorder: true,
                                    columnSpacing: 30,
                                    dividerThickness: 2,
                                    dataRowHeight: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                    dataTextStyle: const TextStyle(
                                      fontFamily: 'Hind',
                                    ),
                                    headingRowColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => primaryColor),
                                    dataRowColor:
                                        const MaterialStatePropertyAll(
                                            Color(0xffD4F2FF)),
                                    columns: const [
                                      DataColumn(
                                          label: Text(
                                        'No.',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            color: Colors.white),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Account',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            color: Colors.white),
                                      )),
                                      DataColumn(
                                        label: Text(
                                          'Products Name',
                                          style: TextStyle(
                                              fontFamily: 'Hind',
                                              color: Colors.white),
                                        ),
                                      ),
                                      DataColumn(
                                          label: Text(
                                        'Items',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            color: Colors.white),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Prices',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            color: Colors.white),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Refferal Link',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            color: Colors.white),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Super Market',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            color: Colors.white),
                                      )),
                                      DataColumn(
                                        label: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontFamily: 'Hind',
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                        ordersData.orders.value.length,
                                        (index) {
                                      OrderModel orderModel =
                                          ordersData.orders.value[index];
                                      return DataRow(
                                          key: UniqueKey(),
                                          selected: true,
                                          cells: [
                                            DataCell(Text('${index + 1}')),
                                            DataCell(Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(orderModel.userName),
                                                Text(orderModel.email)
                                              ],
                                            )),
                                            // const DataCell(Text('No Products')),
                                            DataCell(StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('products')
                                                    .where('id',
                                                        whereIn: orderModel
                                                            .productIds)
                                                    .where('sellerId',
                                                        isEqualTo: seller
                                                            .seller.value!.uid)
                                                    .snapshots(),
                                                builder: (context, snapshot1) {
                                                  return snapshot1.hasData
                                                      ? SingleChildScrollView(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children:
                                                                  List.generate(
                                                                      snapshot1
                                                                          .data!
                                                                          .docs
                                                                          .length,
                                                                      (index) {
                                                                final data1 =
                                                                    snapshot1
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data();
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child: Row(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child: Image
                                                                            .network(
                                                                          data1[
                                                                              'imageUrl'],
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              40,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              7),
                                                                      Text(
                                                                          '${data1['name']}'),
                                                                    ],
                                                                  ),
                                                                );
                                                              })),
                                                        )
                                                      : const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                })),
                                            DataCell(Text(
                                                '${orderModel.quantity} items')),
                                            DataCell(Text(
                                                '\$ ${orderModel.totalPrice}')),
                                            DataCell(
                                              Text('${orderModel.referalLink}'),
                                            ),
                                            DataCell(Text(seller
                                                .seller.value!.marketName)),
                                            // data['marketName'] == null
                                            //     ? const DataCell(
                                            //         Text('No Market Exist'))
                                            //     : DataCell(Text(
                                            //         '${data['marketName']}')),
                                            orderModel.status == 0
                                                ? const DataCell(Text(
                                                    'Pending',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ))
                                                : orderModel.status == 1
                                                    ? const DataCell(Text(
                                                        'Completed',
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ))
                                                    : const DataCell(Text(
                                                        'Cancelled',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )),
                                          ]);
                                    })),
                              )))
                    ],
                  ),
      ),
    );
  }
}
