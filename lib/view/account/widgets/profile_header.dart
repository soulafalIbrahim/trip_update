import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/routes.dart';
import '../../../widget/custom_text.dart';
import '../setting_profile/controller/account_controller.dart';


class AppHeader extends StatelessWidget {
  const AppHeader(
      {super.key, required this.title, required this.optionsSettings});
  final String title;
  final bool optionsSettings;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountController>();
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !optionsSettings
                ? InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios, color: AppColor.white),
                  )
                : Container(),
            const Spacer(),
            CustomText(
              text: title,
              fontSize: 20,
              color: AppColor.white,
            ),
            const Spacer(),
            optionsSettings
                ? Icon(Icons.more_vert, color: AppColor.white)
                : Container(),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        optionsSettings
            ? GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.settingsScreen),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        backgroundImage: controller.profileImage != null && controller.profileImage.isNotEmpty
                            ? NetworkImage(controller.profileImage!)
                            : null,
                        child: controller.profileImage == null || controller.profileImage.isEmpty
                            ? const Icon(Icons.person,
                                size: 40, color: Colors.blue)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.userName.value,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  controller.email.value,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
