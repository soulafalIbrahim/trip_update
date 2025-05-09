import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/widget/custom_text.dart';

import '../constant/assets.dart';

showGiftDialog(int fingerPrintNum) {
  return Get.defaultDialog(
    backgroundColor: AppColor.appColor,
    title: 'Congrats',
    content: Column(
      children: [
        LottieBuilder.asset(Assets.openedGiftift),
        CustomText(
          text: 'Gift For You is ${fingerPrintNum} fingerprint'.tr,
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ],
    ),
  );
}
