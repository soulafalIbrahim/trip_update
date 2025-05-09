import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/assets.dart';
import '../../../core/constant/color.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_elevated_button.dart';
import '../controller/auth_controller.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.dark,
          title: CustomText(
            text: 'Verification Code'.tr,
            fontSize: 25,
            color: AppColor.lightGrey,
          ),
          centerTitle: true,
        ),
        backgroundColor: AppColor.dark,
        body: GetBuilder<AuthController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset(Assets.verEmail)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                    child: CustomText(
                      text:
                          'Please check your email for the verification link and click on it.'.tr,
                      fontSize: 18,
                      color: AppColor.lightGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomElevatedButton(
                  text: 'Confirmed My Email'.tr,
                  buttonColor: AppColor.appColor,
                  onPressed: controller.checkVerification,
                ),
              ],
            ),
          );
        }));
  }
}
