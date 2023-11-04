// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/provider/message-provider.dart';
import 'package:chat_app/screens/chat/chat-details/componant/appbar-chat.dart';
import 'package:chat_app/screens/chat/chat-details/componant/chat-message.dart';
import 'package:chat_app/screens/chat/chat-details/componant/chat-sent-message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/user-model.dart';

class ChatDetails extends StatefulWidget {
  ChatDetails({super.key, required this.user});
  UserInformation user;

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  @override
  void initState() {
    getNotificationByUid();
    super.initState();
  }

  getNotificationByUid() {
    context
        .read<MessageProvider>()
        .getUserTokensByUid(userUid: widget.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          AppbarChat(
            userinfor: widget.user,
          ),
          Expanded(
              child: ChatMessage(
            userInfor: widget.user,
          )),
          ChatSentMessage(user: widget.user),
        ],
      ),
    ));
  }
}
