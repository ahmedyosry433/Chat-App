// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  // Future<List<UserInformation>> getUsersFromFirestore() async {
  //   QuerySnapshot userSnapshots =
  //       await FirebaseFirestore.instance.collection('user').get();

  //   print('________________________________');
  //   List<UserInformation> users = userSnapshots.docs.map((userDoc) {
  //     final data = userDoc.data() as Map<String, dynamic>;

  //     print('________________________________$data');
  //     return UserInformation.fromJson(userDoc as Map<String, dynamic>);
  //   }).toList();
  //   print('________________________________$users');
  //   return users;
  // }
}
