// ignore_for_file: file_names, unnecessary_null_comparison, avoid_print

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/provider/message-provider.dart';
import 'package:chat_app/screens/chat/chat-main/components/appbar-chat-main.dart';
import 'package:chat_app/widgets/online-image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth-provider.dart';
import '../chat-details/chat-screen.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getUsersFromFirestore();
    getTokens();
    super.initState();
  }

//-------------get tokens------------------------------------
  getTokens() {
    context
        .read<MessageProvider>()
        .setUserNotificationDevice(currentUserUid: user!.uid);
  }

//---------------get users----------------------------------------
  getUsersFromFirestore() {
    context.read<AuthProvider>().getCurrentUserByUid(user!.uid);
    context.read<AuthProvider>().getUsersFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);
    final subsubAuthProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.chat_bubble_outlined,
          size: 30,
        ),
      ),
      body: !subAuthProvider.isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const AppbarMainChat(),
                subAuthProvider.filterAllUsersOnline.isEmpty
                    ? const Text('No Active Users')
                    : SizedBox(
                        height: 100,
                        child: Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  subsubAuthProvider.filterUsersOnline().length,
                              itemBuilder: ((context, index) {
                                final allUsers =
                                    subAuthProvider.filterAllUsersOnline[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatDetails(
                                                user: allUsers,
                                              ))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: OnlineImage(
                                            index: index,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('${allUsers.firstName} ',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                              ' ${allUsers.lastName}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                        ),
                      ),
                const Divider(
                  color: AppColorLight.sceondColor,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: subAuthProvider.filterUsers(user!.uid).length,
                      itemBuilder: ((context, index) {
                        final allUsers =
                            subAuthProvider.filterAllUsersFormFirebase[index];

                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatDetails(
                                        user: allUsers,
                                      ))),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CircleAvatar(
                                            foregroundImage:
                                                NetworkImage(allUsers.imageUrl),
                                          )),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${allUsers.firstName} ${allUsers.lastName}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700)),
                                          const Text(
                                            'last message',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Text('10:40 Am'),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
    ));
  }
}
