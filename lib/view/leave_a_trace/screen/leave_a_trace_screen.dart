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
      appBar: AppBar(
        backgroundColor: AppColor.dark,
        title:CustomText(text:
                        "Leave a Trace",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
          
                      ) ,
        centerTitle: true,
        leading:  IconButton(
          icon:  const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 25,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:CrossAxisAlignment.start ,
                  children: [
                   SizedBox(height:  controller.comeFromTextButton == false ? 10 :28),
                    CustomText(text: "Enter a Message".tr, color: Colors.white, fontSize: 16),
                     SizedBox(height: controller.comeFromTextButton == false ? 10 : 25), 
                     TextField(
                         
                        onChanged: controller.updateMessage,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "write your message here".tr,
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          contentPadding:const EdgeInsets.symmetric(vertical:28 , horizontal:10),
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                       
                        ),
                        
                      ),
                    const SizedBox(height: 10), 
                    controller.comeFromTextButton == false ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: 
                       controller.selectedImage.value != null 
                          ? 
                          Image.file(
                        File(controller.selectedImage.value!.path),
                        width: double.infinity,
                        height: 298,
                        fit: BoxFit.fill,
                      ) :  arMapController.capturedImage.value != null ?
                          Image.file(
                        File(arMapController.capturedImage.value!.path),
                        width: double.infinity,
                        height: 298,
                        fit: BoxFit.fill,
                      ) 
                          : Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
                    const SizedBox(height: 16),

                     controller.comeFromTextButton == false ?
                  
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
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                    : SizedBox.shrink(),
                    const SizedBox(height: 30),
                        
                    // Enter a Message
                    // GestureDetector(
                    //   onTap: controller.toggleMessageField,
                    //   child:  Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //      CustomText(text: "Enter a Message".tr, color: Colors.white, fontSize: 16),
                    //       Icon(Icons.chevron_right, color: AppColor.white),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                        
                    //if (controller.showMessageField.value)
                     
                    // const SizedBox(height: 20),
                    // GestureDetector(
                    //   onTap: controller.choosePrivacy,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //        CustomText(text: 'Privacy'.tr, color: Colors.white, fontSize: 16),
                    //       Row(
                    //         children: [
                    //           CustomText(text: controller.privacy.value, color: AppColor.white),
                    //           Icon(Icons.chevron_right, color: AppColor.white),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                     SizedBox(height: controller.comeFromTextButton == false ? 100 : 300),
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
                          else {
                            Get.snackbar('', 'The fingerprint cannot be empty');
                          }
                         },
                        child:  CustomText(text: controller.isloading.value == true ? "Loading":
                         "PLACE TRACE",fontSize: 16,color: AppColor.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
