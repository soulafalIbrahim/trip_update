import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:torch_light/torch_light.dart';
import 'package:trip/data/helpers/my_dialogs.dart';
import '../../../data/models/posts/posts.dart';
import '../../gifts/gift_controller/gift_controller.dart';
import '../../leave_a_trace/screen/ImagePreviewScreen.dart';


class ArMapController extends GetxController   {
  late CameraController cameraController;
  LatLng? currentLocation;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth userCredential = FirebaseAuth.instance;
  var isCameraInitialized = false.obs;
  RxBool isLoading = false.obs;
  Rx<File?> capturedImage = Rx<File?>(null);
  RxBool isRearFlashOn = true.obs;


  RxList<Post> nearbyPosts = <Post>[].obs;
  List<CameraDescription> cameras = [];
  RxInt selectedCameraIndex = 0.obs;
  RxBool showFb = true.obs;
 

  @override
  void onInit() async {

    await getCurrentLocation();
    await fetchNearbyPosts();
    await _initCamera();
    super.onInit();
  }

  void refreshScreen() {
    getCurrentLocation();
  }

 
  
  

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        MyDialogs.error(msg: 'No Camera On This Phone!');
        return;
      }

      selectedCameraIndex = 0.obs;
      final camera = cameras[selectedCameraIndex.value];

      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController.initialize();
      isCameraInitialized.value = true;

    } catch (e) {
      debugPrint('Error initializing camera: $e');
      isCameraInitialized.value = false;
    }
  }


  Future<void> switchCamera() async {
    if (cameras.length < 2) {
      MyDialogs.info(msg: 'You Just Have One Camera!');
      return;
    }

    isCameraInitialized.value = false;
    await cameraController.dispose();

    selectedCameraIndex = selectedCameraIndex == 0.obs ? 1.obs : 0.obs;
    final newCamera = cameras[selectedCameraIndex.value];

    cameraController = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await cameraController.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint('Error switching camera: $e');
      MyDialogs.error(msg: 'Failed to switch camera');
    }
  }


  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized) return;

    final XFile picture = await cameraController.takePicture();
    capturedImage.value = File(picture.path);

    Get.to(()=> ImagePreviewScreen(imageFile: capturedImage.value!,)) ;
  }

  RxDouble heading = 0.0.obs;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      await getCurrentLocation();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation = LatLng(position.latitude, position.longitude);

      // Get heading from compass
      FlutterCompass.events!.listen((event) {
        heading.value = event.heading ?? 0;
      });

      await saveUserLocation(position);

    }
  }

  double calculateBearingTo(LatLng destination) {
    if (currentLocation == null) return 0.0;

    double lat1 = currentLocation!.latitude * pi / 180;
    double lat2 = destination.latitude * pi / 180;
    double deltaLon =
        (destination.longitude - currentLocation!.longitude) * pi / 180;

    double y = sin(deltaLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon);
    double bearing = atan2(y, x) * 180 / pi;

    return (bearing + 360) % 360;
  }

  Future<void> fetchNearbyPosts() async {
    MyDialogs.info(msg: 'Searching For FingerPrints') ;
    await getCurrentLocation();
    try {
      if (currentLocation == null) {
        MyDialogs.info(msg: 'We Need Location on!');
      }
      final postsSnapshot = await _firestore.collection('fingerprints').get();
      final allPosts = postsSnapshot.docs.map((doc) {
        return Post.fromFirestore(doc);
      }).toList();

      final nearby = allPosts.where((post) {
        final distance = Geolocator.distanceBetween(
          currentLocation!.latitude,
          currentLocation!.longitude,
          post.latitude,
          post.longitude,
        );
        return distance <= 100;
      }).toList();

      nearbyPosts.value = nearby;
      nearby.isNotEmpty
          ? MyDialogs.success(msg: 'Nearby FingerPrints Found!')
          : MyDialogs.info(msg: 'No Nearby FingerPrint!');
    } catch (e) {
      MyDialogs.error(msg: e.toString());
    }
  }

  Future<void> saveUserLocation(Position position) async {
    String userId = userCredential.currentUser!.uid;
    try {
      await _firestore.collection('users').doc(userId).update({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (e) {
      throw ('Error updating location: $e');
    }
  }

  Future<void> fetchNearbyGfts() async {
     final GiftController giftController = Get.put(GiftController());

    try {
      MyDialogs.info(msg: 'Searching For Gifts') ;
      isLoading.value = true ;
      await  getCurrentLocation() ;
      await giftController.getAllGiftSoldLocation(
          currentLocation!.latitude, currentLocation!.longitude);

      isLoading.value = false;
    } catch (e) {
      print(' Some Thing Wrong${e.toString()}');
    }
  }


void toggleFlash() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;

    try {
      if (isRearFlashOn.value == false) {
        await cameraController!.setFlashMode(FlashMode.off);
      } else {
        await cameraController!.setFlashMode(FlashMode.torch); // or .auto
      }
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }
 
  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
