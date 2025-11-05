// lib/helper.dart
import 'package:flutter/material.dart';

/// ========================
/// 🌐 API CONFIG
/// ========================
class ApiConfig {
  // Base URL → change here only
  static const String baseUrl = "http://192.168.1.13:3000/api/doctor";
  static const String baseUrl2 = "http://192.168.1.13:3000/api";

  static const String baseFileUrl= "http://192.168.1.13:3000";

  // Endpoints
  static String get login => "$baseUrl/loginDoctor";
  static String get register => "$baseUrl/registerDoctor";
  static String get otpLogin => "$baseUrl/loginOtpDoctor";
  static String get profile => "$baseUrl/profile";
  static String get forgotPassword => "$baseUrl/forgotPasswordDoctor";
  static String get verifyOtp => "$baseUrl/verifyOtpDoctor";
  static String get resetPassword => "$baseUrl/resetPasswordDoctor";
  static String get terms => "$baseUrl2/terms&Conditions";

}

/// ========================
/// 🎨 APP COLORS
/// ========================
class AppColors {
  // Main theme
  static const Color primary = Color(0xFF2B5FE6);   //Color(0xFF0D4F45)
  static const Color accent = Colors.teal;
  static const Color background = Color(0xFFF5F5F5);

  // Chat bubble colors
  static const Color chatUser = Colors.white;      // user messages
  static const Color chatBot = Color(0xFFE6F0FF);       // bot messages
  static const Color chatDoctor = Color(0xFFC8E6C9);    // doctor messages
  static const Color chatSystem = Color(0xFFBBDEFB);    // system messages

  // Chat text colors
  static const Color chatUserText = Colors.black87;     // user message text
  static const Color chatBotText = Colors.black;      // bot message text
  static const Color chatDoctorText = Colors.black87;   // doctor message text
  static const Color chatSystemText = Colors.black87;   // system message text

  // Text colors
  static const Color textDark = Colors.black87;
  static const Color textLight = Colors.white;

  // Button colors
  static const Color buttonPrimary = Colors.white;
  static const Color buttonSecondary = Colors.lightBlueAccent; // payment button
  static const Color buttonText = Colors.black;        // Button text color (new!)

  // Icon colors
  static const Color iconColor = Colors.white;// Default icon color

  //Profile Icon colors
  static const Color profileiconColor = Color(0xFF2B5FE6);
}

/// ========================
/// 🔧 HELPER FUNCTIONS
/// ========================
class Helpers {
  /// Dynamically build endpoint
  static String getEndpoint(String endpoint) =>
      "${ApiConfig.baseUrl}/$endpoint";

  /// Validate email
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  /// Validate phone number
  static bool isValidPhone(String phone) {
    return phone.length >= 10;
  }

  /// Show snackbar (reuse everywhere)
  static void showSnackBar(BuildContext context, String message,
      {Color bgColor = Colors.black87}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
      ),
    );
  }
}
