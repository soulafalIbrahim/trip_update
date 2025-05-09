import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constant/assets.dart';
import '../../../core/constant/color.dart';
import '../../../widget/custom_button_navbar_widget.dart';
import '../../gifts/gift_controller/gift_controller.dart';
import '../../gifts/screen/gifts_screen.dart';
import '../../leave_a_trace/screen/leave_a_trace_screen.dart';
import '../../scanner/scanner_screen/scanner_screen.dart';
import '../controller/ar_map_controller.dart';

// class ArTakePhotoScreen extends StatelessWidget {
//   const ArTakePhotoScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ArMapController());
//
//     return Scaffold(
//       backgroundColor: AppColor.dark,
//       appBar: AppBar(
//         backgroundColor: AppColor.dark,
//         title: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(AppRoutes.buttonNavBarScreen);
//                 },
//                 child: Icon(Icons.arrow_back_ios, color: AppColor.white),
//               ),
//               const Spacer(),
//               CustomText(
//                 text: 'Add Trace',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//                 color: AppColor.lightGrey,
//               ),
//               const Spacer(),
//               IconButton(
//                 icon: Icon(
//                   Icons.arrow_circle_down_sharp,
//                   color: AppColor.white,
//                 ),
//                 onPressed: () {
//                   Get.to(
//                     () => const CustomBottomNavigationWidget(),
//                     transition: Transition.upToDown,
//                     duration: const Duration(milliseconds: 500),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (!controller.isCameraInitialized.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: CameraPreview(controller.cameraController),
//             ),
//             Positioned(
//               top: 150,
//               left: 0,
//               right: 0,
//               child: Obx(() {
//                 if (controller.selectedPage.value == 0) {
//                   return Center(
//                     child: CustomText(
//                       text: "Fingerprint Mode",
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 } else if (controller.selectedPage.value == 1) {
//                   return Center(
//                     child: CustomText(
//                       text: "Camera Mode",
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 } else if (controller.selectedPage.value == 2) {
//                   return Center(
//                     child: CustomText(
//                       text: "Gift Mode",
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                 } else {
//                   return const SizedBox();
//                 }
//               }),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 0,
//               right: 0,
//               height: 100,
//               child: PageView(
//                 controller: PageController(viewportFraction: 0.3),
//                 scrollDirection: Axis.horizontal,
//                 onPageChanged: (index) {
//                   controller.selectedPage.value = index;
//                 },
//                 children: List.generate(controller.buttons.length, (index) {
//                   final button = controller.buttons[index];
//                   return GestureDetector(
//                     onTap: () => controller.takePicture(),
//                     child: Obx(() => Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: controller.selectedPage.value == index
//                                   ? Colors.blueAccent
//                                   : Colors.transparent,
//                               width: 3,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(button['icon'],
//                                   size: 50, color: Colors.blueAccent),
//                               const SizedBox(height: 8),
//                               CustomText(
//                                   text: button['label'],
//                                   color: Colors.white,
//                                   fontSize: 14),
//                             ],
//                           ),
//                         )),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

class ArTakePhotoScreen extends StatelessWidget {
  const ArTakePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ArMapController());
   // final giftController = Get.put(GiftController());

    return Scaffold(
      backgroundColor: AppColor.dark,
      appBar: AppBar(
        backgroundColor: AppColor.dark,
        title: const Text(
          'Add Trace',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.grey),
        ),
        centerTitle: true ,
        leading:  IconButton(
          icon:  const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 25,
          ),
          onPressed: () {
            Get.to(() => const CustomBottomNavigationWidget(), transition: Transition.upToDown, duration: const Duration(milliseconds: 500));
          },
        ),
      ),
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            Positioned.fill(
              child: CameraPreview(controller.cameraController),
            ),
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Obx(() {
                if (controller.selectedPage.value == 0) {
                  return  Center(
                    child: Text("Scanner Mode".tr, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  );
                } else if (controller.selectedPage.value == 1) {
                  return  Center(//Gift Mode
                    child: Text("Fingerprint Mode".tr, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  );
                } else if (controller.selectedPage.value == 2) {
                  return  Center(
                    child: Text("Gift Mode".tr, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  );
                } 
                
                else {
                  return const SizedBox();
                }
              }),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              height: 100,
              child: PageView(
                controller: PageController(viewportFraction: 0.3),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  controller.selectedPage.value = index;
                },
                children: List.generate(controller.buttons.length, (index) {
                  final button = controller.buttons[index];
                  return GestureDetector(
                    onTap: () {
                      //edit action for button
                      if( controller.selectedPage.value == 0){
                           Get.to(ScannerScreen());
                      }else if(controller.selectedPage.value == 1){
                            controller.takePicture();
                          Get.to(LeaveTraceScreen());
                      }
                      else if(controller.selectedPage.value == 2){
                       
                      
                        Get.to(GiftsMapScreen());
                      }
                      
                    },
                    child: Obx(() => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.selectedPage.value == index ? Colors.blueAccent : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(button['icon'], size: 50, color: Colors.blueAccent),
                          const SizedBox(height: 8),
                          Text(button['label'], style: const TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    )),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}
