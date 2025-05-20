import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/widget/custom_text.dart';
import '../../../core/constant/assets.dart';
import '../../../core/constant/color.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColor.dark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.logo,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 3) ,
            const CustomText(text: 'TagZone',fontSize: 25,fontWeight: FontWeight.bold,
            color: AppColor.appColor,)
          ],
        ),
      ),
    );
  }
}
