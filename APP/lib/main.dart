import 'package:flutter/material.dart';
import 'home_page.dart';
import 'doctors_screen.dart';
import 'orders.dart';
import 'upload_files.dart';
import 'login_page.dart';
import 'login_with_Otp.dart';
import 'register_page.dart';
import 'splash_screen.dart';
import 'terms_&_Privacy.dart';
import 'profile.dart';
import 'onboardingpage.dart';
import 'help.dart';
import 'welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/otp_page': (context)=>OtpLoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/terms' : (context) => TermsPage(),
        '/doctors': (context) => DoctorScreen(),
        '/orders' : (context) => OrdersPage(),
        '/upload': (context) => UploadFiles(orderId: '', userId: '',),
        '/profile' : (context) => ProfilePage(),
        '/onboarding' : (context) => OnboardingPage(),
        '/help': (context) => const HelpPage(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

