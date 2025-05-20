import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/assets.dart';
import '../../../core/constant/color.dart';
import '../../../core/constant/const_data.dart';
import '../../../widget/custom_text.dart';
import '../controller/gift_comments_controller.dart';
import '../widget/comment_bubble.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class GiftCommentsScreen extends StatelessWidget {
  const GiftCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GiftsCommentsController());

    return Scaffold(
      backgroundColor: AppColor.dark,
      appBar: AppBar(
        backgroundColor: AppColor.dark,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => controller.showReportDialog(context, controller.fingerPrintUserId),
            child: const Icon(Icons.report_gmailerrorred, color: Colors.redAccent),
          ),


          const SizedBox(width: 15),
          GestureDetector(
            onTap: () async {
              controller.isClickedToggle();
              if (controller.isClicked.value) {
                await controller.likesForFingerPrint(
                  ConstData.fingerprintDocId,
                  controller.auth.currentUser!.uid,
                );
              } else {
                await controller.unlikesForFingerPrint(
                  ConstData.fingerprintDocId,
                  controller.auth.currentUser!.uid,
                );
              }
              await controller.getAllCommentsAndLikes();
            },
            child: Obx(
              () => Row(
                children: [
                  Text(
                    controller.likes.isEmpty
                        ? '0'
                        : '${controller.likes.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    controller.isClicked.value
                        ? Assets.likeIcon
                        : Assets.loveitIcon,
                    width: 28,
                    height: 28,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),


        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                controller.fingerPrintUserImage.value != ''
                                    ? NetworkImage(
                                        controller.fingerPrintUserImage.value)
                                    : null,
                            backgroundColor:
                                controller.fingerPrintUserImage.value != ''
                                    ? AppColor.lightGrey
                                    : null,
                            // null,
                            radius: 15,
                            child: controller.fingerPrintUserImage.value == ''
                                ? Image.asset(Assets.logo)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(controller.fingerPrintUserName.value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))
                        ]),
                  ),
                  const SizedBox(height: 5),
                  ChatBubble(
                    clipper:
                        ChatBubbleClipper6(type: BubbleType.receiverBubble),
                 
                    margin:const EdgeInsets.only(top: 15),
                    backGroundColor: Colors.white,
                    child: SizedBox(
                      width: Get.width,
                      height: Get.height * 0.25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: controller.imageUrl.value.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => SizedBox(
                                      width: Get.width,
                                      height: Get.height * 0.062,
                                      child: CustomText(
                                        text: controller.titleFingerPrint.value,
                                        color: AppColor.dark,
                                        fontSize: 18,
                                        textOverflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(height: 5),
                                  Obx(() => controller.imageUrl.value.isNotEmpty
                                      ? SizedBox(
                                          height: Get.height * 0.18,
                                          width: Get.width ,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              controller.imageUrl.value,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink()),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => 
                                     CustomText(
                                          text:controller.titleFingerPrint.value,
                                          color: AppColor.dark,
                                          fontSize: 20,
                                          textOverflow: TextOverflow.clip,

                                        ),
                                 ),
                                       
                                        
                                      
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GetBuilder(
                    init: GiftsCommentsController(),
                    builder: (controller) => ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.allCommectsForFingerPrint.length,
                      itemBuilder: (context, index) {
                        final message = controller.allCommectsForFingerPrint;
                        return CommentBubble(
                          deleteComment: () async {
                            await controller
                                .deleteComment(message[index]['commentId']);
                          },
                          name: message[index]['username'],
                          text: message[index]['text'],
                          imagePath: controller.profileImages,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 👇 Bottom TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.message,
                    decoration: InputDecoration(
                      hintText: "Type a Message...".tr,
                      hintStyle: TextStyle(color: AppColor.white, fontSize: 12),
                      filled: true,
                      fillColor: AppColor.appColor,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                            InkWell(
                              onTap: () async {
                                await controller.addCommentToFingerPoint(
                                  ConstData.fingerprintDocId,
                                  controller.message.text,
                                );
                                await controller.getAllCommentsAndLikes();
                                controller.message.clear(); // Clear after send
                              },
                              child: const Icon(Icons.send,
                                  color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
