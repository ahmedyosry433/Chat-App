// ignore_for_file: file_names

import 'package:chat_app/provider/auth-provider.dart';
import 'package:chat_app/provider/message-provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../chat-details/chat-screen.dart';

class UserCard extends StatelessWidget {
  UserCard({super.key});
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);
    final subMessageProvider = Provider.of<MessageProvider>(context);
    return Expanded(
      child: ListView.builder(
          itemCount: subAuthProvider.filterUsers(user!.uid).length,
          itemBuilder: ((context, index) {
            final userFilter =
                subAuthProvider.filterAllUsersFormFirebase[index];

            return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatDetails(
                              user: userFilter,
                            ))),
                child: StreamBuilder(
                  stream: subMessageProvider.getLastMessage(
                      createChatId: subMessageProvider.createChatId(
                          userReceived: userFilter.userId)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text(''));
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something Went Wrong.'));
                    }
                    final loadedMessage = snapshot.data!.docs;
                    return SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(userFilter.imageUrl),
                                    )),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${userFilter.firstName} ${userFilter.lastName}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      loadedMessage[0]['type'] == 'text'
                                          ? loadedMessage[0]['text']
                                          : 'photo',
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(subMessageProvider.convertDataTime(
                                loadedMessage[0]['createdAt'])),
                          ],
                        ),
                      ),
                    );
                  },
                ));
          })),
    );
  }
}
