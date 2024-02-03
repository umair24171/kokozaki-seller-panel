// ignore_for_file: prefer_final_fields

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kokozaki_seller_panel/helper/snackbar.dart';
import 'package:kokozaki_seller_panel/models/market_model.dart';
import 'package:kokozaki_seller_panel/models/product.dart';
import 'package:uuid/uuid.dart';

class FirestoreHelper {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  addSellerProduct(context, Product product, String productId) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .set(product.toMap());
    } catch (e) {
      showSnackBar(e.toString(), 'Error Accured while sending data');
    }
  }

  Future<Uint8List> pickImage() async {
    final picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    // if (file == null) {}
    return await file!.readAsBytes();
  }

  Future<String> uploadFile(
      String childName,
      // String name,
      Uint8List file,
      BuildContext context) async {
    var urlDownload = "";
    var uuid = const Uuid();
    String randomId = uuid.v4();

    await _storage
        .ref()
        .child(childName)
        // .child(randomId)

        .child('$randomId.png')
        .putData(file)
        .then((p0) async {
      urlDownload = await p0.ref.getDownloadURL();
    }).catchError((err) {
      showSnackBar(err.toString(), 'Error Accured While Uploading Image');
    });

    return urlDownload;
  }

  deleteProduct(context, String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      showSnackBar(e.toString(), 'Error Accured');
    }
  }

  addDealProduct(context, Product product, String productId) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .set(product.toMap());
    } catch (e) {
      showSnackBar(e.toString(), 'Error Accured while sending data');
    }
  }

  // Future<MarketModel> getCurrentSellerDetails() async {
  //   User? currentSeller = FirebaseAuth.instance.currentUser;
  //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('sellers')
  //       .doc(currentSeller!.uid)
  //       .get();
  //   return MarketModel.fromSNap(snapshot.data());
  // }
  Future<MarketModel> getCurrentSellerDetails() async {
    MarketModel? marketModel;
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      // print('Seller Data ${value.data()}');
      marketModel = MarketModel.fromMap(value.data()!);
    });
    return marketModel!;
  }

  deleteDeal(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}
