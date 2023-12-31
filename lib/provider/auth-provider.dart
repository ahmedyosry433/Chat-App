// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

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
      'isOnline': true,
      'imageUrl': Constants.defualtImageUrl,
      'lastSeen': Timestamp.now(),
    });

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
    await setLastSeen();
    
    await FirebaseAuth.instance.signOut();

    notifyListeners();
  }

  

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Error sending password reset email: $e');
    }
  }

//-------------- Set Data ----------------------------

  Future setIsOnilne({required bool isOnline}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'isOnline': isOnline,
      });
    }
    notifyListeners();
  }

  Future setLastSeen() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'lastSeen': Timestamp.now(),
      });
    }
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

  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
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
    allUsersFormFirebase = filterAllUsersFormFirebase;
    notifyListeners();
    return filterAllUsersFormFirebase;
  }

  List<UserInformation> filterAllUsersOnline = [];

  List<UserInformation> filterUsersOnline() {
    filterAllUsersOnline =
        allUsersFormFirebase.where((user) => user.isOnline == true).toList();

    notifyListeners();
    return filterAllUsersOnline;
  }

  //-------------Get Users ----------------------
  setUserToList({required QuerySnapshot userSnapshot}) {
    List<UserInformation> users = [];
    final currntUser = FirebaseAuth.instance.currentUser!;

    for (var userDoc in userSnapshot.docs) {
      users.add(UserInformation(
        email: userDoc['email'],
        firstName: userDoc['firstName'],
        lastName: userDoc['lastName'],
        phone: userDoc['phone'],
        userId: userDoc['userId'],
        isOnline: userDoc['isOnline'],
        lastSeen: userDoc['lastSeen'],
        imageUrl: userDoc['imageUrl'] ?? Constants.defualtImageUrl,
      ));
    }
    allUsersFormFirebase = users;

    filterUsers(currntUser.uid);
    filterUsersOnline();
  }

  dynamic getCurrentUser;

  getCurrentUserByUid(String userUid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .get();

      if (userSnapshot.exists) {
        getCurrentUser = userSnapshot.data();
      } else {
        getCurrentUser = {};
      }
    } catch (e) {
      getCurrentUser = {};
    }
    notifyListeners();
  }

  List<UserInformation> allUsersFormFirebase = [];

  bool isLoad = false;
  Future<void> getUsersFromFirestore() async {
    if (!isLoad) {
      final query = FirebaseFirestore.instance.collection('user');
      QuerySnapshot usersnapshots = await query.get();
      setUserToList(userSnapshot: usersnapshots);
    }
    isLoad = true;
    //stop loading
    notifyListeners();
  }

// -----------------image picker----------------------

  File? pickedImageProfile;
  Future<void> pickImageProfile(ImageSource source) async {
    final pick = ImagePicker();
    final pickedFile = await pick.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      pickedImageProfile = File(pickedFile.path);
    }

    await saveImagePickerInFirebase();
    isLoad = true;
    notifyListeners();
  }

  String? imageUrlFromFirbase;
  Future saveImagePickerInFirebase() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final Reference storgeRef =
        FirebaseStorage.instance.ref().child('user_images').child('$user.jpg');

    await storgeRef.putFile(pickedImageProfile!);
    imageUrlFromFirbase = await storgeRef.getDownloadURL();
    await setIsImage();

    notifyListeners();
  }

  //-------------------------Search--------------------------------------
  Future<void> searchUsers(String searchText) async {
    allUsersFormFirebase = [];
    final usersCollection = FirebaseFirestore.instance.collection('user');
    if (searchText.isNotEmpty) {
      final querySnapshot = await usersCollection
          .where('firstName', isGreaterThanOrEqualTo: searchText)
          .where('firstName', isLessThanOrEqualTo: '${searchText}z')
          .get();
      setUserToList(userSnapshot: querySnapshot);
    } else {
      final querySnapshot = await usersCollection.get();
      setUserToList(userSnapshot: querySnapshot);
    }
    notifyListeners();
  }
}
