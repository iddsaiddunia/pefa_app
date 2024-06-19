import 'package:flutter/material.dart';
import 'package:pfa_app/nonAuth/login.dart';
import 'package:pfa_app/services/providers/user_provider.dart';
import 'package:pfa_app/splash_screen.dart';
import 'package:pfa_app/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home:  SplashScreenPage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/wrapper': (context) => Wrapper(isSignedIn: false),
          // '/home': (context) => HomePage(),
        },
      ),
    );
  }
}


