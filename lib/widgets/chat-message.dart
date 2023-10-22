// ignore_for_file: file_names

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
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
            return SingleChildScrollView(
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: AppColorLight.gradientColorEnd,
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: const CircleAvatar(),
                      title: Text('${loadedMessage[index].data()['text']}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      trailing: const Text('10:12 am',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
