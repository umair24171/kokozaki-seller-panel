import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/controllers/seller_controllers.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SellerController());
    // controller.getSellerData();
    return Scaffold(
        body: Obx(
      () => controller.seller.value != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(controller.seller.value!.imageUrl),
                  radius: 100,
                ),
                Text('\$${controller.seller.value!.sellerBalance}'),
                Text(controller.seller.value!.marketName),
                Text(controller.seller.value!.email),
                Text(controller.seller.value!.category),
                Text(controller.seller.value!.hmRatings.toString()),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    ));
  }
}
