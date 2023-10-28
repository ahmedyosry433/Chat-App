// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/widgets/appbar-chat.dart';
import 'package:chat_app/widgets/chat-message.dart';
import 'package:chat_app/widgets/chat-sent-message.dart';
import 'package:flutter/material.dart';

import '../../model/user-model.dart';

class ChatDetails extends StatelessWidget {
  ChatDetails({super.key, required this.user});
  UserInformation user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          AppbarChat(
            userinfor: user,
          ),
          Expanded(
              child: ChatMessage(
            userInfor: user,
          )),
          ChatSentMessage(user: user),
        ],
      ),
    ));
  }
}
