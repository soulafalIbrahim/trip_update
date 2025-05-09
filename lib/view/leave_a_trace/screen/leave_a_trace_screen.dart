import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/color.dart';

import '../../../widget/custom_text.dart';

import '../../ar_map/controller/ar_map_controller.dart';
import '../controller/leave_a_trace_controller.dart';

class LeaveTraceScreen extends StatelessWidget {
  const LeaveTraceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveTraceController());
    final arMapController = Get.put(ArMapController());
    return Scaffold(
      backgroundColor:AppColor.dark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                       InkWell(onTap:(){Get.back();},child: Icon(Icons.arrow_back, color: AppColor.white)),
                      const Spacer(),
                      const SizedBox(width: 8),
                       CustomText(text:
                        "Leave a Trace",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
          
                      ),
                    //  const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
          
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: 
                     controller.selectedImage.value != null 
                        ? 
                        Image.file(
                      File(controller.selectedImage.value!.path),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ) :  arMapController.capturedImage.value != null ?
                        Image.file(
                      File(arMapController.capturedImage.value!.path),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ) 
                        : Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image, color: Colors.blue),
                          const   SizedBox(width: 8),
                          Text(
                            "Upload photo".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
          
                  // Enter a Message
                  GestureDetector(
                    onTap: controller.toggleMessageField,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       CustomText(text: "Enter a Message".tr, color: Colors.white, fontSize: 16),
                        Icon(Icons.chevron_right, color: AppColor.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
          
                  if (controller.showMessageField.value)
                    TextField(
                      onChanged: controller.updateMessage,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "اكتب رسالتك هنا".tr,
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: controller.choosePrivacy,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         CustomText(text: 'Privacy'.tr, color: Colors.white, fontSize: 16),
                        Row(
                          children: [
                            CustomText(text: controller.privacy.value, color: AppColor.white),
                            Icon(Icons.chevron_right, color: AppColor.white),
                          ],
                        ),
                      ],
                    ),
                  ),
          
                  //const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.appColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:() async { 
                        if(controller.message.value != '' || controller.selectedImage.value != null || arMapController.capturedImage.value != null)
                        {
                           await controller.addFingerPrint(controller.message.value);
                          
                        }
                       },
                      child:  CustomText(text: controller.isloading.value == true ? "Loading":
                       "PLACE TRACE",fontSize: 16,color: AppColor.white,),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
