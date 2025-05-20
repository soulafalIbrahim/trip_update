import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/data/helpers/my_dialogs.dart';
import 'package:trip/widget/custom_text.dart';
import '../../../core/constant/color.dart';
import '../../../data/models/posts/posts.dart';
import '../../../widget/custom_elevated_button.dart';

class MyFingerprint extends StatefulWidget {
  const MyFingerprint({super.key});

  @override
  State<MyFingerprint> createState() => _MyFingerprintState();
}

class _MyFingerprintState extends State<MyFingerprint> {
  late Future<List<Post>> _futureFingerprints;

  @override
  void initState() {
    super.initState();
    _futureFingerprints = fetchUserFingerprints();
  }

  Future<List<Post>> fetchUserFingerprints() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('fingerprints')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  Future<void> deleteFingerprint(String postId) async {
    await FirebaseFirestore.instance.collection('fingerprints').doc(postId).delete();
    MyDialogs.success(msg: 'Fingerprint deleted');

    // Refresh the list after deletion
    setState(() {
      _futureFingerprints = fetchUserFingerprints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.dark,
      appBar: AppBar(
        backgroundColor: AppColor.dark,
        title: CustomText(text: 'My Fingerprints', color: AppColor.lightGrey, fontSize: 20),
        leading: InkWell(
          onTap: () => Get.back(),
          child:  Icon(Icons.arrow_back_ios, color: AppColor.white),
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _futureFingerprints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No fingerprints found', style: TextStyle(color: AppColor.appColor)));
          }

          final fingerprints = snapshot.data!;
          return ListView.builder(
            itemCount: fingerprints.length,
            itemBuilder: (context, index) {
              final post = fingerprints[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    post.postImage != null
                        ? SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image.network(
                        post.postImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Image error: $error');
                          return const Center(child: Icon(Icons.broken_image, color: Colors.red));
                        },
                      ),
                    )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                    CustomText(text: post.postText, color: AppColor.dark),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      text: 'Delete',
                      buttonColor: Colors.red,
                      onPressed: () async {
                        await deleteFingerprint(post.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
