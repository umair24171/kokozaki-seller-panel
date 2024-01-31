import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/controllers/firestore_helper.dart';
import 'package:kokozaki_seller_panel/helper/get_size.dart';
import 'package:kokozaki_seller_panel/models/product.dart';
import 'package:kokozaki_seller_panel/screens/auth_screens/login_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController newpriceController = TextEditingController();
  final TextEditingController oldpriceController = TextEditingController();
  final TextEditingController noOfPeoplesController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  String selectedCategory = '';
  // List<String> categories = [""];
  bool isStatus = false;
  int? _selectedCategoryIndex;
  // String? _selectedProduct;
  List<String> categories = [
    'Popular',
    'New',
    'Fashion & Cosmetics',
    'Food & Drinks',
    'Sport',
    'Kids',
    'Electronics',
    'Home'
  ];
  bool isAddCategory = false;
  showDialogForEditProduct(context, Product product) {
    titleController.text = product.name;
    descriptionController.text = product.description;
    oldpriceController.text = product.oldPrice.toString();
    newpriceController.text = product.newPrice.toString();
    imageUrlController.text = product.imageUrl;
    isStatus = product.isStatus;
    selectedCategory = product.category;

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
                              text: 'Description',
                              maxLines: 4,
                              controller: descriptionController,
                            ),
                            CustomTextFormFIeld(
                              text: 'Old Price',
                              controller: oldpriceController,
                            ),
                            CustomTextFormFIeld(
                              text: 'New Price',
                              controller: newpriceController,
                            ),
                            CustomTextFormFIeld(
                              text: 'ImageUrl',
                              controller: imageUrlController,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Category',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Hind',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            alignment: Alignment.center,
                                            // width: 200,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff6bc2e6),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: DropdownButton(
                                                value: selectedCategory,
                                                items: categories
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                              value: e,
                                                              child: Text(e),
                                                            ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedCategory = value!;
                                                  });
                                                }),
                                          )),
                                    ],
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
                                text: 'Update Product',
                                icon: Icons.add_card,
                                callBack: () async {
                                  Product product1 = Product(
                                      id: product.id,
                                      sellerId: product.sellerId,
                                      name: titleController.text,
                                      description: descriptionController.text,
                                      oldPrice:
                                          double.parse(oldpriceController.text),
                                      newPrice:
                                          double.parse(newpriceController.text),
                                      category: selectedCategory,
                                      imageUrl: imageUrlController.text,
                                      isStatus: isStatus,
                                      rating: product.rating);
                                  FirestoreHelper().updateProduct(product1);
                                  Navigator.pop(context);
                                }),
                          ],
                        )),
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       // if (isAddCategory)
            //       // Column(
            //       //   children: [
            //       //     const Text(
            //       //       'Add Category Title',
            //       //       style: TextStyle(
            //       //           fontSize: 16,
            //       //           fontFamily: 'Hind',
            //       //           fontWeight: FontWeight.bold),
            //       //     ),
            //       //     TextFormField(
            //       //       decoration: InputDecoration(
            //       //         fillColor: secondaryColor,
            //       //         filled: true,
            //       //         border: InputBorder.none,
            //       //         hintText: 'Category Name',
            //       //         hintStyle: TextStyle(
            //       //             color: whiteColor,
            //       //             fontSize: 14,
            //       //             fontWeight: FontWeight.w400),
            //       //       ),
            //       //     ),
            //       //   ],
            //       // ),
            //       Expanded(
            //         flex: 3,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 8.0, horizontal: 80),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text(
            //                 'Add Category Title',
            //                 style: TextStyle(
            //                     fontSize: 18,
            //                     fontFamily: 'Hind',
            //                     fontWeight: FontWeight.bold),
            //               ),
            //               const SizedBox(
            //                 height: 5,
            //               ),
            //               TextFormField(
            //                 decoration: InputDecoration(
            //                   // fillColor: Colors.white,
            //                   // filled: true,
            //                   border: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(8)),
            //                   hintText: 'category name..',
            //                   hintStyle: const TextStyle(
            //                       color: Colors.black,
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w400),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       const Expanded(flex: 2, child: SizedBox()),
            //       Expanded(
            //         flex: 1,
            //         child: GestureDetector(
            //           onTap: () {},
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 color: primaryColor,
            //                 borderRadius: BorderRadius.circular(8)),
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(
            //                   vertical: 10, horizontal: 40),
            //               child: Text(
            //                 'Add Category',
            //                 style: TextStyle(
            //                     fontSize: 20,
            //                     fontFamily: "Hind",
            //                     color: whiteColor),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex =
                            _selectedCategoryIndex == index ? null : index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            // color: secondaryColor,
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        categories[index],
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontFamily: 'Hind',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('products')
                                              .where('sellerId',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('category',
                                                  isEqualTo: categories[index])
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data!.docs.isEmpty) {
                                                return Text(
                                                  'Products #0',
                                                  style: TextStyle(
                                                      fontFamily: 'Hind',
                                                      color: whiteColor,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                );
                                              }
                                              return Text(
                                                'Products #${snapshot.data!.docs.length}',
                                                style: TextStyle(
                                                    fontFamily: 'Hind',
                                                    color: whiteColor,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              );
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     IconButton(
                                  //       onPressed: () {},
                                  //       icon: Icon(
                                  //         Icons.edit,
                                  //         size: 30,
                                  //         color: whiteColor,
                                  //       ),
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 10,
                                  //     ),
                                  //     IconButton(
                                  //         onPressed: () {},
                                  //         icon: Icon(
                                  //           Icons.delete,
                                  //           size: 30,
                                  //           color: whiteColor,
                                  //         ))
                                  //   ],
                                  // )
                                ],
                              ),
                            ),
                          ),
                          if (_selectedCategoryIndex == index)
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('products')
                                    .where('sellerId',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .where('category',
                                        isEqualTo: categories[index])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.docs.isEmpty) {
                                      return const Text('No Products Found');
                                    }

                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data!.docs[index].data();
                                          Product product = Product.fromMap(
                                              snapshot.data!.docs[index]
                                                  .data());
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: double.infinity,
                                              // color: secondaryColor,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  // const Color.fromARGB(
                                                  //     255, 185, 225, 236),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        child: Image.network(
                                                          data['imageUrl'],
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data['name'],
                                                            // maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: TextStyle(
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .alphabetic,
                                                                color:
                                                                    whiteColor,
                                                                fontFamily:
                                                                    'Hind',
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Text(
                                                            data['description'],
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: const TextStyle(
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .alphabetic,
                                                                color: Colors
                                                                    .white70,
                                                                fontFamily:
                                                                    'Hind',
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                data[
                                                                    'category'],
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontFamily:
                                                                        'Hind',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              const SizedBox(
                                                                width: 30,
                                                              ),
                                                              Text(
                                                                '\$${data['newPrice']}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Hind',
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  showDialogForEditProduct(
                                                                      context,
                                                                      product);
                                                                },
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  size: 30,
                                                                  color:
                                                                      whiteColor,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    FirestoreHelper().deleteProduct(
                                                                        context,
                                                                        data[
                                                                            'id']);
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 30,
                                                                    color:
                                                                        whiteColor,
                                                                  ))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    );
                                  }
                                }),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
