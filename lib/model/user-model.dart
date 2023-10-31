// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformation {
  String userId;
  String firstName;
  String lastName;
  String phone;
  String email;
  bool isOnline;
  String lastMessage ;
  // String imageUrl;

  UserInformation({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isOnline,
    required this.lastMessage

    // required this.imageUrl,
  });

  factory UserInformation.fromJson(Map<String, dynamic> data) {
    return UserInformation(
      firstName: data['firstname'],
      lastName: data['lastname'],
      phone: data['phone'],
      userId: data['userId'],
      email: data['email'],
      isOnline: data['isOnline'],
      lastMessage: data['lastMessage'],
      // imageUrl: data['imagUrl'],
    );
  }
  // User? user = FirebaseAuth.instance.currentUser;
  //  Map<String, dynamic> toJson() {
  //   return {
  //     'userId': userId,
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'phone': phone,
  //     'email': user!.email,
  //   };
  // }
}
