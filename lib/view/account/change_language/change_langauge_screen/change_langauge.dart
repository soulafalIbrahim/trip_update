import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constant/color.dart';
import '../../../../widget/custom_elevated_button.dart';
import '../change_langauge_controller/change_langauge_controller.dart';
import '../../widgets/profile_header.dart';

class ChangeLangaugeScreen extends StatelessWidget {
  const ChangeLangaugeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColor.dark,
      body:SafeArea(
        child:GetBuilder(
          init: ChangeLangaugeController(),
          builder: (controller) => 
           Container(
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
              padding: const EdgeInsets.symmetric(vertical:8 , horizontal:18),
              child: Column(
                    
                      children: [
                          AppHeader(
                          title: "language".tr, optionsSettings: false),
                       SizedBox(height: Get.height * 0.3,),
                         CustomElevatedButton(
                        text: 'English Language'.tr,
                        buttonColor: AppColor.appColor,
                        onPressed: () async {
                          await  controller.changeLanguage('en');
                        },
                      ),
                       const  SizedBox(height:20,),
                         CustomElevatedButton(
                        text: 'Arabic Language'.tr,
                        buttonColor: AppColor.appColor,
                        onPressed: () async {
                         await controller.changeLanguage('ar');
                    
                        },
                      ),
                      ],
              
                    ),
            ),
          ),
        )),
    ) ;
  }
}