// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/controllers/firestore_helper.dart';
import 'package:kokozaki_seller_panel/helper/snackbar.dart';
import 'package:kokozaki_seller_panel/models/product.dart';
import 'package:uuid/uuid.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  bool isActive = false;
  String selectedCategory = '';
  // List<String> categories = [""];
  Uint8List? file;

  @override
  Widget build(BuildContext context) {
    // categories = [
    //   categories[0],
    //   ...[
    //     'Popular',
    //     'New',
    //     'Fashion & Cosmetics',
    //     'Food & Drinks',
    //     'Sport',
    //     'Kids',
    //     'Electronics',
    //     'Home'
    //   ]
    // ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xffD4f2ff),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                            'Add Title',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Hind',
                                fontSize: 20),
                          ),
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            fillColor: const Color(0xff6bc2e6),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Short sleeve t-shirts..',
                            hintStyle:
                                TextStyle(color: whiteColor, fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                            'Add Description',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: 'Hind',
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                        TextField(
                          controller: descriptionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            fillColor: const Color(0xff6bc2e6),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Write product description..',
                            hintStyle:
                                TextStyle(color: whiteColor, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            'Media',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: 'Hind',
                                fontWeight: FontWeight.w400,
                                fontSize: 19),
                          ),
                        ),
                        file == null
                            ? DottedBorder(
                                strokeWidth: 1,
                                borderType: BorderType.Rect,
                                child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              file = await FirestoreHelper()
                                                  .pickImage();
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color:
                                                      const Color(0xff6bc2e6)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 30),
                                                child: Text(
                                                  'Upload product photo ',
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 20,
                                                      fontFamily: 'Hind'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextField(
                                        controller: imageUrlController,
                                        decoration: InputDecoration(
                                          constraints: const BoxConstraints(
                                              maxWidth: 500),
                                          fillColor: const Color(0xff6bc2e6),
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          hintText: 'Add from URL',
                                          hintStyle: TextStyle(
                                              color: whiteColor, fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                child: Image(
                                    height: 200,
                                    width: double.infinity,
                                    image: MemoryImage(file!)))
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          DocumentSnapshot<Map<String, dynamic>> snapshot =
                              await FirebaseFirestore.instance
                                  .collection('sellers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get();
                          String category = snapshot.data()!['category'];
                          var uuid = const Uuid();
                          String productId = uuid.v4();
                          String? url1;
                          if (file != null) {
                            url1 = await FirestoreHelper()
                                .uploadFile('products', file!, context);
                          }
                          // print('URL is $url1');
                          Product product = Product(
                              id: productId,
                              sellerId: FirebaseAuth.instance.currentUser!.uid,
                              name: titleController.text,
                              description: descriptionController.text,
                              oldPrice: double.parse(oldPriceController.text),
                              newPrice: double.parse(newPriceController.text),
                              category: category,
                              rating: 0,
                              imageUrl: imageUrlController.text.isEmpty
                                  ? url1!
                                  : imageUrlController.text,
                              isStatus: isActive);

                          FirestoreHelper()
                              .addSellerProduct(context, product, productId);
                          showSnackBar('Product Added Successfully',
                              'Congratulations...');
                          titleController.clear();
                          descriptionController.clear();
                          oldPriceController.clear();
                          newPriceController.clear();
                          imageUrlController.clear();
                          isActive = false;

                          file = null;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: Text(
                              'List Product',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Hind",
                                  color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xffD4f2ff)),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Hind',
                                        fontSize: 19),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    // width: 200,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff6bc2e6),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Active'),
                                          Checkbox(
                                              value: isActive,
                                              onChanged: (value) {
                                                setState(() {
                                                  isActive = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xffD4f2ff)),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                    'Product Category',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Hind',
                                        fontSize: 19),
                                  ),
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('sellers')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!['category'] ==
                                            null) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              alignment: Alignment.center,
                                              // width: 200,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff6bc2e6),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                child: Text(
                                                    snapshot.data!['category']),
                                              ),
                                            ));
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xffD4f2ff)),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                    'Add Product Price',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Hind',
                                        fontSize: 19),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 18,
                                            fontFamily: 'Hind'),
                                      ),
                                      TextField(
                                        controller: newPriceController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          constraints: const BoxConstraints(
                                              maxHeight: 50),
                                          hintText: 'New price',
                                          hintStyle:
                                              TextStyle(color: whiteColor),
                                          fillColor: const Color(0xff6bc2e6),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Compare at Price',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 18,
                                            fontFamily: 'Hind'),
                                      ),
                                      TextField(
                                        controller: oldPriceController,
                                        decoration: InputDecoration(
                                          constraints: const BoxConstraints(
                                              maxHeight: 50),
                                          fillColor: const Color(0xff6bc2e6),
                                          filled: true,
                                          hintStyle:
                                              TextStyle(color: whiteColor),
                                          hintText: 'Old price',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          DocumentSnapshot<Map<String, dynamic>> snapshot =
                              await FirebaseFirestore.instance
                                  .collection('sellers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get();
                          String category = snapshot.data()!['category'];
                          var uuid = const Uuid();
                          String productId = uuid.v4();
                          String? url1;
                          if (file != null) {
                            url1 = await FirestoreHelper()
                                .uploadFile('products', file!, context);
                          }
                          // print('URL is $url1');
                          Product product = Product(
                              id: productId,
                              sellerId: FirebaseAuth.instance.currentUser!.uid,
                              name: titleController.text,
                              description: descriptionController.text,
                              oldPrice: double.parse(oldPriceController.text),
                              newPrice: double.parse(oldPriceController.text),
                              category: category,
                              rating: 0,
                              imageUrl: imageUrlController.text.isEmpty
                                  ? url1!
                                  : imageUrlController.text,
                              isStatus: isActive);

                          FirestoreHelper()
                              .addSellerProduct(context, product, productId);
                          showSnackBar('Product Added Successfully',
                              'Congratulations...');
                          titleController.clear();
                          descriptionController.clear();
                          oldPriceController.clear();
                          newPriceController.clear();
                          imageUrlController.clear();
                          isActive = false;

                          file = null;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: Text(
                              'List Product',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Hind",
                                  color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
