// ignore_for_file: library_private_types_in_public_api


import 'package:chat_app/core/theme/theme-data/theme-data-light.dart';
import 'package:chat_app/provider/auth-provider.dart';
import 'package:chat_app/provider/message-provider.dart';
import 'package:chat_app/screens/auth/profile-screen.dart';
import 'package:chat_app/screens/chat/contact.dart';
import 'package:chat_app/widgets/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login-screen.dart';
import 'screens/auth/signup-screen.dart';
import 'firebase_options.dart';
import 'screens/chat/chat-main/main-chat-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ListenableProvider<MessageProvider>(
              create: (context) => MessageProvider()),
          ListenableProvider<AuthProvider>(create: (context) => AuthProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: getThemeDataLight(),
          initialRoute: '/splash',
          routes: {
            '/signup': (context) => const Signuppage(),
            '/splash': (context) => const Splash(),
            '/login': (context) => LoginPage(),
            '/chatmain': (context) => const ChatMain(),
            '/profile': (context) => Profile(),
            '/contact': (context) =>const AllContact(),
          },
        ));
  }
}
