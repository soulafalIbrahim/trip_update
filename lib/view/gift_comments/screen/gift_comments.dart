import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/assets.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/const_data.dart';
import '../../../widget/custom_text.dart';
import '../controller/gift_comments_controller.dart';
import '../widget/comment_bubble.dart';

class GiftCommentsScreen extends StatelessWidget {
  const GiftCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GiftsCommentsController());

    return Scaffold(
      backgroundColor: AppColor.dark,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios, color: AppColor.white),
                ),
                //const Spacer(),
                // CustomText(
                //   text: 'Gift Comments'.tr,
                //   fontSize: 20,
                //   color: AppColor.lightGrey,
                // ),
                // const Spacer(),
                // Icon(Icons.more_vert, color: AppColor.white),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2D2D2D),
                    Color(0xFF1E1E1E),
                  ],
                ),
                border: Border.all(color: AppColor.white, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/comments_background.png",
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          text: "Gifts Page - Saudi Arabia".tr,
                          color: AppColor.white,
                          fontSize: 12,
                        ),
                        //
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            controller.isClickedToggle();
                            controller.isclicked.value
                                ? await controller.likesForFingerPrint(
                                    ConstData.fingerprintDocId,
                                    controller.auth.currentUser!.uid)
                                : controller.unlikesForFingerPrint(
                                    ConstData.fingerprintDocId,
                                    controller.auth.currentUser!.uid);
                          },
                          child: Obx(
                            () => SizedBox(
                              child: controller.isclicked.value == false
                                  ? Column(
                                    children: [
                                      Image.asset(Assets.loveitIcon,
                                          width: 20, height: 20),
                                          Text( controller.likes.isEmpty?'0':
                                            '${controller.likes.length}', style: const TextStyle(color: Colors.white, fontSize: 8),)
                                    ],
                                  )
                                  : Column(
                                    children: [
                                      Image.asset(Assets.likeIcon,
                                          width: 20, height: 20),
                                           Text(controller.likes.isEmpty?'0':
                                            '${controller.likes.length}', style: const TextStyle(color: Colors.white, fontSize: 8),),
                                    ],
                                  ),
                            ),
                          ),
                        ),
                        //  Icon(Icons.close, color: AppColor.white),
                        //  Icon(Icons.more_horiz, color: AppColor.white),
                      ],
                    ),

                    const SizedBox(height: 8),
                    // text fingerpoint or gift
                    Obx(
                      () => CustomText(
                        text: controller.titleFinferPrint.value != ''
                            ? controller.titleFinferPrint.value
                            : '',
                        //"Providing special gift offers such as the Great Winter Sale Or buy now and enjoy free shipping, which can ... See More ",
                        color: AppColor.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Obx(
                      () => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: controller.imageUrl != '' &&
                                controller.imageUrl.isNotEmpty
                            ? Image.network(
                                fit: BoxFit.contain,
                                controller.imageUrl.value,
                                // width: 50,
                                //height: 50,
                              )
                            : const SizedBox.shrink(),
                        //Image.asset(
                        //  "assets/images/comments_background.png"),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.message,
                            decoration: InputDecoration(
                              hintText: "Type a Message...".tr,
                              hintStyle: TextStyle(
                                  color: AppColor.white, fontSize: 12),
                              filled: true,
                              fillColor: AppColor.appColor,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              suffixIcon: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                decoration: const BoxDecoration(
                                  color: AppColor.appColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // const Icon(Icons.mic,
                                    //     color: Colors.white, size: 20),
                                    // const SizedBox(width: 6),
                                    // const Icon(Icons.image,
                                    //     color: Colors.white, size: 20),
                                    //const SizedBox(width: 6),
                                    //  const  Icon(Icons.add,
                                    //           color: Colors.white, size: 20)
                                    // const SizedBox(width: 6),
                                    InkWell(
                                        onTap: () async {
                                          print(
                                              'we will add a comment.................');
                                          await controller
                                              .addCommentToFingerPoint(
                                                  ConstData.fingerprintDocId,
                                                  controller.message.text);
                                          await controller
                                              .getAllCommectsandLikes();
                                        },
                                        child: Icon(Icons.send,
                                            color: Colors.white, size: 20)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            GetBuilder(
              init: GiftsCommentsController(),
              builder: (controller) => Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.allCommectsForFingerPrint.length,
                  itemBuilder: (context, index) {
                    final message = controller.allCommectsForFingerPrint;
                    // controller.messages[index];
                    return CommentBubble(
                      deleteComment: () async {
                        await controller
                            .deleteComment(message[index]['commentId']);
                      },
                      name: message[index]['username'],
                      text: message[index]['text'],
                      imagePath: controller.profileImages ?? '',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
