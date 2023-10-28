// ignore_for_file: file_names

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/screens/chat/components/appbar-chat-main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth-provider.dart';
import 'chat-screen.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  bool isLoading = false;
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    getUsersFromFirestore();
    super.initState();
  }

  getUsersFromFirestore() {
    if (!isLoading) {
      context.read<AuthProvider>().getUserByUid(user!.uid);
      context.read<AuthProvider>().getUsersFromFirestore();
      isLoading = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);
    return SafeArea(
        child: Scaffold(
      body: !isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const AppbarMainChat(),
                SizedBox(
                  height: 100,
                  child: Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            subAuthProvider.filterUsers(user!.uid).length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircleAvatar(),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${subAuthProvider.allUsersFormFirebase[index].firstName} ',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        ' ${subAuthProvider.allUsersFormFirebase[index].lastName}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
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
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatDetails(
                                        user: subAuthProvider
                                            .allUsersFormFirebase[index],
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
                                      const SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CircleAvatar()),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${subAuthProvider.allUsersFormFirebase[index].firstName} ${subAuthProvider.allUsersFormFirebase[index].lastName}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700)),
                                          const Text(
                                            'Last Message',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Text('10:25 am'),
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
