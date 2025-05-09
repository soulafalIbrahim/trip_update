import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class ArMapController extends GetxController {
  late CameraController cameraController;
  var isCameraInitialized = false.obs;
  var capturedImage = Rx<File?>(null);
  RxInt selectedPage = 0.obs;
  List<Map<String, dynamic>> buttons = [
    {"icon": BoxIcons. bx_qr_scan , "label": "Scanner"},
    {"icon": Icons.fingerprint, "label": "Fingerprint"},
    {"icon": BoxIcons.bx_gift, "label": "Gift"},
   

  ];
  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await cameraController.initialize();
    isCameraInitialized.value = true;
  }

  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized) return;

    // final directory = await getTemporaryDirectory();
    // final imagePath = join(directory.path, '${DateTime.now()}.png');

    final XFile picture = await cameraController.takePicture();
    capturedImage.value = File(picture.path);
    print('photo  Token${capturedImage.value}');
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
