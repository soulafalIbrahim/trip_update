import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/widget/custom_elevated_button.dart';
import 'package:trip/widget/custom_text_form_filed.dart';
import '../../../core/constant/routes.dart';
import '../../../widget/custom_text.dart';
import '../controller/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.dark,
        title: CustomText(
          text: 'Sign up'.tr,
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
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: controller.pickProfileImage,
                    child: CircleAvatar(
                      backgroundColor: AppColor.lightGrey,
                      radius: 50,
                      backgroundImage: controller.profileImage != null
                          ? FileImage(controller.profileImage!)
                          : null,
                      child: controller.profileImage == null
                          ? const Icon(Icons.camera_alt, size: 40, color: AppColor.appColor)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextForm(
                    myController: controller.usernameController,
                    hintText: "Enter your name".tr,
                    iconPrefixData: Icons.person,
                    valid: (val) => val == null || val.isEmpty ? 'Enter your name'.tr : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    myController: controller.emailController,
                    hintText: "Enter your email".tr,
                    iconPrefixData: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    valid: (val) =>
                    !GetUtils.isEmail(val!) ? 'Enter a valid email'.tr : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    myController: controller.birthdateController,
                    hintText: "Date of Birth".tr,
                    iconPrefixData: Icons.calendar_today,
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        controller.birthdateController.text =
                        "${date.year}-${date.month}-${date.day}";
                      }
                    },
                    valid: (val) =>
                    val == null || val.isEmpty ? 'Enter birthdate'.tr : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    myController: controller.passwordController,
                    hintText: "Password".tr,
                    obscureText: true,
                    iconPrefixData: Icons.lock,
                    valid: (val) => val != null && val.length >= 6
                        ? null
                        : 'Password must be at least 6 characters'.tr,
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    myController: controller.confirmPasswordController,
                    hintText: "Confirm Password".tr,
                    obscureText: true,
                    iconPrefixData: Icons.lock,
                    valid: (val) =>
                    val == controller.passwordController.text
                        ? null
                        : 'Passwords do not match'.tr,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Gender: ", style: TextStyle(color: Colors.white , fontSize: 16)),
                      const SizedBox(width: 8,) ,
                      Expanded(
                        child: Obx(() => DropdownButton<String>(
                          value: controller.gender.value,
                          isExpanded: true,
                          dropdownColor: Colors.black,
                          style: const TextStyle(color: Colors.white),
                          items:  [
                            DropdownMenuItem(
                                value: 'Male', child: Text("Male".tr , style:const TextStyle(color: Colors.white , fontSize: 16),)),
                            DropdownMenuItem(
                                value: 'Female', child: Text("Female".tr , style:const TextStyle(color: Colors.white , fontSize: 16),)),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.gender.value = value;
                            }
                          },
                        )),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    text: 'Register'.tr,
                    buttonColor: AppColor.appColor,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.registerWithEmail(
                          controller.emailController.text.trim(),
                          controller.passwordController.text.trim(),
                          controller.usernameController.text.trim(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
