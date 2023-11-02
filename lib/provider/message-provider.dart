// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MessageProvider with ChangeNotifier {
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
      'token': userData.data()!['token']
    });
    sentNatification(
        senderName:
            '${userData.data()!['firstName']} ${userData.data()!['lastName']}',
        message: entryMessage,
        token: userData.data()!['myToken']);
    entryMessageController.clear();
    notifyListeners();
  }

  String convertDataTime(Timestamp timeStamp) {
    var format = DateFormat('hh:mm a').format(timeStamp.toDate());
    notifyListeners();
    return format;
  }

  sentNatification(
      {required String senderName,
      required String message,
      required String token}) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAVXga5do:APA91bHMv8cvMwlyr3bTZK-kc_oeFTppY5YBXNO9nVQ08IfsDhb9cGsWglb5jxaQUdP0ILUowmv5ZCaEmqVFz_ocZlgVh-7hm7g9bmfS2GObbjGdTTvpGLMAvqXEOZviWdr5yVG5UsT_'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": token,
      "notification": {"title": senderName, "body": message}
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print('___body___$resBody');
    } else {
      print(res.reasonPhrase);
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
