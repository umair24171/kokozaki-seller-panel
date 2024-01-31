// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/models/market_model.dart';
import 'package:kokozaki_seller_panel/screens/auth_screens/login_screen.dart';
import 'package:kokozaki_seller_panel/screens/auth_screens/signup_screen.dart';
import 'package:kokozaki_seller_panel/screens/dashboard.dart';
import 'firebase_options.dart';

// ...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = 'pk_tes';
  // await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    updateUserSubscriptions();
    getUserData();
  }

  getUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('coupons').get();
    print('Data is ${snapshot.docs[0].data()}');
  }

  updateUserSubscriptions() async {
    DateTime currentDate = DateTime.now();
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('sellers').doc(auth.currentUser!.uid).get();
    MarketModel seller = MarketModel.fromMap(snapshot.data()!);
    DateTime duration = seller.subscription!.duration;
    // print('Duration $duration');
    // print('Current Date $currentDate');
    if (currentDate.isAfter(duration)) {
      await firestore.collection('sellers').doc(auth.currentUser!.uid).update({
        'subscription': {
          'id': auth.currentUser!.uid,
          'status': false,
          'price': 0,
          'duration': currentDate,
          'title': 'Subscription Ended',
          'description': 'Subscription Ended'
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('ID is ${auth.currentUser!.uid}');
    return GetMaterialApp(
      title: 'Kokozaki Seller Panel',
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? const SignupScreen()
          : Dashboard(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen()
      },
    );
  }
}
