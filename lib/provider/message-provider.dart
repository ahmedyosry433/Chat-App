// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MessageProvider with ChangeNotifier {
  //-----send message---------------
  sentMessage(
      {required TextEditingController entryMessageController,
      required String chatId}) async {
    final entryMessage = entryMessageController.text;

    if (entryMessage.trim().isEmpty) {
      return;
    }
    // get users to instance uid
    final User user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

    await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatId)
        .collection('message')
        .add({
      'text': entryMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'firstName': userData.data()!['firstName'],
      'lastName': userData.data()!['lastName'],
    });

    sendNotification(
        senderName:
            '${userData.data()!['firstName']} ${userData.data()!['lastName']}',
        message: entryMessage,
        tokens: userNotificationTokens);

    entryMessageController.clear();

    notifyListeners();
  }

//--------Convert data----------------------
  String convertDataTime(Timestamp timeStamp) {
    var format = DateFormat('hh:mm a').format(timeStamp.toDate());
    notifyListeners();
    return format;
  }

  //---------save all Devices tokens-------------------
  List<String?> userNotificationTokens = [];
  Future setUserNotificationDevice({required String currentUserUid}) async {
    await getCurrentTokensByUid(currentUserUid: currentUserUid);

    var token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      if (userNotificationTokens.isEmpty) {
        userNotificationTokens.add(token);
      } else {
        var savedToken = userNotificationTokens
            .firstWhere((item) => item == token, orElse: () => null);
        if (savedToken != null) {
          return;
        } else {
          userNotificationTokens.add(token);
        }
      }
    }
    await saveNotificationTokensTofirebase();

    notifyListeners();
  }

  Future saveNotificationTokensTofirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    for (var token in userNotificationTokens) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection('tokens')
          .add({'deviceToken': token});
    }
    notifyListeners();
  }

//--------------------------------------------
  // List currentUserTokens = [];
  getCurrentTokensByUid({required String currentUserUid}) async {
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserUid)
        .collection('tokens')
        .get();

    for (var userDoc in userSnapshots.docs) {
      userNotificationTokens.add(userDoc['deviceToken']);
    }
    notifyListeners();
  }

  //-----------------------------------------------
  List userRecived = [];
  getUserTokensByUid({required String userUid}) async {
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance
        .collection('user')
        .doc(userUid)
        .collection('tokens')
        .get();

    for (var userDoc in userSnapshots.docs) {
      userRecived.add(userDoc);
    }
    notifyListeners();
  }

//---------notification-----------------------
  sendNotification(
      {required String senderName,
      required String message,
      required List tokens}) async {
    for (var token in userRecived) {
      var headersList = {
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAVXga5do:APA91bHMv8cvMwlyr3bTZK-kc_oeFTppY5YBXNO9nVQ08IfsDhb9cGsWglb5jxaQUdP0ILUowmv5ZCaEmqVFz_ocZlgVh-7hm7g9bmfS2GObbjGdTTvpGLMAvqXEOZviWdr5yVG5UsT_'
      };
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      var body = {
        "to": token['deviceToken'],
        "notification": {"title": senderName, "body": message}
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      await res.stream.bytesToString();
    }
  }

  // String? lastMessage;
  // Future<String?> getLastMessage({required String createChatId}) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final query = firestore
  //       .collection('chat')
  //       .doc(createChatId)
  //       .collection('message')
  //       .orderBy('createdAt', descending: true)
  //       .limit(1);

  //   final querySnapshot = await query.get();
  //   if (querySnapshot.docs.isNotEmpty) {

  //     return await querySnapshot.docs[0]['text'];
  //   }

  //   return null;
  // }
  // String createChatId() {
  //   final currentUser = FirebaseAuth.instance.currentUser!.uid;
  //   final userReceiving = user!.userId;
  //   List<String> sortedUserIds = [currentUser, userReceiving]..sort();
  //   return sortedUserIds.join('_');
  // }
}
