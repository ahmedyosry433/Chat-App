import 'package:chat_app/core/theme/theme-data/theme-data-light.dart';
import 'package:chat_app/provider/auth-provider.dart';
import 'package:chat_app/provider/message-provider.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'provider/main-chat-provider.dart';
import 'screens/auth/login-screen.dart';
import 'screens/auth/signup-screen.dart';
import 'firebase_options.dart';
import 'screens/chat/chat-screen.dart';
import 'screens/chat/main-chat-screen.dart';

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
          ListenableProvider<MainChatProvider>(
              create: (context) => MainChatProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: getThemeDataLight(),
          initialRoute: '/splash',
          routes: {
            '/signup': (context) => const Signuppage(),
            '/splash': (context) => const Splash(),
            '/login': (context) => LoginPage(),
            '/chatdetails': (context) => const ChatDetails(),
            '/chatmain': (context) => const ChatMain(),
          },
        ));
  }
}
