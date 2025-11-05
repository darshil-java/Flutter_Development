// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home_page.dart';
// import 'login_page.dart';
// import 'onboardingpage.dart';
// import 'helper.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNext();
//   }
//
//   Future<void> _navigateToNext() async {
//     await Future.delayed(const Duration(seconds: 3)); // Splash delay
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//     if (isLoggedIn) {
//       // User already logged in → go to HomePage
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     } else {
//       // User not logged in → always show Onboarding first
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const OnboardingPage()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: AppColors.primary,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 180,
//                 width: 200,
//                 child: Image.asset('assets/images/splash2.png'),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "HealthBuddy",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textLight,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Trusted Health Advicer",
//                 style: TextStyle(
//                   fontSize: 21,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'onboardingpage.dart';
import 'helper.dart';
import 'welcome_screen.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;

    if (isLoggedIn) {
      // User already logged in → go to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // User not logged in
      if (onboardingCompleted) {
        // Onboarding already seen → go to WelcomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        // First time → show Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                width: 200,
                child: Image.asset('assets/images/splash2.png'),
              ),
              const SizedBox(height: 20),
              Text(
                "HealthBuddy",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Trusted Health Advicer",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}