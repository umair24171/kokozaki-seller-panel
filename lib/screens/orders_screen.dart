import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/controllers/seller_controllers.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';

// import 'package:kokzaki_admin_panel/helper/colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedStatus = 'All';
  List<String> options = [""];

  @override
  Widget build(BuildContext context) {
    var sellerController = Get.put(SellerController());
    sellerController.getSellerData();
    sellerController.updateUserSubscriptions();
    options = [
      options[0],
      ...(['All', 'Pending', 'Completed', 'Cancelled'])
    ];
    return Scaffold(
        body: Obx(
      () => sellerController.seller.value == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : sellerController.seller.value!.subscription!.title != 'Standard' &&
                  sellerController.seller.value!.subscription!.title !=
                      'Professional' &&
                  sellerController.seller.value!.subscription!.title !=
                      'Big Business'
              ? const Center(
                  child: Text(
                    'You need to purchase Standard plan to see this data',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('marketId',
                          arrayContains: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text(
                          'No Orders Yet',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: whiteColor,
                                        blurRadius: 3,
                                        offset: const Offset(0, 0))
                                  ]),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.badge_outlined,
                                          size: 30,
                                        ),
                                        DropdownButton(
                                            value: selectedStatus,
                                            focusColor: Colors.black,
                                            items: options
                                                .map((String e) =>
                                                    DropdownMenuItem(
                                                        // enabled: true,
                                                        value: e,
                                                        child: Text(
                                                          e,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        )))
                                                .toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedStatus = value!;
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'All Orders',
                                        style: TextStyle(
                                            color: Color(0xff8B8D97),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Pending',
                                        style: TextStyle(
                                            color: Color(0xff8B8D97),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Shipped',
                                        style: TextStyle(
                                            color: Color(0xff8B8D97),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                            color: Color(0xff8B8D97),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Cancelled',
                                        style: TextStyle(
                                            color: Color(0xff8B8D97),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '${snapshot.data!.docs.length}',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        snapshot.data!.docs
                                            .where((element) =>
                                                element['status'] == 0)
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        snapshot.data!.docs
                                            .where((element) =>
                                                element['status'] == 1)
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        snapshot.data!.docs
                                            .where((element) =>
                                                element['status'] == 2)
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        snapshot.data!.docs
                                            .where((element) =>
                                                element['status'] == 3)
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: StreamBuilder(
                                  stream: selectedStatus == 'All'
                                      ? FirebaseFirestore.instance
                                          .collection('orders')
                                          // .orderBy('orderDate',
                                          //     descending: true)
                                          .where('marketId',
                                              arrayContains: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .snapshots()
                                      : selectedStatus == 'Pending'
                                          ? FirebaseFirestore.instance
                                              .collection('orders')
                                              .where('marketId',
                                                  arrayContains: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('status', isEqualTo: 0)
                                              .snapshots()
                                          : selectedStatus == 'Completed'
                                              ? FirebaseFirestore.instance
                                                  .collection('orders')
                                                  .where('marketId',
                                                      arrayContains:
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid)
                                                  .where('status', isEqualTo: 1)
                                                  .snapshots()
                                              : FirebaseFirestore.instance
                                                  .collection('orders')
                                                  .where('marketId',
                                                      arrayContains:
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid)
                                                  .where('status', isEqualTo: 2)
                                                  .snapshots(),
                                  builder: (context, snapshot1) {
                                    if (snapshot1.hasData) {
                                      if (snapshot1.data!.docs.isEmpty) {
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
                                          // border: const TableBorder(
                                          //     right: BorderSide(width: 1),
                                          //     left: BorderSide(width: 1),
                                          //     top: BorderSide(width: 1),
                                          //     bottom: BorderSide(width: 1)),
                                          columnSpacing: 30,
                                          dividerThickness: 2,
                                          dataRowHeight: 80,

                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2)),
                                          // showCheckboxColumn: true,
                                          // sortColumnIndex: 1,
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
                                              'Customer Name',
                                              style: TextStyle(
                                                  fontFamily: 'Hind',
                                                  color: Colors.white),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Email',
                                              style: TextStyle(
                                                  fontFamily: 'Hind',
                                                  color: Colors.white),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Order Date',
                                              style: TextStyle(
                                                  fontFamily: 'Hind',
                                                  color: Colors.white),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'User Address',
                                              style: TextStyle(
                                                  fontFamily: 'Hind',
                                                  color: Colors.white),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Tracking Id',
                                              style: TextStyle(
                                                  fontFamily: 'Hind',
                                                  color: Colors.white),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Order Total',
                                              style: TextStyle(
                                                  fontFamily: 'Hind',
                                                  color: Colors.white),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'Delivery Type',
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
                                            )),
                                          ],
                                          rows: List.generate(
                                              snapshot.data!.docs.length,
                                              (index) {
                                            final data = snapshot
                                                .data!.docs[index]
                                                .data();
                                            // OrderModel order =
                                            //     OrderModel.fromMap(data.data());
                                            return DataRow(
                                              key:
                                                  UniqueKey(), // Add a unique key to each DataRow
                                              cells: [
                                                DataCell(Text('${index + 1}')),
                                                DataCell(
                                                    Text(data['userName'])),
                                                DataCell(Text(data['email'])),
                                                DataCell(Text(
                                                    '${data['orderDate'].toDate().day}-${data['orderDate'].toDate().month}-${data['orderDate'].toDate().year}')),
                                                DataCell(
                                                    Text(data['userAddress'])),
                                                DataCell(Text(data['orderId'])),
                                                DataCell(Text(
                                                    '\$${data['totalPrice']}')),
                                                DataCell(Text(
                                                    '${data['deliveryOption']}')),
                                                DataCell(
                                                    MyDropdown(order: data)),
                                              ],
                                            );
                                          }),
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
    ));
  }
}

class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key, required this.order});
  final order;
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  // The list of items for the dropdown
  List<String> items = [
    'Pending',
    'Shipped',
    'Completed',
    'Cancelled',
  ];

  // The currently selected item
  String selectedItem = 'Pending';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.order['status'] == 0
          ? 'Pending'
          : widget.order['status'] == 1
              ? 'Shipped'
              : widget.order['status'] == 2
                  ? 'Completed'
                  : 'Cancelled',
      onChanged: (String? newValue) {
        selectedItem = newValue!;
        // Move the code for updating Firestore inside the setState callback
        if (newValue == 'Pending') {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.order['orderId'])
              .update({
            'status': 0,
            // 'email': widget.order['email'],
            // 'userName': widget.order['userName'],
            // 'marketName': widget.order['marketName'],
            // 'productIds': widget.order['productIds'],
            // 'quantity': widget.order['quantity'],
            // 'referalLink': widget.order['referalLink'],
            // 'marketId': widget.order['marketId'],
            // 'totalPrice': widget.order['totalPrice'],
            // 'orderId': widget.order['orderId'],
            // 'orderDate': widget.order['orderDate'],
            // 'userAddress': widget.order['userAddress'],
          });
        } else if (newValue == 'Shipped') {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.order['orderId'])
              .update({
            'status': 1,
            // 'email': widget.order['email'],
            // 'userName': widget.order['userName'],
            // 'marketName': widget.order['marketName'],
            // 'productIds': widget.order['productIds'],
            // 'quantity': widget.order['quantity'],
            // 'referalLink': widget.order['referalLink'],
            // 'marketId': widget.order['marketId'],
            // 'totalPrice': widget.order['totalPrice'],
            // 'orderId': widget.order['orderId'],
            // 'orderDate': widget.order['orderDate'],
            // 'userAddress': widget.order['userAddress'],
            // 'address': widget.order['address'],
          });
        } else if (newValue == 'Completed') {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.order['orderId'])
              .update({
            'status': 2,
            // 'email': widget.order['email'],
            // 'userName': widget.order['userName'],
            // 'marketName': widget.order['marketName'],
            // 'productIds': widget.order['productIds'],
            // 'quantity': widget.order['quantity'],
            // 'referalLink': widget.order['referalLink'],
            // 'marketId': widget.order['marketId'],
            // 'totalPrice': widget.order['totalPrice'],
            // 'orderId': widget.order['orderId'],
            // 'orderDate': widget.order['orderDate'],
            // 'userAddress': widget.order['userAddress'],
            // 'address': widget.order['address'],
          });
        } else if (newValue == 'Cancelled') {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.order['orderId'])
              .update({
            'status': 3,
            // 'email': widget.order['email'],
            // 'userName': widget.order['userName'],
            // 'marketName': widget.order['marketName'],
            // 'productIds': widget.order['productIds'],
            // 'quantity': widget.order['quantity'],
            // 'referalLink': widget.order['referalLink'],
            // 'marketId': widget.order['marketId'],
            // 'totalPrice': widget.order['totalPrice'],
            // 'orderId': widget.order['orderId'],
            // 'orderDate': widget.order['orderDate'],
            // 'userAddress': widget.order['userAddress'],
            // 'address': widget.order['address'],
          });
        } else {
          FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.order['orderId'])
              .update({
            'status': 2,
            // 'email': widget.order['email'],
            // 'userName': widget.order['userName'],
            // 'marketName': widget.order['marketName'],
            // 'productIds': widget.order['productIds'],
            // 'quantity': widget.order['quantity'],
            // 'referalLink': widget.order['referalLink'],
            // 'marketId': widget.order['marketId'],
            // 'totalPrice': widget.order['totalPrice'],
            // 'orderId': widget.order['orderId'],
            // 'orderDate': widget.order['orderDate'],
            // 'userAddress': widget.order['userAddress'],
            // 'address': widget.order['address'],
          });
        }
        setState(() {});
      },
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
                fontFamily: 'Hind',
                color: widget.order['status'] == 0
                    ? Colors.red
                    : widget.order['status'] == 1
                        ? Colors.orange
                        : widget.order['status'] == 2
                            ? Colors.green
                            : Colors.grey),
          ),
        );
      }).toList(),
    );
  }
}
