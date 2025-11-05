// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import '../helper.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class LogoutHelper {
//   static Future<void> logoutUser(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     if (token == null) {
//       Helpers.showSnackBar(context, "You are not logged in.");
//       return;
//     }
//
//     final url = Uri.parse("${ApiConfig.baseUrl}/logout");
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         await prefs.clear();
//         Helpers.showSnackBar(context, "Logout successful",
//             bgColor: AppColors.accent);
//         if (context.mounted) {
//           Navigator.pushReplacementNamed(context, '/login');
//         }
//       } else {
//         final responseData = jsonDecode(response.body);
//         Helpers.showSnackBar(
//             context, responseData['message'] ?? "Logout failed",
//             bgColor: Colors.red);
//       }
//     } catch (e) {
//       Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.red);
//     }
//   }
// }
