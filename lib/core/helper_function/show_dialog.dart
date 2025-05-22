import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constant/assets.dart';
import '../constant/color.dart';

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

showAddFinferPrintErrorDialog(){
  return 
    Get.defaultDialog(
          title: 'Error',
          titleStyle:TextStyle(color:Colors.white),
          middleText: ' ',
          backgroundColor: AppColor.appColor,
          radius: 12,
          content: SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.1,
            width: MediaQuery.of(Get.context!).size.height * 0.4,
            child: const Text(
              'The fingerprint not added , please try again',
              style: TextStyle(color: Colors.white , fontSize:15),
            ),
          ),
          cancel: TextButton(
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Get.back(),
          ));
}
// latitude   35.2616517
// longitude   36.0572808
// fingerPrintNum 300
// userId whqXt0gExcg09RkiWQ287QBFvGD3
