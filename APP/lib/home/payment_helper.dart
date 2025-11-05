// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:flutter/material.dart';
// import '../helper.dart';
// import 'message_model.dart';
//
// class PaymentHelper {
//   static Future<void> createOrder(dynamic state, int amount, String doctorCategory) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? storedUserId = prefs.getString('userId');
//
//       if (storedUserId == null || storedUserId.isEmpty) {
//         Helpers.showSnackBar(state.context, "User ID not found! Please login again.");
//         return;
//       }
//
//       var response = await http.post(
//         Uri.parse(ApiConfig.orders),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"amount": amount, "UserId": storedUserId}),
//       );
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['success'] == true &&
//             data['data'] != null &&
//             data['data']['orderId'] != null) {
//           openCheckout(state, amount, doctorCategory, data['data']['orderId']);
//         } else {
//           Helpers.showSnackBar(state.context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
//         }
//       } else {
//         Helpers.showSnackBar(state.context, "Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Helpers.showSnackBar(state.context, "Error: $e");
//     }
//   }
//
//   static Future<void> openCheckout(dynamic state, int amount, String doctorCategory, String orderId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userPhone = prefs.getString('phone') ?? '';
//     String userEmail = prefs.getString('email') ?? '';
//
//     var options = {
//       'key': 'rzp_test_vDQGr1D5EBRubo',
//       'amount': amount * 100,
//       'name': 'Health Buddy',
//       'description': 'Consultation Fee - $doctorCategory',
//       'order_id': orderId,
//       'prefill': {'contact': userPhone, 'email': userEmail},
//       'external': {'wallets': ['paytm']}
//     };
//
//     try {
//       state._razorpay.open(options);
//     } catch (e) {
//       debugPrint("Error opening Razorpay: $e");
//     }
//   }
//
//   static Future<void> handlePaymentSuccess(dynamic state, PaymentSuccessResponse response) async {
//     try {
//       var verifyResponse = await http.post(
//         Uri.parse("${ApiConfig.baseUrl}/verify-payment"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "razorpay_order_id": response.orderId,
//           "razorpay_payment_id": response.paymentId,
//           "razorpay_signature": response.signature,
//         }),
//       );
//
//       var verifyData = jsonDecode(verifyResponse.body);
//
//       if (verifyData['success'] == true) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String storedUserId = prefs.getString('userId') ?? "Unknown";
//         state.setState(() {
//           state.paymentDone = true;
//           state.paymentPrompt = false;
//         });
//
//         state._addMessage(Message(text: "Payment successful and verified.", isBot: true));
//         state._addMessage(Message(text: "₹200 has been successfully processed.", isBot: false));
//         state._addMessage(Message(text: "User ID: $storedUserId\nOrder ID: ${response.orderId}", isBot: false, isSystem: true));
//
//         if (state.selectedDoctorType == "Allopathy" && !state.reportUploaded) {
//           state._addMessage(Message(text: "Kindly upload your medical report to proceed with the consultation.", isBot: true, isUploadPrompt: true));
//         } else {
//           state._addMessage(Message(text: "You may now type your query for the doctor.", isBot: true));
//           state.queryAsked = false;
//         }
//       } else {
//         Helpers.showSnackBar(state.context, "Payment verification failed", bgColor: Colors.red);
//       }
//     } catch (e) {
//       debugPrint("Verification error: $e");
//     }
//   }
//
//   static void handlePaymentError(dynamic state, PaymentFailureResponse response) {
//     state._addMessage(Message(text: "Payment could not be completed. Please try again.", isBot: true));
//   }
//
//   static void handleExternalWallet(dynamic state, ExternalWalletResponse response) {
//     Helpers.showSnackBar(state.context, "Wallet selected: ${response.walletName}");
//   }
// }
