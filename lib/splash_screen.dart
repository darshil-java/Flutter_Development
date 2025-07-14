import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const SplashScreen());
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  //        For Duration of splash Screen
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement
        (context,
          MaterialPageRoute(
              builder: (context)=> LoginPage(),
          ));
    });
  }
  Widget build(BuildContext context) {
    const Color darkJungleGreen = Color(0xFF0B3D2E);
    return Scaffold(
      body: Container(
        color: darkJungleGreen,
        child: Center(
          child: Column(
            children: [
              Container(
                  height: 350,
                  width: 200,
                  child: Image.asset('assets/images/splash.png')
              ),
              Text("VSG Logic - Chat APP",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700,color: Colors.teal.shade100),),
              SizedBox(height:10),
              Text("Clear,Trusted Health Advice",style: TextStyle(fontSize:21,fontWeight: FontWeight.w300,color: Colors.white),),

            ],
          ),
        ),
      ),

    );

  }
}
