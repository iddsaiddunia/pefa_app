import 'package:flutter/material.dart';
import 'package:pfa_app/auth/chat_bot.dart';
import 'package:pfa_app/auth/home.dart';
import 'package:pfa_app/auth/settings.dart';
import 'package:pfa_app/color_themes.dart';

ColorThemes _colorThemes = new ColorThemes();

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int _currentIndex = 0;
  PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    const ChatBot(),
    const SettingPage(),
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
      drawer: Drawer(),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person_3),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
