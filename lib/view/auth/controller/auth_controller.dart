import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trip/data/helpers/my_dialogs.dart';
import '../../ar_map/screen/ar_take_photo_screen.dart';
import '../screen/success_registration_screen.dart';
import '../screen/verification_code.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKeyLog = GlobalKey<FormState>();
  var gender = 'Male'.obs;
  File? profileImage;
  bool isLoading = false;

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    usernameController.clear();
    birthdateController.clear();
    gender.value = 'Male';
    profileImage = null;

    super.onClose();
  }

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage = File(picked.path);
      update();
    }
  }

  Future<void> registerWithEmail(
      String email, String password, String username) async {
    try {
      isLoading = true;
      update();
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      String? imageUrl;
      if (profileImage != null) {
        final ref = storage.ref().child('profile_images/$userId.jpg');
        await ref.putFile(profileImage!);
        imageUrl = await ref.getDownloadURL();
      }

      await firestore.collection('users').doc(userId).set({
        'id': userId,
        'username': username,
        'email': email,
        'gender': gender.value,
        'birthdate': birthdateController.text,
        'profileImage': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'remainingDays': 30,
        'isEmailVerified': false,
        'fingerPoint':0,
        'balance':0,
      });

      // Send email verification link
      await userCredential.user!.sendEmailVerification();

      MyDialogs.success(
          msg: 'Verification email sent. Please check your inbox.');

      Get.offAll(() => const EmailVerificationScreen());
      isLoading = false;
      update();
    } on FirebaseAuthException catch (e) {
      isLoading = false ;
      update();
      
      MyDialogs.error(msg: 'Registration failed: ${e.message}');
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      isLoading = true;
      update();
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid;

      await firestore.collection('users').doc(userId).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      MyDialogs.success(msg: 'Logged in successfully!');
      Get.offAll(() => const ArTakePhotoScreen());
      isLoading = false;
      update();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      update();
      if (e.code == 'user-not-found') {
        MyDialogs.error(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        MyDialogs.error(msg: 'Incorrect password.');
      } else {
        MyDialogs.error(msg: 'Login failed. Please try again.');
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Email Sent Successfully',
        'Please check your email messages',
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Something wrong',
        '$e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> checkVerification() async {
    isLoading = true;
    update();
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null) {
      if (user.emailVerified) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'isEmailVerified': true,
        });
        Get.offAll(() => const SuccessRegistrationScreen());
        isLoading = false;
        update();
      } else {
        Get.snackbar('Email Not Verified', 'Please verify your email first.',
            backgroundColor: Colors.red, colorText: Colors.white);
        isLoading = false;
        update();
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if the user is new or returning
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'email': user.email,
            'name': user.displayName,
            'profileImage': user.photoURL,
          });
        }
      }

      Get.offAll(() => const ArTakePhotoScreen());
    } catch (e) {
      throw('Error signing in with Google: $e');
    }
  }

  // Future<void> signInWithApple() async {
  //   try {
  //     // Request Apple ID credential
  //     final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
  //       // Specify the requested scopes
  //       scopes: [
  //         AppleIDAuthorizationScope.email,
  //         AppleIDAuthorizationScope.fullName,  // You can request the user's full name
  //       ],
  //     );
  //     final OAuthCredential appleCredential = OAuthProvider("apple.com").credential(
  //       idToken: credential.identityToken,
  //       accessToken: credential.authorizationCode,
  //     );
  //
  //     // Sign in with the Apple credentials
  //     final UserCredential userCredential = await auth.signInWithCredential(appleCredential);
  //     User? user = userCredential.user;
  //
  //     if (user != null) {
  //       // Check if the user is new or returning
  //       final userDoc = await firestore.collection('users').doc(user.uid).get();
  //       if (!userDoc.exists) {
  //         await firestore.collection('users').doc(user.uid).set({
  //           'id': user.uid,
  //           'email': user.email,
  //           'name': user.displayName,
  //           'profileImage': user.photoURL,
  //         });
  //       }
  //     }
  //
  //     Get.offAllNamed(AppRoutes.homeScreen);  // Navigate to the home screen after login
  //   } catch (e) {
  //     print('Error signing in with Apple: $e');
  //   }
  // }
}
