import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:get/get.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';

showSnackBar(String text, String title) {
  Flushbar(
    title: title,
    message: text,
    duration: const Duration(seconds: 3),
    isDismissible: false,
    backgroundColor: primaryColor,
  ).show(Get.context!);
}
