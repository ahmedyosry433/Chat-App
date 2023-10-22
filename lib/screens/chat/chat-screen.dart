// ignore_for_file: file_names

import 'package:chat_app/widgets/appbar-chat.dart';
import 'package:chat_app/widgets/chat-message.dart';
import 'package:chat_app/widgets/chat-sent-message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  User? user = FirebaseAuth.instance.currentUser;

  // getUserInfo() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   await Provider.of<MessageProvider>(context, listen: false)
  //       .getUserMessageByUid(userUid: user!.uid);
  // }

  @override
  void initState() {
    super.initState();
    // getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          const AppbarChat(),
          const Expanded(child: ChatMessage()),
          ChatSentMessage(),
        ],
      ),
    ));
  }
}
