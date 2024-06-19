import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pfa_app/auth/about.dart';
import 'package:pfa_app/auth/add_loan.dart';
import 'package:pfa_app/auth/add_target.dart';
import 'package:pfa_app/auth/chat_bot.dart';
import 'package:pfa_app/auth/home.dart';
import 'package:pfa_app/auth/notification.dart';
import 'package:pfa_app/auth/profile.dart';
import 'package:pfa_app/auth/savings.dart';
import 'package:pfa_app/auth/transactions.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/components.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:pfa_app/wrapper.dart';

ColorThemes _colorThemes = new ColorThemes();

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AuthService _authService = AuthService();

  int _currentIndex = 0;
  PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    const ChatBot(),
    // const SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(color: color.primaryColor),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "johndoe@mail.com",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    DrawerTile(
                      title: "Profile",
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      icon: Icons.person_3_outlined,
                    ),
                    DrawerTile(
                      title: "Targets",
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TargetsPage(),
                          ),
                        );
                      },
                      icon: Icons.add_chart,
                    ),
                    DrawerTile(
                      title: "Transactions",
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionPage(),
                          ),
                        );
                      },
                      icon: Icons.monetization_on_outlined,
                    ),
                    DrawerTile(
                      title: "Savings",
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavingsPage(),
                          ),
                        );
                      },
                      icon: Icons.lightbulb_circle_outlined,
                    ),
                    DrawerTile(
                      title: "Loans",
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoansPage(),
                          ),
                        );
                      },
                      icon: Icons.list_alt_outlined,
                    ),
                    DrawerTile(
                      title: "About",
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutPage(),
                          ),
                        );
                      },
                      icon: Icons.question_answer_outlined,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                      minWidth: 120,
                      height: 50,
                      elevation: 0,
                      color: color.buttonColor,
                      child: Row(
                        children: [Icon(Icons.logout), Text("LogOut")],
                      ),
                      onPressed: () async {
                        await _authService.logout(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Wrapper(isSignedIn: false),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Developed by UDOM/S.G4"),
                Text(
                  "2024@ Pefa All rights reserved",
                  style: TextStyle(color: Colors.black87, fontSize: 11),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ),
              );
            },
            icon: Icon(
              Icons.notifications,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        selectedItemColor: _colorThemes.primaryColor,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 247, 247, 247),
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 247, 247, 247),
        ),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Bot',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_3),
          //   label: 'profile',
          // ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final Function() ontap;
  final IconData icon;
  const DrawerTile({
    super.key,
    required this.title,
    required this.ontap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(title),
            )
          ],
        ),
      ),
    );
  }
}
