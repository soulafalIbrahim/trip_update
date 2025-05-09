import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/widget/custom_elevated_button.dart';
import '../../../../core/constant/color.dart';
import '../../../../widget/custom_text_form_filed.dart';
import '../../setting_profile/controller/account_controller.dart';
import '../edit_profile_controller/edit_profile_controller.dart';
import '../../widgets/profile_header.dart';


class EditProfileScreen extends StatelessWidget {
 const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final AccountController accountController = Get.put(AccountController());
    return Scaffold(
      backgroundColor: AppColor.dark,
      body: SafeArea(
        child: GetBuilder(
          init: EditProfileController(),
          builder: (controller) => SingleChildScrollView(
            child: Container(
              height: Get.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey,
                    Colors.black,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:8 , horizontal:10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     AppHeader(
                        title: "Edit Account".tr, optionsSettings: false),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                           onTap:controller.pickProfileImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: controller.profileImage != null 
                                  
                                ? FileImage(controller.profileImage!)
                                : null,
                            child: controller.profileImage == null 
                                    
                                ? const Icon(Icons.person,
                                    size: 60, color: Colors.blue)
                                : null,
                          ),
                        ),
                         const Positioned(
                          bottom: 0,
                          right: 4,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: 
                            
                               const Icon(Icons.camera_alt,
                                  size: 15, color: Colors.black
                            ),
                          ),
                        ),
                      ],
                    ),
                     const SizedBox(height: 16),
                    CustomTextForm(
                      hintText: accountController.email.value,
                      readOnly: true,
                    ),
                    const SizedBox(height:5),
                    CustomTextForm(
                      hintText: accountController.userName.value,
                      myController: controller.userNameController,
                    ),
                    const SizedBox(height: 5),
                    CustomTextForm(
                      hintText: 'Enter your Phone Number'.tr,
                      myController: controller.userNumberController,
                    )
                    ,
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      text: 'Edit Data'.tr,
                      buttonColor: AppColor.appColor,
                      onPressed: () async {
                      
                       await controller.updateUserAcount(
                          controller.userNameController.text,
                          controller.userNumberController.text,
                        );
                        controller.isLoading == true ?
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.appColor,
                          )
                        ):
                        Get.back(result:true );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
