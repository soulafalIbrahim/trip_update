
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constant/assets.dart';
import '../../../core/constant/const_data.dart';
import '../../gift_comments/screen/gift_comments.dart';

class HomeController extends GetxController {
  LatLng? _currentLocation;
  LatLng? currentLocationt;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {}; // ✅ لإضافة مسار
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LatLng> polylineCoordinates = [];
  RxList<Map<String, dynamic>> arIconsData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    _getCurrentLocation();
    print('${currentLocation}');
    loadARIconsData();
    super.onInit();
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
      throw ("Error loading AR icons data: $e");
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
          desiredAccuracy: LocationAccuracy.high);
      _currentLocation = LatLng(position.latitude, position.longitude);
      currentLocationt = _currentLocation;
      update();
      loadMarkers();
    }
  }

  Future<void> loadMarkers() async {
    List<Marker> markers = [];
    try {
      QuerySnapshot provincesSnapshot =
          await _firestore.collection('fingerprints').get();
      
      final Uint8List markerIcon = await getBytesFromAsset(Assets.logo, 100);
      for (var provinceDoc in provincesSnapshot.docs) {
        // String provinceName = provinceDoc['name'];
        double provinceLat = double.parse(provinceDoc['latitude'].toString());
        double provinceLng = double.parse(provinceDoc['longitude'].toString());

        markers.add(Marker(
          markerId: MarkerId(provinceDoc.id),
          position: LatLng(provinceLat, provinceLng),
          //  infoWindow: InfoWindow(title: '${provinceLng}'),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          visible: false,
          onTap: () {
           
          },
        ));
        // Load fingerprints
        QuerySnapshot fingerprintsSnapshot =
            await _firestore.collection('fingerprints').get();

        for (var fingerprintDoc in fingerprintsSnapshot.docs) {
          //String colorHex = fingerprintDoc['color'];
          double lat = double.parse(fingerprintDoc['latitude'].toString());
          double lng = double.parse(fingerprintDoc['longitude'].toString());
          // another location
          markers.add(Marker(
            markerId: MarkerId(fingerprintDoc.id),
            position: LatLng(lat, lng),
            //  infoWindow: InfoWindow(title: 'Fingerprint ${fingerprintDoc.id}'),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            onTap: () {
              ConstData.fingerprintDocId = fingerprintDoc.id;
           //   getRoutePoints(LatLng(lat, lng));
            //  drawRoute();
        
              //LatLng(lat, lng)// ✅ عند الضغط على البصمة نرسم المسار
            },
          ));
        }
      }

      _markers = markers.toSet();
      update();
    } catch (e) {
      throw ("Error loading data: $e");
    }
  }

  // ss
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

Future<void> getRoutePoints(LatLng destination) async {
  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    googleApiKey: 'AIzaSyARTBQax2dBWtXzMvsQpKRabo4wElGuY5Y',
    request: PolylineRequest(origin: PointLatLng(currentLocation!.latitude, currentLocation!.longitude), 
    destination: PointLatLng(destination.latitude, destination.longitude),
    mode: TravelMode.driving,),
    
  );

  if (result.points.isNotEmpty) {
    polylineCoordinates = result.points
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }
}

  

  void drawRoute() {
    if (_currentLocation == null) return;

    final Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      color: const Color(0xFF42A5F5), // لون المسار أزرق
      width: 5,
      points: polylineCoordinates,
    );

    _polylines = {polyline};
    update();
  }

//AIzaSyARTBQax2dBWtXzMvsQpKRabo4wElGuY5Y
  Set<Marker> get markers => _markers;
  LatLng? get currentLocation => _currentLocation;
  Set<Polyline> get polylines => _polylines; // ✅ getter للمسارات
}
