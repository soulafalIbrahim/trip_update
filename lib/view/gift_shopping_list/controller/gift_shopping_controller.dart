import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GiftsShoppingListController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference gifts = FirebaseFirestore.instance.collection('gifts');
  bool isLoading = false;
  var imageGiftUrl;
  File? GiftImage;
  List allGifts = [];

  Future getAllGifts() async {
    try{
      isLoading = true;
      update();
       await gifts.snapshots().listen((event) {
      final doc = event.docs;
    
      allGifts.assignAll(doc);
      update();

      isLoading   = false;
      update();
      print('Giftsssskkkkkkkkkkk${allGifts[0]['giftImage']}');
    });
    }catch(e){
      print('some thing wrong ${e}');
    }
  
  }

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      GiftImage = File(picked.path);
      update();
    }
  }

  Future<void> addGifts(
      String giftId, String giftname, int price, int fingerPoint) async {
    try {
      isLoading = true;
      update();

      String? imageUrl;
      if (GiftImage != null) {
        final ref = storage.ref().child('gift_images/$giftId.jpg');
        await ref.putFile(GiftImage!);
        imageUrl = await ref.getDownloadURL();
      }

      await gifts.doc(giftId).set({
        'id': giftId,
        'name': giftname,
        'giftImage': imageUrl ?? '',
        'price': price,
        'fingerPoint': fingerPoint,
      });
    } catch (e) {
      print('some thing wrong ${e}');
    }
  }

@override
  void onInit()  async{
    await  getAllGifts();
    super.onInit();
  }



}
