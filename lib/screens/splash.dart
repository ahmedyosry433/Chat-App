import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth-provider.dart';
import 'auth/login-screen.dart';
import 'chat/main-chat-screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoading = false;
  final user = FirebaseAuth.instance.currentUser;
  getUsersFromFirestore() {
    if (!isLoading) {
      context.read<AuthProvider>().getUserByUid(user!.uid);
      context.read<AuthProvider>().getUsersFromFirestore();
    }
  }

  @override
  void initState() {
    getUsersFromFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const ChatMain();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
