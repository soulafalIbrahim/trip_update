import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/color.dart';

class CommentBubble extends StatelessWidget {
  final String name;
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
                  color: const Color(0xFF006DFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: TextStyle(
                            color: AppColor.dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                            ),
                            textAlign: TextAlign.start,),
                    const SizedBox(height: 4),
                    Text(text, style: const TextStyle(color: Colors.white) , textAlign: TextAlign.end,),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          CircleAvatar(
           backgroundImage:imagePath != ''? NetworkImage(imagePath) : null,
           child: imagePath == '' ? Image.asset('assets/icons/avatar.png'): null,
           // null,
            radius: 20,
          )
        ],
      ),
    );
  }
}
