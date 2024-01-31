import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/controllers/firestore_helper.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/helper/get_size.dart';
import 'package:kokozaki_seller_panel/models/product.dart';
import 'package:kokozaki_seller_panel/screens/auth_screens/login_screen.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController newpriceController = TextEditingController();
  final TextEditingController oldpriceController = TextEditingController();
  final TextEditingController noOfPeoplesController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  showDialogForEditProduct(context, Product product) {
    titleController.text = product.name;
    descriptionController.text = product.description;
    oldpriceController.text = product.oldPrice.toString();
    newpriceController.text = product.newPrice.toString();
    imageUrlController.text = product.imageUrl;
    bool isStatus = false;
    isStatus = product.isStatus;

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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: Text(
                                                product.category,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Hind',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
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
                                      category: product.category,
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('sellerId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Products'),
              );
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data!.docs[index].data();
                  Product product =
                      Product.fromMap(snapshot.data!.docs[index].data());
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      // color: secondaryColor,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          // const Color.fromARGB(
                          //     255, 185, 225, 236),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    data['imageUrl'],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'],
                                    // maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        color: whiteColor,
                                        fontFamily: 'Hind',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    data['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        color: Colors.white70,
                                        fontFamily: 'Hind',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data['category'],
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontFamily: 'Hind',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        '\$${data['newPrice']}',
                                        style: TextStyle(
                                            fontFamily: 'Hind',
                                            color: whiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialogForEditProduct(
                                              context, product);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 30,
                                          color: whiteColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            FirestoreHelper().deleteProduct(
                                                context, data['id']);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: whiteColor,
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
