// ignore_for_file: file_names

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
      required this.user,
      required this.changeShowEmoji,
      required this.showEmoji,
      required this.entryMessageController});
  UserInformation? user;
  Function changeShowEmoji;
  bool showEmoji;
  final TextEditingController entryMessageController;

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String createChatId() {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final userReceiving = user!.userId;
    List<String> sortedUserIds = [currentUser, userReceiving]..sort();
    return sortedUserIds.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final subProviderMessage = Provider.of<MessageProvider>(context);
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.attach_file,
                        color: Color.fromARGB(190, 0, 0, 0),
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_enhance,
                        color: Color.fromARGB(190, 0, 0, 0),
                      )),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                try {
                  await subProviderMessage.sentMessage(
                      entryMessageController: entryMessageController,
                      chatId: createChatId());
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Faild Send $e')));
                }
              },
              icon: const Icon(
                Icons.send,
                color: AppColorLight.primaryColor,
              ))
        ],
      ),
    );
  }
}
