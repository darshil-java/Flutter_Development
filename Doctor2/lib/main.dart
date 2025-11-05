import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'login_with_Otp.dart';
import 'register_page.dart';
import 'splash_screen.dart';
import 'profile.dart';
import 'onboardingpage.dart';
import 'terms_&_Privacy.dart';
import 'history_page.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'welcome_screen.dart';


@pragma('vm:entry-point')
void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  // This will be called by the native code
  print('Download callback: $id, $status, $progress%');

  // You can use MethodChannel to communicate with your UI if needed
  // For now, we'll just print the status
  if (status == DownloadTaskStatus.complete) {
    print('✅ Download completed: $id');
  } else if (status == DownloadTaskStatus.failed) {
    print('❌ Download failed: $id');
  }
}

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Flutter Downloader
  await FlutterDownloader.initialize(
    debug: true, // set to false in production
  );

  runApp(MyApp());
}
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
        '/profile' : (context) => ProfilePage(),
        '/onboarding' : (context) => OnboardingPage(),
        '/terms' : (context) => TermsPage(),
        '/history': (context) => HistoryPage(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

