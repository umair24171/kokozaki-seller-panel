// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/helper/get_size.dart';

class PackageContainer extends StatelessWidget {
  PackageContainer(
      {super.key,
      required this.packageTitle,
      required this.buttonText,
      required this.callback,
      required this.price,
      required this.isYearly,
      required this.packageDetails});
  final String packageTitle;
  final String buttonText;
  final VoidCallback callback;
  final double price;

  List<PackageDetails> packageDetails;
  bool isYearly;
  @override
  Widget build(BuildContext context) {
    var discountedPrice = price * 12 * 25 / 100;
    return Flexible(
      child: Card(
        elevation: 8,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: getWidth(context) < 1700 ? getHeight(context) * 0.7 : 0.5,
          width: getWidth(context) * 0.19,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor, width: 1),
              gradient: const LinearGradient(
                  colors: [Color(0xff26A8ED), Color(0xff6CC3E8)])),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        packageTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Hind',
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: packageDetails,
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      isYearly ? '\$$discountedPrice/Year' : '\$$price/Month',
                      style: TextStyle(
                          fontFamily: 'Hind',
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    CustomButtonPackage(
                      buttonText: buttonText,
                      callback: callback,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PackageDetails extends StatelessWidget {
  const PackageDetails({super.key, required this.packageDetails});
  final String packageDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.verified,
              color: Colors.green,
              size: 15,
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            child: Text(
              packageDetails,
              // maxLines: 2,
              style: const TextStyle(
                  overflow: TextOverflow.visible,
                  fontFamily: 'Hind',
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButtonPackage extends StatelessWidget {
  const CustomButtonPackage(
      {super.key, required this.buttonText, required this.callback});
  final String buttonText;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: callback,
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            // color: primaryColor,
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffFEA500), Color(0xffFFD78D)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: whiteColor, fontFamily: 'Hind', fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
