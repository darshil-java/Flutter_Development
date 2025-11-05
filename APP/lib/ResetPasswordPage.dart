import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'helper.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  ResetPasswordPage({required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  /// 🔹 Password Validation Logic
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Must contain at least 1 uppercase letter";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Must contain at least 1 special character";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Confirm your password";
    if (value != newPasswordController.text) return "Passwords do not match";
    return null;
  }

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = newPasswordController.text.trim();

    setState(() => isLoading = true);

    try {
      final url = Uri.parse(ApiConfig.resetPassword);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": "", // already verified
          "newPassword": newPassword,
          "confirmPassword": confirmPasswordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.black),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Error resetting password"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // 🔹 Page Title in Body
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),


                // 🔹 Icon
                Icon(Icons.lock_reset, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),

                // 🔹 Subtitle
                Text(
                  "Create New Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your new password must be different from the old one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),

                // 🔹 New Password
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !_showNewPassword,
                  validator: _validatePassword,
                  maxLength: 12,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter New Password",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showNewPassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: () => setState(() => _showNewPassword = !_showNewPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 🔹 Confirm Password
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !_showConfirmPassword,
                  validator: _validateConfirmPassword,
                  maxLength: 12,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Confirm New Password",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // 🔹 Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : resetPassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
