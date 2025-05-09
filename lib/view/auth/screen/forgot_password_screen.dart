import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/assets.dart';
import '../../../widget/custom_elevated_button.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_text_form_filed.dart';
import '../../../core/constant/color.dart';
import '../controller/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.dark,
        title: CustomText(
          text: 'Reset Password'.tr,
          fontSize: 25,
          color: AppColor.lightGrey,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child:const Icon(Icons.arrow_back_ios, color: Colors.white),
        ) ,
      ),
      backgroundColor: AppColor.dark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.iconLock),
              const SizedBox(height: 20),
              CustomText(
                text: 'Enter your email'.tr,
                fontSize: 18,
                color: AppColor.lightGrey,
              ),
              const SizedBox(height: 20),
              CustomTextForm(
                myController: _emailController,
                hintText: 'Email'.tr,
                iconPrefixData: Icons.email,
                valid: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pleas enter your email'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Send Email'.tr,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _authController.sendPasswordResetEmail(
                      _emailController.text.trim(),
                    );
                  }
                },
                buttonColor: AppColor.appColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
