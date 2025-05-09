import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/helpers/my_dialogs.dart';
import '../../../auth/screen/login_screen.dart';

class AccountController extends GetxController {
  var userName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var country = ''.obs;
  var idNumber = ''.obs;
  var userBalance = 0.obs;
 
  var fingerPoint = 0.obs;
  var profileImage  ; 

  
 
  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // call on startup
   
  }
  
   
  
  void fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          userName.value = data['username'] ?? '';
          email.value = data['email'] ?? '';
          phone.value = data['phone'] ?? '';
          country.value = data['country'] ?? '';
          idNumber.value = data['id'] ?? '';
          profileImage  = data['profileImage']?? '';
          fingerPoint.value = data['fingerPoint'] ?? 0;
          userBalance.value = data['balance'] ?? 0;
            
          print('//////////////////////${data['balance']}');

        }

       
      } else {
        throw ("User is not logged in.");
      }
    } catch (e) {
      throw("Error fetching user data: $e");
    }
  }
  Future<void> deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        await FirebaseFirestore.instance.collection('users').doc(userId).delete();


        await user.delete();

        await FirebaseAuth.instance.signOut();

        Get.offAll(() => const LoginScreen());

        MyDialogs.success(msg: 'تم حذف الحساب بنجاح');
      }
    } catch (e) {
      MyDialogs.error(msg: 'حدث خطأ أثناء حذف الحساب: $e');
    }
  }



  



}


