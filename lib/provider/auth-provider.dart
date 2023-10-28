// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user-model.dart';

class AuthProvider with ChangeNotifier {
  dynamic userAlreadyexist;

  Future<void> signUp({
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    notifyListeners();
  }

  Future<void> addUserInfoInFirebase({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
      'userId': user.uid,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': user.email,
    });
    notifyListeners();
  }

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

  Future logIn(
      {required TextEditingController emailController,
      required TextEditingController passwordController}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    notifyListeners();
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('______________Error sending password reset email: $e');
    }
  }

  bool visibility = true;
  visibilityPassword() {
    visibility = !visibility;
    notifyListeners();
  }

  List<UserInformation> allUsersFormFirebase = [];

  List<UserInformation> filterUsers(String currentUserId) {
    notifyListeners();
    return allUsersFormFirebase
        .where((user) => user.userId != currentUserId)
        .toList();
  }

  Future<void> getUsersFromFirestore() async {
    QuerySnapshot userSnapshots =
        await FirebaseFirestore.instance.collection('user').get();

    print('_______________1_________________');
    List<UserInformation> users = userSnapshots.docs.map((userDoc) {
      final data = userDoc.data();
      print('________________2________________$data');
      print('________________3________________$allUsersFormFirebase');

      return UserInformation(
          email: userDoc['email'],
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          phone: userDoc['phone'],
          userId: userDoc['userId']);
    }).toList();

    allUsersFormFirebase = users;

    print(
        '_______________4_________${allUsersFormFirebase.length}_______$allUsersFormFirebase');
  }


  File? imageProfile;
  Future<void> pickImageProfile(ImageSource source) async {
    final pick = ImagePicker();
    final pickedFile = await pick.pickImage(source: source);
    if (pickedFile != null) {
      imageProfile = File(pickedFile.path);
      print('_______provider____picker');
      print('_______P____picker$imageProfile');

      notifyListeners();
    }
  }
}
