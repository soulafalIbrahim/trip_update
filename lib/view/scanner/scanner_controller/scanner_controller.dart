import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constant/const_data.dart';
import '../../home/controller/home_controller.dart';

class ScannerController  extends GetxController{
 LatLng? currentLocationt;
 List  nearby = [];
 bool isLoading = false;
 //<DocumentSnapshot>

  CollectionReference fingerprint =  FirebaseFirestore.instance.collection('fingerprints');
   CollectionReference users =  FirebaseFirestore.instance.collection('users');
  HomeController homeController = Get.put(HomeController());
  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocationt = LatLng(position.latitude, position.longitude);
    
      update();
      getAllFingerPrintLocation();
      
    }
  }
  getAllFingerPrintLocation()async{
    try{
    
        isLoading = true;
        update();
        QuerySnapshot provincesSnapshot =
          await fingerprint.get();
          
          for (var provinceDoc in provincesSnapshot.docs) {
        // String provinceName = provinceDoc['name'];
        double provinceLat = double.parse(provinceDoc['latitude'].toString());
        double provinceLng = double.parse(provinceDoc['longitude'].toString());
          double distanceInMeters = Geolocator.distanceBetween(
          currentLocationt!.latitude, currentLocationt!.longitude,
          provinceLat, provinceLng,
  );

  if (distanceInMeters <= 4) { 
     ConstData.fingerprintDocId = provinceDoc.id;
    final userId = provinceDoc['userId'];
    final userSnapshot = await users.doc(userId).get();

    nearby.add({
      'figerprintId': provinceDoc.id,
      'userId': userId,
      'username': userSnapshot['username'] ?? 'some one',  
      'userImage': userSnapshot['profileImage'],
    });
    update();
    
    print(nearby.length);
    print('.......................nearby${ConstData.fingerprintDocId}');
  print('.......................nearby${nearby[0]['username']}');
  }
          
   isLoading = false;
    update();       
          }
    }catch(xerroe){
      print('Some thing wrong ${xerroe}');
    }

  }

  @override
  void onInit() {
    getCurrentLocation();
    // TODO: implement onInit
    super.onInit();
  }
}
