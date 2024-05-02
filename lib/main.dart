import 'package:flutter/material.dart';
import 'package:pfa_app/auth/base_layout.dart';
import 'package:pfa_app/auth/home.dart';
import 'package:pfa_app/nonAuth/login.dart';
import 'package:pfa_app/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home:  SplashScreenPage(),
    );
  }
}


