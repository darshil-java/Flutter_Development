import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({super.key});

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());

  bool _otpSent = false;
  bool isLoading = false;
  String _statusMessage = '';
  Color _statusColor = Colors.red;

  // Timer variables
  int _otpExpiry = 300; // 5 minutes = 300 sec
  Timer? _expiryTimer;
  bool _canResend = false;
  String _expiryText = '';

  @override
  void dispose() {
    _emailController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    _expiryTimer?.cancel();
    super.dispose();
  }

  // ================= OTP Expiry Timer =================
  void _startOtpExpiryTimer() {
    _expiryTimer?.cancel();
    _otpExpiry = 300;
    _canResend = false;

    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpExpiry == 0) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _canResend = true;
            _expiryText = "OTP expired. Please resend.";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _otpExpiry--;
            final minutes = (_otpExpiry ~/ 60).toString().padLeft(2, '0');
            final seconds = (_otpExpiry % 60).toString().padLeft(2, '0');
            _expiryText = "OTP expires in $minutes:$seconds";
          });
        }
      }
    });
  }

  // ================= VALIDATE EMAIL =================
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a Valid Email Address";
    }
    return null;
  }

  // ================= VALIDATE OTP =================
  String? validateOtp(String otp) {
    if (otp.isEmpty) return "Enter OTP";
    if (otp.length != 6 || !RegExp(r'^\d+$').hasMatch(otp)) {
      return "OTP must be 6 digits";
    }
    return null;
  }

  // ================= SEND OTP =================
  Future<void> sendOtp() async {
    final email = _emailController.text.trim();
    final emailError = validateEmail(email);
    if (emailError != null) {
      setState(() {
        _statusMessage = emailError;
        _statusColor = Colors.red;
      });
      return;
    }

    setState(() {
      isLoading = true;
      _statusMessage = '';
    });

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/sentOtp');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Clear old OTP fields
        for (var c in _otpControllers) {
          c.clear();
        }

        setState(() {
          _otpSent = true;
          _statusMessage = 'OTP sent to $email';
          _statusColor = Colors.green;
        });

        _startOtpExpiryTimer();

        Helpers.showSnackBar(context, 'OTP sent to $email',
            bgColor: AppColors.primary);
      } else {
        setState(() {
          _statusMessage = data['error'] ?? 'Failed to send OTP';
          _statusColor = Colors.red;
        });
        Helpers.showSnackBar(context, data['error'] ?? 'Failed to send OTP',
            bgColor: Colors.red.shade700);
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _statusColor = Colors.red;
      });
      Helpers.showSnackBar(context, 'Error: $e', bgColor: Colors.red.shade700);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= VERIFY OTP =================
  Future<void> verifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpControllers.map((c) => c.text).join();

    final otpError = validateOtp(otp);
    if (otpError != null) {
      setState(() {
        _statusMessage = otpError;
        _statusColor = Colors.red;
      });
      return;
    }

    setState(() {
      isLoading = true;
      _statusMessage = '';
    });

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/verifyOtp');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'] ?? {};
        final token = data['token']?.toString() ?? '';
        final user = data['user'] ?? {};

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', token);
        await prefs.setString('userId', user['id']?.toString() ?? '');
        await prefs.setString(
            'fullName', user['fullname']?.toString() ?? 'No Name');
        await prefs.setString('email', user['email']?.toString() ?? '');
        await prefs.setString('phone', user['phone']?.toString() ?? '');
        await prefs.setString(
            'dob', user['dob']?.toString() ?? 'Not specified');
        await prefs.setString(
            'gender', user['gender']?.toString() ?? 'Not specified');
        await prefs.setString(
            'language', user['language']?.toString() ?? 'Not specified');

        Helpers.showSnackBar(context, "Login Successful",
            bgColor: AppColors.primary);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _statusMessage = responseData['error'] ?? 'Invalid OTP';
          _statusColor = Colors.red;
        });
        Helpers.showSnackBar(
            context, responseData['error'] ?? 'Invalid OTP',
            bgColor: Colors.red.shade700);
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _statusColor = Colors.red;
      });
      Helpers.showSnackBar(context, 'Error: $e', bgColor: Colors.red.shade700);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("OTP Login",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Enter Your Registered Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            if (_otpSent) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _otpControllers[index],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        } else {
                          if (index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              !_canResend
                  ? Text(
                _expiryText,
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500),
              )
                  : TextButton(
                onPressed: isLoading ? null : sendOtp,
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isLoading ? null : (_otpSent ? verifyOtp : sendOtp),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  _otpSent ? "Verify OTP" : "Send OTP",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_statusMessage.isNotEmpty)
              Text(
                _statusMessage,
                style: TextStyle(
                    color: _statusColor, fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}
