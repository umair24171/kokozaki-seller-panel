import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/controllers/firestore_helper.dart';
import 'package:kokozaki_seller_panel/helper/get_size.dart';
import 'package:kokozaki_seller_panel/helper/snackbar.dart';
import 'package:kokozaki_seller_panel/models/deal_model.dart';
import 'package:kokozaki_seller_panel/models/market_model.dart';
import 'package:kokozaki_seller_panel/screens/auth_screens/login_screen.dart';
import 'package:kokozaki_seller_panel/widgets/recent_deals_product.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  checkOrders() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    final orders = snapshot.docs.first.data();
    print('Order is ${orders}');
  }

  PageStorageBucket bucket = PageStorageBucket();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController noOfPeoplesController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  bool isStatus = false;

  showDialogForAddDeal(context) {
    showDialog(
        useSafeArea: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: getWidth(context) * .6,
                    ),
                    Card(
                      elevation: 8,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  secondaryColor,
                                  whiteColor,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.circular(20)),
                        width: getWidth(context) * .5,
                        child: Form(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFIeld(
                              text: 'Title',
                              controller: titleController,
                            ),
                            CustomTextFormFIeld(
                              text: 'Discount',
                              controller: discountController,
                            ),
                            CustomTextFormFIeld(
                              text: 'Description',
                              maxLines: 4,
                              controller: descriptionController,
                            ),
                            CustomTextFormFIeld(
                              text: 'Price',
                              controller: priceController,
                            ),
                            CustomTextFormFIeld(
                              text: 'No of People the deal is for',
                              controller: noOfPeoplesController,
                            ),
                            CustomTextFormFIeld(
                              text: 'ImageUrl',
                              controller: imageUrlController,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                'Expire Date',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Sofia-pro',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2)
                                  .copyWith(bottom: 10),
                              child: GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.black)),
                                  width: getWidth(context),
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 20, bottom: 20),
                                  child: Text(
                                    DateFormat("MMM dd yyyy")
                                        .format(selectedDate),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Sofia-pro',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            CheckboxListTile(
                                value: isStatus,
                                title: const Text("Status"),
                                onChanged: (val) {
                                  setState(() {
                                    isStatus = !isStatus;
                                  });
                                }),
                            CustomButton(
                                text: 'Add Deal',
                                icon: Icons.add_card,
                                callBack: () async {
                                  var uuid = const Uuid();
                                  String productId = uuid.v4();
                                  Deal deal = Deal(
                                      id: productId,
                                      sellerId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      name: titleController.text,
                                      description: descriptionController.text,
                                      discount:
                                          double.parse(discountController.text),
                                      newPrice:
                                          double.parse(priceController.text),
                                      people:
                                          int.parse(noOfPeoplesController.text),
                                      imageUrl: imageUrlController.text,
                                      isStatus: isStatus,
                                      publishedDate: DateTime.now(),
                                      expireDate: selectedDate);

                                  FirestoreHelper()
                                      .addDealProduct(context, deal, productId);

                                  Navigator.pop(context);
                                  showSnackBar(
                                      'Deal added Successful', 'Successful');
                                }),
                          ],
                        )),
                      ),
                    )
                  ],
                ),
              );
            }),
            // actions: <Widget>[
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context)
            //           .pop(); // Close the dialog
            //     },
            //     child: Text('Close'),
            //   ),
            // ],
          );
        });
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  MarketModel? seller;

  @override
  void initState() {
    super.initState();
    refershSeller();
    checkOrders();
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
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    noOfPeoplesController.dispose();
    imageUrlController.dispose();
    discountController.dispose();
  }

  PageStorageKey mykey = const PageStorageKey("testkey");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: seller == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : seller!.subscription!.title != 'Standard' &&
                  seller!.subscription!.title != 'Professional' &&
                  seller!.subscription!.title != 'Big Business'
              ? const SafeArea(
                  child: Center(
                    child: Text(
                      'Purchase a Standard Plan to access the deals',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const NewDealWidget(),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialogForAddDeal(context);
                                        },
                                        child: Text(
                                          'Add New Deal',
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontFamily: 'Hind'),
                                        ),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: whiteColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: getWidth(context) * 0.35,
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 0,
                                        offset: Offset(0, 0))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Recent Deals',
                                          style: TextStyle(
                                              color: Color(0xff092C4C),
                                              fontSize: 22,
                                              fontFamily: 'Hind'),
                                        ),
                                        Text(
                                          'View All',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 17,
                                              fontFamily: 'Hind'),
                                        ),
                                      ],
                                    ),
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('deals')
                                            .where('sellerId',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .orderBy('publishedDate',
                                                descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data!.docs.isEmpty) {
                                              return const Text(
                                                  'No Deals Found');
                                            }

                                            return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  final deal = Deal.fromMap(
                                                      snapshot.data!.docs[index]
                                                          .data());

                                                  if (snapshot.data!.docs.first
                                                      .data()['expireDate']
                                                      .toDate()
                                                      .isBefore(
                                                          DateTime.now())) {
                                                    FirebaseFirestore.instance
                                                        .collection('deals')
                                                        .doc(deal.id)
                                                        .delete();
                                                    setState(() {});
                                                  }
                                                  return RecentDealsProduct(
                                                      deal: deal);
                                                });
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: getWidth(context) * 0.2,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 0,
                                            offset: Offset(0, 0))
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Customers',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 19,
                                                  fontFamily: 'Hind',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            Text(
                                              '78',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 19,
                                                  fontFamily: 'Hind',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.supervised_user_circle_sharp,
                                          size: 70,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: getWidth(context) * 0.2,
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 0,
                                            offset: Offset(0, 0))
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Deals',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 19,
                                                  fontFamily: 'Hind',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            Text(
                                              '136',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 19,
                                                  fontFamily: 'Hind',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.badge,
                                          size: 70,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}

