import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'dart:math' as Math;
import 'package:http/http.dart' as http;
import 'package:trip/data/helpers/my_dialogs.dart';
import '../../../core/constant/assets.dart';
import '../../../core/helper_function/show_dialog.dart';
import '../../home/controller/home_controller.dart';


import '../../notification/controller/notification_controller.dart';

class GiftController extends GetxController {
  var isLoading = false.obs;
  LatLng? _currentLocation;
 // LatLng? currentLocation;
 
  List<Polyline> _polylines = [];
  List<LatLng> polylineCoordinates = [];
  String profileImages = '';
   List<Marker> _giftMarkers = [];
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
      _currentLocation = LatLng(position.latitude, position.longitude);
      update();
      loadMarkers();
    }
  }

  Future<void> loadMarkers() async {
    List<Marker> giftMarkers = [];
    try {
    

        QuerySnapshot fingerprintsSnapshot = await firestore.get();

        for (var fingerprintDoc in fingerprintsSnapshot.docs) {
          double lat = double.parse(fingerprintDoc['latitude'].toString());
          double lng = double.parse(fingerprintDoc['longitude'].toString());
          // another location
          giftMarkers.add(

              Marker(
             point: LatLng(lat, lng),
            width: 90,
            height: 90,
             child: GestureDetector(
              onTap: () async {
              
                await getRoutePoints(LatLng(lat, lng));
              },
              child:  Image.asset(Assets.gift_logo),
            ),
             
        )
          );
        }
      

      _giftMarkers = giftMarkers;
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

        if (distanceInMeters <= 10) {
          final balance = userSnapshot['balance'];
          final fingerPrintNum = provinceDoc['fingerPrintNum'];
          showGiftDialog(fingerPrintNum);
          updateUserBalance(userId, balance, fingerPrintNum);
          deleteGift();
          sendNotifiction(currentUserId, userSnapshot['name'], userId,
              'Your gift has been opend');
          MyDialogs.success(msg: 'New Gift For You') ;
          update();
        }else{
          MyDialogs.info(msg: 'No Nearby Gifts!') ;
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
      String userId, String nameuser, String receiverId, String action) async {
    final NotificationController notificationController =
        Get.put(NotificationController());

    await notificationController.sendNotification(
        senderId: userId,
        senderName: nameuser ?? '',
        senderImage: profileImages ?? '',
        receiverId: receiverId,
        action: action);
  }

  Future<void> getRoutePoints(LatLng destination) async {
    try {
      const String apiKey =
          '5b3ce3597851110001cf6248fc608d865d2842dc82658c7a1064ec0a';

      final url = Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car/geojson');

      final body = jsonEncode({
        "coordinates": [
          [_currentLocation!.longitude, _currentLocation!.latitude],
          [destination.longitude, destination.latitude]
        ]
      });

      final response = await http.post(
        url,
        headers: {
          'Authorization': apiKey,
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coordinates = data['features'][0]['geometry']['coordinates'];

        polylineCoordinates = coordinates
            .map<LatLng>((point) => LatLng(point[1], point[0]))
            .toList();

        drawRoute();
        /// AR Code
        ///    drawArrowsOnRoute();
      } else {
        print('Failed to load directions: ${response.body}');
      }
    } catch (e) {
      print('Error getting route points: $e');
    }
  }
  void drawRoute() {
    if (_currentLocation == null || polylineCoordinates.isEmpty) return;

    final polyline = Polyline(
      points: polylineCoordinates,
      color: const Color(0xFF42A5F5),
      strokeWidth: 4.0,
    );

    _polylines = [polyline];
    update();
  }

  List<Marker> get giftMarkers => _giftMarkers;
  List<Polyline> get polylines => _polylines;
   LatLng? get currentLocation => _currentLocation;
 
  @override
  void onInit() {
    // getCurrentLocation();
    getCurrentLocation();

    // TODO: implement onInit
    super.onInit();
  }
}
