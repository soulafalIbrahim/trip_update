import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constant/assets.dart';

showGiftDialog(int fingerPrintNum) {
  return Get.defaultDialog(
    backgroundColor: Colors.transparent,
    radius: 12,
    content: SizedBox(
      height: MediaQuery.of(Get.context!).size.height * 0.5,
      width: double.infinity,
      child: LottieBuilder.asset(Assets.openedGiftift , fit: BoxFit.fill,),
    ),
  );
}

// latitude   35.2616517
// longitude   36.0572808
// fingerPrintNum 300
// userId whqXt0gExcg09RkiWQ287QBFvGD3
