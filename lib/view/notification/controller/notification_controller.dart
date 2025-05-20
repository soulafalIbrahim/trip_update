import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/notificatios_model.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    _listenToNotifications();
  }

  void _listenToNotifications() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    _firestore
        .collection('notifications')
       
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((querySnapshot) async {
      List<NotificationModel> temp = [];

      for (var doc in querySnapshot.docs) {
        final notification = NotificationModel.fromDoc(doc);
        if (notification.receiverId == currentUserId) {
            temp.add(notification);
        }
        else{
          continue;
        }
       
      }

      if (temp.length > notifications.length) {
        _playNotificationSound();
      }

      notifications.value = temp;
    });
  }

  void _playNotificationSound() async {
    await _audioPlayer.play(AssetSource('notifications/notification.mp3'));
  }

  Future<void> sendNotification({
    required String senderId,
    required String senderName,
    required String senderImage,
    required String receiverId,
    required String action,
  }) async {
    await _firestore.collection('notifications').add({
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'receiverId': receiverId,
      'action': action,
      'timestamp': Timestamp.now(),
    });
  }

  String formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      throw ("Error deleting notification: $e");
    }
  }

  void showOptions(NotificationModel notification) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete Notification"),
              onTap: () async {
                await deleteNotification(notification.id);
                notifications.removeWhere((n) => n.id == notification.id);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
