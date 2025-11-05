// forgot_password_page.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'helper.dart';
import 'ResetPasswordPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final otpCtrls = List.generate(6, (_) => TextEditingController());
  final otpNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;
  bool otpSent = false;
  String errorText = '';
  String? serverEmail;
  String? resetToken; // JWT token from backend

  int _otpExpiry = 300;
  Timer? _expiryTimer;
  bool _canResend = false;
  String _expiryText = '';

  @override
  void dispose() {
    emailCtrl.dispose();
    otpCtrls.forEach((c) => c.dispose());
    otpNodes.forEach((n) => n.dispose());
    _expiryTimer?.cancel();
    super.dispose();
  }

  void _startOtpExpiryTimer() {
    _expiryTimer?.cancel();
    _otpExpiry = 300;
    _canResend = false;
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpExpiry == 0) {
        timer.cancel();
        if (mounted) {
          setState(() {
            errorText = 'OTP expired. Please request a new one.';
            _canResend = true;
          });
        }
      } else if (mounted) {
        setState(() {
          _otpExpiry--;
          final minutes = (_otpExpiry ~/ 60).toString().padLeft(2, '0');
          final seconds = (_otpExpiry % 60).toString().padLeft(2, '0');
          _expiryText = 'OTP expires in $minutes:$seconds';
        });
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorText = '';
    });

    try {
      final url = Uri.parse(ApiConfig.forgotPassword);
      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": emailCtrl.text.trim()}),
      );

      final data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        setState(() {
          otpSent = true;
          serverEmail = emailCtrl.text.trim();
          resetToken = data['data']['token']; // save JWT token
        });
        _startOtpExpiryTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.black),
        );
        FocusScope.of(context).requestFocus(otpNodes[0]);
      } else {
        throw (data['message'] ?? "Error sending OTP");
      }
    } catch (e) {
      setState(() => errorText = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Step 2: Verify OTP
  Future<void> _verifyOtp() async {
    final otp = otpCtrls.map((c) => c.text.trim()).join();
    if (otp.length != 6) {
      setState(() => errorText = 'Enter a 6-digit OTP');
      return;
    }

    setState(() {
      isLoading = true;
      errorText = '';
    });

    try {
      final url = Uri.parse(ApiConfig.verifyOtp);
      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": serverEmail, "otp": otp}),
      );

      final data = jsonDecode(resp.body);

      if (resp.statusCode == 200 && data['data'] != null && data['data']['token'] != null) {
        final token = data['data']['token']; // safely get token

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified"), backgroundColor: Colors.black),
        );

        // Pass token to ResetPasswordPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(email: serverEmail!, token: token),
          ),
        );
      } else {
        throw (data['message'] ?? "Invalid or expired OTP or no token returned");
      }
    } catch (e) {
      setState(() => errorText = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }


  Widget _otpFields() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(6, (i) {
      return SizedBox(
        width: 45,
        child: TextField(
          controller: otpCtrls[i],
          focusNode: otpNodes[i],
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(counterText: ''),
          onChanged: (v) {
            if (v.isNotEmpty && i < 5) FocusScope.of(context).requestFocus(otpNodes[i + 1]);
          },
        ),
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Forgot Password", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.primary)),
              const SizedBox(height: 8),
              Text("Reset your password with OTP verification", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
              const SizedBox(height: 32),
              TextFormField(
                controller: emailCtrl,
                enabled: !otpSent,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "e.g. darshil@gmail.com",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Email is required";
                  final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!re.hasMatch(v.trim())) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (errorText.isNotEmpty)
                Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(errorText, style: const TextStyle(color: Colors.redAccent))),
              if (!otpSent)
                ElevatedButton(
                  onPressed: isLoading ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textLight, minimumSize: const Size(double.infinity, 50)),
                  child: isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Send OTP", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textLight)),
                )
              else ...[
                const Text("Enter the 6-digit code sent to your email", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                _otpFields(),
                const SizedBox(height: 20),
                !_canResend
                    ? Text(_expiryText, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700]))
                    : TextButton(onPressed: isLoading ? null : _sendOtp, child: const Text("Resend OTP", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textLight, minimumSize: const Size(double.infinity, 50)),
                  child: isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Verify OTP", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textLight)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import "helper.dart";
// import "ResetPasswordPage.dart";
//
// class ForgotPasswordPage extends StatefulWidget {
//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }
//
// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final emailCtrl = TextEditingController();
//   final otpCtrls = List.generate(6, (_) => TextEditingController());
//   final otpNodes = List.generate(6, (_) => FocusNode());
//
//   bool isLoading = false;
//   bool otpSent = false;
//   bool otpVerified = false;
//   String errorText = '';
//   String? serverEmail;
//
//   // OTP Expiry Timer
//   int _otpExpiry = 300; // 5 minutes
//   Timer? _expiryTimer;
//   bool _canResend = false;
//   String _expiryText = '';
//
//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     otpCtrls.forEach((c) => c.dispose());
//     otpNodes.forEach((n) => n.dispose());
//     _expiryTimer?.cancel();
//     super.dispose();
//   }
//
//   void _startOtpExpiryTimer() {
//     _expiryTimer?.cancel();
//     _otpExpiry = 300;
//     _canResend = false;
//
//     _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_otpExpiry == 0) {
//         timer.cancel();
//         if (mounted) {
//           setState(() {
//             errorText = 'OTP expired. Please request a new one.';
//             _canResend = true;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             _otpExpiry--;
//             final minutes = (_otpExpiry ~/ 60).toString().padLeft(2, '0');
//             final seconds = (_otpExpiry % 60).toString().padLeft(2, '0');
//             _expiryText = 'OTP expires in $minutes:$seconds';
//           });
//         }
//       }
//     });
//   }
//
//   Future<void> _sendOtp() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       isLoading = true;
//       errorText = '';
//     });
//
//     try {
//       final url = Uri.parse(ApiConfig.forgotPassword);
//       final resp = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": emailCtrl.text.trim()}),
//       );
//
//       final data = jsonDecode(resp.body);
//       print("Send OTP response: $data");
//
//       if (resp.statusCode == 200) {
//         setState(() {
//           otpSent = true;
//           serverEmail = emailCtrl.text.trim();
//           otpVerified = false;
//         });
//         _startOtpExpiryTimer();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message']), backgroundColor: Colors.black),
//         );
//         FocusScope.of(context).requestFocus(otpNodes[0]);
//       } else {
//         throw (data['message'] ?? "Error sending OTP");
//       }
//     } catch (e) {
//       setState(() => errorText = e.toString());
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _verifyOtp() async {
//     final otp = otpCtrls.map((c) => c.text.trim()).join();
//     if (otp.length != 6) {
//       setState(() => errorText = 'Enter a 6-digit OTP');
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       errorText = '';
//     });
//
//     try {
//       final url = Uri.parse(ApiConfig.verifyOtp);
//       final resp = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": serverEmail, "otp": otp}),
//       );
//
//       final data = jsonDecode(resp.body);
//       print("Verify OTP response: $data");
//
//       if (resp.statusCode == 200 && data["data"] != null && data["data"]["token"] != null) {
//         final resetToken = data["data"]["token"];
//
//         setState(() {
//           otpVerified = true;
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("OTP Verified"), backgroundColor: Colors.black),
//         );
//
//         // Auto-navigate to ResetPasswordPage
//         Future.delayed(const Duration(milliseconds: 500), () {
//           if (!mounted) return;
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ResetPasswordPage(
//                 email: serverEmail!,
//                 resetToken: resetToken,
//               ),
//             ),
//           );
//         });
//       } else {
//         setState(() => errorText = data["message"] ?? "Invalid or expired OTP");
//       }
//     } catch (e) {
//       setState(() => errorText = e.toString());
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Widget _otpFields() => Row(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: List.generate(6, (i) {
//       return SizedBox(
//         width: 45,
//         child: TextField(
//           controller: otpCtrls[i],
//           focusNode: otpNodes[i],
//           maxLength: 1,
//           keyboardType: TextInputType.number,
//           textAlign: TextAlign.center,
//           enabled: !otpVerified, // disable after success
//           decoration: const InputDecoration(counterText: ''),
//           onChanged: (v) {
//             if (v.isNotEmpty && i < 5) {
//               FocusScope.of(context).requestFocus(otpNodes[i + 1]);
//             }
//             if (v.isEmpty && i > 0) {
//               FocusScope.of(context).requestFocus(otpNodes[i - 1]);
//             }
//           },
//         ),
//       );
//     }),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Forgot Password",
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Reset your password with OTP verification",
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               TextFormField(
//                 controller: emailCtrl,
//                 enabled: !otpSent,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   hintText: "e.g. darshil@gmail.com",
//                   hintStyle: TextStyle(color: Colors.grey.shade500),
//                   border: const OutlineInputBorder(),
//                 ),
//                 validator: (v) {
//                   if (v == null || v.trim().isEmpty) {
//                     return "Email is required";
//                   }
//                   final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//                   if (!re.hasMatch(v.trim())) {
//                     return "Enter a valid email";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               if (errorText.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Text(
//                     errorText,
//                     style: const TextStyle(color: Colors.redAccent),
//                   ),
//                 ),
//               if (!otpSent)
//                 ElevatedButton(
//                   onPressed: isLoading ? null : _sendOtp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     foregroundColor: AppColors.textLight,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(7)),
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: isLoading
//                       ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(color: Colors.white),
//                   )
//                       : const Text(
//                     "Send OTP",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textLight,
//                     ),
//                   ),
//                 )
//               else ...[
//                 const Text(
//                   "Enter the 6-digit code sent to your email",
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 24),
//                 _otpFields(),
//                 const SizedBox(height: 20),
//                 !_canResend
//                     ? Text(
//                   _expiryText,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey[700]),
//                 )
//                     : TextButton(
//                   onPressed: isLoading ? null : _sendOtp,
//                   child: const Text(
//                     "Resend OTP",
//                     style: TextStyle(
//                       color: AppColors.primary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: isLoading || otpVerified ? null : _verifyOtp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     foregroundColor: AppColors.textLight,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(7)),
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: isLoading
//                       ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(color: Colors.white),
//                   )
//                       : const Text(
//                     "Verify OTP",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textLight,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
