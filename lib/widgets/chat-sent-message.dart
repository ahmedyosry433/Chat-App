// ignore_for_file: file_names

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/message-provider.dart';

class ChatSentMessage extends StatelessWidget {
  ChatSentMessage({super.key});
  final TextEditingController _entryMessageController = TextEditingController();
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
                    controller: _entryMessageController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Send Message',
                        icon: IconButton(
                            onPressed: () {
                              subProviderMessage.sentMessage(
                                  entryMessageController:
                                      _entryMessageController);
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
                  await Provider.of<MessageProvider>(context, listen: false)
                      .sentMessage(
                          entryMessageController: _entryMessageController);
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
