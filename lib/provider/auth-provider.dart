// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:chat_app/core/constants/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user-model.dart';

class AuthProvider with ChangeNotifier {
//-------------- Authantication --------------------

  Future<void> signUp({
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    setIsOnilne(isOnline: true);
    notifyListeners();
  }

  Future logIn(
      {required TextEditingController emailController,
      required TextEditingController passwordController}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    setIsOnilne(isOnline: true);

    notifyListeners();
  }

  Future logOut() async {
    await setIsOnilne(isOnline: false);
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('______________Error sending password reset email: $e');
    }
  }

//-------------- Set Data ----------------------------

  Future setIsOnilne({required bool isOnline}) async {
    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'isOnline': isOnline,
    });
    notifyListeners();
  }

  Future setIsImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'imageUrl': imageUrlFromFirbase ?? Constants.defualtImageUrl,
    });
    notifyListeners();
  }

  bool visibility = true;
  visibilityPassword() {
    visibility = !visibility;
    notifyListeners();
  }

  //-------Add Users To Firebase ---------------------

  Future<void> addUserInfoInFirebase({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    // final myToken = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
      'userId': user.uid,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': user.email,
      'isOnline': true,
      'imageUrl': imageUrlFromFirbase ??
          userAlreadyexist['imageUrl'] ??
          Constants.defualtImageUrl,
      // 'myToken': myToken,
    });
    await getUsersFromFirestore();
    notifyListeners();
  }

// --------Filter users--------------------

  List<UserInformation> filterAllUsersFormFirebase = [];

  List<UserInformation> filterUsers(String currentUserId) {
    filterAllUsersFormFirebase = allUsersFormFirebase
        .where((user) => user.userId != currentUserId)
        .toList();
    notifyListeners();
    return filterAllUsersFormFirebase;
  }

  List<UserInformation> filterAllUsersOnline = [];

  List<UserInformation> filterUsersOnline() {
    filterAllUsersOnline = filterAllUsersFormFirebase
        .where((user) => user.isOnline == true)
        .toList();

    notifyListeners();
    return filterAllUsersOnline;
  }

  //-------------Get Users ----------------------

  dynamic userAlreadyexist;

  Future<Map<String, dynamic>> getUserByUid(String userUid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .get();

      if (userSnapshot.exists) {
        userAlreadyexist = userSnapshot.data();
      } else {
        userAlreadyexist = {};
      }
    } catch (e) {
      userAlreadyexist = {};
    }
    notifyListeners();
    return {};
  }

  List<UserInformation> allUsersFormFirebase = [];
  bool isLoad = false;
  Future<void> getUsersFromFirestore() async {
    if (!isLoad) {
      QuerySnapshot userSnapshots =
          await FirebaseFirestore.instance.collection('user').get();
      List<UserInformation> users = [];
      final currntUser = FirebaseAuth.instance.currentUser!;
      for (var userDoc in userSnapshots.docs) {
        // List<String> sortedUserIds = [currntUser.uid, userDoc['userId']]
        //   ..sort();

        // final lastMessage =
        // await getLastMessage(createChatId: sortedUserIds.join('_'));

        users.add(UserInformation(
          email: userDoc['email'],
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          phone: userDoc['phone'],
          userId: userDoc['userId'],
          isOnline: userDoc['isOnline'],
          imageUrl: userDoc['imageUrl'],
          // myToken: userDoc['myToken'],

          //-------issue : return null - if user create account--------------
          // lastMessage: lastMessage!['text'] ?? '',
          // lastMessageTime: lastMessage['createdAt'] ?? '',
          // --------------------------------------------
        ));
      }
      allUsersFormFirebase = users;
      filterUsers(currntUser.uid);
      filterUsersOnline();
      // setIsImage();
    }
    isLoad = true;
    //stop loading
    notifyListeners();
  }

// -----------------image picker----------------------

  File? pickedImageProfile;
  Future<void> pickImageProfile(ImageSource source) async {
    isLoad = false;
    if (!isLoad) {
      final pick = ImagePicker();
      final pickedFile = await pick.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        pickedImageProfile = File(pickedFile.path);
      }
    }
    await saveImagePickerInFirebase();
    isLoad = true;
    notifyListeners();
  }

  String? imageUrlFromFirbase;
  Future saveImagePickerInFirebase() async {
    // isLoad = false;

    final user = FirebaseAuth.instance.currentUser!.uid;
    final Reference storgeRef =
        FirebaseStorage.instance.ref().child('user_images').child('$user.jpg');

    await storgeRef.putFile(pickedImageProfile!);
    imageUrlFromFirbase = await storgeRef.getDownloadURL();
    await setIsImage();

    notifyListeners();
  }

// --------------------- message-----------------------------------------
  Future<DocumentSnapshot?> getLastMessage(
      {required String createChatId}) async {
    final firestore = FirebaseFirestore.instance;
    final query = firestore
        .collection('chat')
        .doc(createChatId)
        .collection('message')
        .orderBy('createdAt', descending: true)
        .limit(1);

    final querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      getUsersFromFirestore();

      return querySnapshot.docs[0];
    }
    return null;
  }
}
