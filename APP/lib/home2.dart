//
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:open_filex/open_filex.dart';
// // import 'package:intl/intl.dart';
// // import 'helper.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // // Chat message model
// // class Message {
// //   final String text;
// //   final bool isBot;
// //   final bool showButtons;
// //   final bool isUploadPrompt;
// //   final bool isSystem;
// //   final String? filePath; // ⬅️ add this
// //   final DateTime? createdAt; // ⬅️ Add this
// //   final bool isSecondOpinion; // <-- NEW
// //   final String id;
// //
// //
// //   Message({
// //     required this.text,
// //     required this.isBot,
// //     this.showButtons = false,
// //     this.isUploadPrompt = false,
// //     this.isSystem = false,
// //     this.filePath,
// //     this.createdAt,
// //     this.isSecondOpinion = false, // <-- default false so old calls still work
// //     String? id,
// //   }) : id = id ?? UniqueKey().toString(); // auto-generate if not passed
// //
// // }
// //
// // // Logout helper
// // Future<void> logoutUser(BuildContext context) async {
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   final token = prefs.getString('token');
// //
// //   if (token == null) {
// //     Helpers.showSnackBar(context, "You are not logged in.");
// //     return;
// //   }
// //
// //   final url = Uri.parse("${ApiConfig.baseUrl}/logout");
// //
// //   try {
// //     final response = await http.post(
// //       url,
// //       headers: {
// //         'Content-Type': 'application/json',
// //         'Authorization': 'Bearer $token',
// //       },
// //     );
// //
// //     if (response.statusCode == 200) {
// //       await prefs.clear();
// //       Helpers.showSnackBar(context, "Logout successful",
// //           bgColor: AppColors.accent);
// //       if (context.mounted) {
// //         Navigator.pushReplacementNamed(context, '/login');
// //       }
// //     } else {
// //       final responseData = jsonDecode(response.body);
// //       Helpers.showSnackBar(
// //           context, responseData['message'] ?? "Logout failed",
// //           bgColor: Colors.red);
// //     }
// //   } catch (e) {
// //     Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.red);
// //   }
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   List<Message> messages = [];
// //   TextEditingController m1 = TextEditingController();
// //   final ScrollController _scrollController = ScrollController(); // ⬅️ new
// //
// //   bool yesClicked = false;
// //   bool showUploadButton = true;
// //   bool reportUploaded = false;
// //   bool queryAsked = false;
// //   bool paymentDone = false;
// //
// //   String? activeConfirmMessageId;
// //
// //
// //
// //   // Format date like "09 Sep 2025"
// //   String formatDate(DateTime date) {
// //     return DateFormat('dd MMM yyyy').format(date);
// //   }
// //
// //   String? pendingDoctorType; // store selected type before confirmation
// //   bool showTypeConfirm = false;
// //
// //
// // // Check if two dates are on the same day
// //   bool isSameDay(DateTime d1, DateTime d2) {
// //     return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
// //   }
// //
// //
// //   List<String> doctorCategories = [
// //     'MBBS',
// //     'MD',
// //     'Dentist',
// //     'Cardiologist',
// //     'Dermatologist',
// //     'Neurologist',
// //     'Orthopedic',
// //     'ENT Specialist',
// //     'Gynecologist',
// //     'Pediatrician',
// //     'Psychiatrist',
// //     'Oncologist',
// //     'Urologist',
// //     'Gastroenterologist'
// //   ];
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
// //
// //     _initializeChat();
// //   }
// //
// //   Future<void> _initializeChat() async {
// //     await _loadUserId(); // ✅ wait until userId is loaded
// //     await fetchChatHistory(); // ✅ now fetch
// //     if (messages.isEmpty) {
// //       _addMessage(Message(
// //           text:
// //           "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
// //           isBot: true));
// //       _addMessage(Message(
// //           text: "Would you like to receive a second opinion from a specialist?",
// //           isBot: true,
// //           showButtons: true,
// //           isSecondOpinion: true));
// //     }
// //   }
// //
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
// //     _scrollController.dispose(); // cleanup
// //     super.dispose();
// //   }
// //   //-----------------------Retrive Chats---------------------------
// //   Future<void> fetchChatHistory() async {
// //     if (userId == null) return;
// //
// //     try {
// //       final url = Uri.parse(ApiConfig.getChatHistory(userId!));
// //       final response = await http.get(url);
// //
// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //
// //         if (responseData['success'] == true && responseData['data'] != null) {
// //           final List data = responseData['data'];
// //
// //           // Ensure chronological order (oldest first)
// //           data.sort((a, b) =>
// //               DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt'])));
// //
// //           messages = data.map((chat) {
// //             String msgText = chat['message'] ?? "";
// //             bool isBotMsg = false;
// //
// //             if (msgText.startsWith("Bot:")) {
// //               isBotMsg = true;
// //               msgText = msgText.replaceFirst("Bot: ", "");
// //             } else if (msgText.startsWith("User:")) {
// //               isBotMsg = false;
// //               msgText = msgText.replaceFirst("User: ", "");
// //             } else {
// //               isBotMsg = chat['isBot'] ?? false;
// //             }
// //
// //             // Get filePath if present
// //             String? filePath;
// //             if (chat.containsKey('filePath')) {
// //               filePath = chat['filePath']; // URL or local path
// //             }
// //
// //             return Message(
// //               text: msgText,
// //               isBot: isBotMsg,
// //               createdAt: chat['createdAt'] != null
// //                   ? DateTime.parse(chat['createdAt'])
// //                   : null,
// //               showButtons: false,
// //               isUploadPrompt: false,
// //               isSystem: false,
// //               filePath: filePath,
// //             );
// //           }).toList();
// //
// //           setState(() {});
// //           _scrollToBottom();
// //         }
// //       } else {
// //         debugPrint("❌ Failed to fetch chat history: ${response.body}");
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Error fetching chat history: $e");
// //     }
// //   }
// //
// //
// //
// //   // ------------------- Save Chat API -------------------
// //   Future<void> sendMessage(
// //       String senderId, String receiverId, String message) async {
// //     final url = Uri.parse(ApiConfig.chat);
// //
// //     final body = {
// //       "senderId": senderId,
// //       "receiverId": receiverId,
// //       "message": message,
// //     };
// //
// //     try {
// //       final response = await http.post(
// //         url,
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode(body),
// //       );
// //       debugPrint("✅ Response status: ${response.statusCode}");
// //     } catch (e) {
// //       debugPrint("❌ Error sending message: $e");
// //     }
// //   }
// //
// //   void _scrollToBottom() {
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
// //   void _addMessage(Message msg) async {
// //     setState(() {
// //       messages.add(msg);
// //     });
// //
// //     _scrollToBottom(); // ⬅️ scroll after new message
// //
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? senderId = prefs.getString("userId");
// //
// //     if (senderId == null) {
// //       debugPrint("❌ senderId is null, user might not be logged in!");
// //       return;
// //     }
// //
// //     String receiverId = "650b2f8a1f3a2b00123abcd4";
// //     String prefixedMessage =
// //     msg.isBot ? "Bot: ${msg.text}" : "User: ${msg.text}";
// //     await sendMessage(senderId, receiverId, prefixedMessage);
// //   }
// //
// //   // ------------------- Razorpay Integration -------------------
// //   Future<void> createOrder(int amount, String doctorCategory) async {
// //     try {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       String? storedUserId = prefs.getString('userId');
// //
// //       if (storedUserId == null || storedUserId.isEmpty) {
// //         Helpers.showSnackBar(context, "User ID not found! Please login again.");
// //         return;
// //       }
// //
// //       var response = await http.post(
// //         Uri.parse(ApiConfig.orders),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({"amount": amount, "UserId": storedUserId}),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(response.body);
// //         if (data['success'] == true &&
// //             data['data'] != null &&
// //             data['data']['orderId'] != null) {
// //           openCheckout(amount, doctorCategory, data['data']['orderId']);
// //         } else {
// //           Helpers.showSnackBar(context,
// //               "Order creation failed: ${data['message'] ?? 'Unknown error'}");
// //         }
// //       } else {
// //         Helpers.showSnackBar(context, "Error: ${response.statusCode}");
// //       }
// //     } catch (e) {
// //       Helpers.showSnackBar(context, "Error: $e");
// //     }
// //   }
// //
// //   Future<void> openCheckout(
// //       int amount, String doctorCategory, String orderId) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String userPhone = prefs.getString('phone') ?? '';
// //     String userEmail = prefs.getString('email') ?? '';
// //
// //     var options = {
// //       'key': 'rzp_test_vDQGr1D5EBRubo',
// //       'amount': amount * 100,
// //       'name': 'Health Buddy',
// //       'description': 'Consultation Fee - $doctorCategory',
// //       'order_id': orderId,
// //       'prefill': {'contact': userPhone, 'email': userEmail},
// //       'external': {'wallets': ['paytm']}
// //     };
// //
// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint("Error opening Razorpay: $e");
// //     }
// //   }
// //
// //   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
// //     try {
// //       var verifyResponse = await http.post(
// //         Uri.parse("${ApiConfig.baseUrl}/verify-payment"),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "razorpay_order_id": response.orderId,
// //           "razorpay_payment_id": response.paymentId,
// //           "razorpay_signature": response.signature,
// //         }),
// //       );
// //
// //       var verifyData = jsonDecode(verifyResponse.body);
// //
// //       if (verifyData['success'] == true) {
// //         SharedPreferences prefs = await SharedPreferences.getInstance();
// //         String storedUserId = prefs.getString('userId') ?? "Unknown";
// //
// //         setState(() {
// //           paymentDone = true;
// //           paymentPrompt = false;
// //         });
// //
// //         _addMessage(
// //             Message(text: "Payment successful and verified.", isBot: true));
// //         _addMessage(
// //             Message(text: "₹200 has been successfully processed.", isBot: false));
// //         _addMessage(Message(
// //             text: "User ID: $storedUserId\nOrder ID: ${response.orderId}",
// //             isBot: false,
// //             isSystem: true));
// //
// //         if (selectedDoctorType == "Allopathy" && !reportUploaded) {
// //           _addMessage(Message(
// //               text:
// //               "Kindly upload your medical report to proceed with the consultation.",
// //               isBot: true,
// //               isUploadPrompt: true));
// //         } else {
// //           _addMessage(
// //               Message(text: "You may now type your query for the doctor.", isBot: true));
// //           queryAsked = false;
// //         }
// //       } else {
// //         Helpers.showSnackBar(context, "Payment verification failed",
// //             bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       debugPrint("Verification error: $e");
// //     }
// //   }
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     _addMessage(Message(
// //         text: "Payment could not be completed. Please try again.", isBot: true));
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
// //   }
// //
// //   // ------------------- Chat Logic -------------------
// //   void sendUserMessage(String userText) {
// //     _addMessage(Message(text: userText, isBot: false));
// //
// //     if (userText.toLowerCase() == "yes") {
// //       _addMessage(Message(text: "Please choose a doctor type:", isBot: true));
// //       setState(() {
// //         showDoctorTypeOptions = true;
// //       });
// //     }
// //   }
// //
// //
// //   //--------------Download files------------------
// //   Future<String?> downloadFile(String url, String fileName) async {
// //     try {
// //       var response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final dir = await getApplicationDocumentsDirectory();
// //         final file = File('${dir.path}/$fileName');
// //         await file.writeAsBytes(response.bodyBytes);
// //         return file.path;
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Download error: $e");
// //     }
// //     return null;
// //   }
// //
// //   Widget buildYesNoButtons() {
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12),
// //       child: Row(
// //         children: [
// //           // ✅ YES button
// //           ElevatedButton(
// //             onPressed: () {
// //               setState(() {
// //                 showTypeConfirm = false;
// //
// //                 if (pendingDoctorType == "Allopathy") {
// //                   showDropdown = true;
// //                   _addMessage(Message(
// //                       text: "Yes, continue with Allopathy.", isBot: false));
// //                   _addMessage(Message(
// //                       text: "Now select the doctor's specialty:", isBot: true));
// //                 } else {
// //                   paymentPrompt = true;
// //                   _addMessage(Message(
// //                       text: "Yes, continue with $pendingDoctorType.",
// //                       isBot: false));
// //                   _addMessage(Message(
// //                       text: "Please complete the payment to confirm the consultation.",
// //                       isBot: true));
// //                 }
// //               });
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primary,       // ✅ YES button color
// //               foregroundColor: AppColors.textLight,       // ✅ YES text color
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12), // ✅ rounded corners
// //               ),
// //               padding: const EdgeInsets.symmetric(
// //                   horizontal: 20, vertical: 12), // ✅ bigger button
// //             ),
// //             child: const Text("Yes"),
// //           ),
// //
// //           const SizedBox(width: 10),
// //
// //           // ❌ NO button
// //           ElevatedButton(
// //             onPressed: () {
// //               setState(() {
// //                 showTypeConfirm = false;
// //                 selectedDoctorType = null;
// //                 pendingDoctorType = null;
// //                 showDoctorTypeOptions = true; // ask again
// //               });
// //               _addMessage(Message(
// //                   text: "No, I don’t want this option.", isBot: false));
// //               _addMessage(Message(
// //                   text: "Please choose another doctor type:", isBot: true));
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.background,         // ✅ NO button color
// //               foregroundColor: AppColors.textDark,       // ✅ NO text color
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding: const EdgeInsets.symmetric(
// //                   horizontal: 20, vertical: 12), // ✅ bigger button
// //             ),
// //             child: const Text("No"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //
// //   // UI Bubbles
// //   Widget buildMessageBubble(Message msg) {
// //     final isBot = msg.isBot;
// //
// //     return Column(
// //       crossAxisAlignment:
// //       isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
// //       children: [
// //         Align(
// //           alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
// //           child: GestureDetector(
// //             onTap: () async {
// //               if (msg.filePath != null) {
// //                 String path = msg.filePath!;
// //                 if (path.startsWith('http')) {
// //                   // Download remote file first
// //                   path = await downloadFile(path, path.split('/').last) ?? '';
// //                 }
// //                 if (path.isNotEmpty) {
// //                   final result = await OpenFilex.open(path);
// //                   debugPrint("📂 Opened file: ${result.message}");
// //                 }
// //               }
// //             },
// //             child: Container(
// //               margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //               padding: const EdgeInsets.all(12),
// //               constraints: BoxConstraints(
// //                   maxWidth: MediaQuery.of(context).size.width * 0.75),
// //               decoration: BoxDecoration(
// //                 color: msg.filePath != null
// //                     ? Colors.white // highlight uploaded files
// //                     : (isBot ? AppColors.chatBot : AppColors.chatUser),
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: const Radius.circular(16),
// //                   topRight: const Radius.circular(16),
// //                   bottomLeft: isBot
// //                       ? const Radius.circular(0)
// //                       : const Radius.circular(16),
// //                   bottomRight: isBot
// //                       ? const Radius.circular(16)
// //                       : const Radius.circular(0),
// //                 ),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   if (msg.filePath != null) ...[
// //                     const SizedBox(width: 6),
// //                   ],
// //                   Flexible(
// //                     child: Text(
// //                       msg.text,
// //                       style: TextStyle(
// //                         color: isBot ? AppColors.chatBotText : AppColors.chatUserText,
// //                         fontSize: 15,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //
// //
// //         // Timestamp
// //         if (msg.createdAt != null)
// //           Padding(
// //             padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
// //             child: Text(
// //               DateFormat('hh:mm a').format(msg.createdAt!.toLocal()), // e.g., 03:45 PM
// //               style: const TextStyle(color: Colors.grey, fontSize: 10),
// //             ),
// //           ),
// //
// //
// //         // Conditional widgets
// //         // show single-Yes only for second-opinion message
// //         if (msg.showButtons && msg.isSecondOpinion && !showTypeConfirm) buildYesButtonOnly(),
// //
// // // show Yes/No only for the doctor-type confirmation (not second-opinion)
// //         if (msg.showButtons &&
// //             showTypeConfirm &&
// //             !msg.isSecondOpinion &&
// //             msg.id == activeConfirmMessageId) buildYesNoButtons(),
// //
// //         if (msg.isUploadPrompt) buildUploadReportButton(),
// //         if (showDoctorTypeOptions && msg == messages.last) buildDoctorTypeOptions(),
// //         if (showDropdown && msg == messages.last) buildCategoryDropdown(),
// //         if (paymentPrompt && msg == messages.last) buildPaymentButton(),
// //       ],
// //     );
// //   }
// //
// //
// //   Widget buildYesButtonOnly() {
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12),
// //       child: yesClicked
// //           ? const SizedBox()
// //           : ElevatedButton(
// //         onPressed: () {
// //           setState(() {
// //             yesClicked = true;
// //           });
// //           sendUserMessage("Yes");
// //         },
// //         style: ElevatedButton.styleFrom(
// //           foregroundColor: AppColors.buttonText,
// //         ),
// //         child: const Text("Yes"),
// //       ),
// //     );
// //   }
// //
// //   Widget buildDoctorTypeOptions() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //         decoration: BoxDecoration(
// //           color: AppColors.chatBot,
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         width: double.infinity,
// //         child: DropdownButtonHideUnderline(
// //           child: DropdownButton<String>(
// //             hint: const Text(
// //               "Please choose a doctor type",
// //               style: TextStyle(color: AppColors.buttonText),
// //             ),
// //             dropdownColor: AppColors.chatBot,
// //             value: selectedDoctorType,
// //             isExpanded: true,
// //             items: doctorTypes.map((String type) {
// //               return DropdownMenuItem<String>(
// //                 value: type,
// //                 child: Text(type, style: const TextStyle(color: Colors.black)),
// //               );
// //             }).toList(),
// //             onChanged: (String? value) {
// //               if (value != null) {
// //                 // ✅ Create the confirmation message
// //                 final confirmMsg = Message(
// //                   text: "You selected $value. Do you want to continue?",
// //                   isBot: true,
// //                   showButtons: true,
// //                   isSecondOpinion: false,
// //                 );
// //
// //                 // ✅ Add message first
// //                 _addMessage(confirmMsg);
// //
// //                 // ✅ Update state with new confirmation
// //                 setState(() {
// //                   selectedDoctorType = value;
// //                   pendingDoctorType = value;
// //                   showDoctorTypeOptions = false;
// //                   showTypeConfirm = true;
// //                   activeConfirmMessageId = confirmMsg.id; // 🔥 only this one gets Yes/No
// //                 });
// //               }
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// //   Widget buildCategoryDropdown() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       child: DropdownButton<String>(
// //         value: selectedCategory,
// //         hint: const Text("Select Category"),
// //         isExpanded: true,
// //         menuMaxHeight: 200,
// //         items: doctorCategories.map((String category) {
// //           return DropdownMenuItem<String>(
// //             value: category,
// //             child: Text(category),
// //           );
// //         }).toList(),
// //         onChanged: (String? value) {
// //           if (value != null) {
// //             setState(() {
// //               selectedCategory = value;
// //               showDropdown = false;
// //               paymentPrompt = true;
// //
// //               _addMessage(Message(text: "Selected: $value", isBot: false));
// //               _addMessage(Message(
// //                   text: "Please complete the payment to confirm the consultation.",
// //                   isBot: true));
// //             });
// //           }
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget buildPaymentButton() {
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12, top: 4),
// //       child: ElevatedButton.icon(
// //         onPressed: () {
// //           String doctorCategory = selectedDoctorType == "Allopathy"
// //               ? selectedCategory ?? "General"
// //               : selectedDoctorType!;
// //           createOrder(200, doctorCategory);
// //         },
// //         icon: Icon(Icons.payment, color: AppColors.iconColor),
// //         label: Text("Pay ₹200", style: TextStyle(color: AppColors.buttonText)),
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: AppColors.buttonSecondary,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget buildUploadReportButton() {
// //     if (!showUploadButton || reportUploaded) return const SizedBox();
// //
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12, top: 4),
// //       child: ElevatedButton.icon(
// //         onPressed: () async {
// //           final result = await Navigator.pushNamed(context, '/upload');
// //
// //           if (result is Map && result['status'] == 'uploaded') {
// //             List reports = result['reports'];
// //
// //             setState(() {
// //               reportUploaded = true;
// //               showUploadButton = false;
// //             });
// //
// //             _addMessage(Message(
// //                 text: "✅ Your reports have been successfully uploaded.",
// //                 isBot: true));
// //
// //             for (var r in reports) {
// //               _addMessage(Message(
// //                 text: "📄 ${r['category']} - ${r['fileName']}",
// //                 isBot: false,
// //                 filePath: r['filePath'],
// //               ));
// //             }
// //
// //             _addMessage(Message(
// //                 text: "You may now type your query for the doctor.",
// //                 isBot: true));
// //           }
// //         },
// //         icon: Icon(Icons.upload_file, color: AppColors.iconColor),
// //         label: Text("Upload Report",
// //             style: TextStyle(color: AppColors.iconColor)),
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: AppColors.buttonSecondary,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   bool canUseChat() {
// //     if (selectedDoctorType == null) return false;
// //
// //     if (selectedDoctorType == "Allopathy") {
// //       return reportUploaded && !queryAsked;
// //     }
// //
// //     if (selectedDoctorType == "Ayurvedic" ||
// //         selectedDoctorType == "Homeopathic") {
// //       return paymentDone && !queryAsked;
// //     }
// //
// //     return false;
// //   }
// //
// //   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
// //     return ListTile(
// //       leading: Icon(icon, size: 25, color: AppColors.iconColor),
// //       title: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Text(title,
// //             style: const TextStyle(
// //                 fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //       ),
// //       onTap: onTap,
// //     );
// //   }
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
// //               icon:
// //               Icon(Icons.person_outline_sharp, color: AppColors.iconColor))
// //         ],
// //       ),
// //       drawer: Drawer(
// //         backgroundColor: AppColors.primary,
// //         child: SafeArea(   // ✅ Keeps content inside safe boundaries
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               const SizedBox(height: 30),
// //
// //               // 🔹 Company Logo / Avatar Section
// //               Center(
// //                 child: Column(
// //                   children: [
// //                     const CircleAvatar(
// //                       radius: 40,
// //                       backgroundImage: AssetImage("assets/images/logo.png"), // replace with your logo
// //                       backgroundColor: Colors.white,
// //                     ),
// //                     const SizedBox(height: 10),
// //                     const Text(
// //                       "HealthBuddy",
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const Text(
// //                       "info@healthbuddy.com",
// //                       style: TextStyle(
// //                         color: Colors.white70,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 20),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //
// //               // 🔹 Drawer Menu Items
// //               Expanded(
// //                 child: ListView(
// //                   padding: EdgeInsets.zero,
// //                   children: [
// //                     drawerItem("Home", Icons.home, () {
// //                       Navigator.pop(context);
// //                       Navigator.pushNamed(context, '/home');
// //                     }),
// //                     drawerItem("Doctor", Icons.add, () {
// //                       Navigator.pushNamed(context, '/doctors');
// //                     }),
// //                     drawerItem("Orders", Icons.file_copy_sharp, () {
// //                       Navigator.pushNamed(context, '/orders');
// //                     }),
// //                     drawerItem("Terms & Privacy", Icons.privacy_tip, () {
// //                       Navigator.pushNamed(context, '/terms');
// //                     }),
// //                     drawerItem("LogOut", Icons.logout_sharp, () async {
// //                       bool? confirm = await showDialog(
// //                         context: context,
// //                         builder: (context) => AlertDialog(
// //                           title: const Text('Confirm Logout'),
// //                           content: const Text('Are you sure you want to logout?'),
// //                           actions: [
// //                             TextButton(
// //                               onPressed: () => Navigator.pop(context, false),
// //                               child: const Text('Cancel'),
// //                             ),
// //                             TextButton(
// //                               onPressed: () => Navigator.pop(context, true),
// //                               child: const Text('Logout'),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                       if (confirm == true) {
// //                         await logoutUser(context);
// //                       }
// //                     }),
// //                   ],
// //                 ),
// //               ),
// //
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //
// //               // 🔹 Footer
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 80),
// //                 child: Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: const [
// //                       Text(
// //                         "Made With",
// //                         style: TextStyle(color: AppColors.textLight, fontSize: 12),
// //                       ),
// //                       SizedBox(width: 5),
// //                       Icon(Icons.favorite, color: AppColors.textLight, size: 14),
// //                       SizedBox(width: 5),
// //                       Text(
// //                         "By VSGLogic",
// //                         style: TextStyle(color: AppColors.textLight, fontSize: 12),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               controller: _scrollController,
// //               padding: const EdgeInsets.symmetric(vertical: 10),
// //               itemCount: messages.length,
// //               itemBuilder: (context, index) {
// //                 final msg = messages[index];
// //
// //                 // Determine if date separator should be shown
// //                 bool showDate = false;
// //                 if (index == 0) {
// //                   showDate = true; // first message always shows date
// //                 } else {
// //                   final prevMsg = messages[index - 1];
// //                   if (msg.createdAt != null && prevMsg.createdAt != null) {
// //                     showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
// //                   }
// //                 }
// //
// //                 return Column(
// //                   children: [
// //                     // Date separator
// //                     if (showDate && msg.createdAt != null)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         child: Container(
// //                           padding:
// //                           const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             color: AppColors.primary,
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Text(
// //                             formatDate(msg.createdAt!),
// //                             style: const TextStyle(
// //                                 fontSize: 12, fontWeight: FontWeight.bold,color: AppColors.textLight),
// //                           ),
// //                         ),
// //                       ),
// //                     // Actual message bubble
// //                     buildMessageBubble(msg),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //
// //           SafeArea(
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //               color: AppColors.primary,
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: canUseChat() ? Colors.white : Colors.grey.shade300,
// //                         borderRadius: BorderRadius.circular(21),
// //                       ),
// //                       child: TextField(
// //                         controller: m1,
// //                         enabled: canUseChat(),
// //                         keyboardType: TextInputType.multiline,
// //                         textInputAction: TextInputAction.newline,
// //                         minLines: 1,  // starts with 1 line
// //                         maxLines: 4,  // grows up to 5 lines, adjust as needed
// //                         decoration: InputDecoration(
// //                           hintText: canUseChat()
// //                               ? "Type your message here"
// //                               : "Complete required steps to chat",
// //                           border: InputBorder.none,
// //                           isDense: true, // remove extra padding
// //                           contentPadding: const EdgeInsets.symmetric(vertical: 10),
// //                         ),
// //                         onChanged: (text) {
// //                           // Optional: scroll to bottom as user types
// //                           WidgetsBinding.instance.addPostFrameCallback((_) {
// //                             _scrollToBottom();
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //
// //                   const SizedBox(width: 8),
// //                   GestureDetector(
// //                     onTap: canUseChat()
// //                         ? () {
// //                       if (m1.text.trim().isNotEmpty) {
// //                         sendUserMessage(m1.text.trim());
// //                         m1.clear();
// //                         setState(() {
// //                           queryAsked = true;
// //                           reportUploaded = false;
// //                         });
// //                         _addMessage(Message(
// //                             text:
// //                             "Your query has been submitted to the doctor. Please wait for their response.",
// //                             isBot: true));
// //                       }
// //                     }
// //                         : null,
// //                     child: Icon(Icons.send,
// //                         color:
// //                         canUseChat() ? AppColors.iconColor : Colors.grey),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // //rzp_test_vDQGr1D5EBRubo
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
// //
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:open_filex/open_filex.dart';
// // import 'package:intl/intl.dart';
// // import 'helper.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // // Chat message model
// // class Message {
// //   final String text;
// //   final bool isBot;
// //   final bool showButtons;
// //   final bool isUploadPrompt;
// //   final bool isSystem;
// //   final String? filePath;
// //   final DateTime? createdAt;
// //   final bool isSecondOpinion;
// //   final String id;
// //
// //   Message({
// //     required this.text,
// //     required this.isBot,
// //     this.showButtons = false,
// //     this.isUploadPrompt = false,
// //     this.isSystem = false,
// //     this.filePath,
// //     this.createdAt,
// //     this.isSecondOpinion = false,
// //     String? id,
// //   }) : id = id ?? UniqueKey().toString();
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'text': text,
// //       'isBot': isBot,
// //       'showButtons': showButtons,
// //       'isUploadPrompt': isUploadPrompt,
// //       'isSystem': isSystem,
// //       'filePath': filePath,
// //       'createdAt': createdAt?.toIso8601String(),
// //       'isSecondOpinion': isSecondOpinion,
// //       'id': id,
// //     };
// //   }
// //
// //   factory Message.fromMap(Map<String, dynamic> map) {
// //     return Message(
// //       text: map['text'] ?? '',
// //       isBot: map['isBot'] ?? false,
// //       showButtons: map['showButtons'] ?? false,
// //       isUploadPrompt: map['isUploadPrompt'] ?? false,
// //       isSystem: map['isSystem'] ?? false,
// //       filePath: map['filePath'],
// //       createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
// //       isSecondOpinion: map['isSecondOpinion'] ?? false,
// //       id: map['id'],
// //     );
// //   }
// // }
// //
// // Future<void> logoutUser(BuildContext context) async {
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   final token = prefs.getString('token');
// //   if (token == null) {
// //     Helpers.showSnackBar(context, "You are not logged in.");
// //     return;
// //   }
// //   final url = Uri.parse("${ApiConfig.baseUrl}/logout");
// //   try {
// //     final response = await http.post(
// //       url,
// //       headers: {
// //         'Content-Type': 'application/json',
// //         'Authorization': 'Bearer $token',
// //       },
// //     );
// //     if (response.statusCode == 200) {
// //       await prefs.clear();
// //       Helpers.showSnackBar(context, "Logout successful",
// //           bgColor: AppColors.accent);
// //       if (context.mounted) {
// //         Navigator.pushReplacementNamed(context, '/login');
// //       }
// //     } else {
// //       final responseData = jsonDecode(response.body);
// //       Helpers.showSnackBar(
// //           context, responseData['message'] ?? "Logout failed",
// //           bgColor: Colors.red);
// //     }
// //   } catch (e) {
// //     Helpers.showSnackBar(context, "Error: $e", bgColor: Colors.red);
// //   }
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   List<Message> messages = [];
// //   TextEditingController m1 = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //
// //   // Persisted state variables
// //   bool yesClicked = false;
// //   bool showUploadButton = true;
// //   bool reportUploaded = false;
// //   bool queryAsked = false;
// //   bool paymentDone = false;
// //   String? activeConfirmMessageId;
// //   String? pendingDoctorType;
// //   bool showTypeConfirm = false;
// //
// //   List<String> doctorCategories = [
// //     'MBBS',
// //     'MD',
// //     'Dentist',
// //     'Cardiologist',
// //     'Dermatologist',
// //     'Neurologist',
// //     'Orthopedic',
// //     'ENT Specialist',
// //     'Gynecologist',
// //     'Pediatrician',
// //     'Psychiatrist',
// //     'Oncologist',
// //     'Urologist',
// //     'Gastroenterologist'
// //   ];
// //   String? selectedCategory;
// //   bool showDropdown = false;
// //   bool paymentPrompt = false;
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
// //
// //     _initializeChat();
// //   }
// //
// //   Future<void> _initializeChat() async {
// //     await _loadUserId();
// //     await _restoreButtonState();
// //     await fetchChatHistory();
// //
// //     // If no messages from server and also no locally saved messages,
// //     // or messages got deleted in database, restarts chat flow with initial prompts.
// //     if ((messages.isEmpty) && (!yesClicked)) {
// //       _addMessage(Message(
// //           text:
// //           "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
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
// //   Future<void> _saveChatToPrefs() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<String> encodedMessages = messages.map((msg) => jsonEncode(msg.toMap())).toList();
// //     await prefs.setStringList('chatMessages', encodedMessages);
// //   }
// //
// //   Future<void> _restoreChatFromPrefs() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<String>? encodedMessages = prefs.getStringList('chatMessages');
// //     if (encodedMessages != null && encodedMessages.isNotEmpty) {
// //       messages = encodedMessages.map((msgStr) {
// //         Map<String, dynamic> map = jsonDecode(msgStr);
// //         return Message.fromMap(map);
// //       }).toList();
// //       setState(() {});
// //       _scrollToBottom();
// //     }
// //   }
// //
// //   Future<void> _restoreButtonState() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       yesClicked = prefs.getBool("yesClicked") ?? false;
// //       showUploadButton = prefs.getBool("showUploadButton") ?? true;
// //       reportUploaded = prefs.getBool("reportUploaded") ?? false;
// //       queryAsked = prefs.getBool("queryAsked") ?? false;
// //       paymentDone = prefs.getBool("paymentDone") ?? false;
// //       showTypeConfirm = prefs.getBool("showTypeConfirm") ?? false;
// //       showDropdown = prefs.getBool("showDropdown") ?? false;
// //       paymentPrompt = prefs.getBool("paymentPrompt") ?? false;
// //       showDoctorTypeOptions = prefs.getBool("showDoctorTypeOptions") ?? false;
// //       selectedCategory = prefs.getString("selectedCategory");
// //       selectedDoctorType = prefs.getString("selectedDoctorType");
// //       pendingDoctorType = prefs.getString("pendingDoctorType");
// //       activeConfirmMessageId = prefs.getString("activeConfirmMessageId");
// //     });
// //
// //     await _restoreChatFromPrefs();
// //   }
// //
// //   Future<void> _saveButtonState() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool("yesClicked", yesClicked);
// //     await prefs.setBool("showUploadButton", showUploadButton);
// //     await prefs.setBool("reportUploaded", reportUploaded);
// //     await prefs.setBool("queryAsked", queryAsked);
// //     await prefs.setBool("paymentDone", paymentDone);
// //     await prefs.setBool("showTypeConfirm", showTypeConfirm);
// //     await prefs.setBool("showDropdown", showDropdown);
// //     await prefs.setBool("paymentPrompt", paymentPrompt);
// //     await prefs.setBool("showDoctorTypeOptions", showDoctorTypeOptions);
// //     if (selectedCategory != null) {
// //       await prefs.setString("selectedCategory", selectedCategory!);
// //     }
// //     if (selectedDoctorType != null) {
// //       await prefs.setString("selectedDoctorType", selectedDoctorType!);
// //     }
// //     if (pendingDoctorType != null) {
// //       await prefs.setString("pendingDoctorType", pendingDoctorType!);
// //     }
// //     if (activeConfirmMessageId != null) {
// //       await prefs.setString("activeConfirmMessageId", activeConfirmMessageId!);
// //     }
// //
// //     await _saveChatToPrefs();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _razorpay.clear();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> fetchChatHistory() async {
// //     if (userId == null || userId!.isEmpty) return;
// //     try {
// //       final url = Uri.parse(ApiConfig.getChatHistory(userId!));
// //       final response = await http.get(url);
// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         if (responseData['success'] == true && responseData['data'] != null) {
// //           final List data = responseData['data'];
// //           if (data.isEmpty) {
// //             // Server chat is empty: reset local chat and states
// //             await _resetChatFlowAfterDeletion();
// //             return; // quit here, flow restarted
// //           }
// //           data.sort((a, b) =>
// //               DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt'])));
// //           messages = data.map((chat) {
// //             String msgText = chat['message'] ?? "";
// //             bool isBotMsg = false;
// //             if (msgText.startsWith("Bot:")) {
// //               isBotMsg = true;
// //               msgText = msgText.replaceFirst("Bot: ", "");
// //             } else if (msgText.startsWith("User:")) {
// //               isBotMsg = false;
// //               msgText = msgText.replaceFirst("User: ", "");
// //             } else {
// //               isBotMsg = chat['isBot'] ?? false;
// //             }
// //             String? filePath;
// //             if (chat.containsKey('filePath')) {
// //               filePath = chat['filePath'];
// //             }
// //             return Message(
// //               text: msgText,
// //               isBot: isBotMsg,
// //               createdAt: chat['createdAt'] != null
// //                   ? DateTime.parse(chat['createdAt'])
// //                   : null,
// //               showButtons: false,
// //               isUploadPrompt: false,
// //               isSystem: false,
// //               filePath: filePath,
// //             );
// //           }).toList();
// //           setState(() {});
// //           _scrollToBottom();
// //           await _saveChatToPrefs();
// //         }
// //       } else {
// //         debugPrint("❌ Failed to fetch chat history: ${response.body}");
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Error fetching chat history: $e");
// //     }
// //   }
// //
// // // New method to reset chat flow after DB deletion
// //   Future<void> _resetChatFlowAfterDeletion() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     await prefs.remove('chatMessages'); // clear local chat store
// //     setState(() {
// //       messages.clear(); // clear current chat
// //       yesClicked = false;
// //       showUploadButton = true;
// //       reportUploaded = false;
// //       queryAsked = false;
// //       paymentDone = false;
// //       paymentPrompt = false;
// //       selectedDoctorType = null;
// //       selectedCategory = null;
// //       pendingDoctorType = null;
// //       showDropdown = false;
// //       showDoctorTypeOptions = false;
// //       showTypeConfirm = false;
// //       activeConfirmMessageId = null;
// //     });
// //     await _saveButtonState();
// //
// //     // Add initial messages for fresh start
// //     _addMessage(Message(
// //         text: "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
// //         isBot: true));
// //     _addMessage(Message(
// //         text: "Would you like to receive a second opinion from a specialist?",
// //         isBot: true,
// //         showButtons: true,
// //         isSecondOpinion: true));
// //   }
// //
// //
// //   Future<void> sendMessage(
// //       String senderId, String receiverId, String message) async {
// //     final url = Uri.parse(ApiConfig.chat);
// //     final body = {
// //       "senderId": senderId,
// //       "receiverId": receiverId,
// //       "message": message,
// //     };
// //     try {
// //       final response = await http.post(
// //         url,
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode(body),
// //       );
// //       debugPrint("✅ Response status: ${response.statusCode}");
// //     } catch (e) {
// //       debugPrint("❌ Error sending message: $e");
// //     }
// //   }
// //
// //   void _scrollToBottom() {
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
// //   void _addMessage(Message msg) async {
// //     setState(() {
// //       messages.add(msg);
// //     });
// //     _scrollToBottom();
// //     await _saveChatToPrefs();
// //
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? senderId = prefs.getString("userId");
// //     if (senderId == null) {
// //       debugPrint("❌ senderId is null, user might not be logged in!");
// //       return;
// //     }
// //     String receiverId = "650b2f8a1f3a2b00123abcd4";
// //     String prefixedMessage = msg.isBot ? "Bot: ${msg.text}" : "User: ${msg.text}";
// //     await sendMessage(senderId, receiverId, prefixedMessage);
// //   }
// //
// //   Future<void> createOrder(int amount, String doctorCategory) async {
// //     try {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       String? storedUserId = prefs.getString('userId');
// //       if (storedUserId == null || storedUserId.isEmpty) {
// //         Helpers.showSnackBar(context, "User ID not found! Please login again.");
// //         return;
// //       }
// //       var response = await http.post(
// //         Uri.parse(ApiConfig.orders),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({"amount": amount, "UserId": storedUserId}),
// //       );
// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(response.body);
// //         if (data['success'] == true &&
// //             data['data'] != null &&
// //             data['data']['orderId'] != null) {
// //           openCheckout(amount, doctorCategory, data['data']['orderId']);
// //         } else {
// //           Helpers.showSnackBar(context,
// //               "Order creation failed: ${data['message'] ?? 'Unknown error'}");
// //         }
// //       } else {
// //         Helpers.showSnackBar(context, "Error: ${response.statusCode}");
// //       }
// //     } catch (e) {
// //       Helpers.showSnackBar(context, "Error: $e");
// //     }
// //   }
// //
// //   Future<void> openCheckout(
// //       int amount, String doctorCategory, String orderId) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String userPhone = prefs.getString('phone') ?? '';
// //     String userEmail = prefs.getString('email') ?? '';
// //     var options = {
// //       'key': 'rzp_test_vDQGr1D5EBRubo',
// //       'amount': amount * 100,
// //       'name': 'Health Buddy',
// //       'description': 'Consultation Fee - $doctorCategory',
// //       'order_id': orderId,
// //       'prefill': {'contact': userPhone, 'email': userEmail},
// //       'external': {'wallets': ['paytm']}
// //     };
// //     try {
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint("Error opening Razorpay: $e");
// //     }
// //   }
// //
// //   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
// //     try {
// //       var verifyResponse = await http.post(
// //         Uri.parse("${ApiConfig.baseUrl}/verify-payment"),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "razorpay_order_id": response.orderId,
// //           "razorpay_payment_id": response.paymentId,
// //           "razorpay_signature": response.signature,
// //         }),
// //       );
// //       var verifyData = jsonDecode(verifyResponse.body);
// //       if (verifyData['success'] == true) {
// //         SharedPreferences prefs = await SharedPreferences.getInstance();
// //         String storedUserId = prefs.getString('userId') ?? "Unknown";
// //
// //         // After payment verification inside handlePaymentSuccess:
// //         // Retrieve last order number count, default 0
// //         int currentOrderCount = prefs.getInt('orderCount') ?? 0;
// //         currentOrderCount++; // Increment order number
// //         // Save updated count
// //         await prefs.setInt('orderCount', currentOrderCount);
// //         // Format order no string
// //         String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');
// //
// //         if (selectedDoctorType == "Allopathy" && !reportUploaded) {
// //           setState(() {
// //             paymentDone = true;
// //             paymentPrompt = false;
// //             showUploadButton = true;
// //             reportUploaded = false;
// //           });
// //           await _saveButtonState();
// //           _addMessage(Message(
// //               text: "Payment successful and verified.", isBot: true));
// //           _addMessage(Message(
// //               text: "₹200 has been successfully processed.", isBot: false));
// //           _addMessage(Message(
// //               text: "Order No: $displayOrderNo",
// //               isBot: false,
// //               isSystem: true));
// //           _addMessage(Message(
// //               text: "Kindly upload your medical report to proceed with the consultation.",
// //               isBot: true,
// //               isUploadPrompt: true));
// //         } else {
// //           setState(() {
// //             paymentDone = true;
// //             paymentPrompt = false;
// //           });
// //           await _saveButtonState();
// //           _addMessage(Message(
// //               text: "Payment successful and verified.", isBot: true));
// //           _addMessage(Message(
// //               text: "₹200 has been successfully processed.", isBot: false));
// //           _addMessage(Message(
// //               text: "Order No: $displayOrderNo",
// //               isBot: false,
// //               isSystem: true));
// //           _addMessage(Message(
// //               text: "You may now type your query for the doctor.", isBot: true));
// //           queryAsked = false;
// //           await _saveButtonState();
// //         }
// //       } else {
// //         Helpers.showSnackBar(context, "Payment verification failed",
// //             bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       debugPrint("Verification error: $e");
// //     }
// //   }
// //
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     _addMessage(Message(
// //         text: "Payment could not be completed. Please try again.", isBot: true));
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
// //   }
// //
// //   void sendUserMessage(String userText) {
// //     _addMessage(Message(text: userText, isBot: false));
// //     if (userText.toLowerCase() == "yes") {
// //       _addMessage(Message(text: "Please choose a doctor type:", isBot: true));
// //       setState(() {
// //         showDoctorTypeOptions = true;
// //       });
// //       _saveButtonState();
// //     }
// //   }
// //
// //   Future<String?> downloadFile(String url, String fileName) async {
// //     try {
// //       var response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final dir = await getApplicationDocumentsDirectory();
// //         final file = File('${dir.path}/$fileName');
// //         await file.writeAsBytes(response.bodyBytes);
// //         return file.path;
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Download error: $e");
// //     }
// //     return null;
// //   }
// //
// //   Widget buildYesNoButtons() {
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12),
// //       child: Row(
// //         children: [
// //           ElevatedButton(
// //             onPressed: () async {
// //               setState(() {
// //                 showTypeConfirm = false;
// //                 if (pendingDoctorType == "Allopathy") {
// //                   showDropdown = true;
// //                   _addMessage(
// //                       Message(text: "Yes, continue with Allopathy.", isBot: false));
// //                   _addMessage(
// //                       Message(text: "Now select the doctor's specialty:", isBot: true));
// //                 } else {
// //                   paymentPrompt = true;
// //                   _addMessage(
// //                       Message(text: "Yes, continue with $pendingDoctorType.", isBot: false));
// //                   _addMessage(Message(
// //                       text: "Please complete the payment to confirm the consultation.",
// //                       isBot: true));
// //                 }
// //               });
// //               await _saveButtonState();
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primary,
// //               foregroundColor: AppColors.textLight,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding:
// //               const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //             ),
// //             child: const Text("Yes"),
// //           ),
// //           const SizedBox(width: 10),
// //           ElevatedButton(
// //             onPressed: () async {
// //               setState(() {
// //                 showTypeConfirm = false;
// //                 selectedDoctorType = null;
// //                 pendingDoctorType = null;
// //                 showDoctorTypeOptions = true;
// //               });
// //               _addMessage(
// //                   Message(text: "No, I don’t want this option.", isBot: false));
// //               _addMessage(Message(
// //                   text: "Please choose another doctor type:", isBot: true));
// //               await _saveButtonState();
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.background,
// //               foregroundColor: AppColors.textDark,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding:
// //               const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //             ),
// //             child: const Text("No"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget buildMessageBubble(Message msg) {
// //     final isBot = msg.isBot;
// //     return Column(
// //       crossAxisAlignment:
// //       isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
// //       children: [
// //         Align(
// //           alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
// //           child: GestureDetector(
// //             onTap: () async {
// //               if (msg.filePath != null) {
// //                 String path = msg.filePath!;
// //                 if (path.startsWith('http')) {
// //                   path = await downloadFile(path, path.split('/').last) ?? '';
// //                 }
// //                 if (path.isNotEmpty) {
// //                   final result = await OpenFilex.open(path);
// //                   debugPrint("📂 Opened file: ${result.message}");
// //                 }
// //               }
// //             },
// //             child: Container(
// //               margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //               padding: const EdgeInsets.all(12),
// //               constraints: BoxConstraints(
// //                   maxWidth: MediaQuery.of(context).size.width * 0.75),
// //               decoration: BoxDecoration(
// //                 color: msg.filePath != null
// //                     ? Colors.white
// //                     : (isBot ? AppColors.chatBot : AppColors.chatUser),
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: const Radius.circular(16),
// //                   topRight: const Radius.circular(16),
// //                   bottomLeft:
// //                   isBot ? const Radius.circular(0) : const Radius.circular(16),
// //                   bottomRight:
// //                   isBot ? const Radius.circular(16) : const Radius.circular(0),
// //                 ),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   if (msg.filePath != null) ...[
// //                     const SizedBox(width: 6),
// //                   ],
// //                   Flexible(
// //                     child: Text(
// //                       msg.text,
// //                       style: TextStyle(
// //                         color: isBot ? AppColors.chatBotText : AppColors.chatUserText,
// //                         fontSize: 15,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         if (msg.createdAt != null)
// //           Padding(
// //             padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
// //             child: Text(
// //               DateFormat('hh:mm a').format(msg.createdAt!.toLocal()),
// //               style: const TextStyle(color: Colors.grey, fontSize: 10),
// //             ),
// //           ),
// //         if (msg.showButtons && msg.isSecondOpinion && !showTypeConfirm)
// //           buildYesButtonOnly(),
// //         if (msg.showButtons &&
// //             showTypeConfirm &&
// //             !msg.isSecondOpinion &&
// //             msg.id == activeConfirmMessageId)
// //           buildYesNoButtons(),
// //         if (msg.isUploadPrompt) buildUploadReportButton(),
// //         if (showDoctorTypeOptions && msg == messages.last) buildDoctorTypeOptions(),
// //         if (showDropdown && msg == messages.last) buildCategoryDropdown(),
// //         if (paymentPrompt && msg == messages.last) buildPaymentButton(),
// //       ],
// //     );
// //   }
// //
// //   Widget buildYesButtonOnly() {
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12),
// //       child: yesClicked
// //           ? const SizedBox()
// //           : ElevatedButton(
// //         onPressed: () async {
// //           setState(() {
// //             yesClicked = true;
// //           });
// //           sendUserMessage("Yes");
// //           await _saveButtonState();
// //         },
// //         style: ElevatedButton.styleFrom(
// //           foregroundColor: AppColors.buttonText,
// //         ),
// //         child: const Text("Yes"),
// //       ),
// //     );
// //   }
// //
// //   Widget buildDoctorTypeOptions() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //         decoration: BoxDecoration(
// //           color: AppColors.chatBot,
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         width: double.infinity,
// //         child: DropdownButtonHideUnderline(
// //           child: DropdownButton<String>(
// //             hint: const Text(
// //               "Please choose a doctor type",
// //               style: TextStyle(color: AppColors.buttonText),
// //             ),
// //             dropdownColor: AppColors.chatBot,
// //             value: selectedDoctorType,
// //             isExpanded: true,
// //             items: doctorTypes.map((String type) {
// //               return DropdownMenuItem<String>(
// //                 value: type,
// //                 child: Text(type, style: const TextStyle(color: Colors.black)),
// //               );
// //             }).toList(),
// //             onChanged: (String? value) async {
// //               if (value != null) {
// //                 final confirmMsg = Message(
// //                   text: "You selected $value. Do you want to continue?",
// //                   isBot: true,
// //                   showButtons: true,
// //                   isSecondOpinion: false,
// //                 );
// //                 _addMessage(confirmMsg);
// //                 setState(() {
// //                   selectedDoctorType = value;
// //                   pendingDoctorType = value;
// //                   showDoctorTypeOptions = false;
// //                   showTypeConfirm = true;
// //                   activeConfirmMessageId = confirmMsg.id;
// //                 });
// //                 await _saveButtonState();
// //               }
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget buildCategoryDropdown() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       child: DropdownButton<String>(
// //         value: selectedCategory,
// //         hint: const Text("Select Category"),
// //         isExpanded: true,
// //         menuMaxHeight: 200,
// //         items: doctorCategories.map((String category) {
// //           return DropdownMenuItem<String>(
// //             value: category,
// //             child: Text(category),
// //           );
// //         }).toList(),
// //         onChanged: (String? value) async {
// //           if (value != null) {
// //             setState(() {
// //               selectedCategory = value;
// //               showDropdown = false;
// //               paymentPrompt = true;
// //               _addMessage(Message(text: "Selected: $value", isBot: false));
// //               _addMessage(Message(
// //                   text: "Please complete the payment to confirm the consultation.",
// //                   isBot: true));
// //             });
// //             await _saveButtonState();
// //           }
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget buildPaymentButton() {
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12, top: 4),
// //       child: ElevatedButton.icon(
// //         onPressed: () {
// //           String doctorCategory = selectedDoctorType == "Allopathy"
// //               ? selectedCategory ?? "General"
// //               : selectedDoctorType!;
// //           createOrder(200, doctorCategory);
// //         },
// //         icon: Icon(Icons.payment, color: AppColors.iconColor),
// //         label: Text("Pay ₹200", style: TextStyle(color: AppColors.buttonText)),
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: AppColors.buttonSecondary,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget buildUploadReportButton() {
// //     if (!showUploadButton || reportUploaded) return const SizedBox();
// //
// //     return Padding(
// //       padding: const EdgeInsets.only(left: 12, top: 4),
// //       child: ElevatedButton.icon(
// //         onPressed: () async {
// //           final result = await Navigator.pushNamed(context, '/upload');
// //
// //           if (result is Map && result['status'] == 'uploaded') {
// //             List reports = result['reports'];
// //
// //             setState(() {
// //               reportUploaded = true;
// //               showUploadButton = false;
// //             });
// //             await _saveButtonState();
// //
// //             _addMessage(Message(
// //                 text: "✅ Your reports have been successfully uploaded.",
// //                 isBot: true));
// //
// //             for (var r in reports) {
// //               _addMessage(Message(
// //                 text: "📄 ${r['category']} - ${r['fileName']}",
// //                 isBot: false,
// //                 filePath: r['filePath'],
// //               ));
// //             }
// //
// //             _addMessage(
// //                 Message(text: "You may now type your query for the doctor.", isBot: true));
// //             await _saveButtonState();
// //           }
// //         },
// //         icon: Icon(Icons.upload_file, color: AppColors.iconColor),
// //         label: Text("Upload Report", style: TextStyle(color: AppColors.iconColor)),
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: AppColors.buttonSecondary,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   bool canUseChat() {
// //     if (selectedDoctorType == null) return false;
// //
// //     if (selectedDoctorType == "Allopathy") {
// //       return reportUploaded && !queryAsked;
// //     }
// //
// //     if (selectedDoctorType == "Ayurvedic" || selectedDoctorType == "Homeopathic") {
// //       return paymentDone && !queryAsked;
// //     }
// //
// //     return false;
// //   }
// //
// //   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
// //     return ListTile(
// //       leading: Icon(icon, size: 25, color: AppColors.iconColor),
// //       title: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Text(title,
// //             style: const TextStyle(
// //                 fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //       ),
// //       onTap: onTap,
// //     );
// //   }
// //
// //
// //   // IntroCard Widget
// //   Widget buildIntroCard() {
// //     return Container(
// //       margin: const EdgeInsets.all(14),
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: AppColors.primary.withOpacity(0.08),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: AppColors.primary, width: 1.2),
// //         boxShadow: [
// //           BoxShadow(
// //             color: AppColors.primary.withOpacity(0.08),
// //             blurRadius: 12,
// //             offset: Offset(0, 2),
// //           )
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(Icons.medical_services, color: AppColors.primary, size: 28),
// //               const SizedBox(width: 10),
// //               Text(
// //                 "Health Buddy",
// //                 style: TextStyle(
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.bold,
// //                   color: AppColors.primary,
// //                   letterSpacing: 0.5,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           Text(
// //             "Get expert medical advice from the comfort of your home.\nOur experienced doctors are ready to help you confidently at every step.",
// //             style: TextStyle(
// //               fontSize: 15.5,
// //               color: Colors.grey[800],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             children: [
// //               Icon(Icons.verified_user, color: AppColors.accent, size: 20),
// //               const SizedBox(width: 5),
// //               Text(
// //                 "Trusted | Secure | Confidential",
// //                 style: TextStyle(
// //                     fontSize: 13,
// //                     fontWeight: FontWeight.w500,
// //                     letterSpacing: 0.1,
// //                     color: AppColors.primary),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 18),
// //           Text(
// //             "How it works:",
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               fontSize: 15,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           // Step 1
// //           _buildStep(
// //             stepNumber: 1,
// //             icon: Icons.person_search,
// //             label: "Choose your doctor type and specialty",
// //           ),
// //           const SizedBox(height: 5),
// //           // Step 2
// //           _buildStep(
// //             stepNumber: 2,
// //             icon: Icons.payment,
// //             label: "Make a secure online payment",
// //           ),
// //           const SizedBox(height: 5),
// //           // Step 3
// //           _buildStep(
// //             stepNumber: 3,
// //             icon: Icons.message_outlined,
// //             label: " upload reports , Chat & get advice",
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStep({
// //     required int stepNumber,
// //     required IconData icon,
// //     required String label,
// //   }) {
// //     return Row(
// //       children: [
// //         CircleAvatar(
// //           radius: 13,
// //           backgroundColor: AppColors.primary,
// //           child: Text(
// //             "$stepNumber",
// //             style: TextStyle(
// //                 color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
// //           ),
// //         ),
// //         const SizedBox(width: 8),
// //         Icon(icon, size: 18, color: AppColors.accent),
// //         const SizedBox(width: 7),
// //         Expanded(
// //           child: Text(
// //             label,
// //             style: TextStyle(fontSize: 13.5, color: Colors.grey[800]),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //
// //   String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);
// //
// //   bool isSameDay(DateTime d1, DateTime d2) =>
// //       d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
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
// //       drawer: Drawer(
// //         backgroundColor: AppColors.primary,
// //         child: SafeArea(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               const SizedBox(height: 30),
// //               Center(
// //                 child: Column(
// //                   children: [
// //                     const CircleAvatar(
// //                       radius: 40,
// //                       backgroundImage: AssetImage("assets/images/logo.png"),
// //                       backgroundColor: Colors.white,
// //                     ),
// //                     const SizedBox(height: 10),
// //                     const Text(
// //                       "HealthBuddy",
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const Text(
// //                       "info@healthbuddy.com",
// //                       style: TextStyle(
// //                         color: Colors.white70,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               Expanded(
// //                 child: ListView(
// //                   padding: EdgeInsets.zero,
// //                   children: [
// //                     drawerItem("Home", Icons.home, () {
// //                       Navigator.pop(context);
// //                       Navigator.pushNamed(context, '/home');
// //                     }),
// //                     drawerItem("Doctor", Icons.add, () {
// //                       Navigator.pushNamed(context, '/doctors');
// //                     }),
// //                     drawerItem("Orders", Icons.file_copy_sharp, () {
// //                       Navigator.pushNamed(context, '/orders');
// //                     }),
// //                     drawerItem("Terms & Privacy", Icons.privacy_tip, () {
// //                       Navigator.pushNamed(context, '/terms');
// //                     }),
// //                     drawerItem("LogOut", Icons.logout_sharp, () async {
// //                       bool? confirm = await showDialog(
// //                         context: context,
// //                         builder: (context) => AlertDialog(
// //                           title: const Text('Confirm Logout'),
// //                           content: const Text('Are you sure you want to logout?'),
// //                           actions: [
// //                             TextButton(
// //                               onPressed: () => Navigator.pop(context, false),
// //                               child: const Text('Cancel'),
// //                             ),
// //                             TextButton(
// //                               onPressed: () => Navigator.pop(context, true),
// //                               child: const Text('Logout'),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                       if (confirm == true) {
// //                         await logoutUser(context);
// //                       }
// //                     }),
// //                   ],
// //                 ),
// //               ),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 80),
// //                 child: Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: const [
// //                       Text(
// //                         "Made With",
// //                         style: TextStyle(color: AppColors.textLight, fontSize: 12),
// //                       ),
// //                       SizedBox(width: 5),
// //                       Icon(Icons.favorite, color: AppColors.textLight, size: 14),
// //                       SizedBox(width: 5),
// //                       Text(
// //                         "By VSGLogic",
// //                         style: TextStyle(color: AppColors.textLight, fontSize: 12),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //       child: ListView.builder(
// //               controller: _scrollController,
// //               padding: const EdgeInsets.symmetric(vertical: 10),
// //               itemCount: messages.length + 1, // +1 for the intro card at the top
// //               itemBuilder: (context, index) {
// //                 if (index == 0) {
// //                   // First item is the intro card
// //                   return buildIntroCard();
// //                 }
// //                 final msg = messages[index - 1];
// //                 // Determine if date separator should be shown
// //                 bool showDate = false;
// //                 if (index == 1) {
// //                   showDate = true;
// //                 } else {
// //                   final prevMsg = messages[index - 2];
// //                   if (msg.createdAt != null && prevMsg.createdAt != null) {
// //                     showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
// //                   }
// //                 }
// //                 return Column(
// //                   children: [
// //                     if (showDate && msg.createdAt != null)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         child: Container(
// //                           padding:
// //                           const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             color: AppColors.primary,
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Text(
// //                             formatDate(msg.createdAt!),
// //                             style: const TextStyle(
// //                                 fontSize: 12,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: AppColors.textLight),
// //                           ),
// //                         ),
// //                       ),
// //                     buildMessageBubble(msg),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //           SafeArea(
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //               color: AppColors.primary,
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Container(
// //                       padding:
// //                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: canUseChat() ? Colors.white : Colors.grey.shade300,
// //                         borderRadius: BorderRadius.circular(21),
// //                       ),
// //                       child: TextField(
// //                         controller: m1,
// //                         enabled: canUseChat(),
// //                         keyboardType: TextInputType.multiline,
// //                         textInputAction: TextInputAction.newline,
// //                         minLines: 1,
// //                         maxLines: 4,
// //                         decoration: InputDecoration(
// //                           hintText: canUseChat()
// //                               ? "Type your message here"
// //                               : "Complete required steps to chat",
// //                           border: InputBorder.none,
// //                           isDense: true,
// //                           contentPadding: const EdgeInsets.symmetric(vertical: 10),
// //                         ),
// //                         onChanged: (text) {
// //                           WidgetsBinding.instance.addPostFrameCallback((_) {
// //                             _scrollToBottom();
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   GestureDetector(
// //                     onTap: canUseChat()
// //                         ? () {
// //                       if (m1.text.trim().isNotEmpty) {
// //                         sendUserMessage(m1.text.trim());
// //                         m1.clear();
// //                         setState(() {
// //                           queryAsked = true;
// //                           reportUploaded = false;
// //                         });
// //                         _saveButtonState();
// //                         _addMessage(Message(
// //                             text:
// //                             "Your query has been submitted to the doctor. Please wait for their response.",
// //                             isBot: true));
// //                       }
// //                     }
// //                         : null,
// //                     child: Icon(Icons.send,
// //                         color: canUseChat() ? AppColors.iconColor : Colors.grey),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
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
//     String? id,
//   }) : id = id ?? UniqueKey().toString();
//
//   Map<String, dynamic> toMap() {
//     return {
//       'text': text,
//       'isBot': isBot,
//       'showButtons': showButtons,
//       'isUploadPrompt': isUploadPrompt,
//       'isSystem': isSystem,
//       'filePath': filePath,
//       'createdAt': createdAt?.toIso8601String(),
//       'isSecondOpinion': isSecondOpinion,
//       'id': id,
//     };
//   }
//
//   factory Message.fromMap(Map<String, dynamic> map) {
//     return Message(
//       text: map['text'] ?? '',
//       isBot: map['isBot'] ?? false,
//       showButtons: map['showButtons'] ?? false,
//       isUploadPrompt: map['isUploadPrompt'] ?? false,
//       isSystem: map['isSystem'] ?? false,
//       filePath: map['filePath'],
//       createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
//       isSecondOpinion: map['isSecondOpinion'] ?? false,
//       id: map['id'],
//     );
//   }
// }
//
// // Chat Order model
// class ChatOrder {
//   final String orderNumber;
//   final DateTime createdAt;
//   final List<Message> messages;
//   final String? doctorType;
//   final String? doctorCategory;
//   final bool paymentCompleted;
//   final String? patientQuery;
//   final String status;
//
//   ChatOrder({
//     required this.orderNumber,
//     required this.createdAt,
//     required this.messages,
//     this.doctorType,
//     this.doctorCategory,
//     this.paymentCompleted = false,
//     this.patientQuery,
//     this.status = 'Completed',
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'orderNumber': orderNumber,
//       'createdAt': createdAt.toIso8601String(),
//       'messages': messages.map((msg) => msg.toMap()).toList(),
//       'doctorType': doctorType,
//       'doctorCategory': doctorCategory,
//       'paymentCompleted': paymentCompleted,
//       'patientQuery': patientQuery,
//       'status': status,
//     };
//   }
//
//   factory ChatOrder.fromMap(Map<String, dynamic> map) {
//     return ChatOrder(
//       orderNumber: map['orderNumber'] ?? '',
//       createdAt: DateTime.parse(map['createdAt']),
//       messages: (map['messages'] as List)
//           .map((msgMap) => Message.fromMap(msgMap))
//           .toList(),
//       doctorType: map['doctorType'],
//       doctorCategory: map['doctorCategory'],
//       paymentCompleted: map['paymentCompleted'] ?? false,
//       patientQuery: map['patientQuery'],
//       status: map['status'] ?? 'Completed',
//     );
//   }
// }
//
// Future<void> logoutUser(BuildContext context) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('token');
//   if (token == null) {
//     Helpers.showSnackBar(context, "You are not logged in.");
//     return;
//   }
//   final url = Uri.parse("${ApiConfig.baseUrl}/logout");
//   try {
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
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
//   // Persisted state variables
//   bool yesClicked = false;
//   bool showUploadButton = true;
//   bool reportUploaded = false;
//   bool queryAsked = false;
//   bool paymentDone = false;
//   String? activeConfirmMessageId;
//   String? pendingDoctorType;
//   bool showTypeConfirm = false;
//   bool chatCompleted = false;
//   bool showEndChatButton = false;
//   String? currentOrderNumber;
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
//   String? selectedCategory;
//   bool showDropdown = false;
//   bool paymentPrompt = false;
//   List<String> doctorTypes = ['Allopathy', 'Ayurvedic', 'Homeopathic'];
//   String? selectedDoctorType;
//   bool showDoctorTypeOptions = false;
//
//   late Razorpay _razorpay;
//   String? userId;
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
//     await _restoreButtonState();
//     await fetchChatHistory();
//
//     // If no messages from server and also no locally saved messages,
//     // or messages got deleted in database, restarts chat flow with initial prompts.
//     if ((messages.isEmpty) && (!yesClicked)) {
//       _addMessage(Message(
//           text:
//           "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
//           isBot: true));
//       _addMessage(Message(
//           text: "Would you like to receive a second opinion from a specialist?",
//           isBot: true,
//           showButtons: true,
//           isSecondOpinion: true));
//     }
//   }
//
//   Future<void> _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString("userId") ?? "";
//     });
//   }
//
//   Future<void> _saveChatToPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> encodedMessages = messages.map((msg) => jsonEncode(msg.toMap())).toList();
//     await prefs.setStringList('chatMessages', encodedMessages);
//   }
//
//   Future<void> _restoreChatFromPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? encodedMessages = prefs.getStringList('chatMessages');
//     if (encodedMessages != null && encodedMessages.isNotEmpty) {
//       messages = encodedMessages.map((msgStr) {
//         Map<String, dynamic> map = jsonDecode(msgStr);
//         return Message.fromMap(map);
//       }).toList();
//       setState(() {});
//       _scrollToBottom();
//     }
//   }
//
//   Future<void> _restoreButtonState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       yesClicked = prefs.getBool("yesClicked") ?? false;
//       showUploadButton = prefs.getBool("showUploadButton") ?? true;
//       reportUploaded = prefs.getBool("reportUploaded") ?? false;
//       queryAsked = prefs.getBool("queryAsked") ?? false;
//       paymentDone = prefs.getBool("paymentDone") ?? false;
//       showTypeConfirm = prefs.getBool("showTypeConfirm") ?? false;
//       showDropdown = prefs.getBool("showDropdown") ?? false;
//       paymentPrompt = prefs.getBool("paymentPrompt") ?? false;
//       showDoctorTypeOptions = prefs.getBool("showDoctorTypeOptions") ?? false;
//       chatCompleted = prefs.getBool("chatCompleted") ?? false;
//       showEndChatButton = prefs.getBool("showEndChatButton") ?? false;
//       selectedCategory = prefs.getString("selectedCategory");
//       selectedDoctorType = prefs.getString("selectedDoctorType");
//       pendingDoctorType = prefs.getString("pendingDoctorType");
//       activeConfirmMessageId = prefs.getString("activeConfirmMessageId");
//       currentOrderNumber = prefs.getString("currentOrderNumber");
//     });
//
//     await _restoreChatFromPrefs();
//   }
//
//   Future<void> _saveButtonState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool("yesClicked", yesClicked);
//     await prefs.setBool("showUploadButton", showUploadButton);
//     await prefs.setBool("reportUploaded", reportUploaded);
//     await prefs.setBool("queryAsked", queryAsked);
//     await prefs.setBool("paymentDone", paymentDone);
//     await prefs.setBool("showTypeConfirm", showTypeConfirm);
//     await prefs.setBool("showDropdown", showDropdown);
//     await prefs.setBool("paymentPrompt", paymentPrompt);
//     await prefs.setBool("showDoctorTypeOptions", showDoctorTypeOptions);
//     await prefs.setBool("chatCompleted", chatCompleted);
//     await prefs.setBool("showEndChatButton", showEndChatButton);
//     if (selectedCategory != null) {
//       await prefs.setString("selectedCategory", selectedCategory!);
//     }
//     if (selectedDoctorType != null) {
//       await prefs.setString("selectedDoctorType", selectedDoctorType!);
//     }
//     if (pendingDoctorType != null) {
//       await prefs.setString("pendingDoctorType", pendingDoctorType!);
//     }
//     if (activeConfirmMessageId != null) {
//       await prefs.setString("activeConfirmMessageId", activeConfirmMessageId!);
//     }
//     if (currentOrderNumber != null) {
//       await prefs.setString("currentOrderNumber", currentOrderNumber!);
//     }
//
//     await _saveChatToPrefs();
//   }
//
//   // Save completed chat as an order
//   Future<void> _saveChatAsOrder() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Get patient query from messages
//     String? patientQuery;
//     for (Message msg in messages.reversed) {
//       if (!msg.isBot && !msg.isSystem && msg.text.isNotEmpty) {
//         patientQuery = msg.text;
//         break;
//       }
//     }
//
//     String orderNumber = currentOrderNumber ?? "001";
//
//     ChatOrder order = ChatOrder(
//       orderNumber: orderNumber,
//       createdAt: DateTime.now(),
//       messages: List.from(messages),
//       doctorType: selectedDoctorType,
//       doctorCategory: selectedCategory,
//       paymentCompleted: paymentDone,
//       patientQuery: patientQuery,
//       status: 'Completed',
//     );
//
//     // Get existing orders
//     List<String>? existingOrdersJson = prefs.getStringList('saved_orders');
//     List<ChatOrder> existingOrders = [];
//
//     if (existingOrdersJson != null) {
//       existingOrders = existingOrdersJson
//           .map((orderJson) => ChatOrder.fromMap(jsonDecode(orderJson)))
//           .toList();
//     }
//
//     // Add new order
//     existingOrders.add(order);
//
//     // Save back to preferences
//     List<String> updatedOrdersJson = existingOrders
//         .map((order) => jsonEncode(order.toMap()))
//         .toList();
//
//     await prefs.setStringList('saved_orders', updatedOrdersJson);
//
//     // Show confirmation
//     Helpers.showSnackBar(
//         context,
//         "Chat saved as Order #$orderNumber successfully!",
//         bgColor: AppColors.accent
//     );
//   }
//
//   // Reset chat for new conversation
//   Future<void> _resetChatForNewConversation() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Clear current chat data
//     await prefs.remove('chatMessages');
//
//     setState(() {
//       messages.clear();
//       yesClicked = false;
//       showUploadButton = true;
//       reportUploaded = false;
//       queryAsked = false;
//       paymentDone = false;
//       paymentPrompt = false;
//       selectedDoctorType = null;
//       selectedCategory = null;
//       pendingDoctorType = null;
//       showDropdown = false;
//       showDoctorTypeOptions = false;
//       showTypeConfirm = false;
//       activeConfirmMessageId = null;
//       chatCompleted = false;
//       showEndChatButton = false;
//       currentOrderNumber = null;
//     });
//
//     await _saveButtonState();
//
//     // Start new chat flow
//     _addMessage(Message(
//         text: "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
//         isBot: true));
//     _addMessage(Message(
//         text: "Would you like to receive a second opinion from a specialist?",
//         isBot: true,
//         showButtons: true,
//         isSecondOpinion: true));
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchChatHistory() async {
//     if (userId == null || userId!.isEmpty) return;
//     try {
//       final url = Uri.parse(ApiConfig.getChatHistory(userId!));
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['success'] == true && responseData['data'] != null) {
//           final List data = responseData['data'];
//           if (data.isEmpty) {
//             // Server chat is empty: reset local chat and states
//             await _resetChatFlowAfterDeletion();
//             return; // quit here, flow restarted
//           }
//           data.sort((a, b) =>
//               DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt'])));
//           messages = data.map((chat) {
//             String msgText = chat['message'] ?? "";
//             bool isBotMsg = false;
//             if (msgText.startsWith("Bot:")) {
//               isBotMsg = true;
//               msgText = msgText.replaceFirst("Bot: ", "");
//             } else if (msgText.startsWith("User:")) {
//               isBotMsg = false;
//               msgText = msgText.replaceFirst("User: ", "");
//             } else {
//               isBotMsg = chat['isBot'] ?? false;
//             }
//             String? filePath;
//             if (chat.containsKey('filePath')) {
//               filePath = chat['filePath'];
//             }
//             return Message(
//               text: msgText,
//               isBot: isBotMsg,
//               createdAt: chat['createdAt'] != null
//                   ? DateTime.parse(chat['createdAt'])
//                   : null,
//               showButtons: false,
//               isUploadPrompt: false,
//               isSystem: false,
//               filePath: filePath,
//             );
//           }).toList();
//           setState(() {});
//           _scrollToBottom();
//           await _saveChatToPrefs();
//         }
//       } else {
//         debugPrint("❌ Failed to fetch chat history: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching chat history: $e");
//     }
//   }
//
// // New method to reset chat flow after DB deletion
//   Future<void> _resetChatFlowAfterDeletion() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('chatMessages'); // clear local chat store
//     setState(() {
//       messages.clear(); // clear current chat
//       yesClicked = false;
//       showUploadButton = true;
//       reportUploaded = false;
//       queryAsked = false;
//       paymentDone = false;
//       paymentPrompt = false;
//       selectedDoctorType = null;
//       selectedCategory = null;
//       pendingDoctorType = null;
//       showDropdown = false;
//       showDoctorTypeOptions = false;
//       showTypeConfirm = false;
//       activeConfirmMessageId = null;
//       chatCompleted = false;
//       showEndChatButton = false;
//       currentOrderNumber = null;
//     });
//     await _saveButtonState();
//
//     // Add initial messages for fresh start
//     _addMessage(Message(
//         text: "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
//         isBot: true));
//     _addMessage(Message(
//         text: "Would you like to receive a second opinion from a specialist?",
//         isBot: true,
//         showButtons: true,
//         isSecondOpinion: true));
//   }
//
//
//   Future<void> sendMessage(
//       String senderId, String receiverId, String message) async {
//     final url = Uri.parse(ApiConfig.chat);
//     final body = {
//       "senderId": senderId,
//       "receiverId": receiverId,
//       "message": message,
//     };
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
//     _scrollToBottom();
//     await _saveChatToPrefs();
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? senderId = prefs.getString("userId");
//     if (senderId == null) {
//       debugPrint("❌ senderId is null, user might not be logged in!");
//       return;
//     }
//     String receiverId = "650b2f8a1f3a2b00123abcd4";
//     String prefixedMessage = msg.isBot ? "Bot: ${msg.text}" : "User: ${msg.text}";
//     await sendMessage(senderId, receiverId, prefixedMessage);
//   }
//
//   Future<void> createOrder(int amount, String doctorCategory) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? storedUserId = prefs.getString('userId');
//       if (storedUserId == null || storedUserId.isEmpty) {
//         Helpers.showSnackBar(context, "User ID not found! Please login again.");
//         return;
//       }
//       var response = await http.post(
//         Uri.parse(ApiConfig.orders),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"amount": amount, "UserId": storedUserId}),
//       );
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
//     var options = {
//       'key': 'rzp_test_vDQGr1D5EBRubo',
//       'amount': amount * 100,
//       'name': 'Health Buddy',
//       'description': 'Consultation Fee - $doctorCategory',
//       'order_id': orderId,
//       'prefill': {'contact': userPhone, 'email': userEmail},
//       'external': {'wallets': ['paytm']}
//     };
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
//       var verifyData = jsonDecode(verifyResponse.body);
//       if (verifyData['success'] == true) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String storedUserId = prefs.getString('userId') ?? "Unknown";
//
//         // After payment verification inside handlePaymentSuccess:
//         // Retrieve last order number count, default 0
//         int currentOrderCount = prefs.getInt('orderCount') ?? 0;
//         currentOrderCount++; // Increment order number
//         // Save updated count
//         await prefs.setInt('orderCount', currentOrderCount);
//         // Format order no string
//         String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');
//
//         // Store current order number
//         currentOrderNumber = displayOrderNo;
//         await prefs.setString("currentOrderNumber", currentOrderNumber!);
//
//         if (selectedDoctorType == "Allopathy" && !reportUploaded) {
//           setState(() {
//             paymentDone = true;
//             paymentPrompt = false;
//             showUploadButton = true;
//             reportUploaded = false;
//           });
//           await _saveButtonState();
//           _addMessage(Message(
//               text: "Payment successful and verified.", isBot: true));
//           _addMessage(Message(
//               text: "₹200 has been successfully processed.", isBot: false));
//           _addMessage(Message(
//               text: "Order No: $displayOrderNo",
//               isBot: false,
//               isSystem: true));
//           _addMessage(Message(
//               text: "Kindly upload your medical report to proceed with the consultation.",
//               isBot: true,
//               isUploadPrompt: true));
//         } else {
//           setState(() {
//             paymentDone = true;
//             paymentPrompt = false;
//           });
//           await _saveButtonState();
//           _addMessage(Message(
//               text: "Payment successful and verified.", isBot: true));
//           _addMessage(Message(
//               text: "₹200 has been successfully processed.", isBot: false));
//           _addMessage(Message(
//               text: "Order No: $displayOrderNo",
//               isBot: false,
//               isSystem: true));
//           _addMessage(Message(
//               text: "You may now type your query for the doctor.", isBot: true));
//           queryAsked = false;
//           await _saveButtonState();
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
//   void sendUserMessage(String userText) {
//     _addMessage(Message(text: userText, isBot: false));
//     if (userText.toLowerCase() == "yes") {
//       _addMessage(Message(text: "Please choose a doctor type:", isBot: true));
//       setState(() {
//         showDoctorTypeOptions = true;
//       });
//       _saveButtonState();
//     }
//   }
//
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
//           ElevatedButton(
//             onPressed: () async {
//               setState(() {
//                 showTypeConfirm = false;
//                 if (pendingDoctorType == "Allopathy") {
//                   showDropdown = true;
//                   _addMessage(
//                       Message(text: "Yes, continue with Allopathy.", isBot: false));
//                   _addMessage(
//                       Message(text: "Now select the doctor's specialty:", isBot: true));
//                 } else {
//                   paymentPrompt = true;
//                   _addMessage(
//                       Message(text: "Yes, continue with $pendingDoctorType.", isBot: false));
//                   _addMessage(Message(
//                       text: "Please complete the payment to confirm the consultation.",
//                       isBot: true));
//                 }
//               });
//               await _saveButtonState();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: AppColors.textLight,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: const Text("Yes"),
//           ),
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: () async {
//               setState(() {
//                 showTypeConfirm = false;
//                 selectedDoctorType = null;
//                 pendingDoctorType = null;
//                 showDoctorTypeOptions = true;
//               });
//               _addMessage(
//                   Message(text: "No, I don't want this option.", isBot: false));
//               _addMessage(Message(
//                   text: "Please choose another doctor type:", isBot: true));
//               await _saveButtonState();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.background,
//               foregroundColor: AppColors.textDark,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: const Text("No"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildMessageBubble(Message msg) {
//     final isBot = msg.isBot;
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
//                   bottomLeft:
//                   isBot ? const Radius.circular(0) : const Radius.circular(16),
//                   bottomRight:
//                   isBot ? const Radius.circular(16) : const Radius.circular(0),
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
//         if (msg.createdAt != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
//             child: Text(
//               DateFormat('hh:mm a').format(msg.createdAt!.toLocal()),
//               style: const TextStyle(color: Colors.grey, fontSize: 10),
//             ),
//           ),
//         if (msg.showButtons && msg.isSecondOpinion && !showTypeConfirm)
//           buildYesButtonOnly(),
//         if (msg.showButtons &&
//             showTypeConfirm &&
//             !msg.isSecondOpinion &&
//             msg.id == activeConfirmMessageId)
//           buildYesNoButtons(),
//         if (msg.isUploadPrompt) buildUploadReportButton(),
//         if (showDoctorTypeOptions && msg == messages.last) buildDoctorTypeOptions(),
//         if (showDropdown && msg == messages.last) buildCategoryDropdown(),
//         if (paymentPrompt && msg == messages.last) buildPaymentButton(),
//       ],
//     );
//   }
//
//   Widget buildYesButtonOnly() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: yesClicked
//           ? const SizedBox()
//           : ElevatedButton(
//         onPressed: () async {
//           setState(() {
//             yesClicked = true;
//           });
//           sendUserMessage("Yes");
//           await _saveButtonState();
//         },
//         style: ElevatedButton.styleFrom(
//           foregroundColor: AppColors.buttonText,
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
//             value: selectedDoctorType,
//             isExpanded: true,
//             items: doctorTypes.map((String type) {
//               return DropdownMenuItem<String>(
//                 value: type,
//                 child: Text(type, style: const TextStyle(color: Colors.black)),
//               );
//             }).toList(),
//             onChanged: (String? value) async {
//               if (value != null) {
//                 final confirmMsg = Message(
//                   text: "You selected $value. Do you want to continue?",
//                   isBot: true,
//                   showButtons: true,
//                   isSecondOpinion: false,
//                 );
//                 _addMessage(confirmMsg);
//                 setState(() {
//                   selectedDoctorType = value;
//                   pendingDoctorType = value;
//                   showDoctorTypeOptions = false;
//                   showTypeConfirm = true;
//                   activeConfirmMessageId = confirmMsg.id;
//                 });
//                 await _saveButtonState();
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
//         value: selectedCategory,
//         hint: const Text("Select Category"),
//         isExpanded: true,
//         menuMaxHeight: 200,
//         items: doctorCategories.map((String category) {
//           return DropdownMenuItem<String>(
//             value: category,
//             child: Text(category),
//           );
//         }).toList(),
//         onChanged: (String? value) async {
//           if (value != null) {
//             setState(() {
//               selectedCategory = value;
//               showDropdown = false;
//               paymentPrompt = true;
//               _addMessage(Message(text: "Selected: $value", isBot: false));
//               _addMessage(Message(
//                   text: "Please complete the payment to confirm the consultation.",
//                   isBot: true));
//             });
//             await _saveButtonState();
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
//     if (!showUploadButton || reportUploaded) return const SizedBox();
//
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
//             });
//             await _saveButtonState();
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
//               ));
//             }
//
//             _addMessage(
//                 Message(text: "You may now type your query for the doctor.", isBot: true));
//             await _saveButtonState();
//           }
//         },
//         icon: Icon(Icons.upload_file, color: AppColors.iconColor),
//         label: Text("Upload Report", style: TextStyle(color: AppColors.iconColor)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.buttonSecondary,
//         ),
//       ),
//     );
//   }
//
//   // End Chat Button
//   Widget buildEndChatButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
//       child: ElevatedButton.icon(
//         onPressed: () async {
//           // Show confirmation dialog
//           bool? confirm = await showDialog<bool>(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: const Text('End Chat'),
//               content: const Text('Are you sure you want to end this chat session? This will save the conversation to your orders.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, false),
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context, true),
//                   child: const Text('End Chat'),
//                 ),
//               ],
//             ),
//           );
//
//           if (confirm == true) {
//             await _saveChatAsOrder();
//             await _resetChatForNewConversation();
//           }
//         },
//         icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
//         label: const Text("End Chat", style: TextStyle(color: Colors.white)),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         ),
//       ),
//     );
//   }
//
//   bool canUseChat() {
//     if (selectedDoctorType == null) return false;
//
//     if (selectedDoctorType == "Allopathy") {
//       return reportUploaded && !queryAsked;
//     }
//
//     if (selectedDoctorType == "Ayurvedic" || selectedDoctorType == "Homeopathic") {
//       return paymentDone && !queryAsked;
//     }
//
//     return false;
//   }
//
//   bool shouldShowEndChatButton() {
//     // Show end chat button when user has asked query and payment is done
//     return queryAsked && paymentDone && messages.isNotEmpty;
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
//
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
//
//   String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);
//
//   bool isSameDay(DateTime d1, DateTime d2) =>
//       d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
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
//               icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor))
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: AppColors.primary,
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 30),
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
//               const SizedBox(height: 20),
//               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
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
//               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
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
//                     if (showDate && msg.createdAt != null)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Container(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             formatDate(msg.createdAt!),
//                             style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textLight),
//                           ),
//                         ),
//                       ),
//                     buildMessageBubble(msg),
//                     // Show End Chat button after the last message if conditions are met
//                     if (index == messages.length && shouldShowEndChatButton())
//                       buildEndChatButton(),
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
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
//                           hintText: canUseChat()
//                               ? "Type your message here"
//                               : "Complete required steps to chat",
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
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: canUseChat()
//                         ? () {
//                       if (m1.text.trim().isNotEmpty) {
//                         sendUserMessage(m1.text.trim());
//                         m1.clear();
//                         setState(() {
//                           queryAsked = true;
//                           reportUploaded = false;
//                           showEndChatButton = true; // Enable end chat button after sending message
//                         });
//                         _saveButtonState();
//                         _addMessage(Message(
//                             text:
//                             "Your query has been submitted to the doctor. Please wait for their response.",
//                             isBot: true));
//                       }
//                     }
//                         : null,
//                     child: Icon(Icons.send,
//                         color: canUseChat() ? AppColors.iconColor : Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'helper.dart';
// import 'package:intl/intl.dart';
// import 'upload_files.dart';
// import 'package:open_filex/open_filex.dart';
// import 'services/chat_service.dart';
//
// String formatDate(DateTime date) {
//   final now = DateTime.now();
//   if (isSameDay(date, now)) {
//     return "Today";
//   }
//   return DateFormat.yMMMMd().format(date);
// }
//
// bool isSameDay(DateTime a, DateTime b) {
//   return a.year == b.year && a.month == b.month && a.day == b.day;
// }
//
// class Message {
//   final String id;
//   final String text;
//   final bool isBot;
//   final bool showButtons;
//   final bool buttonClicked;
//   final DateTime? createdAt;
//   final String? selectedDoctorType;
//   final String? selectedSpeciality;
//   final bool showPaymentButton;
//   final bool paymentCompleted;
//   final String? orderId;
//   final String? paymentId;
//   final String? orderNumber;
//   final int? amount;
//   final bool showReportUploadQuestion;
//   final bool reportUploadAnswered;
//   final bool wantsToUploadReport;
//   final bool showReportUploadButton;
//   final bool reportUploaded;
//   final List<Map<String, dynamic>>? reportFiles;
//   final bool showDoctorTypeConfirmation;
//   final bool showSpecialityConfirmation;
//   final String? pendingDoctorType;
//   final String? pendingSpeciality;
//   final String? userId;
//   final String? userName;
//
//   Message({
//     required this.id,
//     required this.text,
//     required this.isBot,
//     this.showButtons = false,
//     this.buttonClicked = false,
//     this.createdAt,
//     this.selectedDoctorType,
//     this.selectedSpeciality,
//     this.showPaymentButton = false,
//     this.paymentCompleted = false,
//     this.orderId,
//     this.paymentId,
//     this.orderNumber,
//     this.amount,
//     this.showReportUploadQuestion = false,
//     this.reportUploadAnswered = false,
//     this.wantsToUploadReport = false,
//     this.showReportUploadButton = false,
//     this.reportUploaded = false,
//     this.reportFiles,
//     this.showDoctorTypeConfirmation = false,
//     this.showSpecialityConfirmation = false,
//     this.pendingDoctorType,
//     this.pendingSpeciality,
//     this.userId,
//     this.userName,
//   });
//
//   factory Message.fromMap(Map<String, dynamic> map) {
//     final bool buttonClicked = map['buttonClicked'] == true;
//     final bool showButtonsRaw = map['showButtons'] == true;
//
//     int? amount;
//     if (map['amount'] != null) {
//       if (map['amount'] is int) {
//         amount = map['amount'];
//       } else if (map['amount'] is double) {
//         amount = (map['amount'] as double).toInt();
//       } else if (map['amount'] is String) {
//         amount = int.tryParse(map['amount']);
//       }
//     }
//
//     String? safeString(String? value) {
//       return (value == null || value.isEmpty) ? null : value;
//     }
//
//     return Message(
//       id: map['_id'] ?? map['id'] ?? UniqueKey().toString(),
//       text: map['text'] ?? "",
//       isBot: map['isBot'] ?? false,
//       showButtons: showButtonsRaw && !buttonClicked,
//       buttonClicked: buttonClicked,
//       createdAt: map['createdAt'] != null
//           ? DateTime.tryParse(map['createdAt'].toString())
//           : DateTime.now(),
//       selectedDoctorType: safeString(map['selectedDoctorType']),
//       selectedSpeciality: safeString(map['selectedSpeciality']),
//       showPaymentButton: map['showPaymentButton'] ?? false,
//       paymentCompleted: map['paymentCompleted'] ?? false,
//       orderId: safeString(map['orderId']),
//       paymentId: safeString(map['paymentId']),
//       orderNumber: safeString(map['orderNumber']),
//       amount: amount,
//       showReportUploadQuestion: map['showReportUploadQuestion'] ?? false,
//       reportUploadAnswered: map['reportUploadAnswered'] ?? false,
//       wantsToUploadReport: map['wantsToUploadReport'] ?? false,
//       showReportUploadButton: map['showReportUploadButton'] ?? false,
//       reportUploaded: map['reportUploaded'] ?? false,
//       reportFiles: map['reportFiles'] != null && map['reportFiles'] is List
//           ? List<Map<String, dynamic>>.from(map['reportFiles'])
//           : null,
//       showDoctorTypeConfirmation: map['showDoctorTypeConfirmation'] ?? false,
//       showSpecialityConfirmation: map['showSpecialityConfirmation'] ?? false,
//       pendingDoctorType: safeString(map['pendingDoctorType']),
//       pendingSpeciality: safeString(map['pendingSpeciality']),
//       userId: safeString(map['userId']),
//       userName: safeString(map['userName']) ?? 'Health Buddy Bot',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'text': text,
//       'isBot': isBot,
//       'showButtons': showButtons,
//       'buttonClicked': buttonClicked,
//       'createdAt': createdAt?.toIso8601String(),
//       'selectedDoctorType': selectedDoctorType,
//       'selectedSpeciality': selectedSpeciality,
//       'showPaymentButton': showPaymentButton,
//       'paymentCompleted': paymentCompleted,
//       'orderId': orderId,
//       'paymentId': paymentId,
//       'orderNumber': orderNumber,
//       'amount': amount,
//       'showReportUploadQuestion': showReportUploadQuestion,
//       'reportUploadAnswered': reportUploadAnswered,
//       'wantsToUploadReport': wantsToUploadReport,
//       'showReportUploadButton': showReportUploadButton,
//       'reportUploaded': reportUploaded,
//       'reportFiles': reportFiles,
//       'showDoctorTypeConfirmation': showDoctorTypeConfirmation,
//       'showSpecialityConfirmation': showSpecialityConfirmation,
//       'pendingDoctorType': pendingDoctorType,
//       'pendingSpeciality': pendingSpeciality,
//       'userId': userId,
//       'userName': userName,
//     };
//   }
//
//   Message copyWith({
//     String? id,
//     String? text,
//     bool? isBot,
//     bool? showButtons,
//     bool? buttonClicked,
//     DateTime? createdAt,
//     String? selectedDoctorType,
//     String? selectedSpeciality,
//     bool? showPaymentButton,
//     bool? paymentCompleted,
//     String? orderId,
//     String? paymentId,
//     String? orderNumber,
//     int? amount,
//     bool? showReportUploadQuestion,
//     bool? reportUploadAnswered,
//     bool? wantsToUploadReport,
//     bool? showReportUploadButton,
//     bool? reportUploaded,
//     List<Map<String, dynamic>>? reportFiles,
//     bool? showDoctorTypeConfirmation,
//     bool? showSpecialityConfirmation,
//     String? pendingDoctorType,
//     String? pendingSpeciality,
//     String? userId,
//     String? userName,
//   }) {
//     return Message(
//       id: id ?? this.id,
//       text: text ?? this.text,
//       isBot: isBot ?? this.isBot,
//       showButtons: showButtons ?? this.showButtons,
//       buttonClicked: buttonClicked ?? this.buttonClicked,
//       createdAt: createdAt ?? this.createdAt,
//       selectedDoctorType: selectedDoctorType ?? this.selectedDoctorType,
//       selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
//       showPaymentButton: showPaymentButton ?? this.showPaymentButton,
//       paymentCompleted: paymentCompleted ?? this.paymentCompleted,
//       orderId: orderId ?? this.orderId,
//       paymentId: paymentId ?? this.paymentId,
//       orderNumber: orderNumber ?? this.orderNumber,
//       amount: amount ?? this.amount,
//       showReportUploadQuestion: showReportUploadQuestion ?? this.showReportUploadQuestion,
//       reportUploadAnswered: reportUploadAnswered ?? this.reportUploadAnswered,
//       wantsToUploadReport: wantsToUploadReport ?? this.wantsToUploadReport,
//       showReportUploadButton: showReportUploadButton ?? this.showReportUploadButton,
//       reportUploaded: reportUploaded ?? this.reportUploaded,
//       reportFiles: reportFiles ?? this.reportFiles,
//       showDoctorTypeConfirmation: showDoctorTypeConfirmation ?? this.showDoctorTypeConfirmation,
//       showSpecialityConfirmation: showSpecialityConfirmation ?? this.showSpecialityConfirmation,
//       pendingDoctorType: pendingDoctorType ?? this.pendingDoctorType,
//       pendingSpeciality: pendingSpeciality ?? this.pendingSpeciality,
//       userId: userId ?? this.userId,
//       userName: userName ?? this.userName,
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   final String? orderId;
//   final bool isExistingOrder;
//
//   const HomePage({
//     super.key,
//     this.orderId,
//     this.isExistingOrder = false,
//   });
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   List<Message> messages = [];
//   TextEditingController _controller = TextEditingController();
//   String? userId;
//   String? userName;
//   String? userPhone;
//   String? userEmail;
//   bool loadingHistory = true;
//   final ScrollController _scrollController = ScrollController();
//   String? currentDoctorType;
//   String? currentSpeciality;
//   String? currentOrderId;
//   bool paymentCompleted = false;
//   bool reportUploadEnabled = false;
//   bool hasUploadedReport = false;
//   late Razorpay _razorpay;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _loadUserId();
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   int getAmountForDoctorType(String? doctorType) {
//     if (doctorType == null) return 500;
//     switch (doctorType) {
//       case 'Ayurvedic':
//         return 300;
//       case 'Homeopathy':
//         return 350;
//       case 'Allopathy':
//       default:
//         return 500;
//     }
//   }
//
//   Future<void> _loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedUserId = prefs.getString('userId');
//     final storedUserName = prefs.getString('name') ?? 'User';
//     final storedUserPhone = prefs.getString('phone') ?? '';
//     final storedUserEmail = prefs.getString('email') ?? '';
//
//     if (storedUserId == null) {
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//       return;
//     }
//
//     setState(() {
//       userId = storedUserId;
//       userName = storedUserName;
//       userPhone = storedUserPhone;
//       userEmail = storedUserEmail;
//
//       // If this is an existing order, use the provided orderId
//       if (widget.isExistingOrder && widget.orderId != null) {
//         currentOrderId = widget.orderId;
//         print('🔄 Loading existing order: ${widget.orderId}');
//       }
//     });
//
//     await _loadChatHistoryOrInitialize();
//   }
//
//   Future<void> _loadChatHistoryOrInitialize() async {
//     if (userId == null) {
//       print('❌ User ID is null');
//       return;
//     }
//
//     try {
//       print('🔄 Loading chat history from backend...');
//
//       // Build URL with orderId if this is an existing order
//       String url = "${ApiConfig.chatHistory}?userId=$userId";
//       if (widget.isExistingOrder && currentOrderId != null && currentOrderId!.isNotEmpty) {
//         url += "&orderId=$currentOrderId";
//         print('📝 Loading existing order: $currentOrderId');
//       }
//
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//
//         List messagesData = decoded['data']['messages'] as List? ?? [];
//
//         if (messagesData.isEmpty && !widget.isExistingOrder) {
//           print('📂 No messages found, initializing new chat...');
//           await _initializeNewChat();
//           return;
//         } else if (messagesData.isEmpty && widget.isExistingOrder) {
//           print('⚠️ Existing order has no messages, creating fallback');
//           _createFallbackMessages();
//           return;
//         }
//
//         print('📥 Loaded ${messagesData.length} messages from backend');
//
//         final loadedMessages = messagesData.map((msg) {
//           try {
//             return Message.fromMap(msg);
//           } catch (e) {
//             print('❌ Error parsing message: $e - $msg');
//             return Message(
//               id: UniqueKey().toString(),
//               text: msg['text']?.toString() ?? 'Error loading message',
//               isBot: msg['isBot'] ?? false,
//               createdAt: DateTime.now(),
//               userId: userId,
//               userName: msg['userName']?.toString() ?? 'Unknown',
//             );
//           }
//         }).toList();
//
//         setState(() {
//           messages = loadedMessages;
//           loadingHistory = false;
//
//           // For existing orders, assume payment is completed and extract state
//           if (widget.isExistingOrder) {
//             paymentCompleted = true;
//             reportUploadEnabled = true;
//
//             for (var msg in loadedMessages) {
//               if (msg.selectedDoctorType != null && msg.selectedDoctorType!.isNotEmpty) {
//                 currentDoctorType = msg.selectedDoctorType;
//               }
//               if (msg.selectedSpeciality != null && msg.selectedSpeciality!.isNotEmpty) {
//                 currentSpeciality = msg.selectedSpeciality;
//               }
//               if (msg.orderId != null && msg.orderId!.isNotEmpty) {
//                 currentOrderId = msg.orderId;
//               }
//               if (msg.reportUploaded == true) {
//                 hasUploadedReport = true;
//               }
//             }
//
//             print('🔄 Existing order - Doctor: $currentDoctorType, Speciality: $currentSpeciality');
//           } else {
//             // For new chats, extract state normally
//             for (var msg in loadedMessages) {
//               if (msg.selectedDoctorType != null && msg.selectedDoctorType!.isNotEmpty) {
//                 currentDoctorType = msg.selectedDoctorType;
//               }
//               if (msg.selectedSpeciality != null && msg.selectedSpeciality!.isNotEmpty) {
//                 currentSpeciality = msg.selectedSpeciality;
//               }
//               if (msg.paymentCompleted == true) paymentCompleted = true;
//               if (msg.orderId != null && msg.orderId!.isNotEmpty) currentOrderId = msg.orderId;
//               if (msg.wantsToUploadReport == true) reportUploadEnabled = true;
//               if (msg.reportUploaded == true) hasUploadedReport = true;
//             }
//           }
//         });
//
//       } else {
//         print('❌ HTTP error: ${response.statusCode}');
//         if (!widget.isExistingOrder) {
//           await _initializeNewChat();
//         } else {
//           _createFallbackMessages();
//         }
//       }
//     } catch (e) {
//       print('❌ Error loading chat history: $e');
//       if (!widget.isExistingOrder) {
//         await _initializeNewChat();
//       } else {
//         _createFallbackMessages();
//       }
//     }
//
//     _scrollToBottom();
//   }
//
//   Future<void> _initializeNewChat() async {
//     try {
//       print('🔄 Initializing new chat...');
//
//       final response = await ChatService.initializeChat(
//         userId: userId!,
//         userName: userName ?? 'User',
//         userPhone: userPhone,
//         userEmail: userEmail,
//         orderId: currentOrderId,
//       );
//
//       if (response['success'] == true) {
//         final messagesData = response['data']['messages'] as List? ?? [];
//         print('📥 Initialized with ${messagesData.length} messages');
//
//         final initialMessages = messagesData.map((msg) => Message.fromMap(msg)).toList();
//
//         setState(() {
//           messages = initialMessages;
//           loadingHistory = false;
//         });
//
//         if (initialMessages.isNotEmpty && initialMessages.first.orderId != null) {
//           currentOrderId = initialMessages.first.orderId;
//           print('📝 Set currentOrderId: $currentOrderId');
//         }
//       } else {
//         throw Exception('Backend returned success: false');
//       }
//     } catch (e) {
//       print('❌ Error initializing chat: $e');
//       _createFallbackMessages();
//     }
//   }
//
//   void _createFallbackMessages() {
//     final welcome = Message(
//       id: UniqueKey().toString(),
//       text: "Hello! Welcome to Health Buddy. We provide professional doctor consultations from the comfort of your home.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//     final question = Message(
//       id: UniqueKey().toString(),
//       text: "Would you like to receive a second opinion from a specialist?",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages = [welcome, question];
//       loadingHistory = false;
//     });
//
//     print('📝 Using fallback local messages');
//   }
//
//   Future<void> sendMessage(Message message) async {
//     try {
//       await _sendMessageToBackend(message);
//     } catch (e) {
//       print("Error sending message to backend: $e");
//     }
//   }
//
//   Future<void> _sendMessageToBackend(Message message) async {
//     if (userId == null) {
//       print('❌ Cannot send message: User ID is null');
//       return;
//     }
//
//     try {
//       print('🔄 Sending message to backend: ${message.text}');
//
//       final response = await ChatService.sendMessage(
//         userId: userId!,
//         message: message.text,
//         userName: userName ?? 'User',
//         userPhone: userPhone,
//         userEmail: userEmail,
//         doctorType: message.selectedDoctorType ?? currentDoctorType ?? '',
//         speciality: message.selectedSpeciality ?? currentSpeciality ?? '',
//         orderId: message.orderId ?? currentOrderId ?? '',
//         paymentCompleted: message.paymentCompleted || paymentCompleted,
//       );
//
//       print('✅ Message sent to backend successfully');
//
//       if (!message.isBot && paymentCompleted && response['success'] == true) {
//         final botResponse = response['data']['botResponse'];
//         if (botResponse != null) {
//           print('🤖 Received bot response');
//           final botMessage = Message.fromMap(botResponse);
//           setState(() {
//             messages.add(botMessage);
//           });
//           _scrollToBottom();
//         } else {
//           print('ℹ No bot response received');
//         }
//       }
//     } catch (e) {
//       print('❌ Failed to send message to backend: $e');
//     }
//   }
//
//   void _onUserSend(String text) async {
//     if (text.trim().isEmpty) return;
//     if (!paymentCompleted) {
//       Helpers.showSnackBar(context, "Please complete payment before sending messages", bgColor: Colors.red);
//       return;
//     }
//
//     final userMsg = Message(
//       id: UniqueKey().toString(),
//       text: text,
//       isBot: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       userId: userId,
//       userName: userName,
//     );
//
//     setState(() {
//       messages.add(userMsg);
//     });
//
//     await sendMessage(userMsg);
//     _controller.clear();
//     _scrollToBottom();
//   }
//
//   void _onYesButtonPressed(Message questionMsg) async {
//     final index = messages.indexWhere((m) => m.id == questionMsg.id);
//     if (index == -1) return;
//
//     final updatedMsg = questionMsg.copyWith(showButtons: false, buttonClicked: true);
//     final userResponse = Message(
//       id: UniqueKey().toString(),
//       text: "Yes, I would like a second opinion.",
//       isBot: false,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: userName,
//     );
//     final doctorTypeQuestion = Message(
//       id: UniqueKey().toString(),
//       text: "Please select your preferred doctor type:",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//       messages.add(doctorTypeQuestion);
//     });
//
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//     await sendMessage(doctorTypeQuestion);
//     _scrollToBottom();
//   }
//
//   void _onDoctorTypeSelected(Message questionMsg, String doctorType) async {
//     final index = messages.indexWhere((m) => m.id == questionMsg.id);
//     if (index == -1) return;
//
//     final updatedMsg = questionMsg.copyWith(
//       showButtons: false,
//       buttonClicked: true,
//       pendingDoctorType: doctorType,
//     );
//     final confirmationMsg = Message(
//       id: UniqueKey().toString(),
//       text: "You selected $doctorType. Would you like to confirm this selection?",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       showDoctorTypeConfirmation: true,
//       pendingDoctorType: doctorType,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(confirmationMsg);
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(confirmationMsg);
//     _scrollToBottom();
//   }
//
//   void _onDoctorTypeConfirmYes(Message confirmMsg) async {
//     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
//     if (index == -1) return;
//
//     final doctorType = confirmMsg.pendingDoctorType!;
//     final updatedMsg = confirmMsg.copyWith(
//       showButtons: false,
//       buttonClicked: true,
//       selectedDoctorType: doctorType,
//     );
//     final userResponse = Message(
//       id: UniqueKey().toString(),
//       text: "Yes, confirmed $doctorType",
//       isBot: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: doctorType,
//       userId: userId,
//       userName: userName,
//     );
//
//     setState(() {
//       currentDoctorType = doctorType;
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//
//     if (doctorType == "Allopathy") {
//       final specialityQuestion = Message(
//         id: UniqueKey().toString(),
//         text: "Please select your doctor's speciality:",
//         isBot: true,
//         showButtons: true,
//         buttonClicked: false,
//         createdAt: DateTime.now(),
//         selectedDoctorType: doctorType,
//         userId: userId,
//         userName: 'Health Buddy Bot',
//       );
//       setState(() {
//         messages.add(specialityQuestion);
//       });
//       await sendMessage(specialityQuestion);
//     } else {
//       final amount = getAmountForDoctorType(doctorType);
//       final paymentMsg = Message(
//         id: UniqueKey().toString(),
//         text: "Great! You've selected $doctorType. Please proceed with payment to start your consultation.",
//         isBot: true,
//         createdAt: DateTime.now(),
//         selectedDoctorType: doctorType,
//         showPaymentButton: true,
//         amount: amount,
//         userId: userId,
//         userName: 'Health Buddy Bot',
//       );
//       setState(() {
//         messages.add(paymentMsg);
//       });
//       await sendMessage(paymentMsg);
//     }
//     _scrollToBottom();
//   }
//
//   void _onDoctorTypeConfirmNo(Message confirmMsg) async {
//     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
//     if (index == -1) return;
//
//     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
//     final userResponse = Message(
//       id: UniqueKey().toString(),
//       text: "No, let me choose again",
//       isBot: false,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: userName,
//     );
//     final doctorTypeQuestion = Message(
//       id: UniqueKey().toString(),
//       text: "Please select your preferred doctor type:",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//       messages.add(doctorTypeQuestion);
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//     await sendMessage(doctorTypeQuestion);
//     _scrollToBottom();
//   }
//
//   void _onSpecialitySelected(Message questionMsg, String speciality) async {
//     final index = messages.indexWhere((m) => m.id == questionMsg.id);
//     if (index == -1) return;
//
//     final updatedMsg = questionMsg.copyWith(
//       showButtons: false,
//       buttonClicked: true,
//       pendingSpeciality: speciality,
//     );
//     final confirmationMsg = Message(
//       id: UniqueKey().toString(),
//       text: "You selected $speciality. Would you like to confirm this speciality?",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       showSpecialityConfirmation: true,
//       pendingSpeciality: speciality,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(confirmationMsg);
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(confirmationMsg);
//     _scrollToBottom();
//   }
//
//   void _onSpecialityConfirmYes(Message confirmMsg) async {
//     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
//     if (index == -1) return;
//
//     final speciality = confirmMsg.pendingSpeciality!;
//     final updatedMsg = confirmMsg.copyWith(
//       showButtons: false,
//       buttonClicked: true,
//       selectedSpeciality: speciality,
//     );
//     final userResponse = Message(
//       id: UniqueKey().toString(),
//       text: "Yes, confirmed $speciality",
//       isBot: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: speciality,
//       userId: userId,
//       userName: userName,
//     );
//     final amount = getAmountForDoctorType(currentDoctorType);
//     final paymentMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Excellent! You've selected $speciality specialist. Please proceed with payment to start your consultation.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: speciality,
//       showPaymentButton: true,
//       amount: amount,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       currentSpeciality = speciality;
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//       messages.add(paymentMsg);
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//     await sendMessage(paymentMsg);
//     _scrollToBottom();
//   }
//
//   void _onSpecialityConfirmNo(Message confirmMsg) async {
//     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
//     if (index == -1) return;
//
//     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
//     final userResponse = Message(
//       id: UniqueKey().toString(),
//       text: "No, let me choose again",
//       isBot: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       userId: userId,
//       userName: userName,
//     );
//     final specialityQuestion = Message(
//       id: UniqueKey().toString(),
//       text: "Please select your doctor's speciality:",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//       messages.add(specialityQuestion);
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//     await sendMessage(specialityQuestion);
//     _scrollToBottom();
//   }
//
//   Future<void> _onPaymentButtonPressed(Message paymentMsg) async {
//     final index = messages.indexWhere((m) => m.id == paymentMsg.id);
//     if (index == -1) return;
//     if (paymentCompleted) {
//       Helpers.showSnackBar(context, "Payment already completed", bgColor: Colors.orange);
//       return;
//     }
//
//     final updatedPaymentMsg = paymentMsg.copyWith(buttonClicked: true, showPaymentButton: true);
//     final userPaymentMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Proceeding to payment...",
//       isBot: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       userId: userId,
//       userName: userName,
//     );
//
//     setState(() {
//       messages[index] = updatedPaymentMsg;
//       messages.add(userPaymentMsg);
//     });
//     await sendMessage(updatedPaymentMsg);
//     await sendMessage(userPaymentMsg);
//     _scrollToBottom();
//
//     String doctorCategory = currentSpeciality ?? currentDoctorType ?? "General";
//     int amount = getAmountForDoctorType(currentDoctorType);
//     createOrder(amount, doctorCategory);
//   }
//
//   Future<void> createOrder(int amount, String doctorCategory) async {
//     try {
//       if (userId == null) {
//         Helpers.showSnackBar(context, "User ID not found! Please login again.");
//         return;
//       }
//
//       var response = await http.post(
//         Uri.parse(ApiConfig.orders),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "amount": amount,
//           "UserId": userId,
//           "userName": userName,
//           "userPhone": userPhone,
//           "userEmail": userEmail,
//           "doctorType": currentDoctorType,
//           "speciality": currentSpeciality,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['success'] == true && data['data'] != null && data['data']['orderId'] != null) {
//           setState(() {
//             currentOrderId = data['data']['orderId'];
//           });
//           openCheckout(amount, doctorCategory, data['data']['orderId']);
//         } else {
//           Helpers.showSnackBar(context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
//         }
//       } else {
//         Helpers.showSnackBar(context, "Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       Helpers.showSnackBar(context, "Error: $e");
//     }
//   }
//
//   Future<void> openCheckout(int amount, String doctorCategory, String orderId) async {
//     var options = {
//       'key': 'rzp_test_vDQGr1D5EBRubo',
//       'amount': amount * 100,
//       'name': 'Health Buddy',
//       'description': 'Consultation Fee - $doctorCategory',
//       'order_id': orderId,
//       'prefill': {
//         'contact': userPhone ?? '',
//         'email': userEmail ?? '',
//         'name': userName ?? '',
//       },
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
//           "userId": userId,
//           "userName": userName,
//           "userPhone": userPhone,
//           "userEmail": userEmail,
//           "orderId": currentOrderId,
//           "doctorType": currentDoctorType,
//           "speciality": currentSpeciality,
//           "amount": getAmountForDoctorType(currentDoctorType),
//         }),
//       );
//
//       var verifyData = jsonDecode(verifyResponse.body);
//       if (verifyData['success'] == true) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         int currentOrderCount = prefs.getInt('orderCount') ?? 0;
//         currentOrderCount++;
//         await prefs.setInt('orderCount', currentOrderCount);
//         String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');
//
//         setState(() {
//           paymentCompleted = true;
//         });
//
//         final amount = getAmountForDoctorType(currentDoctorType);
//         final paymentSuccessMsg = Message(
//           id: UniqueKey().toString(),
//           text: "Payment successful and verified! ✅",
//           isBot: true,
//           createdAt: DateTime.now(),
//           selectedDoctorType: currentDoctorType,
//           selectedSpeciality: currentSpeciality,
//           paymentCompleted: true,
//           orderId: currentOrderId,
//           paymentId: response.paymentId,
//           orderNumber: displayOrderNo,
//           amount: amount,
//           userId: userId,
//           userName: 'Health Buddy Bot',
//         );
//         final amountMsg = Message(
//           id: UniqueKey().toString(),
//           text: "₹$amount has been successfully processed.",
//           isBot: false,
//           createdAt: DateTime.now(),
//           paymentCompleted: true,
//           amount: amount,
//           userId: userId,
//           userName: userName,
//         );
//         final orderNoMsg = Message(
//           id: UniqueKey().toString(),
//           text: "Order No: $displayOrderNo",
//           isBot: false,
//           createdAt: DateTime.now(),
//           paymentCompleted: true,
//           orderNumber: displayOrderNo,
//           userId: userId,
//           userName: userName,
//         );
//
//         setState(() {
//           messages.add(paymentSuccessMsg);
//           messages.add(amountMsg);
//           messages.add(orderNoMsg);
//         });
//         await sendMessage(paymentSuccessMsg);
//         await sendMessage(amountMsg);
//         await sendMessage(orderNoMsg);
//         await _askReportUploadQuestion();
//         _scrollToBottom();
//
//         Helpers.showSnackBar(context, "Payment successful! Order #$displayOrderNo created.", bgColor: AppColors.accent);
//       } else {
//         Helpers.showSnackBar(context, "Payment verification failed", bgColor: Colors.red);
//       }
//     } catch (e) {
//       debugPrint("Verification error: $e");
//       Helpers.showSnackBar(context, "Payment verification error: $e", bgColor: Colors.red);
//     }
//   }
//
//   Future<void> _askReportUploadQuestion() async {
//     final reportQuestion = Message(
//       id: UniqueKey().toString(),
//       text: "Would you like to upload any medical reports for the doctor to review?",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       showReportUploadQuestion: true,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//     setState(() {
//       messages.add(reportQuestion);
//     });
//     await sendMessage(reportQuestion);
//     _scrollToBottom();
//   }
//
//   Future<void> _onReportUploadYes(Message questionMsg) async {
//     final index = messages.indexWhere((m) => m.id == questionMsg.id);
//     if (index == -1) return;
//
//     final updatedMsg = questionMsg.copyWith(
//       showButtons: false,
//       buttonClicked: true,
//       reportUploadAnswered: true,
//       wantsToUploadReport: true,
//     );
//     final userResponse = Message(
//       id: UniqueKey().toString(),
//       text: "Yes, I would like to upload reports.",
//       isBot: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       userId: userId,
//       userName: userName,
//     );
//     final uploadInstruction = Message(
//       id: UniqueKey().toString(),
//       text: "Great! You can now upload your medical reports using the clip icon next to the message input field.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       showReportUploadButton: true,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//       messages.add(uploadInstruction);
//       reportUploadEnabled = true;
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//     await sendMessage(uploadInstruction);
//
//     final chatEnableMsg = Message(
//       id: UniqueKey().toString(),
//       text: "You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       paymentCompleted: true,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//     setState(() {
//       messages.add(chatEnableMsg);
//     });
//     await sendMessage(chatEnableMsg);
//     _scrollToBottom();
//   }
//
//   Future<void> _onReportUploadNo(Message questionMsg) async {
//     final index = messages.indexWhere((m) => m.id == questionMsg.id);
//     if (index == -1) return;
//
//     final updatedMsg = questionMsg.copyWith(
//       showButtons: false,
//       buttonClicked: true,
//       reportUploadAnswered: true,
//       wantsToUploadReport: false,
//     );
//     final userResponse = Message(
//       id: UniqueKey().toString(),
//       text: "No, I don't need to upload reports right now.",
//       isBot: false,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       userId: userId,
//       userName: userName,
//     );
//     final chatEnableMsg = Message(
//       id: UniqueKey().toString(),
//       text: "No problem! You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       paymentCompleted: true,
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//       messages.add(chatEnableMsg);
//     });
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//     await sendMessage(chatEnableMsg);
//     _scrollToBottom();
//   }
//
//   Future<void> _navigateToUploadFiles() async {
//     if (!reportUploadEnabled) {
//       Helpers.showSnackBar(context, "Please complete payment and confirm report upload first", bgColor: Colors.orange);
//       return;
//     }
//     if (hasUploadedReport) {
//       Helpers.showSnackBar(context, "You have already uploaded reports. Upload is allowed only once.", bgColor: Colors.orange);
//       return;
//     }
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const UploadFiles()),
//     );
//
//     if (result != null && result is Map<String, dynamic> && result['status'] == 'uploaded') {
//       List<Map<String, dynamic>> uploadedReports = List<Map<String, dynamic>>.from(result['reports']);
//       final uploadSuccessMsg = Message(
//         id: UniqueKey().toString(),
//         text: "Reports uploaded successfully! ✅\nTotal files: ${uploadedReports.length}",
//         isBot: true,
//         createdAt: DateTime.now(),
//         selectedDoctorType: currentDoctorType,
//         selectedSpeciality: currentSpeciality,
//         reportUploaded: true,
//         reportFiles: uploadedReports,
//         userId: userId,
//         userName: 'Health Buddy Bot',
//       );
//
//       setState(() {
//         messages.add(uploadSuccessMsg);
//         hasUploadedReport = true;
//       });
//       await sendMessage(uploadSuccessMsg);
//       _scrollToBottom();
//
//       Helpers.showSnackBar(context, "Reports uploaded successfully!", bgColor: AppColors.accent);
//     }
//   }
//
//   Future<void> _openFile(String filePath, String fileName) async {
//     try {
//       final result = await OpenFilex.open(filePath);
//       if (result.type == ResultType.done) {
//         debugPrint("✅ File opened successfully: $fileName");
//       } else if (result.type == ResultType.noAppToOpen) {
//         Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
//       } else if (result.type == ResultType.fileNotFound) {
//         Helpers.showSnackBar(context, "File not found at: $filePath", bgColor: Colors.red);
//       } else {
//         Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
//       }
//     } catch (e) {
//       debugPrint("❌ Error opening file: $e");
//       Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
//     }
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     final errorMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Payment could not be completed. Please try again.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Health Buddy Bot',
//     );
//     setState(() {
//       messages.add(errorMsg);
//     });
//     sendMessage(errorMsg);
//     Helpers.showSnackBar(context, "Payment failed: ${response.message}", bgColor: Colors.red);
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
//   }
//
//   Widget buildIntroCard(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(14),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.primary, width: 1.2),
//         boxShadow: [
//           BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2)),
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
//             style: TextStyle(fontSize: 15.5, color: Colors.grey[800]),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Icon(Icons.verified_user, color: AppColors.accent, size: 20),
//               const SizedBox(width: 5),
//               Text(
//                 "Trusted | Secure | Confidential",
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.primary),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           Text(
//             "How it works:",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
//           ),
//           const SizedBox(height: 8),
//           _buildStep(stepNumber: 1, icon: Icons.person_search, label: "Choose your doctor type and specialty"),
//           const SizedBox(height: 5),
//           _buildStep(stepNumber: 2, icon: Icons.payment, label: "Make a secure online payment"),
//           const SizedBox(height: 5),
//           _buildStep(stepNumber: 3, icon: Icons.message_outlined, label: "Upload reports, Chat & get advice"),
//           const SizedBox(height: 18),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.blue.shade200),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Consultation Fees:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
//                 const SizedBox(height: 6),
//                 _buildPriceRow("Ayurvedic", "₹300"),
//                 _buildPriceRow("Homeopathy", "₹350"),
//                 _buildPriceRow("Allopathy", "₹500"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 18),
//           GestureDetector(
//             onTap: () => Navigator.pushNamed(context, '/terms'),
//             child: Text(
//               "Terms & Conditions",
//               style: TextStyle(decoration: TextDecoration.underline, color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStep({required int stepNumber, required IconData icon, required String label}) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 13,
//           backgroundColor: AppColors.primary,
//           child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
//         ),
//         const SizedBox(width: 8),
//         Icon(icon, size: 18, color: AppColors.accent),
//         const SizedBox(width: 7),
//         Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, color: Colors.grey[800]))),
//       ],
//     );
//   }
//
//   Widget _buildPriceRow(String type, String price) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(type, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
//           Text(price, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accent)),
//         ],
//       ),
//     );
//   }
//
//   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 25, color: AppColors.iconColor),
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   void _scrollToBottom() {
//     if (!_scrollController.hasClients) return;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Widget buildMessageBubble(Message msg) {
//     final isUser = !msg.isBot;
//
//     final showSecondOpinionButton = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("second opinion");
//     final showDoctorTypeDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your preferred doctor type");
//     final showSpecialityDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your doctor's speciality");
//     final showReportUploadButtons = msg.showReportUploadQuestion && msg.showButtons && !msg.buttonClicked;
//     final showDoctorTypeConfirmation = msg.showDoctorTypeConfirmation && msg.showButtons && !msg.buttonClicked;
//     final showSpecialityConfirmation = msg.showSpecialityConfirmation && msg.showButtons && !msg.buttonClicked;
//     final shouldShowPaymentButton = msg.showPaymentButton && !paymentCompleted;
//
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.all(12),
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         decoration: BoxDecoration(
//           color: isUser ? AppColors.chatUser : AppColors.chatBot,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: isUser ? const Radius.circular(16) : Radius.circular(0),
//             bottomRight: isUser ? Radius.circular(0) : const Radius.circular(16),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               msg.text,
//               style: TextStyle(color: isUser ? AppColors.chatUserText : AppColors.chatBotText, fontSize: 15),
//             ),
//
//             if (msg.reportUploaded == true && msg.reportFiles != null && msg.reportFiles!.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: msg.reportFiles!.map((report) {
//                     return GestureDetector(
//                       onTap: () => _openFile(report['filePath'], report['fileName']),
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 6),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.blue.shade200),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.file_present, color: Colors.blue.shade700, size: 20),
//                             const SizedBox(width: 8),
//                             Flexible(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     report['category'] ?? 'Unknown',
//                                     style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 12),
//                                   ),
//                                   Text(
//                                     report['fileName'] ?? "View File",
//                                     style: TextStyle(
//                                       color: Colors.blue.shade700,
//                                       decoration: TextDecoration.underline,
//                                       fontSize: 11,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//
//             if (showSecondOpinionButton)
//               Padding(padding: const EdgeInsets.only(top: 8.0), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onYesButtonPressed(msg), child: const Text("Yes"))),
//
//             if (showReportUploadButtons)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Row(
//                   children: [
//                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onReportUploadYes(msg), child: const Text("Yes")),
//                     const SizedBox(width: 8),
//                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onReportUploadNo(msg), child: const Text("No")),
//                   ],
//                 ),
//               ),
//
//             if (showDoctorTypeConfirmation)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Row(
//                   children: [
//                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmYes(msg), child: const Text("Yes")),
//                     const SizedBox(width: 8),
//                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmNo(msg), child: const Text("No")),
//                   ],
//                 ),
//               ),
//
//             if (showSpecialityConfirmation)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Row(
//                   children: [
//                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmYes(msg), child: const Text("Yes")),
//                     const SizedBox(width: 8),
//                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmNo(msg), child: const Text("No")),
//                   ],
//                 ),
//               ),
//
//             if (showDoctorTypeDropdown)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
//                   child: DropdownButton<String>(
//                     hint: const Text("Select Doctor Type"),
//                     isExpanded: true,
//                     underline: const SizedBox(),
//                     items: const [
//                       DropdownMenuItem(value: "Allopathy", child: Text("Allopathy (₹500)")),
//                       DropdownMenuItem(value: "Ayurvedic", child: Text("Ayurvedic (₹300)")),
//                       DropdownMenuItem(value: "Homeopathy", child: Text("Homeopathy (₹350)")),
//                     ],
//                     onChanged: (value) {
//                       if (value != null) _onDoctorTypeSelected(msg, value);
//                     },
//                   ),
//                 ),
//               ),
//
//             if (showSpecialityDropdown)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
//                   child: DropdownButton<String>(
//                     hint: const Text("Select Speciality"),
//                     isExpanded: true,
//                     underline: const SizedBox(),
//                     items: const [
//                       DropdownMenuItem(value: "MBBS", child: Text("MBBS (General Physician)")),
//                       DropdownMenuItem(value: "MD", child: Text("MD (Doctor of Medicine)")),
//                       DropdownMenuItem(value: "Dentist", child: Text("Dentist")),
//                       DropdownMenuItem(value: "Cardiologist", child: Text("Cardiologist")),
//                       DropdownMenuItem(value: "Dermatologist", child: Text("Dermatologist")),
//                       DropdownMenuItem(value: "Orthopedic", child: Text("Orthopedic")),
//                       DropdownMenuItem(value: "Pediatrician", child: Text("Pediatrician")),
//                       DropdownMenuItem(value: "Gynecologist", child: Text("Gynecologist")),
//                       DropdownMenuItem(value: "Neurologist", child: Text("Neurologist")),
//                       DropdownMenuItem(value: "Psychiatrist", child: Text("Psychiatrist")),
//                     ],
//                     onChanged: (value) {
//                       if (value != null) _onSpecialitySelected(msg, value);
//                     },
//                   ),
//                 ),
//               ),
//
//             if (shouldShowPaymentButton)
//               Builder(builder: (context) {
//                 final amount = msg.amount ?? getAmountForDoctorType(currentDoctorType);
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: !paymentCompleted ? Colors.green[700] : Colors.grey,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     ),
//                     onPressed: !paymentCompleted ? () => _onPaymentButtonPressed(msg) : null,
//                     icon: const Icon(Icons.payment),
//                     label: Text("Pay ₹$amount"),
//                   ),
//                 );
//               }),
//
//             if (msg.paymentCompleted == true)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
//                   child: Text("Payment Completed ✅", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12)),
//                 ),
//               ),
//
//             if (msg.buttonClicked && msg.selectedDoctorType != null && !msg.paymentCompleted && !msg.showDoctorTypeConfirmation && !msg.showSpecialityConfirmation)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   msg.selectedSpeciality != null ? "Selected: ${msg.selectedDoctorType} - ${msg.selectedSpeciality}" : "Selected: ${msg.selectedDoctorType}",
//                   style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12),
//                 ),
//               ),
//
//             if (msg.createdAt != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text("${msg.createdAt!.hour}:${msg.createdAt!.minute.toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
//               )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loadingHistory || userId == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppColors.iconColor),
//         backgroundColor: AppColors.primary,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text("Health Buddy", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//             if (currentDoctorType != null) ...[
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
//                 child: Text(currentSpeciality ?? currentDoctorType!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ],
//         ),
//         actions: [
//           IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor)),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: AppColors.primary,
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 30),
//               Center(
//                 child: Column(
//                   children: const [
//                     CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/logo.png"), backgroundColor: Colors.white),
//                     SizedBox(height: 10),
//                     Text("HealthBuddy", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//                     Text("info@healthbuddy.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     drawerItem("Home", Icons.home, () => Navigator.pushNamed(context, '/home')),
//                     drawerItem("Doctors", Icons.add, () => Navigator.pushNamed(context, '/doctors')),
//                     drawerItem("Orders", Icons.file_copy_sharp, () => Navigator.pushNamed(context, '/orders')),
//                     drawerItem("Terms & Privacy", Icons.privacy_tip, () => Navigator.pushNamed(context, '/terms')),
//                     drawerItem("Log Out", Icons.logout_sharp, () async {
//                       bool? confirm = await showDialog<bool>(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text("Confirm Logout"),
//                           content: const Text("Are you sure you want to logout?"),
//                           actions: [
//                             TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//                             TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Logout")),
//                           ],
//                         ),
//                       );
//                       if (confirm == true && mounted) {
//                         Navigator.pushReplacementNamed(context, '/login');
//                       }
//                     }),
//                   ],
//                 ),
//               ),
//               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 80),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Made With", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
//                       SizedBox(width: 5),
//                       Icon(Icons.favorite, color: AppColors.textLight, size: 14),
//                       SizedBox(width: 5),
//                       Text("By VSGLogic", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               controller: _scrollController,
//               itemCount: messages.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == 0) return buildIntroCard(context);
//                 final msg = messages[index - 1];
//
//                 bool showDate = false;
//                 if (index == 1) {
//                   showDate = true;
//                 } else {
//                   final prevMsg = messages[index - 2];
//                   if (msg.createdAt != null && prevMsg.createdAt != null) {
//                     showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
//                   }
//                 }
//
//                 return Column(
//                   children: [
//                     if (showDate && msg.createdAt != null)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
//                           child: Text(formatDate(msg.createdAt!), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight)),
//                         ),
//                       ),
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
//                   GestureDetector(
//                     onTap: reportUploadEnabled && !hasUploadedReport ? _navigateToUploadFiles : null,
//                     child: Icon(
//                       Icons.attach_file,
//                       color: reportUploadEnabled && !hasUploadedReport ? AppColors.iconColor : Colors.grey.shade600,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: paymentCompleted ? Colors.white : Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(21),
//                       ),
//                       child: TextField(
//                         controller: _controller,
//                         enabled: paymentCompleted,
//                         keyboardType: TextInputType.multiline,
//                         textInputAction: TextInputAction.newline,
//                         minLines: 1,
//                         maxLines: 4,
//                         decoration: InputDecoration.collapsed(
//                           hintText: paymentCompleted ? "Type your message here" : "Complete payment to chat",
//                         ),
//                         onChanged: (text) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: paymentCompleted
//                         ? () {
//                       if (_controller.text.trim().isNotEmpty) {
//                         _onUserSend(_controller.text.trim());
//                         _controller.clear();
//                       }
//                     }
//                         : null,
//                     child: Icon(Icons.send, color: paymentCompleted ? AppColors.iconColor : Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }