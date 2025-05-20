import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../core/constant/assets.dart';
import '../../../core/constant/const_data.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math' as Math;

class HomeController extends GetxController {
  LatLng? _currentLocation;
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LatLng> polylineCoordinates = [];
  RxList<Map<String, dynamic>> arIconsData = <Map<String, dynamic>>[].obs;
  final FirebaseAuth  userCredential = FirebaseAuth.instance;
  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    loadARIconsData();
  }

  Future<void> loadARIconsData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('ar_icons').get();
      List<Map<String, dynamic>> data = snapshot.docs.map((doc) {
        return {
          'position': Offset(doc['x_position'], doc['y_position']),
          'color': Color(int.parse('0xFF${doc['color']}')),
        };
      }).toList();
      arIconsData.value = data;
    } catch (e) {
      print("Error loading AR icons data: $e");
    }
  }
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentLocation = LatLng(position.latitude, position.longitude);
      update();
      await loadMarkers();
    
    }
  }
  Future<void> loadMarkers() async {
    List<Marker> markers = [];
    try {
      QuerySnapshot fingerprintsSnapshot = await _firestore.collection('fingerprints').get();
      for (var doc in fingerprintsSnapshot.docs) {
        double lat = double.parse(doc['latitude'].toString());
        double lng = double.parse(doc['longitude'].toString());

        markers.add(
          Marker(
            point: LatLng(lat, lng),
            width: 60,
            height: 60,
            child: GestureDetector(
              onTap: () async {
                ConstData.fingerprintDocId = doc.id;
                await getRoutePoints(LatLng(lat, lng));
              },
              child: Image.asset(Assets.logo),
            ),
          ),
        );
      }
      _markers = markers;
      update();
    } catch (e) {
      print("Error loading markers: $e");
    }
  }
  Future<void> getRoutePoints(LatLng destination) async {
    try {
      const String apiKey = '5b3ce3597851110001cf6248fc608d865d2842dc82658c7a1064ec0a';

      final url = Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car/geojson');

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
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
  double getBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * (3.141592653589793 / 180.0);
    final lon1 = start.longitude * (3.141592653589793 / 180.0);
    final lat2 = end.latitude * (3.141592653589793 / 180.0);
    final lon2 = end.longitude * (3.141592653589793 / 180.0);

    final dLon = lon2 - lon1;

    final y = Math.sin(dLon) * Math.cos(lat2);
    final x = Math.cos(lat1) * Math.sin(lat2) -
        Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);

    double brng = Math.atan2(y, x);
    brng = brng * (180.0 / 3.141592653589793);
    return (brng + 360) % 360;
  }
 


  List<Marker> get markers => _markers;
  LatLng? get currentLocation => _currentLocation;
  List<Polyline> get polylines => _polylines;
}
