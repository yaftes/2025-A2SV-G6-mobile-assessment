import 'package:flutter/material.dart';
import 'package:g6_assessment/features/auth/presentation/pages/login_page.dart';
import 'package:g6_assessment/features/auth/presentation/pages/signup_page.dart';
import 'package:g6_assessment/features/chat/presentation/pages/chat_message_page.dart';
import 'package:g6_assessment/features/chat/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/sign-up': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/chat': (context) => ChatMessagePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
