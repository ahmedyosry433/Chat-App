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
  String imageUrl;
  Timestamp lastSeen;
  // String myToken;
  // String lastMessage;
  // Timestamp lastMessageTime;

  UserInformation({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.isOnline,
    required this.imageUrl,
    required this.lastSeen,
    // required this.myToken,
    // required this.lastMessage,
    // required this.lastMessageTime,
  });

  factory UserInformation.fromJson(Map<String, dynamic> data) {
    return UserInformation(
      firstName: data['firstname'],
      lastName: data['lastname'],
      phone: data['phone'],
      userId: data['userId'],
      email: data['email'],
      imageUrl: data['imageUrl'],
      isOnline: data['isOnline'],
      lastSeen: data['lastSeen'],
      // myToken: data['myToken'],
      // lastMessage: data['lastMessage'],
      // lastMessageTime: data['lastMessageTime'],
    );
  }
}
