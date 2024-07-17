import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfa_app/components.dart';
import 'package:pfa_app/nonAuth/login.dart';
import 'package:pfa_app/services/auth_services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _newPassword;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_usernameController.text != "" ||
          _contactController.text != "" ||
          _secretController.text != "") {
        final newPassword = await _authService.forgotPassword(
          _usernameController.text,
          _contactController.text,
          _secretController.text,
        );
        setState(() {
          _newPassword = newPassword;
          showDialog(
              context: context,
              builder: (BuildContext contex) {
                return AlertDialog(
                  title: const Text(
                    "Password recovery",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    MaterialButton(
                      elevation: 0,
                      color: CupertinoColors.activeGreen,
                      onPressed: () {
                        copyToClipboard(newPassword);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      child: const Text("Copy"),
                    ),
                    MaterialButton(
                      elevation: 0,
                      color: Color.fromARGB(255, 202, 202, 202),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text("Ok"),
                    ),
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Your new password:"),
                      Text(
                        "$newPassword",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fill all fields')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            InputBox(
              title: "username",
              controller: _usernameController,
              isText: true,
            ),
            InputBox(
              title: "email/phone",
              controller: _contactController,
              isText: true,
            ),
            InputBox(
              title: "secrete word",
              controller: _secretController,
              isText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 38.0),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 50,
                color: Colors.blue,
                child: (_isLoading)
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Request",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onPressed: _resetPassword,
              ),
            )
          ],
        ),
      ),
    );
  }
}
