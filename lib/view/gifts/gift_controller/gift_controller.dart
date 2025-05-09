import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../core/constant/assets.dart';
import '../../../core/helper_function/show_dialog.dart';
import '../../home/controller/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../notification/controller/notification_controller.dart';

class GiftController extends GetxController {
  var isLoading = false.obs;
  LatLng? _currentLocationt;
  LatLng? currentLocationt;
  String profileImages = '';
  Set<Marker> _markers = {};
  String gitId = '';
  List nearby = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('gift_sold');
  final HomeController homeController = Get.put(HomeController());
  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _currentLocationt = LatLng(position.latitude, position.longitude);
      currentLocationt = _currentLocationt;
      update();
      await getAllGiftSoldLocation(position.latitude, position.longitude);

      update();
      loadMarkers();
    }
  }

  Future<void> loadMarkers() async {
    List<Marker> markers = [];
    try {
      QuerySnapshot provincesSnapshot = await firestore.get();

      final Uint8List markerIcon =
          await homeController.getBytesFromAsset(Assets.gift_logo, 350);
      for (var provinceDoc in provincesSnapshot.docs) {
        // String provinceName = provinceDoc['name']; //'FF5722'
        double provinceLat = double.parse(provinceDoc['latitude'].toString());
        double provinceLng = double.parse(provinceDoc['longitude'].toString());

        markers.add(Marker(
          markerId: MarkerId(provinceDoc.id),
          position: LatLng(provinceLat, provinceLng),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          visible: false,
          onTap: () {},
        ));
        // Load fingerprints
        QuerySnapshot fingerprintsSnapshot = await firestore.get();

        for (var fingerprintDoc in fingerprintsSnapshot.docs) {
          double lat = double.parse(fingerprintDoc['latitude'].toString());
          double lng = double.parse(fingerprintDoc['longitude'].toString());
          // another location
          markers.add(Marker(
            markerId: MarkerId(fingerprintDoc.id),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            onTap: () {},
          ));
        }
      }

      _markers = markers.toSet();
      update();
    } catch (e) {
      throw ("Error loading data: $e");
    }
  }

  getAllGiftSoldLocation(double lat, double lng) async {
    try {
      isLoading.value = true;
      update();
      QuerySnapshot provincesSnapshot = await firestore.get();

      for (var provinceDoc in provincesSnapshot.docs) {
        // String provinceName = provinceDoc['name'];
        double provinceLat = double.parse(provinceDoc['latitude'].toString());
        double provinceLng = double.parse(provinceDoc['longitude'].toString());
        double distanceInMeters = Geolocator.distanceBetween(
          lat,
          lng,
          provinceLat,
          provinceLng,
        );

        final userId = provinceDoc['userId'];
        gitId = provinceDoc.id;
        final userSnapshot = await users.doc(currentUserId).get();

        if (distanceInMeters <= 3) {
          final balance = userSnapshot['balance'];
          final fingerPrintNum = provinceDoc['fingerPrintNum'];
          showGiftDialog(fingerPrintNum);
          updateUserBalance(currentUserId, balance, fingerPrintNum);
          deleteGift();
          await sendNotifiction(currentUserId, userSnapshot['username'], userId,
              'Your gift has been opend');

          update();
        }
      }
    } catch (xerroe) {
      print('Some thing wrong ${xerroe}');
    }
  }

  Future updateUserBalance(var userId, var balance, var fingerPrintNum) async {
    await users.doc(userId).update({'balance': balance + fingerPrintNum});
  }

  Future deleteGift() async {
    await firestore.doc(gitId).delete();
  }

  Future<void> sendNotifiction(
      String userId, String nameUser, String receiverId, String action) async {
         final NotificationController notificationController = Get.put(NotificationController());
    await notificationController.sendNotification(
        senderId: userId,
        senderName: nameUser ?? '',
        senderImage: profileImages ?? '',
        receiverId: receiverId,
        action: action);
  }

  Set<Marker> get markers => _markers;
  @override
  void onInit() {
  
    getCurrentLocation();

    // TODO: implement onInit
    super.onInit();
  }
}
