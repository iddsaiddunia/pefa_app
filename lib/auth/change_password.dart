import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/components.dart';
import 'package:pfa_app/services/auth_services.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final _authService = AuthService();
  bool isLoading = false;
  bool isPassValid = false;

  void _changePassword() async {
    if (_currentController.text != "" || _newController.text != "") {
      final currentPassword = _currentController.text;
      final newPassword = _newController.text;

      try {
        await _authService.changePassword(currentPassword, newPassword);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password changed successfully'),
        ));
        // Optionally: Navigate to another screen or perform additional actions after successful password change
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to change password'),
        ));
        // Handle error, e.g., show error message or retry logic
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fill all fields'),
      ));
    }
  }

  bool isValidPassword(String password) {
    String passwordPattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$';
    RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(password);
  }

  void _validatePassword() {
    setState(() {
      if (isValidPassword(_newController.text)) {
        isPassValid = true;
      } else {
        isPassValid = false;
        // _passwordErrorText =
        //     'Password must be at least 8 characters long, contain an uppercase, lowercase letter, a number, and a special character';
      }
    });
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
              title: "Current Password",
              controller: _currentController,
              isText: true,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: TextField(
                // obscureText: true,
                controller: _newController,
                decoration: const InputDecoration(
                  hintText: " New password (@Example123)",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _validatePassword();
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: (isPassValid)
                  ? Text(
                      "strong",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    )
                  : Text(
                      "Enter strong password",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 38.0),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 50,
                color: Colors.blue,
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _changePassword,
              ),
            )
          ],
        ),
      ),
    );
  }
}
