// ignore_for_file: file_names, avoid_print

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/provider/message-provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final user = FirebaseAuth.instance.currentUser;

  late User signInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() {
    try {
      if (user != null) {
        signInUser = user!;
        print('____________________________${signInUser.email}');
      }
    } catch (e) {
      print('________________________________$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final subMessageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Message Found.'));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something Went Wrong.'));
        }
        final loadedMessage = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: loadedMessage.length,
          itemBuilder: (context, index) {
            bool isMe = loadedMessage[index].data()['userId'] == signInUser.uid;
            return SingleChildScrollView(
              child: Expanded(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 3),
                          child: Text(
                            isMe
                                ? 'You'
                                : loadedMessage[index].data()['firstName'] +
                                    loadedMessage[index].data()['lastName'],
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black38),
                          ),
                        ),
                        Container(
                          decoration: isMe
                              ? const BoxDecoration(
                                  color: AppColorLight.blueColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ))
                              : const BoxDecoration(
                                  color: AppColorLight.sceondColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              loadedMessage[index].data()['text'],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: isMe
                                      ? AppColorLight.whiteColor
                                      : AppColorLight.blackColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 3),
                          child: Text(
                            subMessageProvider.convertDataTime(
                                loadedMessage[index].data()['createdAt']),
                            style: const TextStyle(
                                fontSize: 10, color: AppColorLight.blackColor),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          },
        );
      },
    );
  }
}
// Container(
//                     height: 70,
//                     decoration: BoxDecoration(
//                         color: AppColorLight.gradientColorEnd,
//                         borderRadius: BorderRadius.circular(16)),
//                     child: ListTile(
//                       leading: const CircleAvatar(),
//                       title: Text(
//                           '${loadedMessage[index].data()['firstName']} ${loadedMessage[index].data()['lastName']}',
//                           style: const TextStyle(
//                               fontSize: 14, color: Colors.black)),
//                       subtitle: Text('${loadedMessage[index].data()['text']}',
//                           style: const TextStyle(
//                               fontSize: 12, color: Colors.grey)),
//                       trailing: const Text('10:12 am',
//                           style: TextStyle(color: Colors.black)),
//                     ),
//                   ),