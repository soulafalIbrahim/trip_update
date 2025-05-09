import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../setting_profile/controller/account_controller.dart';



class EditProfileController extends GetxController {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userNumberController = TextEditingController();
  final AccountController accountcontroller = Get.put(AccountController());
  UserCredential? userCredential;
  File? profileImage;
  var imageUrl;
  bool isLoading = false;

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage = File(picked.path);
      update();
    }
  }

  Future updateUserAcount(String newName, String phoneNumber) async {
    try {
      isLoading = true; 
      update();
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;
        if (profileImage != null) {
          final ref = storage.ref().child('profile_images/$userId.jpg');
          await ref.putFile(profileImage!);
          imageUrl = await ref.getDownloadURL();

          await firestore.collection('users').doc(userId).update({
            'username': newName,
            'phone': phoneNumber,
            'profileImage': imageUrl ?? '',
          });
          await user.updateDisplayName(newName);
          await user.reload();
       
        }
      }
        await user!.updatePhotoURL(imageUrl);
        accountcontroller.fetchUserData();
      //   print('Update Photo Done............');
      // }
      await user!.reload();
      isLoading = false;
    } catch (xerroe) {
      print('some thing wrong ${xerroe}');
    }
  }

  @override
  void onClose() {
    userNameController.clear();
    userNumberController.clear();
    super.onClose();
  }
}
