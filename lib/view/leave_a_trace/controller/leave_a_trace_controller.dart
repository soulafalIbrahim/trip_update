import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip/core/constant/color.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trip/core/constant/const_data.dart';
import 'package:trip/core/services/services.dart';
import '../../account/setting_profile/controller/account_controller.dart';
import '../../home/controller/home_controller.dart';
import '../../notification/controller/notification_controller.dart';

class LeaveTraceController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  LatLng? currentLocation;
  String receiverId = ' ';
  String username = '';
  var profileImage;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool showMessageField = false.obs;
  RxString message = ''.obs;
  RxString privacy = 'Public'.obs;
  RxInt fingerPoint = 0.obs;
  String fingerprintUserId = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference fingerPrints =
      FirebaseFirestore.instance.collection('fingerprints');
  
  final FirebaseStorage storage = FirebaseStorage.instance;

  final AccountController accountController = Get.find();
  final HomeController homeController =
      Get.put(HomeController()); // Get the instance of HomeController
  User? user = FirebaseAuth.instance.currentUser;
  RxString fingerPointId = ''.obs;
  var oldFingerPoint;
  RxBool isloading = false.obs;

  getAllUserLocation() async {
    try {
      //   isLoading = true;
      update();
      QuerySnapshot provincesSnapshot = await fingerPrints.get();

      for (var provinceDoc in provincesSnapshot.docs) {
        // String provinceName = provinceDoc['name'];
        double provinceLat = double.parse(provinceDoc['latitude'].toString());
        double provinceLng = double.parse(provinceDoc['longitude'].toString());
        double distanceInMeters = Geolocator.distanceBetween(
          currentLocation!.latitude,
          currentLocation!.longitude,
          provinceLat,
          provinceLng,
        );

        if (distanceInMeters <= 3) {
          final userId = provinceDoc['userId'];
          final userSnapshot = await users.doc(userId).get();
          if (userSnapshot.exists) {
            username = userSnapshot['username'];
            profileImage = userSnapshot['profileImage'];
          }

          await sendNotifiction(userId, username ?? '', user!.uid,
              '${username} add a finger print');
        }
      }
    } catch (xerroe) {
      print('Some thing wrong ${xerroe}');
    }
  }

  increaceFingerPrint() {
    fingerPoint.value++;
    oldFingerPoint = accountController.fingerPoint + fingerPoint.value;
    updateFingerPrintNumber();
    print('fingerPoint.........${fingerPoint.value}');
  }

  updateFingerPrintNumber() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('we Update User Point Figher Now ............');
      await users.doc(user.uid).update({'fingerPoint': oldFingerPoint.value});
    }
  }

  addFingerPrint(String title) async {
    Position position = await getCurrentLocation();
    try {
      print('we in try ......................');
      isloading.value = true;
      String? imageUrl;

      currentLocation = LatLng(position.latitude, position.longitude);
      if (user != null) {
        final newRef = fingerPrints.doc();

        final fingerPrintId = newRef.id;

        if (selectedImage!.value != null) {
          final ref =
              storage.ref().child('fingerPoint_images/${fingerPrintId}.jpg');
          await ref.putFile(selectedImage.value!);
          imageUrl = await ref.getDownloadURL();
        }

        print(
            'we add finger point User Point Figher Now ......${fingerPrintId}....${ConstData.fingerprintDocId}..');
        await fingerPrints.doc(fingerPrintId).set({
          'id': fingerPrintId,
          'title': title,
          'image': imageUrl ?? '',
          'userId': user!.uid,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'likes': [],
        });

        increaceFingerPrint();
        placeTrace();
        await getAllUserLocation();
        isloading.value = false;
        Get.find<HomeController>();
      }
    } catch (xerroe) {
      print('Some thing is error ${xerroe}');
    }
  }

  void pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void toggleMessageField() {
    showMessageField.toggle();
  }

  void updateMessage(String value) {
    message.value = value;
  }

  void placeTrace() async {
    Get.snackbar("تم", "تم إرسال التتبع بنجاح!");
  }

  void choosePrivacy() {
    Get.defaultDialog(
      title: "Select Privacy",
      titleStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColor.white),
      backgroundColor: Colors.grey[900],
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          ListTile(
            title: const Text("Public", style: TextStyle(color: Colors.white)),
            leading: const Icon(Icons.public, color: Colors.blue),
            onTap: () {
              privacy.value = "Public";
              Get.back();
            },
          ),
          ListTile(
            title: const Text("Private", style: TextStyle(color: Colors.white)),
            leading: const Icon(Icons.lock, color: Colors.blue),
            onTap: () {
              privacy.value = "Private";
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  Future<Position> getCurrentLocation() async {
    await requestLocationPermission(); // ensure permission granted
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future sendNotifiction(String senderId, String? nameuser, String receiverId,
      String action) async {
        final NotificationController notificationController =
      Get.put(NotificationController());
    await notificationController.sendNotification(
        senderId: senderId,
        senderName: nameuser ?? '',
        senderImage: profileImage ?? '',
        receiverId: receiverId,
        action: action);
  }
}
