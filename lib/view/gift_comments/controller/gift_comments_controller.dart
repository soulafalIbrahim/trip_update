import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/core/constant/const_data.dart';
import 'package:trip/data/helpers/my_dialogs.dart';
import 'package:trip/widget/custom_text.dart';

import '../../notification/controller/notification_controller.dart';

class GiftsCommentsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isClicked = false.obs;
  String fingerPrintUserId = '';
  RxString imageUrl = ''.obs;
  RxString titleFingerPrint = ''.obs;
  RxList<dynamic> likes = [].obs;
  CollectionReference fingerPrints =
      FirebaseFirestore.instance.collection('fingerprints');
  CollectionReference allUsers = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController message = TextEditingController();
  String profileImages = ''; //users
  var allCommectsForFingerPrint = [];
  RxList allLikesForFingerPrint = [].obs;
  List allusercomment = [];
  String  userName = '' ;
  RxString fingerPrintUserName = ''.obs;
  RxString fingerPrintUserImage = ''.obs;

  void isClickedToggle() {
    isClicked.value = !isClicked.value;
  }

  Future getFingerPrint(String fingerPrintId) async {
    final fingerPrint = await fingerPrints.doc(fingerPrintId).get();
    if (fingerPrint.exists) {
      imageUrl.value = fingerPrint['image'];
      print('ccccccccccccccccccc${imageUrl}');
      titleFingerPrint.value = fingerPrint['title'];
      fingerPrintUserId = fingerPrint['userId'];
      final userSnapshot = await allUsers.doc(fingerPrintUserId).get();
      fingerPrintUserName.value = userSnapshot['username'] ?? '';
      fingerPrintUserImage.value = userSnapshot['profileImage'] ?? '';
    }

  }

  Future<void> addCommentToFingerPoint(
      String fingerPointId, String commentText) async {
    try {
      final userId = auth.currentUser!.uid;
      final userSnapshot = await allUsers.doc(userId).get();
      userName = userSnapshot['username'] ?? '';
      //auth.currentUser!.displayName;
      final commentRef =
          fingerPrints.doc(fingerPointId).collection('comments').doc();

      final commentId = commentRef.id;

      await commentRef.set({
        'commentId': commentId,
        'userId': userId,
        'username': userName,
        'text': commentText,
        'timestamp': FieldValue.serverTimestamp(),
        'replay': [], // Add a timestamp for the comment
      });
      message.clear();
      await sendNotifiction(
          userId, userName , ' $userName Comment on Your Post');
    } catch (e) {
      throw ('Error adding comment: $e');
    }
  }

  Future<void> likesForFingerPrint(String fingerPrintId, String userId) async {
    final docRef = fingerPrints.doc(fingerPrintId);
    final userName = auth.currentUser!.displayName;
    try {
      await docRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });

      await sendNotifiction(
          userId, userName ?? 'Some one', ' $userName Liked Your Post');
      update();
    } catch (e) {
      throw ('fingerPrint liked error!');
    }
  }

  Future<void> unlikesForFingerPrint(
      String fingerPrintId, String userId) async {
    final fingerPrintRef = fingerPrints.doc(fingerPrintId);

    await fingerPrintRef.update({
      'likes': FieldValue.arrayRemove([userId])
    });
  }

  Future getAllCommentsAndLikes() async {
    isLoading.value = true;

    final docRef = fingerPrints.doc(ConstData.fingerprintDocId);

    docRef.collection('comments').snapshots().listen((event) {
      final doc = event.docs;
      if (doc.isNotEmpty) {
        allCommectsForFingerPrint.assignAll(doc);
        update();
      } else {
        const Text('No Comment Now');
        update();
      }
    });

    await getUserComment();
  }

  Future<void> sendNotifiction(
      String userId, String nameuser, String action) async {
    await NotificationController().sendNotification(
        senderId: userId,
        senderName: nameuser,
        senderImage: profileImages,
        receiverId: fingerPrintUserId,
        action: action);
  }

  Future getUserComment() async {
    final commentSnapshots = await fingerPrints
        .doc(ConstData.fingerprintDocId)
        .collection('comments')
        .get();
    for (var commentDoc in commentSnapshots.docs) {
      String userId = commentDoc['userId'];
      String commentId = commentDoc['commentId'];

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        profileImages = userSnapshot.data()?['profileImage'] ?? '';
        userName = userSnapshot.data()?['username'] ?? '';

        fingerPrints
            .doc(ConstData.fingerprintDocId)
            .collection('comments')
            .doc(commentId)
            .update({
          'profileImage': profileImages,
        });
        update();
      }
    }
  }

  Future deleteComment(String commentId) async {
    try {
      await fingerPrints
          .doc(ConstData.fingerprintDocId)
          .collection('comments')
          .doc(commentId)
          .delete();

      allCommectsForFingerPrint
          .removeWhere((comment) => comment['commentId'] == commentId);
    } catch (e) {
      throw ('Error deleting comment: $e');
    }
  }

  getallLike() async {
    fingerPrints.doc(ConstData.fingerprintDocId).snapshots().listen((event) {
      final doc = event;
      final like = doc['likes'];
      likes.value = like;
      if (like.contains(auth.currentUser!.uid)) {
        isClicked.value = true;
      }
      if (doc['likes'] != null) {
        for (String uid in like) {
          final userDoc = allUsers.doc(uid).get();

          if (!allLikesForFingerPrint.contains(userDoc)) {
            allLikesForFingerPrint.add(userDoc);
          }
        }
      } else {
        throw ('Some thing wrong');
      }
    });
  }
  void showReportDialog(BuildContext context, String postId) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.dark,
        title:  const CustomText(text: 'Report Post' , color: AppColor.appColor, fontSize: 16, fontWeight: FontWeight.w500,),
        content: TextField(
          controller: messageController,
          maxLines: 4,
          style: TextStyle(color: AppColor.white),
          decoration:  InputDecoration(
            hintText: 'Enter your reason for reporting...',
            hintStyle: TextStyle(color: AppColor.white),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:   const CustomText(text: 'Cancel' , color: AppColor.appColor, fontSize: 16, fontWeight: FontWeight.w500,),
          ),
          TextButton(
            onPressed: () async {
              final message = messageController.text.trim();
              if (message.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: CustomText(text: 'Please enter a message',color: AppColor.appColor, fontSize: 16, fontWeight: FontWeight.w300,)),
                );
                return;
              }

              final userId = FirebaseAuth.instance.currentUser?.uid;

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: CustomText(text: 'User not authenticated',color: AppColor.appColor, fontSize: 16, fontWeight: FontWeight.w300,)),
                );
                return;
              }

              await FirebaseFirestore.instance.collection('reports').add({
                'postId': postId,
                'userId': userId,
                'message': message,
                'timestamp': FieldValue.serverTimestamp(),
              });

             Get.back() ; // Close dialog

              MyDialogs.success(msg: 'Report submitted. Thank you.') ;
            },
            child: const CustomText(text: 'Send' ,color: AppColor.appColor, fontSize: 16, fontWeight: FontWeight.w500,),
          ),
        ],
      ),
    );
  }


  @override
  void onInit() async {
   await getFingerPrint(ConstData.fingerprintDocId);
    getAllCommentsAndLikes();
    getallLike();
    // TODO: implement onInit
    super.onInit();
  }
}

class Message {
  final String name;
  final String text;
  final String image;

  Message({required this.name, required this.text, required this.image});
}
