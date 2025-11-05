// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'helper.dart';
//
// class OtpLoginPage extends StatefulWidget {
//   const OtpLoginPage({super.key});
//
//   @override
//   State<OtpLoginPage> createState() => _OtpLoginPageState();
// }
//
// class _OtpLoginPageState extends State<OtpLoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final List<TextEditingController> _otpControllers =
//   List.generate(6, (_) => TextEditingController());
//
//   bool _otpSent = false;
//   bool isLoading = false;
//   String _statusMessage = '';
//   Color _statusColor = Colors.red;
//
//   // Timer variables
//   int _otpExpiry = 300; // 5 minutes
//   Timer? _expiryTimer;
//   bool _canResend = false;
//   String _expiryText = '';
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     for (var c in _otpControllers) c.dispose();
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
//             _canResend = true;
//             _expiryText = "OTP expired. Please resend.";
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             _otpExpiry--;
//             final minutes = (_otpExpiry ~/ 60).toString().padLeft(2, '0');
//             final seconds = (_otpExpiry % 60).toString().padLeft(2, '0');
//             _expiryText = "OTP expires in $minutes:$seconds";
//           });
//         }
//       }
//     });
//   }
//
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) return "Please Enter Your Email";
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return "Enter a Valid Email Address";
//     return null;
//   }
//
//   String? validateOtp(String otp) {
//     if (otp.isEmpty) return "Enter OTP";
//     if (otp.length != 6 || !RegExp(r'^\d+$').hasMatch(otp)) {
//       return "OTP must be 6 digits";
//     }
//     return null;
//   }
//
//   Future<void> sendOtp() async {
//     final email = _emailController.text.trim();
//     final emailError = validateEmail(email);
//     if (emailError != null) {
//       setState(() {
//         _statusMessage = emailError;
//         _statusColor = Colors.red;
//       });
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       _statusMessage = '';
//     });
//
//     try {
//       final url = Uri.parse('${ApiConfig.baseUrl}/sendOtpDoctor');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email}),
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         for (var c in _otpControllers) c.clear();
//         setState(() {
//           _otpSent = true;
//           _statusMessage = 'OTP sent to $email';
//           _statusColor = Colors.green;
//         });
//         _startOtpExpiryTimer();
//         Helpers.showSnackBar(context, 'OTP sent to $email',
//             bgColor: AppColors.primary);
//       } else {
//         setState(() {
//           _statusMessage = data['error'] ?? 'Failed to send OTP';
//           _statusColor = Colors.red;
//         });
//         Helpers.showSnackBar(context, data['error'] ?? 'Failed to send OTP',
//             bgColor: Colors.red.shade700);
//       }
//     } catch (e) {
//       setState(() {
//         _statusMessage = 'Error: $e';
//         _statusColor = Colors.red;
//       });
//       Helpers.showSnackBar(context, 'Error: $e', bgColor: Colors.red.shade700);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> verifyOtp() async {
//     final email = _emailController.text.trim();
//     final otp = _otpControllers.map((c) => c.text).join();
//     final otpError = validateOtp(otp);
//
//     if (otpError != null) {
//       setState(() {
//         _statusMessage = otpError;
//         _statusColor = Colors.red;
//       });
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       _statusMessage = '';
//     });
//
//     try {
//       final url = Uri.parse(ApiConfig.otpLogin);
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'otp': otp}),
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         final data = responseData['data'] ?? {};
//         final token = data['token']?.toString() ?? '';
//
//         // Only store token
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('token', token);
//
//         Helpers.showSnackBar(context, "Login Successful",
//             bgColor: AppColors.primary);
//
//         // Navigate to ProfilePage
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         setState(() {
//           _statusMessage = responseData['error'] ?? 'Invalid OTP';
//           _statusColor = Colors.red;
//         });
//         Helpers.showSnackBar(context,
//             responseData['error'] ?? 'Invalid OTP', bgColor: Colors.red.shade700);
//       }
//     } catch (e) {
//       setState(() {
//         _statusMessage = 'Error: $e';
//         _statusColor = Colors.red;
//       });
//       Helpers.showSnackBar(context, 'Error: $e', bgColor: Colors.red.shade700);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("OTP Login",
//                 style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primary)),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: "Enter Your Registered Email",
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             if (_otpSent) ...[
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(6, (index) {
//                   return SizedBox(
//                     width: 40,
//                     child: TextField(
//                       controller: _otpControllers[index],
//                       maxLength: 1,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         counterText: '',
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) {
//                         if (value.isNotEmpty) {
//                           if (index < 5) {
//                             FocusScope.of(context).nextFocus();
//                           } else {
//                             FocusScope.of(context).unfocus();
//                           }
//                         } else {
//                           if (index > 0) {
//                             FocusScope.of(context).previousFocus();
//                           }
//                         }
//                       },
//                     ),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 16),
//               !_canResend
//                   ? Text(_expiryText,
//                   style: const TextStyle(
//                       color: AppColors.primary,
//                       fontWeight: FontWeight.w500))
//                   : TextButton(
//                 onPressed: isLoading ? null : sendOtp,
//                 child: const Text(
//                   "Resend OTP",
//                   style: TextStyle(
//                       color: AppColors.primary,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: isLoading ? null : (_otpSent ? verifyOtp : sendOtp),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : Text(
//                   _otpSent ? "Verify OTP" : "Send OTP",
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_statusMessage.isNotEmpty)
//               Text(
//                 _statusMessage,
//                 style: TextStyle(
//                     color: _statusColor, fontWeight: FontWeight.w500),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }







import 'dart:async';
import 'dart:convert';
import 'dart:math';
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
  int _otpExpiry = 300;
  Timer? _expiryTimer;
  bool _canResend = false;
  String _expiryText = '';

  @override
  void dispose() {
    _emailController.dispose();
    for (var c in _otpControllers) c.dispose();
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please Enter Your Email";
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Enter a Valid Email Address";
    return null;
  }

  String? validateOtp(String otp) {
    if (otp.isEmpty) return "Enter OTP";
    if (otp.length != 6 || !RegExp(r'^\d+$').hasMatch(otp)) {
      return "OTP must be 6 digits";
    }
    return null;
  }

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
      // Try doctor OTP first
      print('🔄 Attempting to send OTP to doctor...');
      final url = Uri.parse('${ApiConfig.baseUrl}/sendOtpDoctor');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (var c in _otpControllers) c.clear();
        setState(() {
          _otpSent = true;
          _statusMessage = 'OTP sent to $email';
          _statusColor = Colors.green;
        });
        _startOtpExpiryTimer();
        Helpers.showSnackBar(context, 'OTP sent to $email',
            bgColor: AppColors.primary);
      } else {
        // If doctor OTP fails, try regular user OTP
        print('🔄 Doctor OTP failed, trying regular user OTP...');
        await sendRegularUserOtp(email);
      }
    } catch (e) {
      print('❌ Doctor OTP error: $e');
      // Try regular user OTP as fallback
      await sendRegularUserOtp(email);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> sendRegularUserOtp(String email) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/send-otp');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (var c in _otpControllers) c.clear();
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
    }
  }

  // ==================== FIXED OTP VERIFICATION =====================
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
      // First try doctor OTP verification
      print('🔄 Attempting doctor OTP verification...');
      final doctorResponse = await http.post(
        Uri.parse('${ApiConfig.otpLogin}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print('📦 Doctor OTP response status: ${doctorResponse.statusCode}');
      print('📦 Doctor OTP response body: ${doctorResponse.body}');

      if (doctorResponse.statusCode == 200) {
        await handleDoctorOtpSuccess(doctorResponse, email);
        return;
      }

      // If doctor verification fails, try regular user OTP verification
      print('🔄 Attempting regular user OTP verification...');
      final userResponse = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (userResponse.statusCode == 200) {
        await handleRegularUserOtpSuccess(userResponse, email);
      } else {
        final errorData = jsonDecode(userResponse.body);
        final errorMessage = errorData['message'] ?? errorData['error'] ?? 'Invalid OTP';
        setState(() {
          _statusMessage = errorMessage;
          _statusColor = Colors.red;
        });
        Helpers.showSnackBar(context, errorMessage, bgColor: Colors.red.shade700);
      }
    } catch (e) {
      print('❌ OTP verification error: $e');
      setState(() {
        _statusMessage = 'Error: $e';
        _statusColor = Colors.red;
      });
      Helpers.showSnackBar(context, 'Error: $e', bgColor: Colors.red.shade700);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ==================== FIXED DOCTOR OTP SUCCESS HANDLER =====================
  Future<void> handleDoctorOtpSuccess(http.Response response, String email) async {
    try {
      final responseData = jsonDecode(response.body);
      print('🔍 Full doctor OTP response: $responseData');

      // ✅ FIX: Extract data from the correct structure based on your backend
      final success = responseData['success'] ?? false;
      final message = responseData['message'] ?? '';

      if (!success) {
        Helpers.showSnackBar(context, message, bgColor: Colors.red);
        return;
      }

      // ✅ FIX: Extract from data object (your backend structure)
      final data = responseData['data'] ?? {};
      final token = data['token']?.toString() ?? '';
      final doctor = data['doctor'] ?? {};

      // ✅ FIX: Extract doctor data with proper field names from your backend
      final doctorId = doctor['id']?.toString() ?? doctor['_id']?.toString() ?? '';
      final name = doctor['name']?.toString() ?? 'Doctor';
      final doctorType = doctor['doctorType']?.toString() ?? '';
      final speciality = doctor['speciality']?.toString() ?? '';

      print('🔍 Extracted doctor OTP data:');
      print('  - token: ${token.isNotEmpty ? '✓' : '✗'}');
      print('  - doctorId: $doctorId');
      print('  - name: $name');
      print('  - doctorType: $doctorType');
      print('  - speciality: $speciality');

      // Validate critical data
      if (token.isEmpty) {
        print('❌ Token is empty in doctor OTP response');
        Helpers.showSnackBar(context, "Login failed: No token received", bgColor: Colors.red);
        return;
      }

      if (doctorId.isEmpty) {
        print('❌ Doctor ID is empty');
        Helpers.showSnackBar(context, "Login failed: No doctor ID received", bgColor: Colors.red);
        return;
      }

      // Save doctor data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', token);
      await prefs.setString('userId', doctorId);
      await prefs.setString('doctorId', doctorId);
      await prefs.setString('name', name);
      await prefs.setString('doctorType', doctorType);
      await prefs.setString('speciality', speciality);
      await prefs.setBool('isDoctor', true);
      await prefs.setString('email', email);

      print('✅ Doctor OTP login successful - ALL data saved to SharedPreferences');

      // Verify everything was saved
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
    } catch (e) {
      print('❌ Error processing doctor OTP success: $e');
      Helpers.showSnackBar(context, "Error processing login: $e", bgColor: Colors.red);
    }
  }

  // ==================== FIXED REGULAR USER OTP SUCCESS HANDLER =====================
  Future<void> handleRegularUserOtpSuccess(http.Response response, String email) async {
    try {
      final responseData = jsonDecode(response.body);
      print('🔍 Full regular user OTP response: $responseData');

      // Extract data based on your regular user OTP response structure
      final data = responseData['data'] ?? responseData;
      final token = data['token']?.toString() ?? responseData['token']?.toString() ?? '';

      // Extract user data
      final user = data['user'] ?? data['doctor'] ?? data;
      final userId = user['_id']?.toString() ??
          user['id']?.toString() ??
          data['_id']?.toString() ??
          data['id']?.toString() ?? '';

      final name = user['name']?.toString() ??
          user['fullName']?.toString() ??
          data['name']?.toString() ??
          'User';

      // Extract doctor fields to check if this is actually a doctor
      final doctorType = user['doctorType']?.toString() ??
          data['doctorType']?.toString() ?? '';

      final speciality = user['speciality']?.toString() ??
          data['speciality']?.toString() ?? '';

      print('🔍 Extracted regular user OTP data:');
      print('  - token: ${token.isNotEmpty ? '✓' : '✗'}');
      print('  - userId: $userId');
      print('  - name: $name');
      print('  - doctorType: $doctorType');
      print('  - speciality: $speciality');

      // Validate critical data
      if (token.isEmpty) {
        print('❌ Token is empty in regular user OTP response');
        Helpers.showSnackBar(context, "Token not found", bgColor: Colors.red);
        return;
      }

      // Save user data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('name', name);
      await prefs.setString('email', email);

      // Check if this is a doctor based on the response data
      final isDoctorUser = (doctorType.isNotEmpty && doctorType != 'null') ||
          (speciality.isNotEmpty && speciality != 'null');

      print('🔍 Doctor detection in OTP login:');
      print('  - doctorType found: "$doctorType"');
      print('  - speciality found: "$speciality"');
      print('  - isDoctorUser: $isDoctorUser');

      if (isDoctorUser) {
        // This is a doctor - save doctor data
        await prefs.setBool('isDoctor', true);
        await prefs.setString('doctorId', userId);
        await prefs.setString('doctorType', doctorType);
        await prefs.setString('speciality', speciality);

        print('✅ Doctor detected in OTP login - saving doctor data');
        Helpers.showSnackBar(context, "Welcome Dr. $name! 👨‍⚕️", bgColor: AppColors.primary);
      } else {
        // Regular user
        await prefs.setBool('isDoctor', false);
        await prefs.remove('doctorId');
        await prefs.remove('doctorType');
        await prefs.remove('speciality');

        print('✅ Regular user OTP login');
        Helpers.showSnackBar(context, "Welcome $name! 👋", bgColor: AppColors.primary);
      }

      // Verify everything was saved
      final savedToken = prefs.getString('token');
      final savedUserId = prefs.getString('userId');
      final savedIsDoctor = prefs.getBool('isDoctor');

      print('✅ OTP Login completed:');
      print('  - token: ${savedToken != null ? '✓' : '✗'}');
      print('  - userId: $savedUserId');
      print('  - isDoctor: $savedIsDoctor');

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('❌ Error processing regular user OTP success: $e');
      Helpers.showSnackBar(context, "Error processing login: $e", bgColor: Colors.red);
    }
  }

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
            const SizedBox(height: 8),
            Text(
              "Login with OTP to continue",
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),

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
              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
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
                  ? Text(_expiryText,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500))
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Back to regular login
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back to Password Login",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            if (_statusMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}