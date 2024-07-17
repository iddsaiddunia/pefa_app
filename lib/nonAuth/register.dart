import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  final TextEditingController _secrete_word = TextEditingController();
  bool isLoading = false;
  String? _emailErrorText = "Please enter a valid email";
  String? _phoneErrorText = 'Please enter a valid phone number';
  String? _passwordErrorText = 'Please enter a strong password';

  final AuthService _authService = AuthService();
  bool _isConnected = false;
  bool isPassValid = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        _isConnected = status == InternetConnectionStatus.connected;
      });
    });
  }

  Future<void> checkConnectivity() async {
    _isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  register() async {
    setState(() {
      isLoading = true;
    });

    if (_isConnected) {
      if (_username.text != "" ||
          _email.text != "" ||
          _phone.text != "" ||
          _password.text != "" ||
          _verifyPassword.text != "" ||
          _secrete_word.text != "") {
        String username = _username.text;
        String email = _email.text;
        String phoneNumber = _phone.text;
        String password = _password.text;
        String verifyPassword = _verifyPassword.text;
        String secrete_word = _secrete_word.text;

        if (_emailErrorText != null ||
            _phoneErrorText != null ||
            _passwordErrorText != null) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Either your email, phone or password not formated properly'),
            ),
          );
        } else {
          if (password != verifyPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Passwords do not match'),
              ),
            );
          } else {
            var response = await _authService.signup(
                username, email, phoneNumber, password, secrete_word);

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
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
                SnackBar(
                    content: Text('Failed to sign up: ${response['error']}')),
              );
            } else {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to sign up try new creditials')),
              );
            }
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection'),
        ),
      );
    }
  }

  bool isValidEmail(String email) {
    String emailPattern =
        r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9]{2,}(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z]{2,})+$";
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void _validateEmail() {
    setState(() {
      if (isValidEmail(_email.text)) {
        _emailErrorText = null;
      } else {
        _emailErrorText = 'Please enter a valid email';
      }
    });
  }

  bool isValidPhoneNumber(String phone) {
    // This pattern matches phone numbers starting with + followed by 1 to 3 digits for the country code
    // and then 7 to 15 digits for the rest of the phone number
    String phonePattern = r'^\+\d{1,3}\d{7,15}$';
    RegExp regExp = RegExp(phonePattern);
    return regExp.hasMatch(phone);
  }

  void _validatePhoneNumber() {
    setState(() {
      if (isValidPhoneNumber(_phone.text)) {
        _phoneErrorText = null;
      } else {
        _phoneErrorText = 'Please enter a valid phone number';
      }
    });
  }

  bool isValidPassword(String password) {
    String passwordPattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$';
    RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(password);
  }

  void _validatePassword() {
    setState(() {
      if (isValidPassword(_password.text)) {
        isPassValid = true;
      } else {
        isPassValid = false;
        // _passwordErrorText =
        //     'Password must be at least 8 characters long, contain an uppercase, lowercase letter, a number, and a special character';
      }
    });
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
              height: MediaQuery.of(context).size.height / 9,
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
            child: TextField(
              controller: _email,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Email (example@gmail.com)",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _validateEmail();
              },
            ),
          ),
          SizedBox(
            height: 30,
            child: (_emailErrorText == null)
                ? Text(
                    "valid",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  )
                : Text(
                    "$_emailErrorText",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
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
              controller: _phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Phone (+255-xxx-xxx-xxx)",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                _validatePhoneNumber();
              },
            ),
          ),
          SizedBox(
            height: 30,
            child: (_phoneErrorText == null)
                ? Text(
                    "valid",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  )
                : Text(
                    "$_phoneErrorText",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
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
              obscureText: true,
              controller: _password,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Password (@Example123)",
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
              controller: _secrete_word,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.deepOrangeAccent,
                ),
                hintText: "Enter your secret word",
                border: InputBorder.none,
              ),
              // onChanged: (value) {
              //   _validatePassword();
              // },
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
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    ));
  }
}
