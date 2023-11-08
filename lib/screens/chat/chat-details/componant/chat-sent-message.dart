// ignore_for_file: file_names, avoid_print

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/user-model.dart';
import '../../../../provider/message-provider.dart';

// ignore: must_be_immutable
class ChatSentMessage extends StatelessWidget {
  ChatSentMessage(
      {super.key,
      required this.userInfo,
      required this.changeShowEmoji,
      required this.showEmoji,
      required this.entryMessageController});
  UserInformation? userInfo;
  Function changeShowEmoji;
  bool showEmoji;
  final TextEditingController entryMessageController;

  pickMultiImage({required BuildContext context}) async {
    try {
      Provider.of<MessageProvider>(context, listen: false).pickMultiImageChat(
          chatId: createChatId(), resivedUserUid: userInfo!.userId);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Send Multi Image Error $e')));
    }
  }

  pickSingleImage({required BuildContext context}) async {
    try {
      Provider.of<MessageProvider>(context, listen: false)
          .pickSingleImageByCamera(
              chatId: createChatId(), resivedUserUid: userInfo!.userId);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Send Single Image Error $e')));
    }
  }

  sentMessagebutton({required BuildContext context}) async {
    try {
      await Provider.of<MessageProvider>(context, listen: false).sentMessage(
          messageText: entryMessageController.text,
          chatId: createChatId(),
          resivedUserUid: userInfo!.userId,
          type: 'text');
      entryMessageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Faild Send $e')));
    }
  }

  String createChatId() {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final userReceiving = userInfo!.userId;
    List<String> sortedUserIds = [currentUser, userReceiving]..sort();
    return sortedUserIds.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColorLight.sceondColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: entryMessageController,
                    onTap: () {
                      if (showEmoji) {
                        FocusScope.of(context).unfocus();
                        changeShowEmoji();
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Send Message',
                        icon: IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              changeShowEmoji();
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Color.fromARGB(190, 0, 0, 0),
                            ))),
                  )),
                  IconButton(
                      onPressed: () => pickSingleImage(context: context),
                      icon: const Icon(
                        Icons.camera_enhance,
                        color: Color.fromARGB(190, 0, 0, 0),
                      )),
                  IconButton(
                      onPressed: () => pickMultiImage(context: context),
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        color: Color.fromARGB(190, 0, 0, 0),
                      )),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () => sentMessagebutton(context: context),
              icon: const Icon(
                Icons.send,
                color: AppColorLight.primaryColor,
              ))
        ],
      ),
    );
  }
}
