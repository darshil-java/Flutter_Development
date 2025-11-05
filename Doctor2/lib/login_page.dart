// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'helper.dart';
// // import 'ForgotPasswordPage.dart';
// //
// // class LoginPage extends StatefulWidget {
// //   const LoginPage({super.key});
// //
// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<LoginPage> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
// //
// //   bool _obscureText = true;
// //   bool isSubmitted = false;
// //   bool isLoading = false;
// //
// //   // ==================== LOGIN FUNCTION =====================
// //   Future<void> loginUser() async {
// //     setState(() => isLoading = true);
// //
// //     final url = Uri.parse(ApiConfig.login);
// //
// //     try {
// //       final response = await http.post(
// //         url,
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           'email': emailController.text.trim(),
// //           'password': passwordController.text.trim(),
// //         }),
// //       );
// //
// //       print("==== Response Status: ${response.statusCode} ====");
// //       print("==== Response Body: ${response.body} ====");
// //
// //       final responseData = jsonDecode(response.body);
// //
// //       if (response.statusCode == 200) {
// //         final data = responseData['data'] ?? {};
// //         final token = data['token']?.toString() ?? '';
// //         final user = data['user'] ?? {};
// //
// //         // Debug prints
// //         print("==== User Data Received ====");
// //         print("ID: ${user['id']}");
// //         print("Full Name: ${user['fullname']}");
// //         print("Email: ${user['email']}");
// //         print("Phone: ${user['phone']}");
// //         print("DOB: ${user['dob']}");
// //         print("Gender: ${user['gender']}");
// //         print("Language: ${user['language']}");
// //         print("Token: $token");
// //
// //         SharedPreferences prefs = await SharedPreferences.getInstance();
// //         await prefs.setBool('isLoggedIn', true);
// //         await prefs.setString('token', token);
// //         await prefs.setString('userId', user['id']?.toString() ?? '');
// //         await prefs.setString('fullName', user['fullname']?.toString() ?? 'No Name');
// //         await prefs.setString('email', user['email']?.toString() ?? '');
// //         await prefs.setString('phone', user['phone']?.toString() ?? '');
// //         await prefs.setString('dob', user['dob']?.toString() ?? 'Not specified');
// //         await prefs.setString('gender', user['gender']?.toString() ?? 'Not specified');
// //         await prefs.setString('language', user['language']?.toString() ?? 'Not specified');
// //
// //         Helpers.showSnackBar(context, "Login Successful", bgColor: AppColors.primary);
// //
// //         if (mounted) Navigator.pushReplacementNamed(context, '/home');
// //       } else {
// //         print("Login failed: ${responseData['message'] ?? 'No message'}");
// //         Helpers.showSnackBar(
// //             context, responseData['message'] ?? "Login failed", bgColor: Colors.redAccent);
// //       }
// //     } catch (e) {
// //       print("Error during login: $e");
// //       Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
// //     } finally {
// //       setState(() => isLoading = false);
// //     }
// //   }
// //
// //   // ==================== SUBMIT FUNCTION =====================
// //   void submit() {
// //     setState(() => isSubmitted = true);
// //     if (formKey.currentState!.validate()) {
// //       loginUser();
// //     }
// //   }
// //
// //   // ==================== UI =====================
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
// //         child: Form(
// //           key: formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text("Welcome",
// //                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,color: AppColors.primary)),
// //               const SizedBox(height: 8),
// //               Text("Login to continue",
// //                   style: TextStyle(
// //                       color: Colors.grey[600], fontWeight: FontWeight.w700)),
// //               const SizedBox(height: 32),
// //
// //               // Email/Phone Field
// //               TextFormField(
// //                 controller: emailController,
// //                 decoration: InputDecoration(
// //                   labelText: "Email or Phone",
// //                   hintText: "e.g. darshil@gmail.com or 9876543210",
// //                   hintStyle: TextStyle(color: Colors.grey.shade500),
// //                   border: const OutlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty)
// //                     return "Please Enter Email or Phone";
// //                   if (!Helpers.isValidEmail(value) &&
// //                       !Helpers.isValidPhone(value)) {
// //                     return "Enter valid Email or 10 Digit Number";
// //                   }
// //                   return null;
// //                 },
// //                 autovalidateMode: isSubmitted
// //                     ? AutovalidateMode.onUserInteraction
// //                     : AutovalidateMode.disabled,
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Password Field
// //               TextFormField(
// //                 controller: passwordController,
// //                 obscureText: _obscureText,
// //                 maxLength: 12,
// //                 decoration: InputDecoration(
// //                   labelText: "Enter Password",
// //                   hintText: "e.g. Dars@123",
// //                   hintStyle: TextStyle(color: Colors.grey.shade500),
// //                   border: const OutlineInputBorder(),
// //                   counterText: "",
// //                   suffixIcon: IconButton(
// //                     icon: Icon(_obscureText
// //                         ? Icons.visibility_off
// //                         : Icons.visibility),
// //                     onPressed: () => setState(() => _obscureText = !_obscureText),
// //                   ),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) return "Please Enter Password";
// //                   if (value.length < 8 || value.length > 12)
// //                     return "Password must be 8–12 characters";
// //                   final letter = RegExp(r'[A-Za-z]');
// //                   final digit = RegExp(r'\d');
// //                   final special = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
// //                   if (!letter.hasMatch(value)) return "Include letters";
// //                   if (!digit.hasMatch(value)) return "Include digits";
// //                   if (!special.hasMatch(value)) return "Include special characters";
// //                   return null;
// //                 },
// //                 autovalidateMode: isSubmitted
// //                     ? AutovalidateMode.onUserInteraction
// //                     : AutovalidateMode.disabled,
// //               ),
// //               const SizedBox(height: 10),
// //
// //               Align(
// //                 alignment: Alignment.centerLeft,
// //                 child: TextButton(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
// //                     );
// //                   },
// //                   child: const Text(
// //                     "Forgot Password?",
// //                     style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //               // Login Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 48,
// //                 child: ElevatedButton(
// //                   onPressed: isLoading ? null : submit,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: AppColors.primary,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(7),
// //                     ),
// //                   ),
// //                   child: isLoading
// //                       ? const CircularProgressIndicator(color: Colors.white)
// //                       : const Text("Login",
// //                       style: TextStyle(
// //                           color: AppColors.textLight,
// //                           fontWeight: FontWeight.bold)),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //
// //
// //
// //               // Login with OTP Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 48,
// //                 child: OutlinedButton(
// //                   onPressed: () {
// //                     Navigator.pushNamed(context, '/otp_page');
// //                   },
// //                   style: OutlinedButton.styleFrom(
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(7),
// //                     ),
// //                   ),
// //                   child: const Text("Login with OTP",
// //                       style: TextStyle(
// //                           color: AppColors.primary,
// //                           fontWeight: FontWeight.bold)),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Register
// //               Center(
// //                 child: RichText(
// //                   text: TextSpan(
// //                     text: "Don't Have an Account? ",
// //                     style: const TextStyle(color: Colors.black),
// //                     children: [
// //                       TextSpan(
// //                         text: "Register",
// //                         style: const TextStyle(
// //                           color: AppColors.primary,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         recognizer: TapGestureRecognizer()
// //                           ..onTap = () {
// //                             Navigator.pushNamed(context, '/register');
// //                           },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'helper.dart';
// // import 'ForgotPasswordPage.dart';
// //
// // class LoginPage extends StatefulWidget {
// //   const LoginPage({super.key});
// //
// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<LoginPage> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
// //
// //   bool _obscureText = true;
// //   bool isSubmitted = false;
// //   bool isLoading = false;
// //
// //   // ==================== LOGIN FUNCTION =====================
// //   Future<void> loginUser() async {
// //     setState(() => isLoading = true);
// //
// //     final url = Uri.parse(ApiConfig.login);
// //
// //     try {
// //       final response = await http.post(
// //         url,
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           'email': emailController.text.trim(),
// //           'password': passwordController.text.trim(),
// //         }),
// //       );
// //
// //       final responseData = jsonDecode(response.body);
// //
// //       if (response.statusCode == 200) {
// //         final data = responseData['data'] ?? {};
// //
// //         // Handle dynamic backend responses
// //         final token = data['token']?.toString() ?? '';
// //         final user = data['user'] ?? {};
// //         final userId = user['_id']?.toString() ?? data['id']?.toString() ?? '';
// //         final name = user['fullName'] ?? data['name'] ?? 'User';
// //
// //         if (token.isEmpty) {
// //           Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
// //           return;
// //         }
// //
// //         // Save user data in SharedPreferences
// //         SharedPreferences prefs = await SharedPreferences.getInstance();
// //         await prefs.setBool('isLoggedIn', true);
// //         await prefs.setString('token', token);
// //         await prefs.setString('userId', userId);
// //         await prefs.setString('name', name);
// //
// //         Helpers.showSnackBar(
// //           context,
// //           "Login Successful! Welcome $name 👋",
// //           bgColor: AppColors.primary,
// //         );
// //
// //         if (mounted) Navigator.pushReplacementNamed(context, '/home');
// //       } else {
// //         Helpers.showSnackBar(
// //           context,
// //           responseData['message'] ?? "Login failed. Please try again.",
// //           bgColor: Colors.redAccent,
// //         );
// //       }
// //     } catch (e) {
// //       Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
// //     } finally {
// //       setState(() => isLoading = false);
// //     }
// //   }
// //
// //   // ==================== SUBMIT FUNCTION =====================
// //   void submit() {
// //     setState(() => isSubmitted = true);
// //     if (formKey.currentState!.validate()) {
// //       loginUser();
// //     }
// //   }
// //
// //   // ==================== UI =====================
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
// //         child: Form(
// //           key: formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 "Welcome",
// //                 style: TextStyle(
// //                   fontSize: 32,
// //                   fontWeight: FontWeight.w700,
// //                   color: AppColors.primary,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 "Login to continue",
// //                 style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700),
// //               ),
// //               const SizedBox(height: 32),
// //
// //               // Email/Phone Field
// //               TextFormField(
// //                 controller: emailController,
// //                 decoration: InputDecoration(
// //                   labelText: "Email or Phone",
// //                   hintText: "e.g. darshil@gmail.com or 9876543210",
// //                   hintStyle: TextStyle(color: Colors.grey.shade500),
// //                   border: const OutlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) return "Please enter Email or Phone";
// //                   if (!Helpers.isValidEmail(value) && !Helpers.isValidPhone(value)) {
// //                     return "Enter valid Email or 10-digit Number";
// //                   }
// //                   return null;
// //                 },
// //                 autovalidateMode:
// //                 isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Password Field
// //               TextFormField(
// //                 controller: passwordController,
// //                 obscureText: _obscureText,
// //                 maxLength: 12,
// //                 decoration: InputDecoration(
// //                   labelText: "Enter Password",
// //                   hintText: "e.g. Dars@123",
// //                   hintStyle: TextStyle(color: Colors.grey.shade500),
// //                   border: const OutlineInputBorder(),
// //                   counterText: "",
// //                   suffixIcon: IconButton(
// //                     icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
// //                     onPressed: () => setState(() => _obscureText = !_obscureText),
// //                   ),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) return "Please enter Password";
// //                   if (value.length < 8 || value.length > 12) return "Password must be 8–12 characters";
// //
// //                   final letter = RegExp(r'[A-Za-z]');
// //                   final digit = RegExp(r'\d');
// //                   final special = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
// //                   if (!letter.hasMatch(value)) return "Include letters";
// //                   if (!digit.hasMatch(value)) return "Include digits";
// //                   if (!special.hasMatch(value)) return "Include special characters";
// //                   return null;
// //                 },
// //                 autovalidateMode:
// //                 isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
// //               ),
// //               const SizedBox(height: 10),
// //
// //               Align(
// //                 alignment: Alignment.centerLeft,
// //                 child: TextButton(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
// //                     );
// //                   },
// //                   child: const Text(
// //                     "Forgot Password?",
// //                     style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //
// //               // Login Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 48,
// //                 child: ElevatedButton(
// //                   onPressed: isLoading ? null : submit,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: AppColors.primary,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(7),
// //                     ),
// //                   ),
// //                   child: isLoading
// //                       ? const CircularProgressIndicator(color: Colors.white)
// //                       : const Text(
// //                     "Login",
// //                     style: TextStyle(
// //                       color: AppColors.textLight,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //
// //               // Login with OTP Button
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 48,
// //                 child: OutlinedButton(
// //                   onPressed: () {
// //                     Navigator.pushNamed(context, '/otp_page');
// //                   },
// //                   style: OutlinedButton.styleFrom(
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(7),
// //                     ),
// //                   ),
// //                   child: const Text(
// //                     "Login with OTP",
// //                     style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //
// //               // Register Link
// //               Center(
// //                 child: RichText(
// //                   text: TextSpan(
// //                     text: "Don't have an account? ",
// //                     style: const TextStyle(color: Colors.black),
// //                     children: [
// //                       TextSpan(
// //                         text: "Register",
// //                         style: const TextStyle(
// //                           color: AppColors.primary,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                         recognizer: TapGestureRecognizer()
// //                           ..onTap = () {
// //                             Navigator.pushNamed(context, '/register');
// //                           },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'helper.dart';
// import 'ForgotPasswordPage.dart';
// import 'dart:math'; // Add this for min() function
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   bool _obscureText = true;
//   bool isSubmitted = false;
//   bool isLoading = false;
//
//   // ==================== LOGIN FUNCTION =====================
//   Future<void> loginUser() async {
//     setState(() => isLoading = true);
//
//     final url = Uri.parse(ApiConfig.login);
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': emailController.text.trim(),
//           'password': passwordController.text.trim(),
//         }),
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         final data = responseData['data'] ?? {};
//
//         // Handle dynamic backend responses
//         final token = data['token']?.toString() ?? '';
//         final user = data['user'] ?? {};
//         final userId = user['_id']?.toString() ?? data['id']?.toString() ?? '';
//         final name = user['fullName'] ?? data['name'] ?? 'User';
//
//         if (token.isEmpty) {
//           Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
//           return;
//         }
//
//         // Save user data in SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('token', token);
//         await prefs.setString('userId', userId);
//         await prefs.setString('name', name);
//
//         // ✅ CRITICAL: Save doctor-specific data for doctor dashboard
//         // Check if this is a doctor login by looking for doctor-specific fields
//         final doctorType = user['doctorType'] ?? data['doctorType'] ?? '';
//         final speciality = user['speciality'] ?? data['speciality'] ?? '';
//         final doctorId = user['_id']?.toString() ?? data['id']?.toString() ?? '';
//
//         print('🔍 Doctor data found:');
//         print('  - doctorType: $doctorType');
//         print('  - speciality: $speciality');
//         print('  - doctorId: $doctorId');
//
//         // If doctor-specific fields exist, save them
//         if (doctorType.isNotEmpty || speciality.isNotEmpty) {
//           await prefs.setString('doctorId', doctorId);
//           await prefs.setString('doctorType', doctorType);
//           await prefs.setString('speciality', speciality);
//           print('✅ Doctor data saved to SharedPreferences');
//         } else {
//           print('ℹ️ No doctor-specific data found - this might be a regular user');
//         }
//
//         Helpers.showSnackBar(
//           context,
//           "Login Successful! Welcome $name 👋",
//           bgColor: AppColors.primary,
//         );
//
//         // Debug: Print all saved data
//         final allKeys = prefs.getKeys();
//         print('📋 All saved SharedPreferences keys: $allKeys');
//         for (String key in allKeys) {
//           print('  - $key: ${prefs.get(key)}');
//         }
//
//         if (mounted) Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Helpers.showSnackBar(
//           context,
//           responseData['message'] ?? "Login failed. Please try again.",
//           bgColor: Colors.redAccent,
//         );
//       }
//     } catch (e) {
//       Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   // ==================== DOCTOR LOGIN FUNCTION =====================
//   Future<void> loginDoctor() async {
//     setState(() => isLoading = true);
//
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/doctors/login');
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': emailController.text.trim(),
//           'password': passwordController.text.trim(),
//         }),
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         final data = responseData['data'] ?? {};
//
//         // Handle doctor login response
//         final token = data['token']?.toString() ?? '';
//         final doctor = data['doctor'] ?? {};
//         final doctorId = doctor['_id']?.toString() ?? data['id']?.toString() ?? '';
//         final name = doctor['name'] ?? 'Doctor';
//         final doctorType = doctor['doctorType'] ?? '';
//         final speciality = doctor['speciality'] ?? '';
//
//         if (token.isEmpty) {
//           Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
//           return;
//         }
//
//         // Save doctor data in SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('token', token);
//         await prefs.setString('userId', doctorId);
//         await prefs.setString('doctorId', doctorId);
//         await prefs.setString('name', name);
//         await prefs.setString('doctorType', doctorType);
//         await prefs.setString('speciality', speciality);
//
//         print('✅ Doctor login successful - data saved:');
//         print('  - doctorId: $doctorId');
//         print('  - name: $name');
//         print('  - doctorType: $doctorType');
//         print('  - speciality: $speciality');
//
//         Helpers.showSnackBar(
//           context,
//           "Login Successful! Welcome Dr. $name 👋",
//           bgColor: AppColors.primary,
//         );
//
//         // Debug: Print all saved data
//         final allKeys = prefs.getKeys();
//         print('📋 All saved SharedPreferences keys: $allKeys');
//         for (String key in allKeys) {
//           print('  - $key: ${prefs.get(key)}');
//         }
//
//         if (mounted) Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Helpers.showSnackBar(
//           context,
//           responseData['message'] ?? "Doctor login failed. Please try again.",
//           bgColor: Colors.redAccent,
//         );
//       }
//     } catch (e) {
//       Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   // ==================== SMART LOGIN FUNCTION =====================
//   // ==================== SMART LOGIN FUNCTION =====================
//   // Future<void> smartLogin() async {
//   //   setState(() => isLoading = true);
//   //
//   //   final email = emailController.text.trim();
//   //   final password = passwordController.text.trim();
//   //
//   //   try {
//   //     // First try doctor login
//   //     print('🔄 Attempting doctor login...');
//   //     final doctorResponse = await http.post(
//   //       Uri.parse('${ApiConfig.baseUrl}/api/doctors/login'),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({
//   //         'email': email,
//   //         'password': password,
//   //       }),
//   //     );
//   //
//   //     if (doctorResponse.statusCode == 200) {
//   //       // Doctor login successful
//   //       final responseData = jsonDecode(doctorResponse.body);
//   //       final data = responseData['data'] ?? {};
//   //
//   //       final token = data['token']?.toString() ?? '';
//   //       final doctor = data['doctor'] ?? {};
//   //       final doctorId = doctor['_id']?.toString() ?? data['id']?.toString() ?? '';
//   //       final name = doctor['name'] ?? 'Doctor';
//   //       final doctorType = doctor['doctorType'] ?? '';
//   //       final speciality = doctor['speciality'] ?? '';
//   //
//   //       if (token.isEmpty) {
//   //         Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
//   //         return;
//   //       }
//   //
//   //       // Save doctor data
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       await prefs.setBool('isLoggedIn', true);
//   //       await prefs.setString('token', token);
//   //       await prefs.setString('userId', doctorId);
//   //       await prefs.setString('doctorId', doctorId);
//   //       await prefs.setString('name', name);
//   //       await prefs.setString('doctorType', doctorType);
//   //       await prefs.setString('speciality', speciality);
//   //       await prefs.setBool('isDoctor', true); // ✅ Mark as doctor
//   //
//   //       print('✅ Doctor login successful');
//   //       print('🔍 Doctor data: doctorId: $doctorId, doctorType: $doctorType, speciality: $speciality');
//   //
//   //       Helpers.showSnackBar(
//   //         context,
//   //         "Welcome Dr. $name! 👨‍⚕️",
//   //         bgColor: AppColors.primary,
//   //       );
//   //
//   //       if (mounted) Navigator.pushReplacementNamed(context, '/home');
//   //       return;
//   //     }
//   //
//   //     // If doctor login failed, try regular user login
//   //     print('🔄 Attempting regular user login...');
//   //     final userResponse = await http.post(
//   //       Uri.parse(ApiConfig.login),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({
//   //         'email': email,
//   //         'password': password,
//   //       }),
//   //     );
//   //
//   //     if (userResponse.statusCode == 200) {
//   //       final responseData = jsonDecode(userResponse.body);
//   //       final data = responseData['data'] ?? {};
//   //
//   //       final token = data['token']?.toString() ?? '';
//   //       final user = data['user'] ?? {};
//   //       final userId = user['_id']?.toString() ?? data['id']?.toString() ?? '';
//   //       final name = user['fullName'] ?? data['name'] ?? 'User';
//   //
//   //       if (token.isEmpty) {
//   //         Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
//   //         return;
//   //       }
//   //
//   //       // Save regular user data - CLEAR any existing doctor data
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       await prefs.setBool('isLoggedIn', true);
//   //       await prefs.setString('token', token);
//   //       await prefs.setString('userId', userId);
//   //       await prefs.setString('name', name);
//   //       await prefs.setBool('isDoctor', false); // ✅ Mark as regular user
//   //
//   //       // ✅ Clear any previous doctor data to avoid confusion
//   //       await prefs.remove('doctorId');
//   //       await prefs.remove('doctorType');
//   //       await prefs.remove('speciality');
//   //
//   //       print('✅ Regular user login successful');
//   //       print('ℹ️ User type: Regular User (no doctor data expected)');
//   //
//   //       Helpers.showSnackBar(
//   //         context,
//   //         "Welcome $name! 👋",
//   //         bgColor: AppColors.primary,
//   //       );
//   //
//   //       if (mounted) Navigator.pushReplacementNamed(context, '/home');
//   //     } else {
//   //       final errorData = jsonDecode(userResponse.body);
//   //       Helpers.showSnackBar(
//   //         context,
//   //         errorData['message'] ?? "Login failed. Please check your credentials.",
//   //         bgColor: Colors.redAccent,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print('❌ Login error: $e');
//   //     Helpers.showSnackBar(
//   //       context,
//   //       "Network error. Please try again.",
//   //       bgColor: Colors.redAccent,
//   //     );
//   //   } finally {
//   //     setState(() => isLoading = false);
//   //   }
//   // }
//   // ==================== SMART LOGIN FUNCTION =====================
//   // ==================== ENHANCED SMART LOGIN FUNCTION =====================
//   // ==================== FIXED SMART LOGIN FUNCTION =====================
//   // ==================== FIXED SMART LOGIN FUNCTION =====================
//   // Future<void> smartLogin() async {
//   //   setState(() => isLoading = true);
//   //
//   //   final email = emailController.text.trim();
//   //   final password = passwordController.text.trim();
//   //
//   //   try {
//   //     // First try doctor login
//   //     print('🔄 Attempting doctor login...');
//   //     final doctorResponse = await http.post(
//   //       Uri.parse('${ApiConfig.baseUrl}/api/doctors/login'),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({
//   //         'email': email,
//   //         'password': password,
//   //       }),
//   //     );
//   //
//   //     if (doctorResponse.statusCode == 200) {
//   //       final responseData = jsonDecode(doctorResponse.body);
//   //       print('✅ Doctor login response: $responseData');
//   //
//   //       final data = responseData['data'] ?? responseData;
//   //       final token = data['token']?.toString() ?? '';
//   //       final doctor = data['doctor'] ?? data['user'] ?? data;
//   //
//   //       // Extract doctor data with null safety
//   //       final doctorId = doctor['_id']?.toString() ?? doctor['id']?.toString() ?? '';
//   //       final name = doctor['name']?.toString() ?? doctor['fullName']?.toString() ?? 'Doctor';
//   //       final doctorType = doctor['doctorType']?.toString() ?? doctor['type']?.toString() ?? '';
//   //       final speciality = doctor['speciality']?.toString() ?? '';
//   //
//   //       // ✅ FIX: Proper null safety check
//   //       if (token.isEmpty || doctorId.isEmpty) {
//   //         Helpers.showSnackBar(context, "Login failed: Missing data", bgColor: Colors.red);
//   //         return;
//   //       }
//   //
//   //       // Save doctor data
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       await prefs.setBool('isLoggedIn', true);
//   //       await prefs.setString('token', token);
//   //       await prefs.setString('userId', doctorId);
//   //       await prefs.setString('doctorId', doctorId);
//   //       await prefs.setString('name', name);
//   //       await prefs.setString('doctorType', doctorType);
//   //       await prefs.setString('speciality', speciality);
//   //       await prefs.setBool('isDoctor', true);
//   //
//   //       print('✅ Doctor login successful');
//   //       Helpers.showSnackBar(context, "Welcome Dr. $name! 👨‍⚕️", bgColor: AppColors.primary);
//   //
//   //       if (mounted) Navigator.pushReplacementNamed(context, '/home');
//   //       return;
//   //     }
//   //
//   //     // If doctor login failed, try regular user login
//   //     print('🔄 Attempting regular user login...');
//   //     final userResponse = await http.post(
//   //       Uri.parse(ApiConfig.login),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({
//   //         'email': email,
//   //         'password': password,
//   //       }),
//   //     );
//   //
//   //     print('📦 Regular login response status: ${userResponse.statusCode}');
//   //     print('📦 Regular login response body: ${userResponse.body}');
//   //
//   //     if (userResponse.statusCode == 200) {
//   //       final responseData = jsonDecode(userResponse.body);
//   //       final data = responseData['data'] ?? responseData;
//   //
//   //       final token = data['token']?.toString() ?? '';
//   //
//   //       // ✅ CRITICAL FIX: Extract user data from the correct structure
//   //       // Your response has: data.doctor.id, not data.user._id
//   //       final doctor = data['doctor'] ?? data['user'] ?? data;
//   //
//   //       // ✅ Extract user ID from multiple possible locations in the correct structure
//   //       final userId = doctor['_id']?.toString() ??
//   //           doctor['id']?.toString() ??
//   //           data['_id']?.toString() ??
//   //           data['id']?.toString() ??
//   //           '';
//   //
//   //       final name = doctor['name']?.toString() ??
//   //           doctor['fullName']?.toString() ??
//   //           data['name']?.toString() ??
//   //           'User';
//   //
//   //       // ✅ Extract doctor fields
//   //       final doctorType = doctor['doctorType']?.toString() ??
//   //           doctor['type']?.toString() ??
//   //           data['doctorType']?.toString() ??
//   //           '';
//   //
//   //       final speciality = doctor['speciality']?.toString() ??
//   //           data['speciality']?.toString() ??
//   //           '';
//   //
//   //       print('🔍 Extracted login data:');
//   //       print('  - userId: $userId');
//   //       print('  - name: $name');
//   //       print('  - doctorType: $doctorType');
//   //       print('  - speciality: $speciality');
//   //
//   //       // ✅ FIX: Proper null safety checks
//   //       if (token.isEmpty) {
//   //         Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
//   //         return;
//   //       }
//   //
//   //       // ✅ FIX: Check for empty userId
//   //       if (userId.isEmpty) {
//   //         print('❌ CRITICAL: User ID is empty in response');
//   //         Helpers.showSnackBar(context, "User ID not found", bgColor: Colors.red);
//   //         return;
//   //       }
//   //
//   //       // Save user data
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       await prefs.setBool('isLoggedIn', true);
//   //       await prefs.setString('token', token);
//   //       await prefs.setString('userId', userId); // ✅ This was missing!
//   //       await prefs.setString('name', name);
//   //       await prefs.setString('email', email); // Save email for future reference
//   //
//   //       // ✅ Check if this is a doctor based on the response data
//   //       final isDoctorUser = (doctorType.isNotEmpty && doctorType != 'null') ||
//   //           (speciality.isNotEmpty && speciality != 'null');
//   //
//   //       print('🔍 Doctor detection:');
//   //       print('  - doctorType found: "$doctorType"');
//   //       print('  - speciality found: "$speciality"');
//   //       print('  - isDoctorUser: $isDoctorUser');
//   //
//   //       if (isDoctorUser) {
//   //         // ✅ This is a doctor - save doctor data
//   //         await prefs.setBool('isDoctor', true);
//   //         await prefs.setString('doctorId', userId);
//   //         await prefs.setString('doctorType', doctorType);
//   //         await prefs.setString('speciality', speciality);
//   //
//   //         print('✅ Doctor login detected - saving doctor data');
//   //         Helpers.showSnackBar(context, "Welcome Dr. $name! 👨‍⚕️", bgColor: AppColors.primary);
//   //       } else {
//   //         // Regular user
//   //         await prefs.setBool('isDoctor', false);
//   //         await prefs.remove('doctorId');
//   //         await prefs.remove('doctorType');
//   //         await prefs.remove('speciality');
//   //
//   //         print('✅ Regular user login');
//   //         Helpers.showSnackBar(context, "Welcome $name! 👋", bgColor: AppColors.primary);
//   //       }
//   //
//   //       // ✅ Verify everything was saved
//   //       final savedUserId = prefs.getString('userId');
//   //       final savedIsDoctor = prefs.getBool('isDoctor');
//   //       final savedDoctorType = prefs.getString('doctorType');
//   //       final savedSpeciality = prefs.getString('speciality');
//   //
//   //       print('✅ Login completed:');
//   //       print('  - userId: $savedUserId');
//   //       print('  - isDoctor: $savedIsDoctor');
//   //       print('  - doctorType: $savedDoctorType');
//   //       print('  - speciality: $savedSpeciality');
//   //
//   //       if (mounted) Navigator.pushReplacementNamed(context, '/home');
//   //     } else {
//   //       final errorData = jsonDecode(userResponse.body);
//   //       Helpers.showSnackBar(
//   //         context,
//   //         errorData['message'] ?? "Login failed. Please check your credentials.",
//   //         bgColor: Colors.redAccent,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print('❌ Login error: $e');
//   //     Helpers.showSnackBar(
//   //       context,
//   //       "Network error. Please try again.",
//   //       bgColor: Colors.redAccent,
//   //     );
//   //   } finally {
//   //     setState(() => isLoading = false);
//   //   }
//   // }
//
//   Future<void> smartLogin() async {
//     setState(() => isLoading = true);
//
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     try {
//       // First try doctor login
//       print('🔄 Attempting doctor login...');
//       final doctorResponse = await http.post(
//         Uri.parse('${ApiConfig.baseUrl}/api/doctors/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//       );
//
//       if (doctorResponse.statusCode == 200) {
//         final responseData = jsonDecode(doctorResponse.body);
//         print('✅ Doctor login response: $responseData');
//
//         final data = responseData['data'] ?? responseData;
//
//         // ✅ FIX: Extract token from the correct location
//         // Try multiple possible locations for token
//         final token = data['token']?.toString() ??
//             responseData['token']?.toString() ??
//             '';
//
//         final doctor = data['doctor'] ?? data['user'] ?? data;
//
//         // Extract doctor data with null safety
//         final doctorId = doctor['_id']?.toString() ?? doctor['id']?.toString() ?? '';
//         final name = doctor['name']?.toString() ?? doctor['fullName']?.toString() ?? 'Doctor';
//         final doctorType = doctor['doctorType']?.toString() ?? doctor['type']?.toString() ?? '';
//         final speciality = doctor['speciality']?.toString() ?? '';
//
//         print('🔍 Extracted doctor data:');
//         print('  - token: ${token.isNotEmpty ? '✓' : '✗'}');
//         print('  - doctorId: $doctorId');
//         print('  - name: $name');
//         print('  - doctorType: $doctorType');
//         print('  - speciality: $speciality');
//
//         // ✅ FIX: Proper null safety check
//         if (token.isEmpty) {
//           print('❌ Token is empty in doctor response');
//           Helpers.showSnackBar(context, "Login failed: No token received", bgColor: Colors.red);
//           return;
//         }
//
//         if (doctorId.isEmpty) {
//           print('❌ Doctor ID is empty');
//           Helpers.showSnackBar(context, "Login failed: No doctor ID received", bgColor: Colors.red);
//           return;
//         }
//
//         // ✅ FIX: Save ALL data to SharedPreferences including token
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('token', token); // ✅ THIS WAS MISSING!
//         await prefs.setString('userId', doctorId);
//         await prefs.setString('doctorId', doctorId);
//         await prefs.setString('name', name);
//         await prefs.setString('doctorType', doctorType);
//         await prefs.setString('speciality', speciality);
//         await prefs.setBool('isDoctor', true);
//         await prefs.setString('email', email); // Save email for reference
//
//         print('✅ Doctor login successful - ALL data saved to SharedPreferences');
//
//         // ✅ Verify everything was saved
//         final savedToken = prefs.getString('token');
//         final savedDoctorId = prefs.getString('doctorId');
//         final savedDoctorType = prefs.getString('doctorType');
//
//         print('🔍 Verification - Saved data:');
//         print('  - token: ${savedToken != null ? '✓ (${savedToken.substring(0, min(20, savedToken.length))}...)' : '✗'}');
//         print('  - doctorId: $savedDoctorId');
//         print('  - doctorType: $savedDoctorType');
//         print('  - isDoctor: ${prefs.getBool('isDoctor')}');
//
//         Helpers.showSnackBar(context, "Welcome Dr. $name! 👨‍⚕️", bgColor: AppColors.primary);
//
//         if (mounted) Navigator.pushReplacementNamed(context, '/home');
//         return;
//       }
//
//       // If doctor login failed, try regular user login
//       print('🔄 Attempting regular user login...');
//       final userResponse = await http.post(
//         Uri.parse(ApiConfig.login),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//       );
//
//       print('📦 Regular login response status: ${userResponse.statusCode}');
//       print('📦 Regular login response body: ${userResponse.body}');
//
//       if (userResponse.statusCode == 200) {
//         final responseData = jsonDecode(userResponse.body);
//         final data = responseData['data'] ?? responseData;
//
//         // ✅ FIX: Extract token from multiple possible locations
//         final token = data['token']?.toString() ??
//             responseData['token']?.toString() ??
//             '';
//
//         // Extract user data
//         final doctor = data['doctor'] ?? data['user'] ?? data;
//         final userId = doctor['_id']?.toString() ??
//             doctor['id']?.toString() ??
//             data['_id']?.toString() ??
//             data['id']?.toString() ??
//             '';
//
//         final name = doctor['name']?.toString() ??
//             doctor['fullName']?.toString() ??
//             data['name']?.toString() ??
//             'User';
//
//         // Extract doctor fields
//         final doctorType = doctor['doctorType']?.toString() ??
//             doctor['type']?.toString() ??
//             data['doctorType']?.toString() ??
//             '';
//
//         final speciality = doctor['speciality']?.toString() ??
//             data['speciality']?.toString() ??
//             '';
//
//         print('🔍 Extracted regular user data:');
//         print('  - token: ${token.isNotEmpty ? '✓' : '✗'}');
//         print('  - userId: $userId');
//         print('  - name: $name');
//         print('  - doctorType: $doctorType');
//         print('  - speciality: $speciality');
//
//         // ✅ FIX: Check for token
//         if (token.isEmpty) {
//           print('❌ Token is empty in regular user response');
//           Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
//           return;
//         }
//
//         // Save user data
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('token', token); // ✅ Save token
//         await prefs.setString('userId', userId);
//         await prefs.setString('name', name);
//         await prefs.setString('email', email);
//
//         // Check if this is a doctor based on the response data
//         final isDoctorUser = (doctorType.isNotEmpty && doctorType != 'null') ||
//             (speciality.isNotEmpty && speciality != 'null');
//
//         print('🔍 Doctor detection:');
//         print('  - doctorType found: "$doctorType"');
//         print('  - speciality found: "$speciality"');
//         print('  - isDoctorUser: $isDoctorUser');
//
//         if (isDoctorUser) {
//           // This is a doctor - save doctor data
//           await prefs.setBool('isDoctor', true);
//           await prefs.setString('doctorId', userId);
//           await prefs.setString('doctorType', doctorType);
//           await prefs.setString('speciality', speciality);
//
//           print('✅ Doctor login detected - saving doctor data');
//           Helpers.showSnackBar(context, "Welcome Dr. $name! 👨‍⚕️", bgColor: AppColors.primary);
//         } else {
//           // Regular user
//           await prefs.setBool('isDoctor', false);
//           await prefs.remove('doctorId');
//           await prefs.remove('doctorType');
//           await prefs.remove('speciality');
//
//           print('✅ Regular user login');
//           Helpers.showSnackBar(context, "Welcome $name! 👋", bgColor: AppColors.primary);
//         }
//
//         // ✅ Verify everything was saved
//         final savedToken = prefs.getString('token');
//         final savedUserId = prefs.getString('userId');
//         final savedIsDoctor = prefs.getBool('isDoctor');
//
//         print('✅ Login completed:');
//         print('  - token: ${savedToken != null ? '✓' : '✗'}');
//         print('  - userId: $savedUserId');
//         print('  - isDoctor: $savedIsDoctor');
//
//         if (mounted) Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         final errorData = jsonDecode(userResponse.body);
//         Helpers.showSnackBar(
//           context,
//           errorData['message'] ?? "Login failed. Please check your credentials.",
//           bgColor: Colors.redAccent,
//         );
//       }
//     } catch (e) {
//       print('❌ Login error: $e');
//       Helpers.showSnackBar(
//         context,
//         "Network error. Please try again.",
//         bgColor: Colors.redAccent,
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//   // ==================== SUBMIT FUNCTION =====================
//   void submit() {
//     setState(() => isSubmitted = true);
//     if (formKey.currentState!.validate()) {
//       smartLogin(); // Use the smart login function
//     }
//   }
//
//   // ==================== UI =====================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
//         child: Form(
//           key: formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Welcome",
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Login to continue",
//                 style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(height: 32),
//
//               // Email/Phone Field
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: "Email or Phone",
//                   hintText: "e.g. darshil@gmail.com or 9876543210",
//                   hintStyle: TextStyle(color: Colors.grey.shade500),
//                   border: const OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return "Please enter Email or Phone";
//                   if (!Helpers.isValidEmail(value) && !Helpers.isValidPhone(value)) {
//                     return "Enter valid Email or 10-digit Number";
//                   }
//                   return null;
//                 },
//                 autovalidateMode:
//                 isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
//               ),
//               const SizedBox(height: 16),
//
//               // Password Field
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: _obscureText,
//                 maxLength: 12,
//                 decoration: InputDecoration(
//                   labelText: "Enter Password",
//                   hintText: "e.g. Dars@123",
//                   hintStyle: TextStyle(color: Colors.grey.shade500),
//                   border: const OutlineInputBorder(),
//                   counterText: "",
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () => setState(() => _obscureText = !_obscureText),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return "Please enter Password";
//                   if (value.length < 8 || value.length > 12) return "Password must be 8–12 characters";
//
//                   final letter = RegExp(r'[A-Za-z]');
//                   final digit = RegExp(r'\d');
//                   final special = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
//                   if (!letter.hasMatch(value)) return "Include letters";
//                   if (!digit.hasMatch(value)) return "Include digits";
//                   if (!special.hasMatch(value)) return "Include special characters";
//                   return null;
//                 },
//                 autovalidateMode:
//                 isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
//               ),
//               const SizedBox(height: 10),
//
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
//                     );
//                   },
//                   child: const Text(
//                     "Forgot Password?",
//                     style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//
//               // Login Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : submit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                     "Login",
//                     style: TextStyle(
//                       color: AppColors.textLight,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // Login with OTP Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/otp_page');
//                   },
//                   style: OutlinedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                   ),
//                   child: const Text(
//                     "Login with OTP",
//                     style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Doctor Registration Link
//               // Center(
//               //   child: RichText(
//               //     text: TextSpan(
//               //       text: "Are you a doctor? ",
//               //       style: const TextStyle(color: Colors.black),
//               //       children: [
//               //         TextSpan(
//               //           text: "Register here",
//               //           style: const TextStyle(
//               //             color: AppColors.primary,
//               //             fontWeight: FontWeight.bold,
//               //           ),
//               //           recognizer: TapGestureRecognizer()
//               //             ..onTap = () {
//               //               Navigator.pushNamed(context, '/doctor-register');
//               //             },
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//
//
//               // Register Link
//               Center(
//                 child: RichText(
//                   text: TextSpan(
//                     text: "Don't have an account? ",
//                     style: const TextStyle(color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: "Register",
//                         style: const TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.pushNamed(context, '/register');
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';
import 'ForgotPasswordPage.dart';
import 'welcome_screen.dart'; // Import welcome screen
import 'dart:math'; // Add this for min() function

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool isSubmitted = false;
  bool isLoading = false;

  // ==================== WILL POP SCOPE =====================
  // Handle back button press
  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Are you sure you want to exit the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  // ==================== NAVIGATE TO WELCOME =====================
  void _navigateToWelcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  // ==================== SMART LOGIN FUNCTION =====================
  Future<void> smartLogin() async {
    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // First try doctor login
      print('🔄 Attempting doctor login...');
      final doctorResponse = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/doctors/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (doctorResponse.statusCode == 200) {
        final responseData = jsonDecode(doctorResponse.body);
        print('✅ Doctor login response: $responseData');

        final data = responseData['data'] ?? responseData;

        // ✅ FIX: Extract token from the correct location
        // Try multiple possible locations for token
        final token = data['token']?.toString() ??
            responseData['token']?.toString() ??
            '';

        final doctor = data['doctor'] ?? data['user'] ?? data;

        // Extract doctor data with null safety
        final doctorId = doctor['_id']?.toString() ?? doctor['id']?.toString() ?? '';
        final name = doctor['name']?.toString() ?? doctor['fullName']?.toString() ?? 'Doctor';
        final doctorType = doctor['doctorType']?.toString() ?? doctor['type']?.toString() ?? '';
        final speciality = doctor['speciality']?.toString() ?? '';

        print('🔍 Extracted doctor data:');
        print('  - token: ${token.isNotEmpty ? '✓' : '✗'}');
        print('  - doctorId: $doctorId');
        print('  - name: $name');
        print('  - doctorType: $doctorType');
        print('  - speciality: $speciality');

        // ✅ FIX: Proper null safety check
        if (token.isEmpty) {
          print('❌ Token is empty in doctor response');
          Helpers.showSnackBar(context, "Login failed: No token received", bgColor: Colors.red);
          return;
        }

        if (doctorId.isEmpty) {
          print('❌ Doctor ID is empty');
          Helpers.showSnackBar(context, "Login failed: No doctor ID received", bgColor: Colors.red);
          return;
        }

        // ✅ FIX: Save ALL data to SharedPreferences including token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', token); // ✅ THIS WAS MISSING!
        await prefs.setString('userId', doctorId);
        await prefs.setString('doctorId', doctorId);
        await prefs.setString('name', name);
        await prefs.setString('doctorType', doctorType);
        await prefs.setString('speciality', speciality);
        await prefs.setBool('isDoctor', true);
        await prefs.setString('email', email); // Save email for reference

        print('✅ Doctor login successful - ALL data saved to SharedPreferences');

        // ✅ Verify everything was saved
        final savedToken = prefs.getString('token');
        final savedDoctorId = prefs.getString('doctorId');
        final savedDoctorType = prefs.getString('doctorType');

        print('🔍 Verification - Saved data:');
        print('  - token: ${savedToken != null ? '✓ (${savedToken.substring(0, min(20, savedToken.length))}...)' : '✗'}');
        print('  - doctorId: $savedDoctorId');
        print('  - doctorType: $savedDoctorType');
        print('  - isDoctor: ${prefs.getBool('isDoctor')}');

        Helpers.showSnackBar(context, "Welcome Dr. $name! 👨‍⚕️", bgColor: AppColors.primary);

        if (mounted) Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      // If doctor login failed, try regular user login
      print('🔄 Attempting regular user login...');
      final userResponse = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('📦 Regular login response status: ${userResponse.statusCode}');
      print('📦 Regular login response body: ${userResponse.body}');

      if (userResponse.statusCode == 200) {
        final responseData = jsonDecode(userResponse.body);
        final data = responseData['data'] ?? responseData;

        // ✅ FIX: Extract token from multiple possible locations
        final token = data['token']?.toString() ??
            responseData['token']?.toString() ??
            '';

        // Extract user data
        final doctor = data['doctor'] ?? data['user'] ?? data;
        final userId = doctor['_id']?.toString() ??
            doctor['id']?.toString() ??
            data['_id']?.toString() ??
            data['id']?.toString() ??
            '';

        final name = doctor['name']?.toString() ??
            doctor['fullName']?.toString() ??
            data['name']?.toString() ??
            'User';

        // Extract doctor fields
        final doctorType = doctor['doctorType']?.toString() ??
            doctor['type']?.toString() ??
            data['doctorType']?.toString() ??
            '';

        final speciality = doctor['speciality']?.toString() ??
            data['speciality']?.toString() ??
            '';

        print('🔍 Extracted regular user data:');
        print('  - token: ${token.isNotEmpty ? '✓' : '✗'}');
        print('  - userId: $userId');
        print('  - name: $name');
        print('  - doctorType: $doctorType');
        print('  - speciality: $speciality');

        // ✅ FIX: Check for token
        if (token.isEmpty) {
          print('❌ Token is empty in regular user response');
          Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
          return;
        }

        // Save user data
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', token); // ✅ Save token
        await prefs.setString('userId', userId);
        await prefs.setString('name', name);
        await prefs.setString('email', email);

        // Check if this is a doctor based on the response data
        final isDoctorUser = (doctorType.isNotEmpty && doctorType != 'null') ||
            (speciality.isNotEmpty && speciality != 'null');

        print('🔍 Doctor detection:');
        print('  - doctorType found: "$doctorType"');
        print('  - speciality found: "$speciality"');
        print('  - isDoctorUser: $isDoctorUser');

        if (isDoctorUser) {
          // This is a doctor - save doctor data
          await prefs.setBool('isDoctor', true);
          await prefs.setString('doctorId', userId);
          await prefs.setString('doctorType', doctorType);
          await prefs.setString('speciality', speciality);

          print('✅ Doctor login detected - saving doctor data');
          Helpers.showSnackBar(context, "Welcome Dr. $name! 👨‍⚕️", bgColor: AppColors.primary);
        } else {
          // Regular user
          await prefs.setBool('isDoctor', false);
          await prefs.remove('doctorId');
          await prefs.remove('doctorType');
          await prefs.remove('speciality');

          print('✅ Regular user login');
          Helpers.showSnackBar(context, "Welcome $name! 👋", bgColor: AppColors.primary);
        }

        // ✅ Verify everything was saved
        final savedToken = prefs.getString('token');
        final savedUserId = prefs.getString('userId');
        final savedIsDoctor = prefs.getBool('isDoctor');

        print('✅ Login completed:');
        print('  - token: ${savedToken != null ? '✓' : '✗'}');
        print('  - userId: $savedUserId');
        print('  - isDoctor: $savedIsDoctor');

        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        final errorData = jsonDecode(userResponse.body);
        Helpers.showSnackBar(
          context,
          errorData['message'] ?? "Login failed. Please check your credentials.",
          bgColor: Colors.redAccent,
        );
      }
    } catch (e) {
      print('❌ Login error: $e');
      Helpers.showSnackBar(
        context,
        "Network error. Please try again.",
        bgColor: Colors.redAccent,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ==================== SUBMIT FUNCTION =====================
  void submit() {
    setState(() => isSubmitted = true);
    if (formKey.currentState!.validate()) {
      smartLogin(); // Use the smart login function
    }
  }

  // ==================== UI =====================
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
            onPressed: _navigateToWelcome,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 20),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Login to continue",
                  style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 32),

                // Email/Phone Field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email or Phone",
                    hintText: "e.g. xyz@gmail.com or 0000000000",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter Email or Phone";
                    if (!Helpers.isValidEmail(value) && !Helpers.isValidPhone(value)) {
                      return "Enter valid Email or 10-digit Number";
                    }
                    return null;
                  },
                  autovalidateMode:
                  isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  maxLength: 12,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    hintText: "e.g. Xyz@123",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: const OutlineInputBorder(),
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter Password";
                    if (value.length < 8 || value.length > 12) return "Password must be 8–12 characters";

                    final letter = RegExp(r'[A-Za-z]');
                    final digit = RegExp(r'\d');
                    final special = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
                    if (!letter.hasMatch(value)) return "Include letters";
                    if (!digit.hasMatch(value)) return "Include digits";
                    if (!special.hasMatch(value)) return "Include special characters";
                    return null;
                  },
                  autovalidateMode:
                  isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Login with OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/otp_page');
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      "Login with OTP",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/register');
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                // Back to Welcome Button
                const SizedBox(height: 30),
                // Center(
                //   child: TextButton(
                //     onPressed: _navigateToWelcome,
                //     child: const Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.home, color: AppColors.primary, size: 18),
                //         SizedBox(width: 8),
                //         Text(
                //           "Back to Welcome",
                //           style: TextStyle(
                //             color: AppColors.primary,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}