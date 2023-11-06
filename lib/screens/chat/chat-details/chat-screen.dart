// ignore_for_file: file_names, must_be_immutable

import 'dart:io';

import 'package:chat_app/provider/message-provider.dart';
import 'package:chat_app/screens/chat/chat-details/componant/appbar-chat.dart';
import 'package:chat_app/screens/chat/chat-details/componant/chat-message.dart';
import 'package:chat_app/screens/chat/chat-details/componant/chat-sent-message.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  TextEditingController entryMessageController = TextEditingController();
  bool isShowEmoji = false;

  changeShowEmoji() {
    setState(() {
      isShowEmoji = !isShowEmoji;
    });
  }

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
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
            ChatSentMessage(
              user: widget.user,
              changeShowEmoji: changeShowEmoji,
              showEmoji: isShowEmoji,
              entryMessageController: entryMessageController,
            ),
            if (isShowEmoji)
              SizedBox(
                height: 300,
                child: EmojiPicker(
                    textEditingController: entryMessageController,
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    )),
              )
            // : const SizedBox(height: 0),
          ],
        ),
      )),
    );
  }
}
