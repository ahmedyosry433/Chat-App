// ignore_for_file: file_names, unnecessary_null_comparison, avoid_print, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/provider/message-provider.dart';
import 'package:chat_app/screens/chat/chat-main/components/appbar-chat-main.dart';
import 'package:chat_app/screens/chat/chat-main/components/user-active-card.dart';
import 'package:chat_app/screens/chat/chat-main/components/user-cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth-provider.dart';

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
    messageForeground();
    messageOnMessageOpendApp();
    super.initState();
  }

  messageOnMessageOpendApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  messageForeground() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '${message.notification!.title}\n${message.notification!.body}')));
      }
    });
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

    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/contact'),
        child: const Icon(
          Icons.chat_sharp,
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
                subAuthProvider.allUsersFormFirebase.isEmpty
                    ? const Text('No Active Users')
                    : const SizedBox(height: 100, child: UserActiveCard()),
                const Divider(
                  color: AppColorLight.sceondColor,
                ),
                UserCard(),
              ],
            ),
    ));
  }
}
