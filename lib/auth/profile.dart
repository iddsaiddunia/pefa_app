import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfa_app/auth/change_password.dart';
import 'package:pfa_app/models/user_model.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

AuthService _authService = new AuthService();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late Future<Map<String, dynamic>?> _userFuture;

  @override
  void initState() {
    super.initState();

    _userFuture = _authService.fetchUserDetails();
  }

  editWindow(String title, String label, Map<String, dynamic> user) {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: Text(
              "Edit $title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                color: CupertinoColors.activeGreen,
                onPressed: () async {
                  if (_usernameController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('New $label is required'),
                      ),
                    );
                  } else {
                    String newUsername = _usernameController.text;
                    final prefs = await SharedPreferences.getInstance();
                    var userId = prefs.getInt('userId');

                    Map<String, dynamic> updatedUser = {
                      'id': user['id'],
                      'username': newUsername,
                      'email': user['email'],
                      'phone_number': user['phone_number'],
                      'is_staff': user['is_staff'],
                      'is_active': user['is_active'],
                    };
                    _authService.updateUser(userId!, updatedUser).then((_) {
                      setState(() {
                        _userFuture = _authService.fetchUserDetails();
                      });
                      Navigator.pop(context);
                    });
                  }
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                elevation: 0,
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    label: Text(label),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('User not found'));
          } else {
            Map<String, dynamic> user = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: const BoxDecoration(
                      // color: Colors.black,
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ProfileBox(),
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            ProfileTile(
                              title: "Name",
                              data: user['username'],
                              edit: () {
                                editWindow("name", user['username'], user);
                              },
                              icon: Icons.person,
                              isEmail: false,
                            ),
                            ProfileTile(
                              title: "Email",
                              data: user['email'],
                              edit: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email can not be edited'),
                                  ),
                                );
                              },
                              icon: Icons.email,
                              isEmail: true,
                            ),
                            ProfileTile(
                              title: "Phone",
                              data: user['phone_number'],
                              edit: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Phone number can not be edited'),
                                  ),
                                );
                              },
                              icon: Icons.phone,
                              isEmail: true,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Settings",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 245, 245, 245),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Change password"),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordPage(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final String data;
  final Function()? edit;
  final IconData icon;
  final bool isEmail;
  const ProfileTile({
    required this.title,
    required this.data,
    required this.edit,
    required this.icon,
    required this.isEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Color.fromARGB(255, 122, 122, 122),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$title",
                      style: TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                    ),
                    Text(
                      "$data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          (!isEmail)
              ? IconButton(
                  onPressed: edit,
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                )
              : IconButton(
                  onPressed: edit,
                  icon: const Icon(
                    Icons.lock,
                    size: 20,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                ),
        ],
      ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 240, 240, 240),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                  'https://via.placeholder.com/150'), // Placeholder image URL
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // Handle the add image action
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
