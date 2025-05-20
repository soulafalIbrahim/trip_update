import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/assets.dart';

import '../../../core/constant/color.dart';

class CommentBubble extends StatelessWidget {
  final String? name;
  final String text;
  final Function() deleteComment ;
 final String imagePath;

  const CommentBubble({
    super.key,
    required this.name,
    required this.text,
    required this.deleteComment,
    required this.imagePath,
  });
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
               onTap: () {
                Get.defaultDialog(
                  backgroundColor:AppColor.appColor,
                  title: "Delete Comment",
                  middleText: "Are you sure you want to delete this comment?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  onConfirm: () {
                    deleteComment();
                    // your action here
                    Get.back(); // close dialog
                  },
                  onCancel: () {
                    // optional cancel action
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:  const Color(0xFFC7CACE).withValues(blue: 1 , red: 1 ,green: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name!,
                        style: TextStyle(
                            color: AppColor.dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                            ),
                            textAlign: TextAlign.start,),
                    const SizedBox(height: 4),
                    Text(text, style: const TextStyle(color:AppColor.appColor) , textAlign: TextAlign.end,),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          CircleAvatar(
           backgroundImage:imagePath != ''? NetworkImage(imagePath) : null,
           backgroundColor:imagePath != ''? AppColor.lightGrey : null,
           // null,
            radius: 20,
           child: imagePath == '' ? Image.asset(Assets.logo): null,
          )
        ],
      ),
    );
  }
}
