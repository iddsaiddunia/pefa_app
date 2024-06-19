import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/nonAuth/login.dart';
import 'package:pfa_app/services/auth_services.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _verifyPassword = TextEditingController();
  bool isLoading = false;

  final AuthService _authService = AuthService();

  register() async {
    setState(() {
      isLoading = true;
    });

    if (_username.text != "" ||
        _email.text != "" ||
        _phone.text != "" ||
        _password.text != "" ||
        _verifyPassword.text != "") {
      String username = _username.text;
      String email = _email.text;
      String phoneNumber = _phone.text;
      String password = _password.text;
      String verifyPassword = _verifyPassword.text;

      if (password != verifyPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
      } else {
        var response =
            await _authService.signup(username, email, phoneNumber, password);

        if (response != null && response['success']) {
          setState(() {
            isLoading = false;
          });
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'Sign Up Successful: ${response['data']['username']}'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

          // Navigate to another screen or handle success
        } else if (response != null && !response['success']) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign up: ${response['error']}')),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign up')),
          );
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill all fields'),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _verifyPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: ListView(
        children: [
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 7,
              color: Colors.transparent),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            "Register",
            style: TextStyle(fontSize: 26),
          ),
          const Text(
            "Please Register  to login.",
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
            child: TextFormField(
              controller: _username,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Username",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
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
            child: TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Email",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
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
            child: TextFormField(
              controller: _phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Phone",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
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
            child: TextFormField(
              obscureText: true,
              controller: _password,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Password",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.length < 8) {
                  return "Password should be at least 8 characters";
                }
                return null;
              },
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
            child: TextFormField(
              controller: _verifyPassword,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "verify Password",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please verify your Password';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              register();
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
                child: (!isLoading)
                    ? const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )
                    : const CircularProgressIndicator(
                        color: Colors.white,
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
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
