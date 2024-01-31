// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/models/market_model.dart';
// import 'package:kokzaki_admin_panel/helper/colors.dart';

class UserBuyerData extends StatefulWidget {
  const UserBuyerData({super.key});
  @override
  State<UserBuyerData> createState() => _UserBuyerDataState();
}

class _UserBuyerDataState extends State<UserBuyerData> {
  MarketModel? seller;

  @override
  void initState() {
    super.initState();
    refershSeller();
  }

  refershSeller() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('sellers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    seller = MarketModel.fromMap(snapshot.data()!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: seller == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : seller!.subscription!.title != 'Professional' &&
                  seller!.subscription!.title != 'Big Business'
              ? const Center(
                  child: Text(
                    'You need to purchase Professional plan to see this data',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('marketId',
                                  arrayContains:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text(
                                  'No Orders Yet',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ));
                              }
                              return SingleChildScrollView(
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
                                        snapshot.data!.docs.length, (index) {
                                      final data =
                                          snapshot.data!.docs[index].data();
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
                                                Text(data['userName']),
                                                Text(data['email'])
                                              ],
                                            )),
                                            // const DataCell(Text('No Products')),
                                            DataCell(StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('products')
                                                    .where('id',
                                                        whereIn:
                                                            data['productIds'])
                                                    .where('sellerId',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
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
                                                '${data['quantity']} items')),
                                            DataCell(Text(
                                                '\$ ${data['totalPrice']}')),
                                            DataCell(
                                              Text('${data['referalLink']}'),
                                            ),
                                            DataCell(StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('sellers')
                                                    .where('uid',
                                                        whereIn:
                                                            data['marketId'])
                                                    .snapshots(),

                                                // .doc(data['productIds'][0])

                                                builder: (context, snapshot1) {
                                                  if (snapshot1.hasData) {
                                                    final data1 = snapshot1
                                                        .data!.docs.first
                                                        .data();
                                                    return Text(
                                                        '${data1['marketName']}');
                                                  } else {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                })),
                                            // data['marketName'] == null
                                            //     ? const DataCell(
                                            //         Text('No Market Exist'))
                                            //     : DataCell(Text(
                                            //         '${data['marketName']}')),
                                            data['status'] == 0
                                                ? const DataCell(Text(
                                                    'Pending',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ))
                                                : data['status'] == 1
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
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ))
                  ],
                ),
    );
  }
}
