import 'package:flutter/material.dart';
import 'package:protectmee/auth/presentation/screens/auth_screen.dart';
import 'package:protectmee/user/presentation/screens/user_home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtectMe App',
     theme: ThemeData.dark(),
      home: const AuthScreen(),
    );
  }
}
