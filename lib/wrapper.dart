import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pfa_app/auth/base_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nonAuth/login.dart';
import 'nonAuth/register.dart';

class Wrapper extends StatelessWidget {
  final bool isSignedIn;
  const Wrapper({
    super.key,
    required this.isSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return BaseLayout(); // Replace with your home page
          } else {
            return LoginPage(); // Replace with your login page
          }
        }
      },
    );
  }
    Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null;
  }

}
