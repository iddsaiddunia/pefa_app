import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pfa_app/auth/base_layout.dart';

import 'nonAuth/login.dart';
import 'nonAuth/register.dart';

class Wrapper extends StatelessWidget {
  final bool isSignedIn;
  const Wrapper({super.key,
    required this.isSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return const BaseLayout();
    } else {
      return const LoginPage();
    }
  }
}
