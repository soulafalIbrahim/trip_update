import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/view/account/widgets/profile_header.dart';

import '../../../../core/constant/color.dart';
import '../../../auth/screen/login_screen.dart';
import '../../widgets/profile_row.dart';
import '../../edit_profile/edit_profile_screen/edit _profile_screen.dart';
import '../controller/account_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController accountController = Get.put(AccountController());

    return Scaffold(
      backgroundColor: AppColor.dark,
      body: SafeArea(
        child: Container( decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey,
              Colors.black,
            ],
          ),
        ),
          child: SingleChildScrollView(
            child: Column(
              children: [
        
                 AppHeader(title: "Account Settings".tr,optionsSettings:false),
                const SizedBox(height: 20),
                 Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: accountController.profileImage != null && accountController.profileImage.isNotEmpty
                              ? NetworkImage(accountController.profileImage!)
                              : null,
                      child:accountController.profileImage == null || accountController.profileImage.isEmpty ?
                       const Icon(Icons.person, size: 60, color: Colors.blue)
                              : null,
                    ),
                 const   Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(Icons.camera_alt, size: 15, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      accountController.userName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )),
        
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'PROFILE DATA',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()  => Get.to(()=> EditProfileScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child:  Text("Edit Data".tr, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
        
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Obx(() => Column(
                    children: [
                      ProfileRow(
                        icon: Icons.email,
                        title: "Email address".tr,
                        value: accountController.email.value,
                      ),
                      const Divider(color: Colors.white24),
                      ProfileRow(
                        icon: Icons.person,
                        title: "Name".tr,
                        value: accountController.userName.value,
        
                      ),
                      const Divider(color: Colors.white24),
                      ProfileRow(
                        icon: Icons.phone,
                        title: "Phone Number".tr,
                        value: accountController.phone.value,
                      ),
                      const Divider(color: Colors.white24),
                      ProfileRow(
                        icon: Icons.flag,
                        title: "Country".tr,
                        value: accountController.country.value,
                      ),
                      const Divider(color: Colors.white24),
                      ProfileRow(
                        icon: Icons.badge,
                        title: "Id Number",
                        value: accountController.idNumber.value,
                      ),
                    ],
                  ))
        
                ),
                const SizedBox(height: 20,),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Get.offAll(const LoginScreen());},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child:  Text("Log OUT".tr, style:const TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        accountController.deleteAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child:  Text("Delete Account".tr, style:const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}