class NewDealWidget extends StatefulWidget {
  const NewDealWidget({
    super.key,
  });

  @override
  State<NewDealWidget> createState() => _NewDealWidgetState();
}

class _NewDealWidgetState extends State<NewDealWidget> {
  @override
  Widget build(BuildContext context) {
    // Deal deal = Provider.of<DealProvider>(context, listen: false).getDeal();
    // print('deal is ${deal.name}');
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('deals')
            .where('sellerId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('publishedDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Text('No deal Found');
            }
            final data = snapshot.data!.docs.first.data();
            if (snapshot.data!.docs.first
                .data()['expireDate']
                .toDate()
                .isBefore(DateTime.now())) {
              FirebaseFirestore.instance
                  .collection('deals')
                  .doc(data['id'])
                  .delete();
              setState(() {});
            }

            return Container(
              width: getWidth(context) * 0.2,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(255, 173, 199, 238),
                      Color(0xff6CC3E8),
                    ]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'],
                          maxLines: 1,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 18,
                              fontFamily: 'Hind'),
                        ),
                        IconButton(
                            onPressed: () {
                              FirestoreHelper().deleteDeal(data['id']);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                data['imageUrl'],
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 3,
                        // ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data['description'],
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.visible,
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Hind'),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Deal Expire Date',
                      style: TextStyle(
                          overflow: TextOverflow.visible,
                          color: Color(0xffD6E1E6),
                          fontSize: 14,
                          fontFamily: 'Hind'),
                    ),
                    Text(
                      DateFormat('MMM dd yyyy')
                          .format((data['expireDate'] as Timestamp).toDate()),
                      style: TextStyle(
                          color: whiteColor,
                          overflow: TextOverflow.visible,
                          fontSize: 14,
                          fontFamily: 'Hind'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deal',
                          style: TextStyle(
                              color: Color(0xffD6E1E6),
                              overflow: TextOverflow.visible,
                              fontSize: 14,
                              fontFamily: 'Hind'),
                        ),
                        Text(
                          'People',
                          style: TextStyle(
                              color: Color(0xffD6E1E6),
                              overflow: TextOverflow.visible,
                              fontSize: 14,
                              fontFamily: 'Hind'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buy 1 Get 1 Free ${data['discount']}% off',
                          style: TextStyle(
                              overflow: TextOverflow.visible,
                              color: whiteColor,
                              fontSize: 14,
                              fontFamily: 'Hind'),
                        ),
                        Text(
                          '${data['people']}',
                          style: TextStyle(
                              color: whiteColor,
                              overflow: TextOverflow.visible,
                              fontSize: 14,
                              fontFamily: 'Hind'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${data['discount']}% Off',
                      style: TextStyle(
                          overflow: TextOverflow.visible,
                          color: whiteColor,
                          fontSize: 14,
                          fontFamily: 'Hind'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontFamily: 'Hind',
                                  color: Color(0xffD6E1E6),
                                  fontSize: 14),
                            ),
                            Text(
                              '\$${data['newPrice']}',
                              style: TextStyle(
                                  color: whiteColor,
                                  overflow: TextOverflow.visible,
                                  fontSize: 14,
                                  fontFamily: 'Hind'),
                            ),
                          ],
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //       color: primaryColor,
                        //       borderRadius: BorderRadius.circular(15)),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Text(
                        //       'Edit Deal',
                        //       style: TextStyle(
                        //           overflow: TextOverflow.visible,
                        //           color: whiteColor,
                        //           fontSize: 14,
                        //           fontFamily: 'Hind'),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
