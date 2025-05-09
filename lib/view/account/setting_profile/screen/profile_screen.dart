import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/routes.dart';
import '../../../../core/constant/color.dart';
import '../../../gift_shopping_list/screen/gift_shopping_list_screen.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/profile_menu_item.dart';
import '../../change_language/change_langauge_screen/change_langauge.dart';
import '../../leader_board/leader_board_screen/leader_board_screen.dart';
import '../controller/account_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
   final AccountController accountController = Get.put(AccountController());
    return Scaffold(
      backgroundColor:AppColor.dark,
      body: SafeArea(
        
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey,
                Colors.black,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                 AppHeader(title: 'Profile Screen'.tr,optionsSettings:true),
                const SizedBox(height: 20),
                const  Text(
                  "Setting DATA",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
        
                InkWell(
                  onTap:(){Get.to(LeaderBoardScreen());},
                  child: ProfileMenuItem(icon: Icons.leaderboard, title: "LEADERBOARD".tr)),
              
                InkWell(
                  onTap:()  => Get.to(GiftsShoppingListScreen()),
                  child:ProfileMenuItem(icon: Icons.card_giftcard, title: "GIFT ITEMS".tr)),
                 InkWell(
                  onTap:()=> Get.to(ChangeLangaugeScreen()),
                  child: ProfileMenuItem(icon: Icons.language, title: "Chage Language".tr)),
                 ProfileMenuItem(icon: Icons.warning, title: "Term Of Use".tr),
                const Spacer(),
        
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
