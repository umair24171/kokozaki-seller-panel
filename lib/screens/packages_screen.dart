import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/controllers/stripe_controller.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/helper/snackbar.dart';
import 'package:kokozaki_seller_panel/models/subscription_model.dart';
import 'package:kokozaki_seller_panel/widgets/package_container.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final paymentController = Get.put(PaymentController());
  bool isMonthly = true;

  bool isYearly = false;

  List<PackageDetails> basicPackage = [
    const PackageDetails(packageDetails: 'free to join'),
    const PackageDetails(packageDetails: 'sell products')
  ];

  List<PackageDetails> standordPackage = [
    const PackageDetails(packageDetails: 'sell products'),
    const PackageDetails(
        packageDetails: 'get access to user buyer behaviour data '),
    const PackageDetails(
        packageDetails: 'get access to offer personalized deals'),
  ];

  List<PackageDetails> professionalPackage = [
    const PackageDetails(packageDetails: 'sell products'),
    const PackageDetails(
        packageDetails: 'get access to user buyer behaviour data '),
    const PackageDetails(
        packageDetails: 'get access to offer personalized deals'),
    const PackageDetails(packageDetails: 'get access to extend those deals'),
    const PackageDetails(
        packageDetails: 'get access to generate 5 refferal links'),
  ];
  List<PackageDetails> bigBusinessPackage = [
    const PackageDetails(packageDetails: 'sell products'),
    const PackageDetails(
        packageDetails: 'get access to user buyer behaviour data '),
    const PackageDetails(
        packageDetails: 'get access to offer personalized deals'),
    const PackageDetails(packageDetails: 'get access to extend those deals'),
    const PackageDetails(
        packageDetails: 'get access to generate unlimited refferal links'),
    const PackageDetails(
        packageDetails: 'get access to see the data of other buyers'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 1,
                shadowColor: whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
                color: whiteColor,
                child: Container(
                  width: 310,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(35)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMonthly = true;
                            isYearly = false;
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35)),
                          elevation: 1,
                          shadowColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                color: isYearly ? whiteColor : primaryColor,
                                borderRadius: BorderRadius.circular(35)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Pay Monthly',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: isYearly ? Colors.black : whiteColor,
                                    fontFamily: 'Hind'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMonthly = false;
                            isYearly = true;
                          });
                        },
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: isYearly ? primaryColor : whiteColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Pay Yearly(25%)',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: isYearly ? whiteColor : Colors.black,
                                    fontFamily: 'Hind'),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            if (isMonthly)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PackageContainer(
                      packageTitle: 'Basic',
                      buttonText: 'Free To Use',
                      price: 0,
                      callback: () {
                        if (isMonthly) {
                          paymentController.makePayment(
                              amount: '0', currency: 'usd');
                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Basic',
                                  description: 'Free to use',
                                  price: 0,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 30)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          showSnackBar('Subscription Purchased Successfully',
                              'Congratulations');
                        } else if (!isMonthly) {
                          paymentController.makePayment(
                              amount: '0', currency: 'usd');

                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Basic',
                                  description: 'Free to use',
                                  price: 0,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          showSnackBar('Subscription Purchased Successfully',
                              'Congratulations');
                        } else {
                          showSnackBar('Something went wrong', 'Error');
                        }
                      },
                      isYearly: isYearly,
                      packageDetails: basicPackage),
                  PackageContainer(
                      packageTitle: 'Standard',
                      buttonText: 'Register Now',
                      price: 10,
                      isYearly: isYearly,
                      callback: () {
                        if (isMonthly) {
                          paymentController.makePayment(
                              amount: '10', currency: 'usd');
                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Standard',
                                  description: 'Registered',
                                  price: 10,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 30)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          Get.snackbar("Successful",
                              'Subscription Purchased Successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              duration: const Duration(seconds: 2));
                        } else if (!isMonthly) {
                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Standard',
                                  description: 'Registered',
                                  price: 30,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          Get.snackbar("Successful",
                              'Subscription Purchased Successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              duration: const Duration(seconds: 2));
                        } else {
                          showSnackBar('Something went wrong', 'Error');
                        }
                      },
                      packageDetails: standordPackage),
                  PackageContainer(
                      packageTitle: 'Professional',
                      buttonText: 'Register Now',
                      price: 33,
                      isYearly: isYearly,
                      callback: () {
                        if (isMonthly) {
                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Professional',
                                  description: 'Registered',
                                  price: 33,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 30)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          Get.snackbar("Successful",
                              'Subscription Purchased Successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              duration: const Duration(seconds: 2));
                        } else if (!isMonthly) {
                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Professional',
                                  description: 'Registered',
                                  price: 99,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          Get.snackbar("Successful",
                              'Subscription Purchased Successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              duration: const Duration(seconds: 2));
                        } else {
                          Get.snackbar('Something went wrong', 'Error');
                        }
                      },
                      packageDetails: professionalPackage),
                  PackageContainer(
                      packageTitle: 'Big Business',
                      buttonText: 'Register Now',
                      price: 120,
                      callback: () {
                        if (isMonthly) {
                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Big Business',
                                  description: 'Registered',
                                  price: 120,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 30)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          Get.snackbar("Successful",
                              'Subscription Purchased Successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              duration: const Duration(seconds: 2));
                        } else if (!isMonthly) {
                          SubscriptionModel subscriptionModel =
                              SubscriptionModel(
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                  title: 'Big Business',
                                  description: 'Registered',
                                  price: 360,
                                  duration: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  status: true);
                          FirebaseFirestore.instance
                              .collection('sellers')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(
                                  {'subscription': subscriptionModel.toMap()});
                          showSnackBar('Subscription Purchased Successfully',
                               'Congratulations');
                          Get.snackbar("Successful",
                              'Subscription Purchased Successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              duration: const Duration(seconds: 2));
                        } else {
                          Get.snackbar('Something went wrong', 'Error');
                        }
                      },
                      isYearly: isYearly,
                      packageDetails: bigBusinessPackage),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            // if (isMonthly)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [

            //     ],
            //   ),
            if (isMonthly)
              const SizedBox(
                height: 50,
              ),
            if (isYearly)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PackageContainer(
                      packageTitle: 'Basic',
                      buttonText: 'Free To Use',
                      price: 0,
                      callback: () {
                        SubscriptionModel subscriptionModel = SubscriptionModel(
                            id: FirebaseAuth.instance.currentUser!.uid,
                            title: 'Basic',
                            description: 'Free to use',
                            price: 0,
                            duration:
                                DateTime.now().add(const Duration(days: 30)),
                            status: true);
                        FirebaseFirestore.instance
                            .collection('sellers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update(
                                {'subscription': subscriptionModel.toMap()});
                      },
                      isYearly: isYearly,
                      packageDetails: basicPackage),
                  PackageContainer(
                      packageTitle: 'Standard',
                      buttonText: 'Register Now',
                      price: 10,
                      isYearly: isYearly,
                      callback: () {},
                      packageDetails: standordPackage),
                  PackageContainer(
                      packageTitle: 'Professional',
                      buttonText: 'Register Now',
                      price: 33,
                      isYearly: isYearly,
                      callback: () {},
                      packageDetails: professionalPackage),
                  PackageContainer(
                      packageTitle: 'Big Business',
                      buttonText: 'Register Now',
                      price: 120,
                      callback: () {},
                      isYearly: isYearly,
                      packageDetails: bigBusinessPackage),
                ],
              ),
            // const SizedBox(
            //   height: 20,
            // ),
            // if (isYearly)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       PackageContainer(
            //           packageTitle: 'Professional',
            //           buttonText: 'Register Now',
            //           price: 33,
            //           isYearly: isYearly,
            //           callback: () {},
            //           packageDetails: professionalPackage),
            //       PackageContainer(
            //           packageTitle: 'Big Business',
            //           buttonText: 'Register Now',
            //           price: 120,
            //           callback: () {},
            //           isYearly: isYearly,
            //           packageDetails: bigBusinessPackage),
            //     ],
            //   ),
            if (isYearly)
              const SizedBox(
                height: 50,
              ),
          ],
        ),
      ),
    );
  }
}
