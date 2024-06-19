import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/nonAuth/register.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:pfa_app/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isTransLoading = false;
  int selectedIndex = 0;
  String _errorMessage = '';

  Future<void> authenticateUser() async {
    // Simulate a login request
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Replace this with your actual authentication logic
    if (emailController.text == 'user@mail.com' &&
        passwordController.text == '1234') {
      // Authentication successful, navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Wrapper(
            isSignedIn: true,
          ),
        ),
      );
    } else {
      // Authentication failed, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Authentication Failed'),
            content: const Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _login(String email, String password) async {
    setState(() {
      isLoading = true;
    });

    if (email == '' || password == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert!'),
            content: const Text('Fill all fields'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        isLoading = false;
      });
    } else {
      final token = await _authService.login(email, password);

      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Wrapper(
              isSignedIn: true,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ListView(children: [
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3.3,
            color: Colors.transparent),
        const SizedBox(
          height: 20.0,
        ),
        const Text(
          "Login",
          style: TextStyle(fontSize: 26),
        ),
        const Text(
          "Please Sign in to continue.",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          width: double.infinity,
          height: 55.0,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Email",
                border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 55.0,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Password",
                border: InputBorder.none),
          ),
        ),
        const Align(
            alignment: Alignment.centerRight, child: Text("forgot password?")),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            // authenticateUser();
            _login(emailController.text, passwordController.text);
          },
          child: Container(
            width: double.infinity,
            height: 60.0,
            decoration: BoxDecoration(
              color: color.buttonColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    )
                  : const Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationPage()),
              );
            },
            child: const Text(
              "Don't have an account?Sign Up",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ]),
    ));
  }
}
