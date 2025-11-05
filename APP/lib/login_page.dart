// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'helper.dart';
// import 'ForgotPasswordPage.dart';
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
//       print("==== Response Status: ${response.statusCode} ====");
//       print("==== Response Body: ${response.body} ====");
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         final data = responseData['data'] ?? {};
//         final token = data['token']?.toString() ?? '';
//         final user = data['user'] ?? {};
//
//         // Debug prints
//         print("==== User Data Received ====");
//         print("ID: ${user['id']}");
//         print("Full Name: ${user['fullname']}");
//         print("Email: ${user['email']}");
//         print("Phone: ${user['phone']}");
//         print("DOB: ${user['dob']}");
//         print("Gender: ${user['gender']}");
//         print("Language: ${user['language']}");
//         print("Token: $token");
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('token', token);
//         await prefs.setString('userId', user['id']?.toString() ?? '');
//         await prefs.setString('fullName', user['fullname']?.toString() ?? 'No Name');
//         await prefs.setString('email', user['email']?.toString() ?? '');
//         await prefs.setString('phone', user['phone']?.toString() ?? '');
//         await prefs.setString('dob', user['dob']?.toString() ?? 'Not specified');
//         await prefs.setString('gender', user['gender']?.toString() ?? 'Not specified');
//         await prefs.setString('language', user['language']?.toString() ?? 'Not specified');
//
//         Helpers.showSnackBar(context, "Login Successful", bgColor: AppColors.primary);
//
//         if (mounted) Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         print("Login failed: ${responseData['message'] ?? 'No message'}");
//         Helpers.showSnackBar(
//             context, responseData['message'] ?? "Login failed", bgColor: Colors.redAccent);
//       }
//     } catch (e) {
//       print("Error during login: $e");
//       Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   // ==================== SUBMIT FUNCTION =====================
//   void submit() {
//     setState(() => isSubmitted = true);
//     if (formKey.currentState!.validate()) {
//       loginUser();
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
//               const Text("Welcome",
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,color: AppColors.primary)),
//               const SizedBox(height: 8),
//               Text("Login to continue",
//                   style: TextStyle(
//                       color: Colors.grey[600], fontWeight: FontWeight.w700)),
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
//                   if (value == null || value.isEmpty)
//                     return "Please Enter Email or Phone";
//                   if (!Helpers.isValidEmail(value) &&
//                       !Helpers.isValidPhone(value)) {
//                     return "Enter valid Email or 10 Digit Number";
//                   }
//                   return null;
//                 },
//                 autovalidateMode: isSubmitted
//                     ? AutovalidateMode.onUserInteraction
//                     : AutovalidateMode.disabled,
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
//                     icon: Icon(_obscureText
//                         ? Icons.visibility_off
//                         : Icons.visibility),
//                     onPressed: () => setState(() => _obscureText = !_obscureText),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return "Please Enter Password";
//                   if (value.length < 8 || value.length > 12)
//                     return "Password must be 8–12 characters";
//                   final letter = RegExp(r'[A-Za-z]');
//                   final digit = RegExp(r'\d');
//                   final special = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
//                   if (!letter.hasMatch(value)) return "Include letters";
//                   if (!digit.hasMatch(value)) return "Include digits";
//                   if (!special.hasMatch(value)) return "Include special characters";
//                   return null;
//                 },
//                 autovalidateMode: isSubmitted
//                     ? AutovalidateMode.onUserInteraction
//                     : AutovalidateMode.disabled,
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
//                       : const Text("Login",
//                       style: TextStyle(
//                           color: AppColors.textLight,
//                           fontWeight: FontWeight.bold)),
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//
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
//                   child: const Text("Login with OTP",
//                       style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.bold)),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Register
//               Center(
//                 child: RichText(
//                   text: TextSpan(
//                     text: "Don't Have an Account? ",
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

  // ==================== LOGIN FUNCTION =====================
  Future<void> loginUser() async {
    setState(() => isLoading = true);

    final url = Uri.parse(ApiConfig.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      print("==== Response Status: ${response.statusCode} ====");
      print("==== Response Body: ${response.body} ====");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'] ?? {};
        final token = data['token']?.toString() ?? '';
        final user = data['user'] ?? {};

        // Debug prints
        print("==== User Data Received ====");
        print("ID: ${user['id']}");
        print("Full Name: ${user['fullname']}");
        print("Email: ${user['email']}");
        print("Phone: ${user['phone']}");
        print("DOB: ${user['dob']}");
        print("Gender: ${user['gender']}");
        print("Language: ${user['language']}");
        print("Token: $token");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', token);
        await prefs.setString('userId', user['id']?.toString() ?? '');
        await prefs.setString('fullName', user['fullname']?.toString() ?? 'No Name');
        await prefs.setString('email', user['email']?.toString() ?? '');
        await prefs.setString('phone', user['phone']?.toString() ?? '');
        await prefs.setString('dob', user['dob']?.toString() ?? 'Not specified');
        await prefs.setString('gender', user['gender']?.toString() ?? 'Not specified');
        await prefs.setString('language', user['language']?.toString() ?? 'Not specified');

        Helpers.showSnackBar(context, "Login Successful", bgColor: AppColors.primary);

        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        print("Login failed: ${responseData['message'] ?? 'No message'}");
        Helpers.showSnackBar(
            context, responseData['message'] ?? "Login failed", bgColor: Colors.redAccent);
      }
    } catch (e) {
      print("Error during login: $e");
      Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.redAccent);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ==================== SUBMIT FUNCTION =====================
  void submit() {
    setState(() => isSubmitted = true);
    if (formKey.currentState!.validate()) {
      loginUser();
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
                const Text("Welcome",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700,color: AppColors.primary)),
                const SizedBox(height: 8),
                Text("Login to continue",
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w700)),
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
                    if (value == null || value.isEmpty)
                      return "Please Enter Email or Phone";
                    if (!Helpers.isValidEmail(value) &&
                        !Helpers.isValidPhone(value)) {
                      return "Enter valid Email or 10 Digit Number";
                    }
                    return null;
                  },
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  maxLength: 12,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    hintText: "e.g. Xyz@1234",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: const OutlineInputBorder(),
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please Enter Password";
                    if (value.length < 8 || value.length > 12)
                      return "Password must be 8–12 characters";
                    final letter = RegExp(r'[A-Za-z]');
                    final digit = RegExp(r'\d');
                    final special = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
                    if (!letter.hasMatch(value)) return "Include letters";
                    if (!digit.hasMatch(value)) return "Include digits";
                    if (!special.hasMatch(value)) return "Include special characters";
                    return null;
                  },
                  autovalidateMode: isSubmitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
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
                        : const Text("Login",
                        style: TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold)),
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
                    child: const Text("Login with OTP",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),

                // Register
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't Have an Account? ",
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