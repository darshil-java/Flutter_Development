// // lib/helper.dart
// import 'package:flutter/material.dart';
//
// /// ========================
// /// 🌐 API CONFIG
// /// ========================
// class ApiConfig {
//   // Base URL → change here only
//   static const String baseUrl = "http://192.168.1.6:9000/api";
//
//   // Endpoints
//   static String get login => "$baseUrl/login";
//   static String get register => "$baseUrl/register";
//   static String get otpLogin => "$baseUrl/login-otp";
//   static String  doctors = "$baseUrl/Doctors/all";
//   static String get orders => "$baseUrl/create-order";
//   static String get profile => "$baseUrl/profile";
//   static String get upload => "$baseUrl/upload";
//   static String get terms => "$baseUrl/terms&Conditions";
//   static String get forgotPassword => "$baseUrl/forgot-password";
//   static String get verifyOtp => "$baseUrl/verify-otp";
//   static String get resetPassword => "$baseUrl/reset-Password";
//   // static String get chat => "$baseUrl/sendMessage";
//   // static String getChatHistory(String userId) => "$baseUrl/chats/$userId";
//   // static const String updateButtonState = "$baseUrl/update-button-state";
//   static String get chat => "$baseUrl/chat"; // matches backend POST /chat
//   static String getChatHistory(String userId) => "$baseUrl/chat-history/$userId"; // matches backend GET /chat-history/:userId
//   static const String updateButtonState = "$baseUrl/update-button-state"; // matches backend POST /update-button-state
//
//
// }
//
// /// ========================
// /// 🎨 APP COLORS
// /// ========================
// class AppColors {
//   // Main theme
//   static const Color primary = Color(0xFF2B5FE6);   //Color(0xFF0D4F45)
//   static const Color accent = Colors.teal;
//   static const Color background = Color(0xFFF5F5F5);
//
//   // Chat bubble colors
//   static const Color chatUser = Colors.white;      // user messages
//   static const Color chatBot = Color(0xFFE6F0FF);       // bot messages
//   static const Color chatDoctor = Color(0xFFC8E6C9);    // doctor messages
//   static const Color chatSystem = Color(0xFFBBDEFB);    // system messages
//
//   // Chat text colors
//   static const Color chatUserText = Colors.black87;     // user message text
//   static const Color chatBotText = Colors.black;      // bot message text
//   static const Color chatDoctorText = Colors.black87;   // doctor message text
//   static const Color chatSystemText = Colors.black87;   // system message text
//
//   // Text colors
//   static const Color textDark = Colors.black87;
//   static const Color textLight = Colors.white;
//
//   // Button colors
//   static const Color buttonPrimary = Colors.white;
//   static const Color buttonSecondary = Colors.lightBlueAccent; // payment button
//   static const Color buttonText = Colors.black;        // Button text color (new!)
//
//   // Icon colors
//   static const Color iconColor = Colors.white;// Default icon color
//
//   //Profile Icon colors
//   static const Color profileiconColor = Color(0xFF2B5FE6);
// }
//
// /// ========================
// /// 🔧 HELPER FUNCTIONS
// /// ========================
// class Helpers {
//   /// Dynamically build endpoint
//   static String getEndpoint(String endpoint) =>
//       "${ApiConfig.baseUrl}/$endpoint";
//
//   /// Validate email
//   static bool isValidEmail(String email) {
//     final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     return regex.hasMatch(email);
//   }
//
//   /// Validate phone number
//   static bool isValidPhone(String phone) {
//     return phone.length >= 10;
//   }
//
//   /// Show snackbar (reuse everywhere)
//   static void showSnackBar(BuildContext context, String message,
//       {Color bgColor = Colors.black87}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: bgColor,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

/// ========================
/// 🌐 API CONFIG
/// ========================
class ApiConfig {
  // 🔗 Base URL (Update this as per your backend server IP/Port)
  static const String baseUrl = "http://192.168.1.13:3000/api";

  // Authentication
  static String get login => "$baseUrl/login";
  static String get register => "$baseUrl/register";
  static String get otpLogin => "$baseUrl/login-otp";

  // Doctors & Profile
  static String doctors = "$baseUrl/Doctors/all";
  static String get profile => "$baseUrl/profile";

  // Orders & Payments
  static String get orders => "$baseUrl/create-order";
  static String get verifyPayment => "$baseUrl/verify-payment";


  // ✅ ADD THIS - Order Status Endpoint
  // static String getOrderStatus(String orderId) => "$baseUrl/orders/$orderId";
  // static String getOrderStatus(String orderId) => "$baseUrl/completeOrder/$orderId";
  static String getOrderStatus(String orderId) => "$baseUrl/doctor/orderStatus/$orderId";
  // Add to your ApiConfig class
  static String get completedOrders => "$baseUrl/api/patients/completed-orders";

  // Miscellaneous
  static String get upload => "$baseUrl/upload";
  // static const String upload = "$baseUrl/upload";
  static String get terms => "$baseUrl/terms&Conditions";

  // Forgot Password Flow
  static String get forgotPassword => "$baseUrl/forgot-password";
  static String get verifyOtp => "$baseUrl/verify-otp";
  static String get resetPassword => "$baseUrl/reset-Password";

  // Chat Endpoints
  // static String get chat => "$baseUrl"; // POST /chat
  // static String getChatHistory(String userId) =>
  //     "$baseUrl/history/$userId"; // GET /chat-history/:userId
  // static const String updateButtonState =
  //     "$baseUrl/update-button-state"; // POST /update-button-state

  static String get chatInitialize => "$baseUrl/initialize";
  static String get chatSend => "$baseUrl/send";
  static String get chatHistory => "$baseUrl/history";
  static String getChatByOrder(String orderId) => "$baseUrl/order/$orderId";
  static String updateMessage(String messageId) => "$baseUrl/message/$messageId";
  static String deleteMessage(String messageId) => "$baseUrl/message/$messageId";
}

/// ========================
/// 🎨 APP COLORS
/// ========================
class AppColors {
  // Main Theme
  static const Color primary = Color(0xFF2B5FE6);
  static const Color accent = Colors.teal;
  static const Color background = Color(0xFFF5F5F5);

  // Chat Bubbles
  static const Color chatUser = Colors.white; // user
  static const Color chatBot = Color(0xFFE6F0FF); // bot
  static const Color chatDoctor = Color(0xFFC8E6C9); // doctor
  static const Color chatSystem = Color(0xFFBBDEFB); // system

  // Chat Text
  static const Color chatUserText = Colors.black87;
  static const Color chatBotText = Colors.black;
  static const Color chatDoctorText = Colors.black87;
  static const Color chatSystemText = Colors.black87;

  // General Text
  static const Color textDark = Colors.black87;
  static const Color textLight = Colors.white;

  // Buttons
  static const Color buttonPrimary = Colors.white;
  static const Color buttonSecondary = Colors.lightBlueAccent;
  static const Color buttonText = Colors.black;

  // Icons
  static const Color iconColor = Colors.white;
  static const Color profileiconColor = Color(0xFF2B5FE6);
}

/// ========================
/// 🔧 HELPER FUNCTIONS
/// ========================
class Helpers {
  /// Build endpoint dynamically
  static String getEndpoint(String endpoint) =>
      "${ApiConfig.baseUrl}/$endpoint";

  /// Validate email format
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  /// Validate phone number length
  static bool isValidPhone(String phone) => phone.length >= 10;

  /// Show snackbar anywhere
  static void showSnackBar(BuildContext context, String message,
      {Color bgColor = AppColors.primary}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
