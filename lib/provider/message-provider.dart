// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MessageProvider with ChangeNotifier {
  //-----send message---------------
  sentMessage(
      {required String messageText,
      required String chatId,
      required resivedUserUid,
      required String type}) async {
    if (messageText.trim().isEmpty) {
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
      'toId': resivedUserUid,
      'text': messageText,
      'createdAt': Timestamp.now(),
      'type': type,
      'fromId': user.uid,
      'firstName': userData.data()!['firstName'],
      'lastName': userData.data()!['lastName'],
    });

    sendNotification(
        senderName:
            '${userData.data()!['firstName']} ${userData.data()!['lastName']}',
        message: messageText,
        tokens: userNotificationTokens);

    notifyListeners();
  }

//--------get last message -----------------
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      {required String createChatId}) {
    return FirebaseFirestore.instance
        .collection('chat')
        .doc(createChatId)
        .collection('message')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots();
  }

//--------Convert data----------------------
  String convertDataTime(Timestamp timeStamp) {
    var format = DateFormat('hh:mm a').format(timeStamp.toDate());
    notifyListeners();
    return format;
  }

  //-----------create chat id ----------------------------------
  String createChatId({required String userReceived}) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final userReceiving = userReceived;
    List<String> sortedUserIds = [currentUser, userReceiving]..sort();
    return sortedUserIds.join('_');
  }

//------------------Image Chat Upload ------------------------
  bool isUploading = false;
  Future<void> pickMultiImageChat(
      {required String chatId, required String resivedUserUid}) async {
    final pick = ImagePicker();
    final List<XFile> images = await pick.pickMultiImage(imageQuality: 80);
    for (var img in images) {
      await saveImagePickerChatInFirebase(
          chatId: chatId, file: File(img.path), resivedUserUid: resivedUserUid);
    }
    isUploading = true;
    notifyListeners();
  }

  Future pickSingleImageByCamera(
      {required String chatId, required String resivedUserUid}) async {
    final pick = ImagePicker();
    final pickedFile =
        await pick.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      File(pickedFile.path);
      await saveImagePickerChatInFirebase(
          chatId: chatId,
          file: File(pickedFile.path),
          resivedUserUid: resivedUserUid);
    }

    notifyListeners();
  }

  Future<void> saveImagePickerChatInFirebase(
      {required String chatId,
      required File file,
      required String resivedUserUid}) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = FirebaseStorage.instance
        .ref()
        .child('images/$chatId/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sentMessage(
        messageText: imageUrl,
        type: 'image',
        resivedUserUid: resivedUserUid,
        chatId: chatId);

    notifyListeners();
  }

//-------------Notifications------------------------

  List<String?> userNotificationTokens = [];
  Future setUserNotificationDevice({required String currentUserUid}) async {
    await getCurrentTokensByUid(currentUserUid: currentUserUid);

    var token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      if (userNotificationTokens.isEmpty) {
        userNotificationTokens.add(token);
        await saveNotificationTokensTofirebase(token: token);
      } else {
        var savedToken = userNotificationTokens
            .firstWhere((item) => item == token, orElse: () => null);
        if (savedToken != null) {
          return;
        } else {
          userNotificationTokens.add(token);
          await saveNotificationTokensTofirebase(token: token);
        }
      }
    }

    notifyListeners();
  }

  Future saveNotificationTokensTofirebase({required String token}) async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('tokens')
        .add({'deviceToken': token});

    notifyListeners();
  }

  Future deleteNotificationTokensFromfirebase({required String token}) async {
    final user = FirebaseAuth.instance.currentUser;

    final collectionRef = FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('tokens');
    final querySnapshot = await collectionRef.get();

    // Create a batch for deleting documents
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add delete operations for each document to the batch
    for (var doc in querySnapshot.docs) {
      if (doc['deviceToken'] == token) {
        batch.delete(doc.reference);
        userNotificationTokens.remove(token);
      }
    }

    // Commit the batch to delete all documents
    await batch.commit();
  }

//--------------------------------------------

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
}
