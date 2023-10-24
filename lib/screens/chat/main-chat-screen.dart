// ignore_for_file: file_names

import 'package:chat_app/screens/chat/components/appbar-chat-main.dart';
import 'package:flutter/material.dart';

import 'components/user-card-in-chat.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          AppbarMainChat(),
          
          UserCardChat(),
        ],
      ),
    ));
  }
}
