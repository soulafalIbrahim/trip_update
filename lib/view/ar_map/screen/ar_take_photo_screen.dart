import 'dart:math';
import 'package:icons_plus/icons_plus.dart';
import 'package:trip/view/home/screen/home_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip/view/gift_comments/screen/gift_comments.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/const_data.dart';
import '../../../core/constant/routes.dart';
import '../../../widget/circle_button_widget.dart';
import '../../account/setting_profile/screen/profile_screen.dart';
import '../../gift_shopping_list/screen/gift_shopping_list_screen.dart';
import '../../leave_a_trace/controller/leave_a_trace_controller.dart';
import '../../leave_a_trace/screen/leave_a_trace_screen.dart';
import '../controller/ar_map_controller.dart';

class ArTakePhotoScreen extends StatelessWidget {
  const ArTakePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ArMapController());

    return VisibilityDetector(
      key: const Key('ar-take-photo-screen'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          controller.refreshScreen();
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.dark,
        appBar: AppBar(
          backgroundColor: AppColor.dark,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Get.to(() => const ProfileScreen()),
              child: const CircleButtonWidget(
                  icon: Icons.person, height: 20, width: 20),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: controller.switchCamera,
              child: const CircleButtonWidget(
                icon: Icons.cameraswitch_sharp,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.notificationScreen),
              child: const CircleButtonWidget(
                icon: Icons.notifications,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 10),
           
            
          ],
        ),
        body: Obx(() {
          if (!controller.isCameraInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final screenSize = MediaQuery.of(context).size;
          final centerX = screenSize.width / 2;
          final centerY = screenSize.height / 2;

          return Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(controller.cameraController),
              ),
              ...controller.nearbyPosts.map((post) {
                final bearing = controller.calculateBearingTo(
                  LatLng(post.latitude, post.longitude),
                );
                final relativeAngle =
                    ((bearing - controller.heading.value + 360) % 360) * (pi / 180);
                final distance = Geolocator.distanceBetween(
                  controller.currentLocation!.latitude,
                  controller.currentLocation!.longitude,
                  post.latitude,
                  post.longitude,
                );
                final clampedDistance = distance.clamp(0, 10);
                final displayRadius = (clampedDistance / 10) * screenSize.width;

                final offsetX = centerX + displayRadius * cos(relativeAngle);
                final offsetY = centerY + displayRadius * sin(relativeAngle);

                return Positioned(
                  left: offsetX.clamp(0, screenSize.width - 60),
                  top: offsetY.clamp(0, screenSize.height - 60),
                  child: controller.showFb.value
                      ? InkWell(
                    onTap: () {
                      ConstData.fingerprintDocId = post.id;
                      Get.to(() => const GiftCommentsScreen());
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.fingerprint,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox(),
                );
              }),
              Positioned(
                bottom: 30,
                left: screenSize.width * 0.38,
                right: screenSize.width * 0.38,
                height: 100,
                child: GestureDetector(
                  onTap: controller.takePicture,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.fingerprint,
                        size: 60, color: Colors.blueAccent),
                  ),
                ),
              ),
           
              Positioned(
                right: 16,
                bottom: 30,
                child: Column(
                  children: [
                     GestureDetector(
                       onTap:(){
                       
                        controller.isRearFlashOn.value = !controller.isRearFlashOn.value;
                       controller.toggleFlash();
                      },
                      child:  CircleButtonWidget(
                          icon:    controller.isRearFlashOn.value ?
                          Icons.flash_on_sharp
                          : Icons.flash_off, height: 40, width: 40),
                    ),
                     const SizedBox(height: 10),
                          GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.leaveTraceScreen),
              child: const CircleButtonWidget(
                icon: Icons.add,
                height: 40,
                width: 40,
              ),
            ),
             const SizedBox(height: 10),
                      GestureDetector(
                      onTap:(){
                        final LeaveTraceController  leaveTraceController= Get.put(LeaveTraceController());
                        leaveTraceController.comeFromTextButton = true ;
                        Get.to(()=> LeaveTraceScreen());

                      },
                      child: const CircleButtonWidget(
                          icon: BoxIcons.bx_text, height: 40, width: 40),
                    ),
                     const SizedBox(height: 10),
                    GestureDetector(
                      onTap: controller.fetchNearbyGfts,
                      child: const CircleButtonWidget(
                          icon: BoxIcons.bx_scan, height: 40, width: 40),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => controller.showFb.toggle(),
                      child: const CircleButtonWidget(
                          icon: Icons.hide_source, height: 40, width: 40),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Get.to(() => const GiftsShoppingListScreen()),
                      child: const CircleButtonWidget(
                          icon: BoxIcons.bx_gift, height: 50, width: 50),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Get.to(() => const ARMapScreen()),
                      child: const CircleButtonWidget(
                          icon: Icons.location_on, height: 60, width: 60),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
