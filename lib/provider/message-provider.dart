// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class MessageProvider with ChangeNotifier {
  sentMessage({required TextEditingController entryMessageController}) async {
    final entryMessage = entryMessageController.text;

    if (entryMessage.trim().isEmpty) {
      return;
    }

    final User user = FirebaseAuth.instance.currentUser!;

    final userData =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

    await FirebaseFirestore.instance.collection('chat').add({
      'text': entryMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'firstName': userData.data()!['firstName'],
      'lastName': userData.data()!['lastName'],
    });

    entryMessageController.clear();
    notifyListeners();
  }

  dynamic userMessagExist;
  Future<Map<String, dynamic>> getUserMessageByUid(
      {required String userUid}) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();

      if (userSnapshot.exists) {
        userMessagExist = userSnapshot.data() as Map<String, dynamic>;
      } else {
        userMessagExist = {};
      }
    } catch (e) {
      userMessagExist = {};
    }
    notifyListeners();
    return {};
  }
}
