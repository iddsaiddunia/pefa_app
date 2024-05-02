import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/wrapper.dart';


class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      duration: Duration(milliseconds: 5000),
      backgroundColor: Colors.blue,
      onInit: () {
        debugPrint("On Init");
      },
      onEnd: () {
        debugPrint("On End");
      },
      childWidget: SizedBox(
        // height: 200,
        width: double.infinity,
        child: Column(children:[
          Text("Pefa", style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold),),
          Text("Your personalized finance managment assistant", style: TextStyle(fontSize: 12, color: Colors.white),),
        ])
      ),
      onAnimationEnd: () => debugPrint("On Fade In End"),
      nextScreen: const Wrapper(isSignedIn: false,),
    );
  }
}