// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:open_filex/open_filex.dart';
// // import 'package:intl/intl.dart';
// // import 'message_model.dart';
// // import 'logout_helper.dart';
// // import 'payment_helper.dart';
// // import 'chat_helper.dart';
// // import 'ui_widgets.dart';
// // import 'drawer_items.dart';
// // import '../helper.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   List<Message> messages = [];
// //   TextEditingController m1 = TextEditingController();
// //
// //   final ScrollController _scrollController = ScrollController();
// //   ScrollController get scrollController => _scrollController;  // public getter
// //
// //   bool yesClicked = false;
// //   bool showUploadButton = true;
// //   bool reportUploaded = false;
// //   bool queryAsked = false;
// //   bool paymentDone = false;
// //
// //   String? activeConfirmMessageId;
// //   String? pendingDoctorType;
// //   bool showTypeConfirm = false;
// //
// //   List<String> doctorCategories = [
// //     'MBBS', 'MD', 'Dentist', 'Cardiologist', 'Dermatologist', 'Neurologist',
// //     'Orthopedic', 'ENT Specialist', 'Gynecologist', 'Pediatrician', 'Psychiatrist',
// //     'Oncologist', 'Urologist', 'Gastroenterologist'
// //   ];
// //
// //   String? selectedCategory;
// //   bool showDropdown = false;
// //   bool paymentPrompt = false;
// //
// //   List<String> doctorTypes = ['Allopathy', 'Ayurvedic', 'Homeopathic'];
// //   String? selectedDoctorType;
// //   bool showDoctorTypeOptions = false;
// //
// //   late Razorpay _razorpay;
// //   String? userId;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //     _initializeChat();
// //   }
// //
// //   Future<void> _initializeChat() async {
// //     await _loadUserId();
// //     await fetchChatHistory();
// //     if (messages.isEmpty) {
// //       _addMessage(Message(
// //           text: "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
// //           isBot: true));
// //       _addMessage(Message(
// //           text: "Would you like to receive a second opinion from a specialist?",
// //           isBot: true,
// //           showButtons: true,
// //           isSecondOpinion: true));
// //     }
// //   }
// //
// //   Future<void> _loadUserId() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       userId = prefs.getString("userId") ?? "";
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _razorpay.clear();
// //     _scrollController.dispose();
// //     m1.dispose();
// //     super.dispose();
// //   }
// //
// //   String formatDate(DateTime date) {
// //     return DateFormat('dd MMM yyyy').format(date);
// //   }
// //
// //   bool isSameDay(DateTime d1, DateTime d2) {
// //     return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
// //   }
// //
// //   Future<void> fetchChatHistory() async => await ChatHelpers.fetchChatHistory(this);
// //   Future<void> sendMessage(String sId, String rId, String msg) async => await ChatHelpers.sendMessage(sId, rId, msg);
// //   void _addMessage(Message msg) => ChatHelpers.addMessage(msg, this);
// //   Future<String?> downloadFile(String url, String fileName) async => await ChatHelpers.downloadFile(url, fileName, this);
// //
// //   Future<void> createOrder(int amount, String doctorCategory) async => await PaymentHelper.createOrder(this, amount, doctorCategory);
// //   Future<void> openCheckout(int amount, String doctorCat, String orderId) async => await PaymentHelper.openCheckout(this, amount, doctorCat, orderId);
// //
// //   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async => await PaymentHelper.handlePaymentSuccess(this, response);
// //   void _handlePaymentError(PaymentFailureResponse response) => PaymentHelper.handlePaymentError(this, response);
// //   void _handleExternalWallet(ExternalWalletResponse response) => PaymentHelper.handleExternalWallet(this, response);
// //
// //   bool canUseChat() => ChatHelpers.canUseChat(this);
// //
// //   void sendUserMessage(String userText) {
// //     _addMessage(Message(text: userText, isBot: false));
// //     if (userText.toLowerCase() == "yes") {
// //       _addMessage(Message(text: "Please choose a doctor type:", isBot: true));
// //       setState(() {
// //         showDoctorTypeOptions = true;
// //       });
// //     }
// //   }
// //
// //   void scrollToBottom() {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (_scrollController.hasClients) {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: const Duration(milliseconds: 400),
// //           curve: Curves.easeOut,
// //         );
// //       }
// //     });
// //   }
// //
// //   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) => DrawerItems.drawerItem(title, icon, onTap, this);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         iconTheme: IconThemeData(color: AppColors.iconColor),
// //         backgroundColor: AppColors.primary,
// //         title: const Center(
// //             child: Text("Health Buddy",
// //                 style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold))),
// //         actions: [
// //           IconButton(
// //               onPressed: () {
// //                 Navigator.pushNamed(context, '/profile');
// //               },
// //               icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor))
// //         ],
// //       ),
// //       drawer: DrawerItems.buildDrawer(context),
// //       body: UIWidgets.buildHomePageBody(this, context),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:open_filex/open_filex.dart';
// import 'package:intl/intl.dart';
// import 'helper.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// // Chat message model
// class Message {
//   final String text;
//   final bool isBot;
//   final bool showButtons;
//   final bool isUploadPrompt;
//   final bool isSystem;
//   final String? filePath;
//   final DateTime? createdAt;
//   final bool isSecondOpinion;
//   final String id;
//   final String? type; // NEW: To identify special message types
//
//   Message({
//     required this.text,
//     required this.isBot,
//     this.showButtons = false,
//     this.isUploadPrompt = false,
//     this.isSystem = false,
//     this.filePath,
//     this.createdAt,
//     this.isSecondOpinion = false,
//     this.type, // NEW: For identifying special messages
//     String? id,
//   }) : id = id ?? UniqueKey().toString();
// }
//
// // Logout helper
// Future<void> logoutUser(BuildContext context) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('token');
//
//   if (token == null) {
//     Helpers.showSnackBar(context, "You are not logged in.");
//     return;
//   }
//
//   final url = Uri.parse("${ApiConfig.baseUrl}/logout");
//
//   try {
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       await prefs.clear();
//       Helpers.showSnackBar(context, "Logout successful",
//           bgColor: AppColors.accent);
//       if (context.mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } else {
//       final responseData = jsonDecode(response.body);
//       Helpers.showSnackBar(
//           context, responseData['message'] ?? "Logout failed",
//           bgColor: Colors.red);
//     }
//   } catch (e) {
//     Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.red);
//   }
// }
//
// class _HomePageState extends State<HomePage> {
//   List<Message> messages = [];
//   TextEditingController m1 = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   bool yesClicked = false;
//   bool showUploadButton = false;
//   bool reportUploaded = false;
//   bool queryAsked = false;
//   bool paymentDone = false;
//   bool showTypeConfirm = false;
//   bool showDropdown = false;
//   bool paymentPrompt = false;
//   bool showDoctorTypeOptions = false;
//   bool showSecondOpinionButtons = false;
//   bool hasSubmittedQuery = false; // NEW: Track if user has submitted a query
//
//   String? activeConfirmMessageId;
//   String? pendingDoctorType;
//   String? selectedCategory;
//   String? selectedDoctorType;
//   String? userId;
//
//   List<String> doctorCategories = [
//     'MBBS',
//     'MD',
//     'Dentist',
//     'Cardiologist',
//     'Dermatologist',
//     'Neurologist',
//     'Orthopedic',
//     'ENT Specialist',
//     'Gynecologist',
//     'Pediatrician',
//     'Psychiatrist',
//     'Oncologist',
//     'Urologist',
//     'Gastroenterologist'
//   ];
//
//   List<String> doctorTypes = ['Allopathy', 'Ayurvedic', 'Homeopathic'];
//
//   late Razorpay _razorpay;
//
//   // NEW: Conversation state tracking
//   String _conversationState = "initial"; // initial, doctor_type_selected, payment_done, etc.
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//
//     _initializeChat();
//   }
//
//   Future<void> _initializeChat() async {
//     await _loadUserId();
//     await fetchChatHistory();
//
//     // NEW: Restore conversation state from history
//     _restoreConversationState();
//
//     if (messages.isEmpty) {
//       _addMessage(Message(
//           text:
//           "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
//           isBot: true));
//       _addMessage(Message(
//           text: "Would you like to receive a second opinion from a specialist?",
//           isBot: true,
//           showButtons: true,
//           isSecondOpinion: true,
//           type: "second_opinion_prompt")); // NEW: Add type identifier
//
//       setState(() {
//         showSecondOpinionButtons = true;
//       });
//     }
//   }
//
//   // COMPLETELY REWRITTEN: Proper conversation state restoration
//   void _restoreConversationState() {
//     if (messages.isEmpty) return;
//
//     // Reset all flags first
//     yesClicked = false;
//     showUploadButton = false;
//     reportUploaded = false;
//     queryAsked = false;
//     paymentDone = false;
//     showTypeConfirm = false;
//     showDropdown = false;
//     paymentPrompt = false;
//     showDoctorTypeOptions = false;
//     showSecondOpinionButtons = false;
//     hasSubmittedQuery = false;
//     selectedCategory = null;
//     selectedDoctorType = null;
//     pendingDoctorType = null;
//     activeConfirmMessageId = null;
//
//     // Analyze message history to determine current state
//     bool hasSecondOpinionPrompt = messages.any((msg) => msg.type == "second_opinion_prompt");
//     bool userSaidYes = messages.any((msg) => !msg.isBot && msg.type == "second_opinion_response");
//
//     var doctorTypeSelections = messages.where((msg) => msg.type == "doctor_type_selection").toList();
//     var doctorTypeConfirmations = messages.where((msg) => msg.type == "doctor_type_confirmation").toList();
//     var categorySelections = messages.where((msg) => msg.type == "category_selection").toList();
//     var paymentSuccessMessages = messages.where((msg) => msg.type == "payment_success").toList();
//     var reportUploads = messages.where((msg) => msg.type == "report_upload").toList();
//     var userQueries = messages.where((msg) => !msg.isBot && msg.type == "user_query").toList();
//
//     // Check for pending confirmations
//     var pendingConfirmations = messages.where((msg) =>
//     msg.type == "doctor_type_confirmation_prompt").toList();
//
//     // Determine current conversation state
//     if (!hasSecondOpinionPrompt) {
//       // Fresh start
//       _conversationState = "initial";
//       showSecondOpinionButtons = true;
//     } else if (hasSecondOpinionPrompt && !userSaidYes) {
//       // User hasn't responded to second opinion yet
//       _conversationState = "awaiting_second_opinion";
//       showSecondOpinionButtons = true;
//     } else if (userSaidYes) {
//       yesClicked = true;
//
//       // Check if there's a pending confirmation
//       bool hasPendingConfirmation = false;
//       if (pendingConfirmations.isNotEmpty) {
//         var lastConfirmation = pendingConfirmations.last;
//
//         // Check if this confirmation was responded to
//         bool wasResponded = doctorTypeConfirmations.any((confirmation) {
//           int confirmIndex = messages.indexWhere((msg) => msg.id == lastConfirmation.id);
//           int responseIndex = messages.indexWhere((msg) => msg.id == confirmation.id);
//           return responseIndex > confirmIndex;
//         });
//
//         if (!wasResponded) {
//           hasPendingConfirmation = true;
//           showTypeConfirm = true;
//           activeConfirmMessageId = lastConfirmation.id;
//
//           // Extract doctor type from confirmation message
//           String confirmText = lastConfirmation.text;
//           for (String type in doctorTypes) {
//             if (confirmText.contains(type)) {
//               pendingDoctorType = type;
//               break;
//             }
//           }
//         }
//       }
//
//       if (!hasPendingConfirmation) {
//         if (doctorTypeSelections.isEmpty) {
//           // Need to select doctor type
//           _conversationState = "awaiting_doctor_type";
//           showDoctorTypeOptions = true;
//         } else if (doctorTypeConfirmations.isEmpty) {
//           // Doctor type selected but not confirmed - this shouldn't happen with proper flow
//           _conversationState = "awaiting_doctor_type";
//           showDoctorTypeOptions = true;
//         } else {
//           // Doctor type confirmed
//           var lastConfirmation = doctorTypeConfirmations.last;
//
//           // Extract doctor type from confirmation
//           if (lastConfirmation.text.contains("Allopathy")) {
//             selectedDoctorType = "Allopathy";
//           } else if (lastConfirmation.text.contains("Ayurvedic")) {
//             selectedDoctorType = "Ayurvedic";
//           } else if (lastConfirmation.text.contains("Homeopathic")) {
//             selectedDoctorType = "Homeopathic";
//           }
//
//           if (selectedDoctorType == "Allopathy") {
//             if (categorySelections.isEmpty) {
//               // Need to select category
//               _conversationState = "awaiting_category";
//               showDropdown = true;
//             } else {
//               // Category selected
//               var lastCategory = categorySelections.last;
//               selectedCategory = lastCategory.text.replaceFirst("Selected: ", "");
//
//               if (paymentSuccessMessages.isEmpty) {
//                 // Need payment
//                 _conversationState = "awaiting_payment";
//                 paymentPrompt = true;
//               } else {
//                 // Payment done
//                 paymentDone = true;
//
//                 if (reportUploads.isEmpty) {
//                   // Need to upload reports
//                   _conversationState = "awaiting_reports";
//                   showUploadButton = true;
//                 } else {
//                   // Reports uploaded
//                   reportUploaded = true;
//
//                   if (userQueries.isEmpty) {
//                     // Ready for query
//                     _conversationState = "ready_for_query";
//                   } else {
//                     // Query submitted
//                     hasSubmittedQuery = true;
//                     _conversationState = "query_submitted";
//                   }
//                 }
//               }
//             }
//           } else {
//             // Non-Allopathy doctor type
//             if (paymentSuccessMessages.isEmpty) {
//               // Need payment
//               _conversationState = "awaiting_payment";
//               paymentPrompt = true;
//             } else {
//               // Payment done
//               paymentDone = true;
//
//               if (userQueries.isEmpty) {
//                 // Ready for query
//                 _conversationState = "ready_for_query";
//               } else {
//                 // Query submitted
//                 hasSubmittedQuery = true;
//                 _conversationState = "query_submitted";
//               }
//             }
//           }
//         }
//       }
//     }
//
//     debugPrint("🔄 Restored conversation state: $_conversationState");
//     debugPrint("🔄 Flags - yesClicked: $yesClicked, showDoctorTypeOptions: $showDoctorTypeOptions");
//     debugPrint("🔄 selectedDoctorType: $selectedDoctorType, selectedCategory: $selectedCategory");
//     debugPrint("🔄 paymentDone: $paymentDone, reportUploaded: $reportUploaded");
//     debugPrint("🔄 showTypeConfirm: $showTypeConfirm, hasSubmittedQuery: $hasSubmittedQuery");
//     debugPrint("🔄 showSecondOpinionButtons: $showSecondOpinionButtons, paymentPrompt: $paymentPrompt");
//
//     setState(() {
//       // All state updates are done above, just trigger rebuild
//     });
//   }
//
//   Future<void> _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString("userId") ?? "";
//     });
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   //-----------------------Retrieve Chats---------------------------
//   Future<void> fetchChatHistory() async {
//     if (userId == null) return;
//
//     try {
//       final url = Uri.parse(ApiConfig.getChatHistory(userId!));
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//
//         if (responseData['success'] == true && responseData['data'] != null) {
//           final List data = responseData['data'];
//
//           // Ensure chronological order (oldest first)
//           data.sort((a, b) =>
//               DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt'])));
//
//           messages = data.map((chat) {
//             String msgText = chat['message'] ?? "";
//             bool isBotMsg = false;
//
//             if (msgText.startsWith("Bot:")) {
//               isBotMsg = true;
//               msgText = msgText.replaceFirst("Bot: ", "");
//             } else if (msgText.startsWith("User:")) {
//               isBotMsg = false;
//               msgText = msgText.replaceFirst("User: ", "");
//             } else {
//               isBotMsg = chat['isBot'] ?? false;
//             }
//
//             // Get filePath if present
//             String? filePath;
//             if (chat.containsKey('filePath')) {
//               filePath = chat['filePath'];
//             }
//
//             // NEW: Get message type if present
//             String? type;
//             if (chat.containsKey('type')) {
//               type = chat['type'];
//             }
//
//             return Message(
//               text: msgText,
//               isBot: isBotMsg,
//               createdAt: chat['createdAt'] != null
//                   ? DateTime.parse(chat['createdAt'])
//                   : null,
//               showButtons: chat['showButtons'] ?? false,
//               isUploadPrompt: chat['isUploadPrompt'] ?? false,
//               isSystem: chat['isSystem'] ?? false,
//               filePath: filePath,
//               isSecondOpinion: chat['isSecondOpinion'] ?? false,
//               type: type,
//             );
//           }).toList();
//
//           setState(() {});
//           _scrollToBottom();
//         }
//       } else {
//         debugPrint("❌ Failed to fetch chat history: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching chat history: $e");
//     }
//   }
//
//   // ------------------- Save Chat API -------------------
//   Future<void> sendMessage(
//       String senderId, String receiverId, Message message) async {
//     final url = Uri.parse(ApiConfig.chat);
//
//     final body = {
//       "senderId": senderId,
//       "receiverId": receiverId,
//       "message": message.isBot ? "Bot: ${message.text}" : "User: ${message.text}",
//       "isBot": message.isBot,
//       "showButtons": message.showButtons,
//       "isUploadPrompt": message.isUploadPrompt,
//       "isSystem": message.isSystem,
//       "filePath": message.filePath,
//       "type": message.type,
//       "isSecondOpinion": message.isSecondOpinion,
//     };
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );
//       debugPrint("✅ Response status: ${response.statusCode}");
//     } catch (e) {
//       debugPrint("❌ Error sending message: $e");
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _addMessage(Message msg) async {
//     setState(() {
//       messages.add(msg);
//     });
//
//     _scrollToBottom();
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? senderId = prefs.getString("userId");
//
//     if (senderId == null) {
//       debugPrint("❌ senderId is null, user might not be logged in!");
//       return;
//     }
//
//     String receiverId = "650b2f8a1f3a2b00123abcd4";
//     await sendMessage(senderId, receiverId, msg);
//   }
//
//   // ------------------- Razorpay Integration -------------------
//   Future<void> createOrder(int amount, String doctorCategory) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? storedUserId = prefs.getString('userId');
//
//       if (storedUserId == null || storedUserId.isEmpty) {
//         Helpers.showSnackBar(context, "User ID not found! Please login again.");
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
//           openCheckout(amount, doctorCategory, data['data']['orderId']);
//         } else {
//           Helpers.showSnackBar(context,
//               "Order creation failed: ${data['message'] ?? 'Unknown error'}");
//         }
//       } else {
//         Helpers.showSnackBar(context, "Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Helpers.showSnackBar(context, "Error: $e");
//     }
//   }
//
//   Future<void> openCheckout(
//       int amount, String doctorCategory, String orderId) async {
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
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint("Error opening Razorpay: $e");
//     }
//   }
//
//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
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
//
//         setState(() {
//           paymentDone = true;
//           paymentPrompt = false;
//           _conversationState = "payment_completed";
//         });
//
//         _addMessage(Message(
//             text: "Payment successful and verified.",
//             isBot: true,
//             type: "payment_success"));
//
//         _addMessage(Message(
//             text: "₹200 has been successfully processed.",
//             isBot: false,
//             type: "payment_success"));
//
//         _addMessage(Message(
//             text: "User ID: $storedUserId\nOrder ID: ${response.orderId}",
//             isBot: false,
//             isSystem: true,
//             type: "payment_details"));
//
//         if (selectedDoctorType == "Allopathy" && !reportUploaded) {
//           setState(() {
//             showUploadButton = true;
//             _conversationState = "awaiting_reports";
//           });
//           _addMessage(Message(
//               text: "Kindly upload your medical report to proceed with the consultation.",
//               isBot: true,
//               isUploadPrompt: true,
//               type: "upload_prompt"));
//         } else {
//           _addMessage(
//               Message(text: "You may now type your query for the doctor.", isBot: true));
//           setState(() {
//             queryAsked = false;
//             _conversationState = "ready_for_query";
//           });
//         }
//       } else {
//         Helpers.showSnackBar(context, "Payment verification failed",
//             bgColor: Colors.red);
//       }
//     } catch (e) {
//       debugPrint("Verification error: $e");
//     }
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     _addMessage(Message(
//         text: "Payment could not be completed. Please try again.", isBot: true));
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
//   }
//
//   // ------------------- Chat Logic -------------------
//   void sendUserMessage(String userText, {String? type}) {
//     _addMessage(Message(text: userText, isBot: false, type: type));
//
//     if (userText.toLowerCase() == "yes" && type == "second_opinion_response") {
//       _addMessage(Message(text: "Please choose a doctor type:", isBot: true));
//       setState(() {
//         showDoctorTypeOptions = true;
//         showSecondOpinionButtons = false;
//         yesClicked = true;
//         _conversationState = "awaiting_doctor_type";
//       });
//     }
//   }
//
//   //--------------Download files------------------
//   Future<String?> downloadFile(String url, String fileName) async {
//     try {
//       var response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final dir = await getApplicationDocumentsDirectory();
//         final file = File('${dir.path}/$fileName');
//         await file.writeAsBytes(response.bodyBytes);
//         return file.path;
//       }
//     } catch (e) {
//       debugPrint("❌ Download error: $e");
//     }
//     return null;
//   }
//
//   Widget buildYesNoButtons() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: Row(
//         children: [
//           // ✅ YES button
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 showTypeConfirm = false;
//                 activeConfirmMessageId = null;
//
//                 if (pendingDoctorType == "Allopathy") {
//                   selectedDoctorType = pendingDoctorType;
//                   showDropdown = true;
//                   _conversationState = "awaiting_category";
//                   _addMessage(Message(
//                       text: "Yes, continue with Allopathy.",
//                       isBot: false,
//                       type: "doctor_type_confirmation"));
//                   _addMessage(Message(
//                       text: "Now select the doctor's specialty:",
//                       isBot: true));
//                 } else {
//                   selectedDoctorType = pendingDoctorType;
//                   paymentPrompt = true;
//                   _conversationState = "awaiting_payment";
//                   _addMessage(Message(
//                       text: "Yes, continue with $pendingDoctorType.",
//                       isBot: false,
//                       type: "doctor_type_confirmation"));
//                   _addMessage(Message(
//                       text: "Please complete the payment to confirm the consultation.",
//                       isBot: true));
//                 }
//                 pendingDoctorType = null;
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: AppColors.textLight,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 20, vertical: 12),
//             ),
//             child: const Text("Yes"),
//           ),
//
//           const SizedBox(width: 10),
//
//           // ❌ NO button
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 showTypeConfirm = false;
//                 activeConfirmMessageId = null;
//                 selectedDoctorType = null;
//                 pendingDoctorType = null;
//                 showDoctorTypeOptions = true;
//                 _conversationState = "awaiting_doctor_type";
//               });
//               _addMessage(Message(
//                   text: "No, I don't want this option.", isBot: false));
//               _addMessage(Message(
//                   text: "Please choose another doctor type:", isBot: true));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.background,
//               foregroundColor: AppColors.textDark,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 20, vertical: 12),
//             ),
//             child: const Text("No"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Format date like "09 Sep 2025"
//   String formatDate(DateTime date) {
//     return DateFormat('dd MMM yyyy').format(date);
//   }
//
//   // Check if two dates are on the same day
//   bool isSameDay(DateTime d1, DateTime d2) {
//     return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
//   }
//
//   // FIXED: Proper button display logic based on conversation state
//   Widget buildMessageBubble(Message msg) {
//     final isBot = msg.isBot;
//     final isLastMessage = messages.isNotEmpty && msg == messages.last;
//
//     return Column(
//       crossAxisAlignment:
//       isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//       children: [
//         Align(
//           alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
//           child: GestureDetector(
//             onTap: () async {
//               if (msg.filePath != null) {
//                 String path = msg.filePath!;
//                 if (path.startsWith('http')) {
//                   // Download remote file first
//                   path = await downloadFile(path, path.split('/').last) ?? '';
//                 }
//                 if (path.isNotEmpty) {
//                   final result = await OpenFilex.open(path);
//                   debugPrint("📂 Opened file: ${result.message}");
//                 }
//               }
//             },
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//               padding: const EdgeInsets.all(12),
//               constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.75),
//               decoration: BoxDecoration(
//                 color: msg.filePath != null
//                     ? Colors.white
//                     : (isBot ? AppColors.chatBot : AppColors.chatUser),
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(16),
//                   topRight: const Radius.circular(16),
//                   bottomLeft: isBot
//                       ? const Radius.circular(0)
//                       : const Radius.circular(16),
//                   bottomRight: isBot
//                       ? const Radius.circular(16)
//                       : const Radius.circular(0),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (msg.filePath != null) ...[
//                     const SizedBox(width: 6),
//                   ],
//                   Flexible(
//                     child: Text(
//                       msg.text,
//                       style: TextStyle(
//                         color: isBot ? AppColors.chatBotText : AppColors.chatUserText,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         // Timestamp
//         if (msg.createdAt != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
//             child: Text(
//               DateFormat('hh:mm a').format(msg.createdAt!.toLocal()),
//               style: const TextStyle(color: Colors.grey, fontSize: 10),
//             ),
//           ),
//
//         // FIXED: Show buttons based on current conversation state, not just message type
//         if (msg.type == "second_opinion_prompt" && showSecondOpinionButtons)
//           buildYesButtonOnly(),
//
//         if (msg.type == "doctor_type_confirmation_prompt" &&
//             showTypeConfirm &&
//             msg.id == activeConfirmMessageId)
//           buildYesNoButtons(),
//
//         if (msg.isUploadPrompt && showUploadButton && !reportUploaded)
//           buildUploadReportButton(),
//
//         // Show interactive elements only for the last message and when appropriate
//         if (isLastMessage) ...[
//           if (showDoctorTypeOptions && !showTypeConfirm)
//             buildDoctorTypeOptions(),
//
//           if (showDropdown && !showTypeConfirm)
//             buildCategoryDropdown(),
//
//           if (paymentPrompt && !showTypeConfirm)
//             buildPaymentButton(),
//         ]
//       ],
//     );
//   }
//
//   Widget buildYesButtonOnly() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: ElevatedButton(
//         onPressed: () {
//           setState(() {
//             yesClicked = true;
//             showSecondOpinionButtons = false;
//           });
//           sendUserMessage("Yes", type: "second_opinion_response");
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: AppColors.textLight,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         ),
//         child: const Text("Yes"),
//       ),
//     );
//   }
//
//   Widget buildDoctorTypeOptions() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: AppColors.chatBot,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         width: double.infinity,
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             hint: const Text(
//               "Please choose a doctor type",
//               style: TextStyle(color: AppColors.buttonText),
//             ),
//             dropdownColor: AppColors.chatBot,
//             value: null, // Always show as unselected to allow re-selection
//             isExpanded: true,
//             items: doctorTypes.map((String type) {
//               return DropdownMenuItem<String>(
//                 value: type,
//                 child: Text(type, style: const TextStyle(color: Colors.black)),
//               );
//             }).toList(),
//             onChanged: (String? value) {
//               if (value != null) {
//                 // Add user selection message
//                 _addMessage(Message(
//                     text: "Selected: $value",
//                     isBot: false,
//                     type: "doctor_type_selection"));
//
//                 // Create the confirmation message
//                 final confirmMsg = Message(
//                   text: "You selected $value. Do you want to continue?",
//                   isBot: true,
//                   showButtons: true,
//                   isSecondOpinion: false,
//                   type: "doctor_type_confirmation_prompt",
//                 );
//
//                 // Add message first
//                 _addMessage(confirmMsg);
//
//                 // Update state with new confirmation
//                 setState(() {
//                   pendingDoctorType = value;
//                   showDoctorTypeOptions = false;
//                   showTypeConfirm = true;
//                   activeConfirmMessageId = confirmMsg.id;
//                 });
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildCategoryDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: DropdownButton<String>(
//         value: null, // Always show as unselected to allow re-selection
//         hint: const Text("Select Category"),
//         isExpanded: true,
//         menuMaxHeight: 200,
//         items: doctorCategories.map((String category) {
//           return DropdownMenuItem<String>(
//             value: category,
//             child: Text(category),
//           );
//         }).toList(),
//         onChanged: (String? value) {
//           if (value != null) {
//             setState(() {
//               selectedCategory = value;
//               showDropdown = false;
//               paymentPrompt = true;
//               _conversationState = "awaiting_payment";
//             });
//
//             _addMessage(Message(
//                 text: "Selected: $value",
//                 isBot: false,
//                 type: "category_selection"));
//             _addMessage(Message(
//                 text: "Please complete the payment to confirm the consultation.",
//                 isBot: true));
//           }
//         },
//       ),
//     );
//   }
//
//   Widget buildPaymentButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 4),
//       child: ElevatedButton.icon(
//         onPressed: () {
//           String doctorCategory = selectedDoctorType == "Allopathy"
//               ? selectedCategory ?? "General"
//               : selectedDoctorType!;
//           createOrder(200, doctorCategory);
//         },
//         icon: Icon(Icons.payment, color: AppColors.iconColor),
//         label: Text("Pay ₹200", style: TextStyle(color: AppColors.buttonText)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.buttonSecondary,
//         ),
//       ),
//     );
//   }
//
//   Widget buildUploadReportButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 4),
//       child: ElevatedButton.icon(
//         onPressed: () async {
//           final result = await Navigator.pushNamed(context, '/upload');
//
//           if (result is Map && result['status'] == 'uploaded') {
//             List reports = result['reports'];
//
//             setState(() {
//               reportUploaded = true;
//               showUploadButton = false;
//               _conversationState = "reports_uploaded";
//             });
//
//             _addMessage(Message(
//                 text: "✅ Your reports have been successfully uploaded.",
//                 isBot: true));
//
//             for (var r in reports) {
//               _addMessage(Message(
//                 text: "📄 ${r['category']} - ${r['fileName']}",
//                 isBot: false,
//                 filePath: r['filePath'],
//                 type: "report_upload",
//               ));
//             }
//
//             _addMessage(Message(
//                 text: "You may now type your query for the doctor. Note: You can only submit one query.",
//                 isBot: true));
//             _conversationState = "ready_for_query";
//           }
//         },
//         icon: Icon(Icons.upload_file, color: AppColors.iconColor),
//         label: Text("Upload Report",
//             style: TextStyle(color: AppColors.iconColor)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.buttonSecondary,
//         ),
//       ),
//     );
//   }
//
//   // UPDATED: Chat availability logic with query limit
//   bool canUseChat() {
//     // For Allopathy: Can chat only after reports are uploaded and haven't submitted query yet
//     if (selectedDoctorType == "Allopathy") {
//       return (_conversationState == "ready_for_query" || _conversationState == "reports_uploaded")
//           && !hasSubmittedQuery;
//     }
//
//     // For other doctor types: Can chat after payment and haven't submitted query yet
//     return (_conversationState == "ready_for_query" || _conversationState == "payment_completed")
//         && !hasSubmittedQuery;
//   }
//
//   String getChatHintText() {
//     if (hasSubmittedQuery) {
//       return "You have already submitted your query. Please wait for doctor's response.";
//     }
//
//     if (!canUseChat()) {
//       return "Complete required steps to chat";
//     }
//
//     return "Type your query here (You can only submit one query)";
//   }
//
//   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 25, color: AppColors.iconColor),
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(title,
//             style: const TextStyle(
//                 fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   // IntroCard Widget
//   Widget buildIntroCard() {
//     return Container(
//       margin: const EdgeInsets.all(14),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.primary, width: 1.2),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.08),
//             blurRadius: 12,
//             offset: Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.medical_services, color: AppColors.primary, size: 28),
//               const SizedBox(width: 10),
//               Text(
//                 "Health Buddy",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "Get expert medical advice from the comfort of your home.\nOur experienced doctors are ready to help you confidently at every step.",
//             style: TextStyle(
//               fontSize: 15.5,
//               color: Colors.grey[800],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Icon(Icons.verified_user, color: AppColors.accent, size: 20),
//               const SizedBox(width: 5),
//               Text(
//                 "Trusted | Secure | Confidential",
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     letterSpacing: 0.1,
//                     color: AppColors.primary),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           Text(
//             "How it works:",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Step 1
//           _buildStep(
//             stepNumber: 1,
//             icon: Icons.person_search,
//             label: "Choose your doctor type and specialty",
//           ),
//           const SizedBox(height: 5),
//           // Step 2
//           _buildStep(
//             stepNumber: 2,
//             icon: Icons.payment,
//             label: "Make a secure online payment",
//           ),
//           const SizedBox(height: 5),
//           // Step 3
//           _buildStep(
//             stepNumber: 3,
//             icon: Icons.message_outlined,
//             label: " upload reports , Chat & get advice",
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStep({
//     required int stepNumber,
//     required IconData icon,
//     required String label,
//   }) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 13,
//           backgroundColor: AppColors.primary,
//           child: Text(
//             "$stepNumber",
//             style: TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Icon(icon, size: 18, color: AppColors.accent),
//         const SizedBox(width: 7),
//         Expanded(
//           child: Text(
//             label,
//             style: TextStyle(fontSize: 13.5, color: Colors.grey[800]),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppColors.iconColor),
//         backgroundColor: AppColors.primary,
//         title: const Center(
//             child: Text("Health Buddy",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold))),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//               icon:
//               Icon(Icons.person_outline_sharp, color: AppColors.iconColor))
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: AppColors.primary,
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 30),
//
//               // 🔹 Company Logo / Avatar Section
//               Center(
//                 child: Column(
//                   children: [
//                     const CircleAvatar(
//                       radius: 40,
//                       backgroundImage: AssetImage("assets/images/logo.png"),
//                       backgroundColor: Colors.white,
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "HealthBuddy",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Text(
//                       "info@healthbuddy.com",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
//
//               // 🔹 Drawer Menu Items
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     drawerItem("Home", Icons.home, () {
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home');
//                     }),
//                     drawerItem("Doctor", Icons.add, () {
//                       Navigator.pushNamed(context, '/doctors');
//                     }),
//                     drawerItem("Orders", Icons.file_copy_sharp, () {
//                       Navigator.pushNamed(context, '/orders');
//                     }),
//                     drawerItem("Terms & Privacy", Icons.privacy_tip, () {
//                       Navigator.pushNamed(context, '/terms');
//                     }),
//                     drawerItem("LogOut", Icons.logout_sharp, () async {
//                       bool? confirm = await showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Confirm Logout'),
//                           content: const Text('Are you sure you want to logout?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, false),
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, true),
//                               child: const Text('Logout'),
//                             ),
//                           ],
//                         ),
//                       );
//                       if (confirm == true) {
//                         await logoutUser(context);
//                       }
//                     }),
//                   ],
//                 ),
//               ),
//
//               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
//
//               // 🔹 Footer
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 80),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Text(
//                         "Made With",
//                         style: TextStyle(color: AppColors.textLight, fontSize: 12),
//                       ),
//                       SizedBox(width: 5),
//                       Icon(Icons.favorite, color: AppColors.textLight, size: 14),
//                       SizedBox(width: 5),
//                       Text(
//                         "By VSGLogic",
//                         style: TextStyle(color: AppColors.textLight, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               itemCount: messages.length + 1, // +1 for the intro card at the top
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   // First item is the intro card
//                   return buildIntroCard();
//                 }
//                 final msg = messages[index - 1];
//                 // Determine if date separator should be shown
//                 bool showDate = false;
//                 if (index == 1) {
//                   showDate = true;
//                 } else {
//                   final prevMsg = messages[index - 2];
//                   if (msg.createdAt != null && prevMsg.createdAt != null) {
//                     showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
//                   }
//                 }
//                 return Column(
//                   children: [
//                     // Date separator
//                     if (showDate && msg.createdAt != null)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             formatDate(msg.createdAt!),
//                             style: const TextStyle(
//                                 fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight),
//                           ),
//                         ),
//                       ),
//                     // Actual message bubble
//                     buildMessageBubble(msg),
//                   ],
//                 );
//               },
//             ),
//           ),
//           SafeArea(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               color: AppColors.primary,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: canUseChat() ? Colors.white : Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(21),
//                       ),
//                       child: TextField(
//                         controller: m1,
//                         enabled: canUseChat(),
//                         keyboardType: TextInputType.multiline,
//                         textInputAction: TextInputAction.newline,
//                         minLines: 1,
//                         maxLines: 4,
//                         decoration: InputDecoration(
//                           hintText: getChatHintText(),
//                           border: InputBorder.none,
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                         ),
//                         onChanged: (text) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             _scrollToBottom();
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: canUseChat()
//                         ? () {
//                       if (m1.text.trim().isNotEmpty) {
//                         sendUserMessage(m1.text.trim(), type: "user_query");
//                         m1.clear();
//                         setState(() {
//                           hasSubmittedQuery = true;
//                           queryAsked = true;
//                           _conversationState = "query_submitted";
//                         });
//                         _addMessage(Message(
//                             text:
//                             "Your query has been submitted to the doctor. Please wait for their response.",
//                             isBot: true));
//                       }
//                     }
//                         : null,
//                     child: Icon(Icons.send,
//                         color:
//                         canUseChat() ? AppColors.iconColor : Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }//rzp_test_vDQGr1D5EBRubo