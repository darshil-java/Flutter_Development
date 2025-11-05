// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'helper.dart';
// // import 'package:intl/intl.dart';
// // import 'upload_files.dart';
// // import 'package:open_filex/open_filex.dart';
// // import 'services/chat_service.dart';
// // import 'dart:async';
// // import 'dart:math';
// //
// // String formatDate(DateTime date) {
// //   final now = DateTime.now();
// //   if (isSameDay(date, now)) {
// //     return "Today";
// //   }
// //   return DateFormat.yMMMMd().format(date);
// // }
// //
// // bool isSameDay(DateTime a, DateTime b) {
// //   return a.year == b.year && a.month == b.month && a.day == b.day;
// // }
// //
// // String _formatFileSize(dynamic size) {
// //   if (size == null) return 'Unknown';
// //   final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
// //   if (bytes <= 0) return "0 B";
// //   const suffixes = ["B", "KB", "MB", "GB"];
// //   var i = (log(bytes) / log(1024)).floor();
// //   return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
// // }
// //
// // String _formatMessageTime(DateTime dateTime) {
// //   final localTime = dateTime.toLocal();
// //   final hour = localTime.hour.toString().padLeft(2, '0');
// //   final minute = localTime.minute.toString().padLeft(2, '0');
// //   return '$hour:$minute';
// // }
// //
// // class Message {
// //   final String id;
// //   final String text;
// //   final bool isBot;
// //   final bool showButtons;
// //   final bool buttonClicked;
// //   final DateTime? createdAt;
// //   final String? selectedDoctorType;
// //   final String? selectedSpeciality;
// //   final bool showPaymentButton;
// //   final bool paymentCompleted;
// //   final String? orderId;
// //   final String? paymentId;
// //   final String? orderNumber;
// //   final int? amount;
// //   final bool showReportUploadQuestion;
// //   final bool reportUploadAnswered;
// //   final bool wantsToUploadReport;
// //   final bool showReportUploadButton;
// //   final bool reportUploaded;
// //   final List<Map<String, dynamic>>? reportFiles;
// //   final bool showDoctorTypeConfirmation;
// //   final bool showSpecialityConfirmation;
// //   final String? pendingDoctorType;
// //   final String? pendingSpeciality;
// //   final String? userId;
// //   final String? userName;
// //   final String? assignedDoctorId;
// //   final String? assignedDoctorName;
// //
// //   Message({
// //     required this.id,
// //     required this.text,
// //     required this.isBot,
// //     this.showButtons = false,
// //     this.buttonClicked = false,
// //     this.createdAt,
// //     this.selectedDoctorType,
// //     this.selectedSpeciality,
// //     this.showPaymentButton = false,
// //     this.paymentCompleted = false,
// //     this.orderId,
// //     this.paymentId,
// //     this.orderNumber,
// //     this.amount,
// //     this.showReportUploadQuestion = false,
// //     this.reportUploadAnswered = false,
// //     this.wantsToUploadReport = false,
// //     this.showReportUploadButton = false,
// //     this.reportUploaded = false,
// //     this.reportFiles,
// //     this.showDoctorTypeConfirmation = false,
// //     this.showSpecialityConfirmation = false,
// //     this.pendingDoctorType,
// //     this.pendingSpeciality,
// //     this.userId,
// //     this.userName,
// //     this.assignedDoctorId,
// //     this.assignedDoctorName,
// //   });
// //
// //   factory Message.fromMap(Map<String, dynamic> map) {
// //     final bool buttonClicked = map['buttonClicked'] == true;
// //     final bool showButtonsRaw = map['showButtons'] == true;
// //
// //     int? amount;
// //     if (map['amount'] != null) {
// //       if (map['amount'] is int) {
// //         amount = map['amount'];
// //       } else if (map['amount'] is double) {
// //         amount = (map['amount'] as double).toInt();
// //       } else if (map['amount'] is String) {
// //         amount = int.tryParse(map['amount']);
// //       }
// //     }
// //
// //     String? safeString(String? value) {
// //       return (value == null || value.isEmpty) ? null : value;
// //     }
// //
// //     return Message(
// //       id: map['_id'] ?? map['id'] ?? UniqueKey().toString(),
// //       text: map['text'] ?? "",
// //       isBot: map['isBot'] ?? false,
// //       showButtons: showButtonsRaw && !buttonClicked,
// //       buttonClicked: buttonClicked,
// //       createdAt: map['createdAt'] != null
// //           ? DateTime.tryParse(map['createdAt'].toString())
// //           : DateTime.now(),
// //       selectedDoctorType: safeString(map['selectedDoctorType']),
// //       selectedSpeciality: safeString(map['selectedSpeciality']),
// //       showPaymentButton: map['showPaymentButton'] ?? false,
// //       paymentCompleted: map['paymentCompleted'] ?? false,
// //       orderId: safeString(map['orderId']),
// //       paymentId: safeString(map['paymentId']),
// //       orderNumber: safeString(map['orderNumber']),
// //       amount: amount,
// //       showReportUploadQuestion: map['showReportUploadQuestion'] ?? false,
// //       reportUploadAnswered: map['reportUploadAnswered'] ?? false,
// //       wantsToUploadReport: map['wantsToUploadReport'] ?? false,
// //       showReportUploadButton: map['showReportUploadButton'] ?? false,
// //       reportUploaded: map['reportUploaded'] ?? false,
// //       reportFiles: map['reportFiles'] != null && map['reportFiles'] is List
// //           ? List<Map<String, dynamic>>.from(map['reportFiles'])
// //           : null,
// //       showDoctorTypeConfirmation: map['showDoctorTypeConfirmation'] ?? false,
// //       showSpecialityConfirmation: map['showSpecialityConfirmation'] ?? false,
// //       pendingDoctorType: safeString(map['pendingDoctorType']),
// //       pendingSpeciality: safeString(map['pendingSpeciality']),
// //       userId: safeString(map['userId']),
// //       userName: safeString(map['userName']) ?? 'Care Connect Bot',
// //       assignedDoctorId: safeString(map['assignedDoctorId']),
// //       assignedDoctorName: safeString(map['assignedDoctorName']),
// //     );
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'text': text,
// //       'isBot': isBot,
// //       'showButtons': showButtons,
// //       'buttonClicked': buttonClicked,
// //       'createdAt': createdAt?.toIso8601String(),
// //       'selectedDoctorType': selectedDoctorType,
// //       'selectedSpeciality': selectedSpeciality,
// //       'showPaymentButton': showPaymentButton,
// //       'paymentCompleted': paymentCompleted,
// //       'orderId': orderId,
// //       'paymentId': paymentId,
// //       'orderNumber': orderNumber,
// //       'amount': amount,
// //       'showReportUploadQuestion': showReportUploadQuestion,
// //       'reportUploadAnswered': reportUploadAnswered,
// //       'wantsToUploadReport': wantsToUploadReport,
// //       'showReportUploadButton': showReportUploadButton,
// //       'reportUploaded': reportUploaded,
// //       'reportFiles': reportFiles,
// //       'showDoctorTypeConfirmation': showDoctorTypeConfirmation,
// //       'showSpecialityConfirmation': showSpecialityConfirmation,
// //       'pendingDoctorType': pendingDoctorType,
// //       'pendingSpeciality': pendingSpeciality,
// //       'userId': userId,
// //       'userName': userName,
// //       'assignedDoctorId': assignedDoctorId,
// //       'assignedDoctorName': assignedDoctorName,
// //     };
// //   }
// //
// //   Message copyWith({
// //     String? id,
// //     String? text,
// //     bool? isBot,
// //     bool? showButtons,
// //     bool? buttonClicked,
// //     DateTime? createdAt,
// //     String? selectedDoctorType,
// //     String? selectedSpeciality,
// //     bool? showPaymentButton,
// //     bool? paymentCompleted,
// //     String? orderId,
// //     String? paymentId,
// //     String? orderNumber,
// //     int? amount,
// //     bool? showReportUploadQuestion,
// //     bool? reportUploadAnswered,
// //     bool? wantsToUploadReport,
// //     bool? showReportUploadButton,
// //     bool? reportUploaded,
// //     List<Map<String, dynamic>>? reportFiles,
// //     bool? showDoctorTypeConfirmation,
// //     bool? showSpecialityConfirmation,
// //     String? pendingDoctorType,
// //     String? pendingSpeciality,
// //     String? userId,
// //     String? userName,
// //     String? assignedDoctorId,
// //     String? assignedDoctorName,
// //   }) {
// //     return Message(
// //       id: id ?? this.id,
// //       text: text ?? this.text,
// //       isBot: isBot ?? this.isBot,
// //       showButtons: showButtons ?? this.showButtons,
// //       buttonClicked: buttonClicked ?? this.buttonClicked,
// //       createdAt: createdAt ?? this.createdAt,
// //       selectedDoctorType: selectedDoctorType ?? this.selectedDoctorType,
// //       selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
// //       showPaymentButton: showPaymentButton ?? this.showPaymentButton,
// //       paymentCompleted: paymentCompleted ?? this.paymentCompleted,
// //       orderId: orderId ?? this.orderId,
// //       paymentId: paymentId ?? this.paymentId,
// //       orderNumber: orderNumber ?? this.orderNumber,
// //       amount: amount ?? this.amount,
// //       showReportUploadQuestion: showReportUploadQuestion ?? this.showReportUploadQuestion,
// //       reportUploadAnswered: reportUploadAnswered ?? this.reportUploadAnswered,
// //       wantsToUploadReport: wantsToUploadReport ?? this.wantsToUploadReport,
// //       showReportUploadButton: showReportUploadButton ?? this.showReportUploadButton,
// //       reportUploaded: reportUploaded ?? this.reportUploaded,
// //       reportFiles: reportFiles ?? this.reportFiles,
// //       showDoctorTypeConfirmation: showDoctorTypeConfirmation ?? this.showDoctorTypeConfirmation,
// //       showSpecialityConfirmation: showSpecialityConfirmation ?? this.showSpecialityConfirmation,
// //       pendingDoctorType: pendingDoctorType ?? this.pendingDoctorType,
// //       pendingSpeciality: pendingSpeciality ?? this.pendingSpeciality,
// //       userId: userId ?? this.userId,
// //       userName: userName ?? this.userName,
// //       assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
// //       assignedDoctorName: assignedDoctorName ?? this.assignedDoctorName,
// //     );
// //   }
// // }
// //
// // class HomePage extends StatefulWidget {
// //   final String? orderId;
// //   final bool isExistingOrder;
// //
// //   const HomePage({
// //     super.key,
// //     this.orderId,
// //     this.isExistingOrder = false,
// //   });
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   List<Message> messages = [];
// //   TextEditingController _controller = TextEditingController();
// //   String? userId;
// //   String? userName;
// //   String? userPhone;
// //   String? userEmail;
// //   bool loadingHistory = true;
// //   final ScrollController _scrollController = ScrollController();
// //   String? currentDoctorType;
// //   String? currentSpeciality;
// //   String? currentOrderId;
// //   bool paymentCompleted = false;
// //   bool reportUploadEnabled = false;
// //   bool hasUploadedReport = false;
// //   late Razorpay _razorpay;
// //   String? assignedDoctorName;
// //   String? assignedDoctorSpeciality;
// //
// //   // Session end variables
// //   bool _isSessionEnded = false;
// //   Timer? _statusCheckTimer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //     _loadUserId();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _statusCheckTimer?.cancel();
// //     _razorpay.clear();
// //     _controller.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   // Session end detection methods
// //   void _startOrderStatusListener() {
// //     if (currentOrderId == null) {
// //       print('❌ Cannot start order status listener: currentOrderId is null');
// //       return;
// //     }
// //
// //     if (_isSessionEnded) {
// //       print('❌ Cannot start order status listener: session already ended');
// //       return;
// //     }
// //
// //     print('🔍 Starting order status listener for: $currentOrderId');
// //
// //     // Cancel existing timer if any
// //     _statusCheckTimer?.cancel();
// //
// //     // Check immediately first
// //     _checkOrderStatus();
// //
// //     // Then check every 5 seconds
// //     _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
// //       print('⏰ Timer tick - checking order status...');
// //       _checkOrderStatus();
// //     });
// //   }
// //
// //   Future<void> _checkOrderStatus() async {
// //     if (currentOrderId == null || _isSessionEnded) {
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Checking order status for: $currentOrderId');
// //
// //       final response = await http.get(
// //         Uri.parse(ApiConfig.getOrderStatus(currentOrderId!)),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final order = data['data'];
// //           final status = order['status']?.toString().toLowerCase();
// //
// //           print('📊 Current order status: $status');
// //
// //           if (status == 'completed') {
// //             print('🎯 Session ended by doctor, resetting chat...');
// //             _handleSessionEndedByDoctor();
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       print('❌ Error checking order status: $e');
// //     }
// //   }
// //
// //   void _handleSessionEndedByDoctor() async {
// //     if (_isSessionEnded) return;
// //
// //     setState(() {
// //       _isSessionEnded = true;
// //     });
// //
// //     // Stop the timer
// //     _statusCheckTimer?.cancel();
// //
// //     try {
// //       print('🎯 Calling backend to complete order: $currentOrderId');
// //
// //       final response = await http.put(
// //         Uri.parse('${ApiConfig.baseUrl}/completeOrder/$currentOrderId'),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "status": "completed",
// //           "completedBy": "Doctor",
// //           "resetChat": true
// //         }),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           print('✅ Order successfully completed on backend');
// //         } else {
// //           print('❌ Failed to complete order on backend: ${data['message']}');
// //         }
// //       } else {
// //         print('❌ Error completing order: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Error calling completeOrder API: $e');
// //     }
// //
// //     // Show session ended message
// //     final sessionEndedMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Your consultation session has been completed by the doctor. Thank you for using Care Connect! Starting a new chat session...",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages.add(sessionEndedMsg);
// //     });
// //
// //     _scrollToBottom();
// //
// //     // Show notification
// //     Helpers.showSnackBar(
// //         context,
// //         "Session completed by doctor - Starting new chat",
// //         bgColor: Colors.orange
// //     );
// //
// //     // Wait 3 seconds then reset the chat
// //     await Future.delayed(const Duration(seconds: 3));
// //     _resetChatToBeginning();
// //   }
// //
// //   void _resetChatToBeginning() async {
// //     print('🔄 Resetting chat to beginning...');
// //
// //     try {
// //       // Store the completed order ID before clearing
// //       final completedOrderId = currentOrderId;
// //
// //       // Clear current state COMPLETELY
// //       setState(() {
// //         messages.clear();
// //         currentDoctorType = null;
// //         currentSpeciality = null;
// //         paymentCompleted = false;
// //         reportUploadEnabled = false;
// //         hasUploadedReport = false;
// //         assignedDoctorName = null;
// //         assignedDoctorSpeciality = null;
// //         currentOrderId = null; // This ensures new order will be created
// //         _isSessionEnded = false;
// //         _controller.clear();
// //       });
// //
// //       // Stop any existing timers
// //       _statusCheckTimer?.cancel();
// //
// //       print('✅ Local state cleared for order: $completedOrderId');
// //
// //       // Re-initialize a FRESH chat with new order
// //       await _initializeNewChat();
// //
// //       print('✅ New chat session started successfully');
// //
// //       Helpers.showSnackBar(
// //         context,
// //         "New chat session started!",
// //         bgColor: Colors.green,
// //       );
// //
// //     } catch (e) {
// //       print('❌ Error resetting chat: $e');
// //       _createFallbackMessages();
// //     }
// //   }
// //
// //   bool _isOrderCompleted(List messagesData) {
// //     if (messagesData.isEmpty) return false;
// //
// //     for (var msg in messagesData) {
// //       if (msg['text'] != null) {
// //         String text = msg['text'].toString();
// //
// //         if (text.contains("Your consultation session has been completed by the doctor") &&
// //             text.contains("Starting a new chat session")) {
// //           print('🎯 Found explicit session end message - session is completed');
// //           return true;
// //         }
// //       }
// //     }
// //
// //     print('💬 No explicit session end found - preserving chat');
// //     return false;
// //   }
// //
// //   bool _isChatTrulyCompleted(List messagesData) {
// //     if (messagesData.isEmpty) return false;
// //
// //     bool hasPaymentCompletion = false;
// //     bool hasActiveChatPrompt = false;
// //     bool hasSessionEndMessage = false;
// //
// //     final recentMessages = messagesData.length > 5
// //         ? messagesData.sublist(messagesData.length - 5)
// //         : messagesData;
// //
// //     for (var msg in recentMessages.reversed) {
// //       if (msg['text'] != null) {
// //         String text = msg['text'].toString().toLowerCase();
// //
// //         if (text.contains("payment successful") ||
// //             text.contains("payment completed")) {
// //           hasPaymentCompletion = true;
// //         }
// //
// //         if (text.contains("how can we help") ||
// //             text.contains("start chatting") ||
// //             text.contains("upload reports") ||
// //             text.contains("assigned to your case")) {
// //           hasActiveChatPrompt = true;
// //         }
// //
// //         if (text.contains("session completed") ||
// //             text.contains("thank you for using Care Connect") ||
// //             text.contains("starting new chat")) {
// //           hasSessionEndMessage = true;
// //         }
// //       }
// //
// //       if (msg['paymentCompleted'] == true) {
// //         hasPaymentCompletion = true;
// //       }
// //     }
// //
// //     if (hasSessionEndMessage) {
// //       return true;
// //     }
// //
// //     if (hasPaymentCompletion && !hasActiveChatPrompt) {
// //       return _isFreshPaymentWithoutChat(messagesData);
// //     }
// //
// //     return false;
// //   }
// //
// //   bool _isFreshPaymentWithoutChat(List messagesData) {
// //     int paymentCompletionIndex = -1;
// //
// //     for (int i = messagesData.length - 1; i >= 0; i--) {
// //       if (messagesData[i]['paymentCompleted'] == true ||
// //           (messagesData[i]['text'] != null &&
// //               messagesData[i]['text'].toString().toLowerCase().contains("payment successful"))) {
// //         paymentCompletionIndex = i;
// //         break;
// //       }
// //     }
// //
// //     if (paymentCompletionIndex == -1) return false;
// //
// //     for (int i = paymentCompletionIndex + 1; i < messagesData.length; i++) {
// //       var msg = messagesData[i];
// //
// //       if (msg['isBot'] == false && msg['text'] != null && msg['text'].toString().trim().isNotEmpty) {
// //         return false;
// //       }
// //
// //       if (msg['isBot'] == true && msg['text'] != null) {
// //         String text = msg['text'].toString().toLowerCase();
// //         if (text.contains("how can we help") ||
// //             text.contains("start chatting") ||
// //             text.contains("upload reports")) {
// //           return false;
// //         }
// //       }
// //     }
// //
// //     return true;
// //   }
// //
// //   Future<int?> getDynamicConsultationFee(String doctorType, String speciality) async {
// //     try {
// //       print('🔄 Getting dynamic fee for: $doctorType - $speciality');
// //
// //       final response = await http.get(
// //         Uri.parse('${ApiConfig.baseUrl}/api/consultation-fee?doctorType=$doctorType&speciality=${Uri.encodeComponent(speciality)}'),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final estimatedFee = data['data']['estimatedFee'] as int;
// //           print('💰 Dynamic fee received: ₹$estimatedFee');
// //           return estimatedFee;
// //         }
// //       }
// //
// //       print('⚠ Using fallback fee');
// //       const fallbackPricing = {
// //         'Allopathy': 500,
// //         'Ayurvedic': 300,
// //         'Homeopathy': 200
// //       };
// //       return fallbackPricing[doctorType] ?? 300;
// //     } catch (e) {
// //       print('❌ Error getting dynamic fee: $e');
// //       const fallbackPricing = {
// //         'Allopathy': 500,
// //         'Ayurvedic': 300,
// //         'Homeopathy': 200
// //       };
// //       return fallbackPricing[doctorType] ?? 300;
// //     }
// //   }
// //
// //   Future<void> _loadUserId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final storedUserId = prefs.getString('userId');
// //     final storedUserName = prefs.getString('fullName') ?? 'User';
// //     final storedUserPhone = prefs.getString('phone') ?? '';
// //     final storedUserEmail = prefs.getString('email') ?? '';
// //
// //     if (storedUserId == null) {
// //       if (mounted) {
// //         Navigator.pushReplacementNamed(context, '/login');
// //       }
// //       return;
// //     }
// //
// //     setState(() {
// //       userId = storedUserId;
// //       userName = storedUserName;
// //       userPhone = storedUserPhone;
// //       userEmail = storedUserEmail;
// //
// //       if (widget.isExistingOrder && widget.orderId != null) {
// //         currentOrderId = widget.orderId;
// //         print('🔄 Loading existing order: ${widget.orderId}');
// //       }
// //     });
// //
// //     await _loadChatHistoryOrInitialize();
// //   }
// //
// //   Future<void> _loadChatHistoryOrInitialize() async {
// //     if (userId == null) {
// //       print('❌ User ID is null');
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Loading chat history from backend...');
// //
// //       String url = "${ApiConfig.chatHistory}?userId=$userId";
// //
// //       if (widget.isExistingOrder && currentOrderId != null && currentOrderId!.isNotEmpty) {
// //         url += "&orderId=$currentOrderId";
// //         print('📝 Loading existing order: $currentOrderId');
// //       }
// //
// //       final response = await http.get(Uri.parse(url));
// //
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         List messagesData = decoded['data']['messages'] as List? ?? [];
// //
// //         if (messagesData.isEmpty) {
// //           print('📂 No messages found, initializing new chat...');
// //           await _initializeNewChat();
// //           return;
// //         }
// //
// //         print('📥 Loaded ${messagesData.length} messages from backend');
// //
// //         final loadedMessages = messagesData.map((msg) {
// //           try {
// //             return Message.fromMap(msg);
// //           } catch (e) {
// //             print('❌ Error parsing message: $e - $msg');
// //             return Message(
// //               id: UniqueKey().toString(),
// //               text: msg['text']?.toString() ?? 'Error loading message',
// //               isBot: msg['isBot'] ?? false,
// //               createdAt: DateTime.now(),
// //               userId: userId,
// //               userName: msg['userName']?.toString() ?? 'Unknown',
// //             );
// //           }
// //         }).toList();
// //
// //         bool restoredPaymentCompleted = false;
// //         bool restoredReportUploadEnabled = false;
// //         bool restoredHasUploadedReport = false;
// //         String? restoredAssignedDoctorName;
// //         String? restoredCurrentDoctorType;
// //         String? restoredCurrentSpeciality;
// //         String? restoredCurrentOrderId;
// //         bool restoredIsSessionEnded = false;
// //
// //         for (var msg in loadedMessages) {
// //           if (msg.selectedDoctorType != null && msg.selectedDoctorType!.isNotEmpty) {
// //             restoredCurrentDoctorType = msg.selectedDoctorType;
// //           }
// //           if (msg.selectedSpeciality != null && msg.selectedSpeciality!.isNotEmpty) {
// //             restoredCurrentSpeciality = msg.selectedSpeciality;
// //           }
// //           if (msg.orderId != null && msg.orderId!.isNotEmpty) {
// //             restoredCurrentOrderId = msg.orderId;
// //           }
// //           if (msg.paymentCompleted == true) {
// //             restoredPaymentCompleted = true;
// //             print('💰 Found payment completed message');
// //           }
// //           if (msg.wantsToUploadReport == true) {
// //             restoredReportUploadEnabled = true;
// //             print('📤 Found wants to upload report message');
// //           }
// //           if (msg.reportUploaded == true) {
// //             restoredHasUploadedReport = true;
// //             print('✅ Found report uploaded message');
// //           }
// //           if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty) {
// //             restoredAssignedDoctorName = msg.assignedDoctorName;
// //           }
// //
// //           if (msg.text.contains("Your consultation session has been completed by the doctor") &&
// //               msg.text.contains("Starting a new chat session")) {
// //             restoredIsSessionEnded = true;
// //             print('🔍 Found session end message in history');
// //           }
// //         }
// //
// //         if (restoredPaymentCompleted && !restoredReportUploadEnabled) {
// //           for (var msg in loadedMessages.reversed) {
// //             if (msg.showReportUploadQuestion || msg.reportUploadAnswered) {
// //               restoredReportUploadEnabled = true;
// //               print('🔄 Detected report upload flow from messages');
// //               break;
// //             }
// //           }
// //         }
// //
// //         if (restoredPaymentCompleted && !restoredHasUploadedReport) {
// //           bool userDeclinedUpload = false;
// //           for (var msg in loadedMessages) {
// //             if (msg.isBot == false && msg.text.toLowerCase().contains("no, i don't need to upload reports")) {
// //               userDeclinedUpload = true;
// //               break;
// //             }
// //           }
// //
// //           if (!userDeclinedUpload) {
// //             restoredReportUploadEnabled = true;
// //             print('🔧 Auto-enabling upload for paid session');
// //           }
// //         }
// //
// //         setState(() {
// //           messages = loadedMessages;
// //           currentDoctorType = restoredCurrentDoctorType;
// //           currentSpeciality = restoredCurrentSpeciality;
// //           currentOrderId = restoredCurrentOrderId;
// //           paymentCompleted = restoredPaymentCompleted;
// //           reportUploadEnabled = restoredReportUploadEnabled;
// //           hasUploadedReport = restoredHasUploadedReport;
// //           assignedDoctorName = restoredAssignedDoctorName;
// //           _isSessionEnded = restoredIsSessionEnded;
// //           loadingHistory = false;
// //         });
// //
// //         print('🔄 State restored from chat history:');
// //         print('   - Messages: ${messages.length}');
// //         print('   - paymentCompleted: $paymentCompleted');
// //         print('   - reportUploadEnabled: $reportUploadEnabled');
// //         print('   - hasUploadedReport: $hasUploadedReport');
// //         print('   - currentOrderId: $currentOrderId');
// //         print('   - isSessionEnded: $_isSessionEnded');
// //
// //         if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
// //           print('🔍 Starting order status listener for active session');
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             _startOrderStatusListener();
// //           });
// //         }
// //
// //       } else {
// //         print('❌ HTTP error: ${response.statusCode}');
// //         await _initializeNewChat();
// //       }
// //     } catch (e) {
// //       print('❌ Error loading chat history: $e');
// //       await _initializeNewChat();
// //     }
// //
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _initializeNewChat() async {
// //     try {
// //       print('🔄 Initializing new chat...');
// //
// //       final response = await ChatService.initializeChat(
// //         userId: userId!,
// //         userName: userName ?? 'User',
// //         userPhone: userPhone,
// //         userEmail: userEmail,
// //         orderId: currentOrderId,
// //       );
// //
// //       if (response['success'] == true) {
// //         final messagesData = response['data']['messages'] as List? ?? [];
// //         print('📥 Initialized with ${messagesData.length} messages');
// //
// //         final initialMessages = messagesData.map((msg) => Message.fromMap(msg)).toList();
// //
// //         setState(() {
// //           messages = initialMessages;
// //           loadingHistory = false;
// //         });
// //
// //         if (initialMessages.isNotEmpty && initialMessages.first.orderId != null) {
// //           currentOrderId = initialMessages.first.orderId;
// //           print('📝 Set currentOrderId: $currentOrderId');
// //         }
// //       } else {
// //         throw Exception('Backend returned success: false');
// //       }
// //     } catch (e) {
// //       print('❌ Error initializing chat: $e');
// //       _createFallbackMessages();
// //     }
// //   }
// //
// //   void _createFallbackMessages() {
// //     final welcome = Message(
// //       id: UniqueKey().toString(),
// //       text: "Hello! Welcome to Care Connect. We provide professional doctor consultations from the comfort of your home.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     final question = Message(
// //       id: UniqueKey().toString(),
// //       text: "Would you like to receive a second opinion from a specialist?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages = [welcome, question];
// //       loadingHistory = false;
// //     });
// //
// //     print('📝 Using fallback local messages');
// //   }
// //
// //   Future<void> sendMessage(Message message) async {
// //     try {
// //       await _sendMessageToBackend(message);
// //     } catch (e) {
// //       print("Error sending message to backend: $e");
// //     }
// //   }
// //
// //   Future<void> _sendMessageToBackend(Message message) async {
// //     if (userId == null) {
// //       print('❌ Cannot send message: User ID is null');
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Sending message to backend: ${message.text}');
// //
// //       final response = await ChatService.sendMessage(
// //         userId: userId!,
// //         message: message.text,
// //         userName: userName ?? 'User',
// //         userPhone: userPhone,
// //         userEmail: userEmail,
// //         doctorType: message.selectedDoctorType ?? currentDoctorType ?? '',
// //         speciality: message.selectedSpeciality ?? currentSpeciality ?? '',
// //         orderId: message.orderId ?? currentOrderId ?? '',
// //         paymentCompleted: message.paymentCompleted || paymentCompleted,
// //       );
// //
// //       print('✅ Message sent to backend successfully');
// //
// //       if (!message.isBot && paymentCompleted && response['success'] == true) {
// //         final botResponse = response['data']['botResponse'];
// //         if (botResponse != null) {
// //           print('🤖 Received bot response');
// //           final botMessage = Message.fromMap(botResponse);
// //           setState(() {
// //             messages.add(botMessage);
// //           });
// //           _scrollToBottom();
// //         } else {
// //           print('ℹ No bot response received');
// //         }
// //       }
// //     } catch (e) {
// //       print('❌ Failed to send message to backend: $e');
// //     }
// //   }
// //
// //   void _onUserSend(String text) async {
// //     if (text.trim().isEmpty) return;
// //     if (!paymentCompleted) {
// //       Helpers.showSnackBar(context, "Please complete payment before sending messages", bgColor: Colors.red);
// //       return;
// //     }
// //     if (_isSessionEnded) {
// //       Helpers.showSnackBar(context, "Session completed - cannot send messages", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     final userMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: text,
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages.add(userMsg);
// //     });
// //
// //     await sendMessage(userMsg);
// //     _controller.clear();
// //     _scrollToBottom();
// //   }
// //
// //   void _onYesButtonPressed(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, I would like a second opinion.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final doctorTypeQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your preferred doctor type:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(doctorTypeQuestion);
// //     });
// //
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(doctorTypeQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   void _onDoctorTypeSelected(Message questionMsg, String doctorType) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       pendingDoctorType: doctorType,
// //     );
// //     final confirmationMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "You selected $doctorType. Would you like to confirm this selection?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       showDoctorTypeConfirmation: true,
// //       pendingDoctorType: doctorType,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(confirmationMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(confirmationMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onDoctorTypeConfirmYes(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final doctorType = confirmMsg.pendingDoctorType!;
// //     final updatedMsg = confirmMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       selectedDoctorType: doctorType,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, confirmed $doctorType",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: doctorType,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       currentDoctorType = doctorType;
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //
// //     if (doctorType == 'Allopathy') {
// //       await _loadSpecializations(doctorType);
// //     } else {
// //       final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //       final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
// //
// //       final paymentMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: doctorType,
// //         selectedSpeciality: defaultSpeciality,
// //         showPaymentButton: true,
// //         amount: amount,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //       setState(() {
// //         currentSpeciality = defaultSpeciality;
// //         messages.add(paymentMsg);
// //       });
// //       await sendMessage(paymentMsg);
// //     }
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _loadSpecializations(String doctorType) async {
// //     try {
// //       print('🔄 Loading specializations for $doctorType...');
// //
// //       final response = await http.get(
// //         Uri.parse('${ApiConfig.baseUrl}/api/patients/doctors/specializations/$doctorType'),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final specializations = List<String>.from(data['data']['specializations']);
// //
// //           if (specializations.isNotEmpty) {
// //             final specialityQuestion = Message(
// //               id: UniqueKey().toString(),
// //               text: "Please select your doctor's speciality:",
// //               isBot: true,
// //               showButtons: true,
// //               buttonClicked: false,
// //               createdAt: DateTime.now(),
// //               selectedDoctorType: doctorType,
// //               userId: userId,
// //               userName: 'Care Connect Bot',
// //             );
// //
// //             setState(() {
// //               messages.add(specialityQuestion);
// //             });
// //             await sendMessage(specialityQuestion);
// //           } else {
// //             _proceedToPayment(doctorType);
// //           }
// //         }
// //       } else {
// //         throw Exception('Failed to load specializations');
// //       }
// //     } catch (e) {
// //       print('❌ Error loading specializations: $e');
// //       if (doctorType == 'Allopathy') {
// //         _showDefaultSpecializations(doctorType);
// //       } else {
// //         _proceedToPayment(doctorType);
// //       }
// //     }
// //   }
// //
// //   void _showDefaultSpecializations(String doctorType) {
// //     List<String> specializations = [];
// //
// //     if (doctorType == 'Allopathy') {
// //       specializations = ['MBBS', 'MD', 'Cardiologist', 'Dermatologist', 'Orthopedic', 'Pediatrician', 'Gynecologist', 'Neurologist', 'Psychiatrist'];
// //     }
// //
// //     if (specializations.isNotEmpty) {
// //       final specialityQuestion = Message(
// //         id: UniqueKey().toString(),
// //         text: "Please select your doctor's speciality:",
// //         isBot: true,
// //         showButtons: true,
// //         buttonClicked: false,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: doctorType,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(specialityQuestion);
// //       });
// //     } else {
// //       _proceedToPayment(doctorType);
// //     }
// //   }
// //
// //   void _proceedToPayment(String doctorType) async {
// //     final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //     final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
// //
// //     final paymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: doctorType,
// //       selectedSpeciality: defaultSpeciality,
// //       showPaymentButton: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       currentSpeciality = defaultSpeciality;
// //       messages.add(paymentMsg);
// //     });
// //     sendMessage(paymentMsg);
// //   }
// //
// //   void _onDoctorTypeConfirmNo(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, let me choose again",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final doctorTypeQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your preferred doctor type:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(doctorTypeQuestion);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(doctorTypeQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialitySelected(Message questionMsg, String speciality) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       pendingSpeciality: speciality,
// //     );
// //     final confirmationMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "You selected $speciality. Would you like to confirm this speciality?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       showSpecialityConfirmation: true,
// //       pendingSpeciality: speciality,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(confirmationMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(confirmationMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialityConfirmYes(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final speciality = confirmMsg.pendingSpeciality!;
// //     final updatedMsg = confirmMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       selectedSpeciality: speciality,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, confirmed $speciality",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: speciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     final amount = await getDynamicConsultationFee(currentDoctorType!, speciality) ?? 500;
// //
// //     final paymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Excellent! You've selected $speciality specialist. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: speciality,
// //       showPaymentButton: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       currentSpeciality = speciality;
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(paymentMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(paymentMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialityConfirmNo(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, let me choose again",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final specialityQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your doctor's speciality:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(specialityQuestion);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(specialityQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onPaymentButtonPressed(Message paymentMsg) async {
// //     final index = messages.indexWhere((m) => m.id == paymentMsg.id);
// //     if (index == -1) return;
// //     if (paymentCompleted) {
// //       Helpers.showSnackBar(context, "Payment already completed", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     final updatedPaymentMsg = paymentMsg.copyWith(buttonClicked: true, showPaymentButton: true);
// //     final userPaymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Proceeding to payment...",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedPaymentMsg;
// //       messages.add(userPaymentMsg);
// //     });
// //     await sendMessage(updatedPaymentMsg);
// //     await sendMessage(userPaymentMsg);
// //     _scrollToBottom();
// //
// //     String doctorCategory = currentSpeciality ?? currentDoctorType ?? "General";
// //     int amount = paymentMsg.amount ?? 500;
// //     createOrder(amount, doctorCategory);
// //   }
// //
// //   Future<void> createOrder(int amount, String doctorCategory) async {
// //     try {
// //       if (userId == null) {
// //         Helpers.showSnackBar(context, "User ID not found! Please login again.");
// //         return;
// //       }
// //
// //       if (currentDoctorType == null || currentDoctorType!.isEmpty) {
// //         Helpers.showSnackBar(context, "Please select a doctor type first");
// //         return;
// //       }
// //
// //       String finalSpeciality = currentSpeciality ?? '';
// //       if ((currentDoctorType == 'Ayurvedic' || currentDoctorType == 'Homeopathy') &&
// //           (finalSpeciality.isEmpty)) {
// //         finalSpeciality = currentDoctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //         setState(() {
// //           currentSpeciality = finalSpeciality;
// //         });
// //         print('🔄 Set default speciality for ${currentDoctorType}: $finalSpeciality');
// //       }
// //
// //       if (finalSpeciality.isEmpty) {
// //         Helpers.showSnackBar(context, "Please select a speciality first");
// //         return;
// //       }
// //
// //       print('🔄 Creating order for doctor: $currentDoctorType, speciality: $finalSpeciality');
// //       print('🔍 Sending data:');
// //       print('   - UserId: $userId');
// //       print('   - userName: $userName');
// //       print('   - doctorType: $currentDoctorType');
// //       print('   - speciality: $finalSpeciality');
// //
// //       var response = await http.post(
// //         Uri.parse(ApiConfig.orders),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "UserId": userId,
// //           "userName": userName ?? 'User',
// //           "userPhone": userPhone ?? '',
// //           "userEmail": userEmail ?? '',
// //           "doctorType": currentDoctorType,
// //           "speciality": finalSpeciality,
// //           "currency": "INR",
// //         }),
// //       );
// //
// //       print('📥 Order creation response: ${response.statusCode}');
// //       print('📥 Response body: ${response.body}');
// //
// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(response.body);
// //         if (data['success'] == true && data['data'] != null) {
// //           String? orderId;
// //           String? razorpayOrderId;
// //           int? actualAmount;
// //
// //           if (data['data']['orderId'] != null) {
// //             orderId = data['data']['orderId'].toString();
// //           } else if (data['data']['id'] != null) {
// //             orderId = data['data']['id'].toString();
// //           }
// //
// //           if (data['data']['razorpayOrderId'] != null) {
// //             razorpayOrderId = data['data']['razorpayOrderId'].toString();
// //           } else if (data['data']['order_id'] != null) {
// //             razorpayOrderId = data['data']['order_id'].toString();
// //           }
// //
// //           if (data['data']['amount'] != null) {
// //             actualAmount = data['data']['amount'] is int
// //                 ? data['data']['amount']
// //                 : (data['data']['amount'] as double).toInt();
// //             print('💰 Backend calculated amount: ₹$actualAmount');
// //           }
// //
// //           if (orderId != null) {
// //             setState(() {
// //               currentOrderId = orderId;
// //             });
// //
// //             String finalRazorpayOrderId = razorpayOrderId ?? orderId;
// //
// //             print('✅ Order created successfully: $currentOrderId');
// //             print('🔑 Razorpay Order ID: $finalRazorpayOrderId');
// //             print('💰 Amount to pay: ₹$actualAmount');
// //
// //             _updatePaymentMessageWithActualAmount(actualAmount ?? amount);
// //
// //             openCheckout(actualAmount ?? amount, doctorCategory, finalRazorpayOrderId);
// //           } else {
// //             Helpers.showSnackBar(context, "Order created but no order ID returned");
// //           }
// //         } else {
// //           Helpers.showSnackBar(context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
// //         }
// //       } else if (response.statusCode == 400) {
// //         var data = jsonDecode(response.body);
// //         Helpers.showSnackBar(context, "Validation error: ${data['message'] ?? 'Check your inputs'}");
// //       } else {
// //         Helpers.showSnackBar(context, "Doctor Not Available.....");
// //       }
// //     } catch (e) {
// //       print('❌ Order creation error: $e');
// //       Helpers.showSnackBar(context, "Network error: $e");
// //     }
// //   }
// //
// //   void _updatePaymentMessageWithActualAmount(int actualAmount) {
// //     for (int i = messages.length - 1; i >= 0; i--) {
// //       if (messages[i].showPaymentButton && !messages[i].paymentCompleted) {
// //         setState(() {
// //           messages[i] = messages[i].copyWith(
// //             amount: actualAmount,
// //             text: "Great! You've selected ${currentDoctorType} - ${currentSpeciality}. Consultation fee: ₹$actualAmount. Please proceed with payment to start your consultation.",
// //           );
// //         });
// //         break;
// //       }
// //     }
// //   }
// //
// //   Future<void> openCheckout(int amount, String doctorCategory, String razorpayOrderId) async {
// //     var options = {
// //       'key': 'rzp_test_vDQGr1D5EBRubo',
// //       'amount': amount * 100,
// //       'name': 'Care Connect',
// //       'description': 'Consultation Fee - $doctorCategory',
// //       'order_id': razorpayOrderId,
// //       'prefill': {
// //         'contact': userPhone ?? '9999999999',
// //         'email': userEmail ?? 'user@example.com',
// //         'name': userName ?? 'User',
// //       },
// //       'theme': {'color': '#00796B'},
// //       'retry': {'enabled': true, 'max_count': 1},
// //       'timeout': 300,
// //     };
// //
// //     try {
// //       print('💰 Opening Razorpay checkout with options: $options');
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint("❌ Error opening Razorpay: $e");
// //       Helpers.showSnackBar(context, "Error opening payment gateway: $e");
// //     }
// //   }
// //
// //   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
// //     try {
// //       print('✅ Payment successful:');
// //       print('   Order ID: ${response.orderId}');
// //       print('   Payment ID: ${response.paymentId}');
// //       print('   Signature: ${response.signature}');
// //
// //       Helpers.showSnackBar(context, "Verifying payment...", bgColor: Colors.orange);
// //
// //       var verifyResponse = await http.post(
// //         Uri.parse(ApiConfig.verifyPayment),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "razorpay_order_id": response.orderId,
// //           "razorpay_payment_id": response.paymentId,
// //           "razorpay_signature": response.signature,
// //           "userId": userId,
// //           "userName": userName,
// //           "userPhone": userPhone,
// //           "userEmail": userEmail,
// //           "orderId": currentOrderId,
// //           "doctorType": currentDoctorType,
// //           "speciality": currentSpeciality,
// //           "amount": getAmountFromMessages() ?? 500,
// //         }),
// //       );
// //
// //       print('📥 Verification response: ${verifyResponse.statusCode}');
// //       print('📥 Verification body: ${verifyResponse.body}');
// //
// //       var verifyData = jsonDecode(verifyResponse.body);
// //
// //       if (verifyData['success'] == true) {
// //         await _handleSuccessfulPayment(response, verifyData);
// //       } else {
// //         Helpers.showSnackBar(
// //             context,
// //             "Payment verification failed: ${verifyData['message'] ?? 'Unknown error'}",
// //             bgColor: Colors.red
// //         );
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Verification error: $e");
// //       Helpers.showSnackBar(context, "Payment verification error: $e", bgColor: Colors.red);
// //     }
// //   }
// //
// //   int? getAmountFromMessages() {
// //     for (int i = messages.length - 1; i >= 0; i--) {
// //       if (messages[i].amount != null) {
// //         return messages[i].amount;
// //       }
// //     }
// //     return null;
// //   }
// //
// //   Future<void> _handleSuccessfulPayment(PaymentSuccessResponse response, Map<String, dynamic> verifyData) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     int currentOrderCount = prefs.getInt('orderCount') ?? 0;
// //     currentOrderCount++;
// //     await prefs.setInt('orderCount', currentOrderCount);
// //     String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');
// //
// //     setState(() {
// //       paymentCompleted = true;
// //     });
// //
// //     final amount = getAmountFromMessages() ?? 500;
// //
// //     final paymentSuccessMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Payment successful and verified! ✅",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       orderId: currentOrderId,
// //       paymentId: response.paymentId,
// //       orderNumber: displayOrderNo,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     final amountMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "₹$amount has been successfully processed for Order #$displayOrderNo",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       paymentCompleted: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages.add(paymentSuccessMsg);
// //       messages.add(amountMsg);
// //     });
// //
// //     await sendMessage(paymentSuccessMsg);
// //     await sendMessage(amountMsg);
// //
// //     await _handleDoctorAssignment(verifyData);
// //
// //     print('💰 Payment completed, starting session end listener...');
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _startOrderStatusListener();
// //     });
// //
// //     await _askReportUploadQuestion();
// //     _scrollToBottom();
// //
// //     Helpers.showSnackBar(
// //         context,
// //         "Payment successful! Order #$displayOrderNo created.",
// //         bgColor: AppColors.accent
// //     );
// //   }
// //
// //   Future<void> _handleDoctorAssignment(Map<String, dynamic> verifyData) async {
// //     if (verifyData['data']['assignedDoctor'] != null) {
// //       final assignedDoctor = verifyData['data']['assignedDoctor'];
// //       setState(() {
// //         assignedDoctorName = assignedDoctor['name'];
// //         assignedDoctorSpeciality = assignedDoctor['speciality'];
// //       });
// //
// //       final doctorAssignmentMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Great news! Dr. ${assignedDoctor['name']} (${assignedDoctor['speciality']}) has been assigned to your case. They will connect with you shortly.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         paymentCompleted: true,
// //         assignedDoctorId: assignedDoctor['id'],
// //         assignedDoctorName: assignedDoctor['name'],
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(doctorAssignmentMsg);
// //       });
// //       await sendMessage(doctorAssignmentMsg);
// //     } else {
// //       final waitingMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Payment successful! We're finding the best ${currentSpeciality} ${currentDoctorType} doctor for you. You'll be notified when a doctor is assigned.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         paymentCompleted: true,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(waitingMsg);
// //       });
// //       await sendMessage(waitingMsg);
// //     }
// //   }
// //
// //   Future<void> _askReportUploadQuestion() async {
// //     final reportQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Would you like to upload any medical reports for the doctor to review?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       showReportUploadQuestion: true,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       messages.add(reportQuestion);
// //     });
// //     await sendMessage(reportQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onReportUploadYes(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       reportUploadAnswered: true,
// //       wantsToUploadReport: true,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, I would like to upload reports.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final uploadInstruction = Message(
// //       id: UniqueKey().toString(),
// //       text: "Great! You can now upload your medical reports using the clip icon next to the message input field.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       showReportUploadButton: true,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(uploadInstruction);
// //       reportUploadEnabled = true;
// //       hasUploadedReport = false;
// //     });
// //
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(uploadInstruction);
// //
// //     final chatEnableMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: assignedDoctorName != null
// //           ? "You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
// //           : "You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       assignedDoctorName: assignedDoctorName,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages.add(chatEnableMsg);
// //     });
// //
// //     await sendMessage(chatEnableMsg);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onReportUploadNo(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       reportUploadAnswered: true,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, I don't need to upload reports right now.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final chatEnableMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: assignedDoctorName != null
// //           ? "No problem! You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
// //           : "No problem! You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       assignedDoctorName: assignedDoctorName,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(chatEnableMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(chatEnableMsg);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _navigateToUploadFiles() async {
// //     if (!reportUploadEnabled) {
// //       Helpers.showSnackBar(context, "Please complete payment and confirm report upload first", bgColor: Colors.orange);
// //       return;
// //     }
// //     if (hasUploadedReport) {
// //       Helpers.showSnackBar(context, "You have already uploaded reports. Upload is allowed only once.", bgColor: Colors.orange);
// //       return;
// //     }
// //     if (_isSessionEnded) {
// //       Helpers.showSnackBar(context, "Session completed - cannot upload files", bgColor: Colors.orange);
// //       return;
// //     }
// //     if (currentOrderId == null) {
// //       Helpers.showSnackBar(context, "No active order found", bgColor: Colors.red);
// //       return;
// //     }
// //
// //     print('📤 Navigating to upload with orderId: $currentOrderId, userId: $userId');
// //
// //     final result = await Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => UploadFiles(
// //         orderId: currentOrderId!,
// //         userId: userId!,
// //       )),
// //     );
// //
// //     if (result != null && result is Map<String, dynamic> && result['status'] == 'uploaded') {
// //       List<Map<String, dynamic>> uploadedReports = List<Map<String, dynamic>>.from(result['reports']);
// //
// //       final uploadSuccessMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Medical reports uploaded successfully! ✅\nTotal files: ${uploadedReports.length}",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         reportUploaded: true,
// //         reportFiles: uploadedReports,
// //         assignedDoctorName: assignedDoctorName,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(uploadSuccessMsg);
// //         hasUploadedReport = true;
// //       });
// //
// //       await sendMessage(uploadSuccessMsg);
// //       _scrollToBottom();
// //
// //       Helpers.showSnackBar(context, "Reports uploaded successfully!", bgColor: AppColors.accent);
// //
// //       await _loadChatHistoryOrInitialize();
// //     }
// //   }
// //
// //   Future<void> _openFile(String filePath, String fileName) async {
// //     try {
// //       final result = await OpenFilex.open(filePath);
// //       if (result.type == ResultType.done) {
// //         debugPrint("✅ File opened successfully: $fileName");
// //       } else if (result.type == ResultType.noAppToOpen) {
// //         Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
// //       } else if (result.type == ResultType.fileNotFound) {
// //         Helpers.showSnackBar(context, "File not found at: $filePath", bgColor: Colors.red);
// //       } else {
// //         Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Error opening file: $e");
// //       Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
// //     }
// //   }
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     final errorMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Payment could not be completed. Please try again.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       messages.add(errorMsg);
// //     });
// //     sendMessage(errorMsg);
// //     Helpers.showSnackBar(context, "Payment failed: ${response.message}", bgColor: Colors.red);
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
// //   }
// //
// //   Widget buildIntroCard(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.all(14),
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: AppColors.primary.withOpacity(0.08),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: AppColors.primary, width: 1.2),
// //         boxShadow: [
// //           BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2)),
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
// //                 "Care Connect",
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
// //             style: TextStyle(fontSize: 15.5, color: Colors.grey[800]),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             children: [
// //               Icon(Icons.verified_user, color: AppColors.accent, size: 20),
// //               const SizedBox(width: 5),
// //               Text(
// //                 "Trusted | Secure | Confidential",
// //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.primary),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 18),
// //           Text(
// //             "How it works:",
// //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
// //           ),
// //           const SizedBox(height: 8),
// //           _buildStep(stepNumber: 1, icon: Icons.person_search, label: "Choose your doctor type and specialty"),
// //           const SizedBox(height: 5),
// //           _buildStep(stepNumber: 2, icon: Icons.payment, label: "Make a secure online payment"),
// //           const SizedBox(height: 5),
// //           _buildStep(stepNumber: 3, icon: Icons.message_outlined, label: "Upload reports, Chat & get advice"),
// //           const SizedBox(height: 18),
// //           GestureDetector(
// //             onTap: () => Navigator.pushNamed(context, '/help'),
// //             child: Text(
// //               "Help & Support",
// //               style: TextStyle(decoration: TextDecoration.underline, color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStep({required int stepNumber, required IconData icon, required String label}) {
// //     return Row(
// //       children: [
// //         CircleAvatar(
// //           radius: 13,
// //           backgroundColor: AppColors.primary,
// //           child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
// //         ),
// //         const SizedBox(width: 8),
// //         Icon(icon, size: 18, color: AppColors.accent),
// //         const SizedBox(width: 7),
// //         Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, color: Colors.grey[800]))),
// //       ],
// //     );
// //   }
// //
// //   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
// //     return ListTile(
// //       leading: Icon(icon, size: 25, color: AppColors.iconColor),
// //       title: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //       ),
// //       onTap: onTap,
// //     );
// //   }
// //
// //   void _scrollToBottom() {
// //     if (!_scrollController.hasClients) return;
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (_scrollController.hasClients) {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: const Duration(milliseconds: 300),
// //           curve: Curves.easeOut,
// //         );
// //       }
// //     });
// //   }
// //
// //   Widget buildMessageBubble(Message msg) {
// //     final isUser = !msg.isBot;
// //
// //     final showSecondOpinionButton = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("second opinion");
// //     final showDoctorTypeDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your preferred doctor type");
// //     final showSpecialityDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your doctor's speciality");
// //     final showReportUploadButtons = msg.showReportUploadQuestion && msg.showButtons && !msg.buttonClicked;
// //     final showDoctorTypeConfirmation = msg.showDoctorTypeConfirmation && msg.showButtons && !msg.buttonClicked;
// //     final showSpecialityConfirmation = msg.showSpecialityConfirmation && msg.showButtons && !msg.buttonClicked;
// //     final shouldShowPaymentButton = msg.showPaymentButton && !paymentCompleted;
// //
// //     return Align(
// //       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //         padding: const EdgeInsets.all(12),
// //         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
// //         decoration: BoxDecoration(
// //           color: isUser ? AppColors.chatUser : AppColors.chatBot,
// //           borderRadius: BorderRadius.only(
// //             topLeft: const Radius.circular(16),
// //             topRight: const Radius.circular(16),
// //             bottomLeft: isUser ? const Radius.circular(16) : Radius.circular(0),
// //             bottomRight: isUser ? Radius.circular(0) : const Radius.circular(16),
// //           ),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               msg.text,
// //               style: TextStyle(color: isUser ? AppColors.chatUserText : AppColors.chatBotText, fontSize: 15),
// //             ),
// //
// //             if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.green.shade50,
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(color: Colors.green.shade200),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.medical_services, color: Colors.green.shade700, size: 16),
// //                       const SizedBox(width: 8),
// //                       Flexible(
// //                         child: Text(
// //                           "Assigned: Dr. ${msg.assignedDoctorName}",
// //                           style: TextStyle(
// //                             color: Colors.green.shade800,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //             if (msg.reportUploaded == true && msg.reportFiles != null && msg.reportFiles!.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: msg.reportFiles!.map((report) {
// //                     return GestureDetector(
// //                       onTap: () => _openFile(report['filePath'], report['fileName']),
// //                       child: Container(
// //                         margin: const EdgeInsets.only(bottom: 6),
// //                         padding: const EdgeInsets.all(8),
// //                         decoration: BoxDecoration(
// //                           color: Colors.blue.shade50,
// //                           borderRadius: BorderRadius.circular(8),
// //                           border: Border.all(color: Colors.blue.shade200),
// //                         ),
// //                         child: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Icon(Icons.file_present, color: Colors.blue.shade700, size: 20),
// //                             const SizedBox(width: 8),
// //                             Flexible(
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     report['category'] ?? 'Medical Report',
// //                                     style: TextStyle(
// //                                         color: Colors.blue.shade900,
// //                                         fontWeight: FontWeight.bold,
// //                                         fontSize: 12
// //                                     ),
// //                                   ),
// //                                   Text(
// //                                     report['fileName'] ?? "View File",
// //                                     style: TextStyle(
// //                                       color: Colors.blue.shade700,
// //                                       decoration: TextDecoration.underline,
// //                                       fontSize: 11,
// //                                     ),
// //                                     overflow: TextOverflow.ellipsis,
// //                                   ),
// //                                   if (report['fileSize'] != null)
// //                                     Text(
// //                                       "Size: ${_formatFileSize(report['fileSize'])}",
// //                                       style: TextStyle(
// //                                         color: Colors.grey.shade600,
// //                                         fontSize: 10,
// //                                       ),
// //                                     ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //
// //             if (showSecondOpinionButton)
// //               Padding(padding: const EdgeInsets.only(top: 8.0), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onYesButtonPressed(msg), child: const Text("Yes"))),
// //
// //             if (showReportUploadButtons)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onReportUploadYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onReportUploadNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showDoctorTypeConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showSpecialityConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showDoctorTypeDropdown)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
// //                   child: DropdownButton<String>(
// //                     hint: const Text("Select Doctor Type"),
// //                     isExpanded: true,
// //                     underline: const SizedBox(),
// //                     items: const [
// //                       DropdownMenuItem(value: "Allopathy", child: Text("Allopathy ")),
// //                       DropdownMenuItem(value: "Ayurvedic", child: Text("Ayurvedic ")),
// //                       DropdownMenuItem(value: "Homeopathy", child: Text("Homeopathy ")),
// //                     ],
// //                     onChanged: (value) {
// //                       if (value != null) _onDoctorTypeSelected(msg, value);
// //                     },
// //                   ),
// //                 ),
// //               ),
// //
// //             if (showSpecialityDropdown)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
// //                   child: DropdownButton<String>(
// //                     hint: const Text("Select Speciality"),
// //                     isExpanded: true,
// //                     underline: const SizedBox(),
// //                     items: const [
// //                       DropdownMenuItem(value: "MBBS", child: Text("MBBS (General Physician)")),
// //                       DropdownMenuItem(value: "MD", child: Text("MD (Doctor of Medicine)")),
// //                       DropdownMenuItem(value: "Dentist", child: Text("Dentist")),
// //                       DropdownMenuItem(value: "Cardiologist", child: Text("Cardiologist")),
// //                       DropdownMenuItem(value: "Dermatologist", child: Text("Dermatologist")),
// //                       DropdownMenuItem(value: "Orthopedic", child: Text("Orthopedic")),
// //                       DropdownMenuItem(value: "Pediatrician", child: Text("Pediatrician")),
// //                       DropdownMenuItem(value: "Gynecologist", child: Text("Gynecologist")),
// //                     ],
// //                     onChanged: (value) {
// //                       if (value != null) _onSpecialitySelected(msg, value);
// //                     },
// //                   ),
// //                 ),
// //               ),
// //
// //             if (shouldShowPaymentButton)
// //               Builder(builder: (context) {
// //                 final amount = msg.amount ?? 500;
// //                 return Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: !paymentCompleted ? Colors.green[700] : Colors.grey,
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                     ),
// //                     onPressed: !paymentCompleted ? () => _onPaymentButtonPressed(msg) : null,
// //                     icon: const Icon(Icons.payment),
// //                     label: Text("Pay"),
// //                   ),
// //                 );
// //               }),
// //
// //             if (msg.buttonClicked && msg.selectedDoctorType != null && !msg.paymentCompleted && !msg.showDoctorTypeConfirmation && !msg.showSpecialityConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Text(
// //                   msg.selectedSpeciality != null ? "Selected: ${msg.selectedDoctorType} - ${msg.selectedSpeciality}" : "Selected: ${msg.selectedDoctorType}",
// //                   style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12),
// //                 ),
// //               ),
// //
// //             if (msg.createdAt != null)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   _formatMessageTime(msg.createdAt!),
// //                   style: const TextStyle(fontSize: 10, color: Colors.grey),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _refreshChat() async {
// //     setState(() {
// //       loadingHistory = true;
// //     });
// //
// //     await _loadChatHistoryOrInitialize();
// //
// //     setState(() {
// //       loadingHistory = false;
// //     });
// //
// //     Helpers.showSnackBar(context, "Chat refreshed", bgColor: Colors.green);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (loadingHistory || userId == null) {
// //       return const Scaffold(
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               CircularProgressIndicator(),
// //               SizedBox(height: 16),
// //               Text('Restoring your chat session...'),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Scaffold(
// //       // Replace the AppBar section in the build method with this code
// //
// //       appBar: AppBar(
// //         iconTheme: IconThemeData(color: AppColors.iconColor),
// //         backgroundColor: AppColors.primary,
// //         titleSpacing: 0,
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Flexible(
// //               child: Text(
// //                 "Care Connect",
// //                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //             ),
// //             if (currentDoctorType != null) ...[
// //               const SizedBox(width: 5),
// //               Flexible(
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                   decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
// //                   child: Text(
// //                     currentDoctorType!,
// //                     style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
// //                     overflow: TextOverflow.ellipsis,
// //                     maxLines: 1,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //         actions: [
// //           IconButton(
// //             onPressed: _refreshChat,
// //             icon: Icon(Icons.refresh, color: AppColors.iconColor),
// //             tooltip: "Refresh Chat",
// //           ),
// //           IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor)),
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
// //                   children: const [
// //                     CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/logo.png"), backgroundColor: Colors.white),
// //                     SizedBox(height: 10),
// //                     Text("CareConnect", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// //                     Text("info@CareConnect.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               Expanded(
// //                 child: ListView(
// //                   padding: EdgeInsets.zero,
// //                   children: [
// //                     drawerItem("Home", Icons.home, () => Navigator.pushNamed(context, '/home')),
// //                     drawerItem("Doctors", Icons.add, () => Navigator.pushNamed(context, '/doctors')),
// //                     // drawerItem("Orders", Icons.file_copy_sharp, () => Navigator.pushNamed(context, '/orders')),
// //                     drawerItem("Terms & Privacy", Icons.privacy_tip, () => Navigator.pushNamed(context, '/terms')),
// //                     drawerItem("Help & Guide", Icons.help_outline, () => Navigator.pushNamed(context, '/help')),
// //                     drawerItem("Log Out", Icons.logout_sharp, () async {
// //                       bool? confirm = await showDialog<bool>(
// //                         context: context,
// //                         builder: (context) => AlertDialog(
// //                           title: const Text("Confirm Logout"),
// //                           content: const Text("Are you sure you want to logout?"),
// //                           actions: [
// //                             TextButton(
// //                                 onPressed: () => Navigator.pop(context, false),
// //                                 child: const Text("Cancel")
// //                             ),
// //                             TextButton(
// //                                 onPressed: () => Navigator.pop(context, true),
// //                                 child: const Text("Logout")
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //
// //                       if (confirm == true && mounted) {
// //                         try {
// //                           final prefs = await SharedPreferences.getInstance();
// //                           final token = prefs.getString('token');
// //
// //                           print('🔐 Attempting logout...');
// //                           print('📱 Token available: ${token != null}');
// //
// //                           if (token != null) {
// //                             final url = Uri.parse("${ApiConfig.baseUrl}/logout");
// //                             print('📤 Calling logout API: $url');
// //
// //                             final response = await http.post(
// //                               url,
// //                               headers: {
// //                                 'Content-Type': 'application/json',
// //                                 'Authorization': 'Bearer $token',
// //                               },
// //                             );
// //
// //                             print('📥 Logout API Response Status: ${response.statusCode}');
// //                             print('📥 Logout API Response Body: ${response.body}');
// //
// //                             if (response.statusCode == 200) {
// //                               final responseData = jsonDecode(response.body);
// //                               if (responseData['success'] == true) {
// //                                 print('✅ Logout API successful');
// //                               } else {
// //                                 print('⚠ Logout API returned success: false');
// //                               }
// //                             } else {
// //                               print('❌ Logout API failed with status: ${response.statusCode}');
// //                             }
// //                           } else {
// //                             print('⚠ No token found, proceeding with local logout');
// //                           }
// //
// //                           await prefs.clear();
// //                           print('✅ Local storage cleared');
// //
// //                           if (mounted) {
// //                             Navigator.pushNamedAndRemoveUntil(
// //                               context,
// //                               '/login',
// //                                   (route) => false,
// //                             );
// //                           }
// //
// //                           Helpers.showSnackBar(
// //                               context,
// //                               "Logged out successfully",
// //                               bgColor: Colors.green
// //                           );
// //
// //                         } catch (e) {
// //                           print('❌ Logout error: $e');
// //
// //                           final prefs = await SharedPreferences.getInstance();
// //                           await prefs.clear();
// //
// //                           if (mounted) {
// //                             Navigator.pushNamedAndRemoveUntil(
// //                               context,
// //                               '/login',
// //                                   (route) => false,
// //                             );
// //                           }
// //
// //                           Helpers.showSnackBar(
// //                               context,
// //                               "Logged out successfully",
// //                               bgColor: Colors.green
// //                           );
// //                         }
// //                       }
// //                     }),
// //                   ],
// //                 ),
// //               ),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               const Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 80),
// //                 child: Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text("Made With", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
// //                       SizedBox(width: 5),
// //                       Icon(Icons.favorite, color: AppColors.textLight, size: 14),
// //                       SizedBox(width: 5),
// //                       Text("By VSGLogic", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
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
// //             child: ListView.builder(
// //               padding: const EdgeInsets.symmetric(vertical: 10),
// //               controller: _scrollController,
// //               itemCount: messages.length + 1,
// //               itemBuilder: (context, index) {
// //                 if (index == 0) return buildIntroCard(context);
// //                 final msg = messages[index - 1];
// //
// //                 bool showDate = false;
// //                 if (index == 1) {
// //                   showDate = true;
// //                 } else {
// //                   final prevMsg = messages[index - 2];
// //                   if (msg.createdAt != null && prevMsg.createdAt != null) {
// //                     showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
// //                   }
// //                 }
// //
// //                 return Column(
// //                   children: [
// //                     if (showDate && msg.createdAt != null)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                           decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
// //                           child: Text(formatDate(msg.createdAt!), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight)),
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
// //               child: Column(
// //                 children: [
// //                   if (_isSessionEnded)
// //                     Container(
// //                       width: double.infinity,
// //                       margin: const EdgeInsets.only(bottom: 8),
// //                       padding: const EdgeInsets.all(12),
// //                       decoration: BoxDecoration(
// //                         color: Colors.orange.shade100,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.info, color: Colors.orange.shade800),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               "Session completed by doctor. Starting new chat...",
// //                               style: TextStyle(
// //                                 color: Colors.orange.shade800,
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                   Row(
// //                     children: [
// //                       GestureDetector(
// //                         onTap: paymentCompleted &&
// //                             reportUploadEnabled &&
// //                             !hasUploadedReport &&
// //                             !_isSessionEnded
// //                             ? _navigateToUploadFiles
// //                             : null,
// //                         child: Icon(
// //                           Icons.attach_file,
// //                           color: paymentCompleted &&
// //                               reportUploadEnabled &&
// //                               !hasUploadedReport &&
// //                               !_isSessionEnded
// //                               ? AppColors.iconColor
// //                               : Colors.grey.shade600,
// //                           size: 28,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                           decoration: BoxDecoration(
// //                             color: paymentCompleted && !_isSessionEnded ? Colors.white : Colors.grey.shade300,
// //                             borderRadius: BorderRadius.circular(21),
// //                           ),
// //                           child: TextField(
// //                             controller: _controller,
// //                             enabled: paymentCompleted && !_isSessionEnded,
// //                             keyboardType: TextInputType.multiline,
// //                             textInputAction: TextInputAction.newline,
// //                             minLines: 1,
// //                             maxLines: 4,
// //                             decoration: InputDecoration.collapsed(
// //                               hintText: _isSessionEnded
// //                                   ? "Session completed - Starting new chat..."
// //                                   : paymentCompleted
// //                                   ? "Type your message here"
// //                                   : "Complete payment to chat",
// //                             ),
// //                             onChanged: (text) {
// //                               WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       GestureDetector(
// //                         onTap: paymentCompleted && !_isSessionEnded
// //                             ? () {
// //                           if (_controller.text.trim().isNotEmpty) {
// //                             _onUserSend(_controller.text.trim());
// //                             _controller.clear();
// //                           }
// //                         }
// //                             : null,
// //                         child: Icon(
// //                             Icons.send,
// //                             color: paymentCompleted && !_isSessionEnded ? AppColors.iconColor : Colors.grey
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
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
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'helper.dart';
// // import 'package:intl/intl.dart';
// // import 'upload_files.dart';
// // import 'package:open_filex/open_filex.dart';
// // import 'services/chat_service.dart';
// // import 'dart:async';
// // import 'dart:math';
// //
// // String formatDate(DateTime date) {
// //   final now = DateTime.now();
// //   if (isSameDay(date, now)) {
// //     return "Today";
// //   }
// //   return DateFormat.yMMMMd().format(date);
// // }
// //
// // bool isSameDay(DateTime a, DateTime b) {
// //   return a.year == b.year && a.month == b.month && a.day == b.day;
// // }
// //
// // String _formatFileSize(dynamic size) {
// //   if (size == null) return 'Unknown';
// //   final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
// //   if (bytes <= 0) return "0 B";
// //   const suffixes = ["B", "KB", "MB", "GB"];
// //   var i = (log(bytes) / log(1024)).floor();
// //   return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
// // }
// //
// // String _formatMessageTime(DateTime dateTime) {
// //   final localTime = dateTime.toLocal();
// //   final hour = localTime.hour.toString().padLeft(2, '0');
// //   final minute = localTime.minute.toString().padLeft(2, '0');
// //   return '$hour:$minute';
// // }
// //
// // class Message {
// //   final String id;
// //   final String text;
// //   final bool isBot;
// //   final bool showButtons;
// //   final bool buttonClicked;
// //   final DateTime? createdAt;
// //   final String? selectedDoctorType;
// //   final String? selectedSpeciality;
// //   final bool showPaymentButton;
// //   final bool paymentCompleted;
// //   final String? orderId;
// //   final String? paymentId;
// //   final String? orderNumber;
// //   final int? amount;
// //   final bool showReportUploadQuestion;
// //   final bool reportUploadAnswered;
// //   final bool wantsToUploadReport;
// //   final bool showReportUploadButton;
// //   final bool reportUploaded;
// //   final List<Map<String, dynamic>>? reportFiles;
// //   final bool showDoctorTypeConfirmation;
// //   final bool showSpecialityConfirmation;
// //   final String? pendingDoctorType;
// //   final String? pendingSpeciality;
// //   final String? userId;
// //   final String? userName;
// //   final String? assignedDoctorId;
// //   final String? assignedDoctorName;
// //
// //   Message({
// //     required this.id,
// //     required this.text,
// //     required this.isBot,
// //     this.showButtons = false,
// //     this.buttonClicked = false,
// //     this.createdAt,
// //     this.selectedDoctorType,
// //     this.selectedSpeciality,
// //     this.showPaymentButton = false,
// //     this.paymentCompleted = false,
// //     this.orderId,
// //     this.paymentId,
// //     this.orderNumber,
// //     this.amount,
// //     this.showReportUploadQuestion = false,
// //     this.reportUploadAnswered = false,
// //     this.wantsToUploadReport = false,
// //     this.showReportUploadButton = false,
// //     this.reportUploaded = false,
// //     this.reportFiles,
// //     this.showDoctorTypeConfirmation = false,
// //     this.showSpecialityConfirmation = false,
// //     this.pendingDoctorType,
// //     this.pendingSpeciality,
// //     this.userId,
// //     this.userName,
// //     this.assignedDoctorId,
// //     this.assignedDoctorName,
// //   });
// //
// //   factory Message.fromMap(Map<String, dynamic> map) {
// //     final bool buttonClicked = map['buttonClicked'] == true;
// //     final bool showButtonsRaw = map['showButtons'] == true;
// //
// //     int? amount;
// //     if (map['amount'] != null) {
// //       if (map['amount'] is int) {
// //         amount = map['amount'];
// //       } else if (map['amount'] is double) {
// //         amount = (map['amount'] as double).toInt();
// //       } else if (map['amount'] is String) {
// //         amount = int.tryParse(map['amount']);
// //       }
// //     }
// //
// //     String? safeString(String? value) {
// //       return (value == null || value.isEmpty) ? null : value;
// //     }
// //
// //     return Message(
// //       id: map['_id'] ?? map['id'] ?? UniqueKey().toString(),
// //       text: map['text'] ?? "",
// //       isBot: map['isBot'] ?? false,
// //       showButtons: showButtonsRaw && !buttonClicked,
// //       buttonClicked: buttonClicked,
// //       createdAt: map['createdAt'] != null
// //           ? DateTime.tryParse(map['createdAt'].toString())
// //           : DateTime.now(),
// //       selectedDoctorType: safeString(map['selectedDoctorType']),
// //       selectedSpeciality: safeString(map['selectedSpeciality']),
// //       showPaymentButton: map['showPaymentButton'] ?? false,
// //       paymentCompleted: map['paymentCompleted'] ?? false,
// //       orderId: safeString(map['orderId']),
// //       paymentId: safeString(map['paymentId']),
// //       orderNumber: safeString(map['orderNumber']),
// //       amount: amount,
// //       showReportUploadQuestion: map['showReportUploadQuestion'] ?? false,
// //       reportUploadAnswered: map['reportUploadAnswered'] ?? false,
// //       wantsToUploadReport: map['wantsToUploadReport'] ?? false,
// //       showReportUploadButton: map['showReportUploadButton'] ?? false,
// //       reportUploaded: map['reportUploaded'] ?? false,
// //       reportFiles: map['reportFiles'] != null && map['reportFiles'] is List
// //           ? List<Map<String, dynamic>>.from(map['reportFiles'])
// //           : null,
// //       showDoctorTypeConfirmation: map['showDoctorTypeConfirmation'] ?? false,
// //       showSpecialityConfirmation: map['showSpecialityConfirmation'] ?? false,
// //       pendingDoctorType: safeString(map['pendingDoctorType']),
// //       pendingSpeciality: safeString(map['pendingSpeciality']),
// //       userId: safeString(map['userId']),
// //       userName: safeString(map['userName']) ?? 'Care Connect Bot',
// //       assignedDoctorId: safeString(map['assignedDoctorId']),
// //       assignedDoctorName: safeString(map['assignedDoctorName']),
// //     );
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'text': text,
// //       'isBot': isBot,
// //       'showButtons': showButtons,
// //       'buttonClicked': buttonClicked,
// //       'createdAt': createdAt?.toIso8601String(),
// //       'selectedDoctorType': selectedDoctorType,
// //       'selectedSpeciality': selectedSpeciality,
// //       'showPaymentButton': showPaymentButton,
// //       'paymentCompleted': paymentCompleted,
// //       'orderId': orderId,
// //       'paymentId': paymentId,
// //       'orderNumber': orderNumber,
// //       'amount': amount,
// //       'showReportUploadQuestion': showReportUploadQuestion,
// //       'reportUploadAnswered': reportUploadAnswered,
// //       'wantsToUploadReport': wantsToUploadReport,
// //       'showReportUploadButton': showReportUploadButton,
// //       'reportUploaded': reportUploaded,
// //       'reportFiles': reportFiles,
// //       'showDoctorTypeConfirmation': showDoctorTypeConfirmation,
// //       'showSpecialityConfirmation': showSpecialityConfirmation,
// //       'pendingDoctorType': pendingDoctorType,
// //       'pendingSpeciality': pendingSpeciality,
// //       'userId': userId,
// //       'userName': userName,
// //       'assignedDoctorId': assignedDoctorId,
// //       'assignedDoctorName': assignedDoctorName,
// //     };
// //   }
// //
// //   Message copyWith({
// //     String? id,
// //     String? text,
// //     bool? isBot,
// //     bool? showButtons,
// //     bool? buttonClicked,
// //     DateTime? createdAt,
// //     String? selectedDoctorType,
// //     String? selectedSpeciality,
// //     bool? showPaymentButton,
// //     bool? paymentCompleted,
// //     String? orderId,
// //     String? paymentId,
// //     String? orderNumber,
// //     int? amount,
// //     bool? showReportUploadQuestion,
// //     bool? reportUploadAnswered,
// //     bool? wantsToUploadReport,
// //     bool? showReportUploadButton,
// //     bool? reportUploaded,
// //     List<Map<String, dynamic>>? reportFiles,
// //     bool? showDoctorTypeConfirmation,
// //     bool? showSpecialityConfirmation,
// //     String? pendingDoctorType,
// //     String? pendingSpeciality,
// //     String? userId,
// //     String? userName,
// //     String? assignedDoctorId,
// //     String? assignedDoctorName,
// //   }) {
// //     return Message(
// //       id: id ?? this.id,
// //       text: text ?? this.text,
// //       isBot: isBot ?? this.isBot,
// //       showButtons: showButtons ?? this.showButtons,
// //       buttonClicked: buttonClicked ?? this.buttonClicked,
// //       createdAt: createdAt ?? this.createdAt,
// //       selectedDoctorType: selectedDoctorType ?? this.selectedDoctorType,
// //       selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
// //       showPaymentButton: showPaymentButton ?? this.showPaymentButton,
// //       paymentCompleted: paymentCompleted ?? this.paymentCompleted,
// //       orderId: orderId ?? this.orderId,
// //       paymentId: paymentId ?? this.paymentId,
// //       orderNumber: orderNumber ?? this.orderNumber,
// //       amount: amount ?? this.amount,
// //       showReportUploadQuestion: showReportUploadQuestion ?? this.showReportUploadQuestion,
// //       reportUploadAnswered: reportUploadAnswered ?? this.reportUploadAnswered,
// //       wantsToUploadReport: wantsToUploadReport ?? this.wantsToUploadReport,
// //       showReportUploadButton: showReportUploadButton ?? this.showReportUploadButton,
// //       reportUploaded: reportUploaded ?? this.reportUploaded,
// //       reportFiles: reportFiles ?? this.reportFiles,
// //       showDoctorTypeConfirmation: showDoctorTypeConfirmation ?? this.showDoctorTypeConfirmation,
// //       showSpecialityConfirmation: showSpecialityConfirmation ?? this.showSpecialityConfirmation,
// //       pendingDoctorType: pendingDoctorType ?? this.pendingDoctorType,
// //       pendingSpeciality: pendingSpeciality ?? this.pendingSpeciality,
// //       userId: userId ?? this.userId,
// //       userName: userName ?? this.userName,
// //       assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
// //       assignedDoctorName: assignedDoctorName ?? this.assignedDoctorName,
// //     );
// //   }
// // }
// //
// // class HomePage extends StatefulWidget {
// //   final String? orderId;
// //   final bool isExistingOrder;
// //
// //   const HomePage({
// //     super.key,
// //     this.orderId,
// //     this.isExistingOrder = false,
// //   });
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   List<Message> messages = [];
// //   TextEditingController _controller = TextEditingController();
// //   String? userId;
// //   String? userName;
// //   String? userPhone;
// //   String? userEmail;
// //   bool loadingHistory = true;
// //   final ScrollController _scrollController = ScrollController();
// //   String? currentDoctorType;
// //   String? currentSpeciality;
// //   String? currentOrderId;
// //   bool paymentCompleted = false;
// //   bool reportUploadEnabled = false;
// //   bool hasUploadedReport = false;
// //   late Razorpay _razorpay;
// //   String? assignedDoctorName;
// //   String? assignedDoctorSpeciality;
// //
// //   // Session end variables
// //   bool _isSessionEnded = false;
// //   Timer? _statusCheckTimer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //     _loadUserId();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _statusCheckTimer?.cancel();
// //     _razorpay.clear();
// //     _controller.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   // NEW: Simplified Terms and Conditions Popup
// //   Future<bool> _showTermsAndConditionsPopup() async {
// //     return await showDialog<bool>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text(
// //             "Terms & Conditions",
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primary,
// //             ),
// //           ),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 "By proceeding, you agree to our terms:",
// //                 style: TextStyle(fontSize: 14),
// //               ),
// //               SizedBox(height: 10),
// //               _buildSimpleTerm("Consultation fees are non-refundable"),
// //               _buildSimpleTerm("Medical information is confidential"),
// //               _buildSimpleTerm("Emergency cases should visit hospital"),
// //               SizedBox(height: 10),
// //               GestureDetector(
// //                 onTap: () => Navigator.pushNamed(context, '/terms'),
// //                 child: Text(
// //                   "Terms & Conditions",
// //                   style: TextStyle(
// //                     color: AppColors.primary,
// //                     decoration: TextDecoration.underline,
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(false),
// //               child: Text("Cancel"),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => Navigator.of(context).pop(true),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: AppColors.primary,
// //                 foregroundColor: Colors.white,
// //               ),
// //               child: Text("I Accept"),
// //             ),
// //           ],
// //         );
// //       },
// //     ) ?? false;
// //   }
// //
// //   Widget _buildSimpleTerm(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Icon(Icons.check_circle, size: 16, color: Colors.green),
// //           SizedBox(width: 8),
// //           Expanded(
// //             child: Text(
// //               text,
// //               style: TextStyle(fontSize: 12),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // void _openTermsAndConditions() {
// //   //   // You can replace this with your actual terms URL
// //   //   final termsUrl = "https://your-website.com/terms-and-conditions";
// //   //
// //   //   showDialog(
// //   //     context: context,
// //   //     builder: (context) => AlertDialog(
// //   //       title: Text("Terms & Conditions"),
// //   //       content: Text("Opening terms and conditions in browser..."),
// //   //       actions: [
// //   //         TextButton(
// //   //           onPressed: () => Navigator.pop(context),
// //   //           child: Text("OK"),
// //   //         ),
// //   //       ],
// //   //     ),
// //   //   );
// //   //
// //   //   // Uncomment below to actually open the URL
// //   //   // launchUrl(Uri.parse(termsUrl));
// //   // }
// //
// //   // Session end detection methods
// //   void _startOrderStatusListener() {
// //     if (currentOrderId == null) {
// //       print('❌ Cannot start order status listener: currentOrderId is null');
// //       return;
// //     }
// //
// //     if (_isSessionEnded) {
// //       print('❌ Cannot start order status listener: session already ended');
// //       return;
// //     }
// //
// //     print('🔍 Starting order status listener for: $currentOrderId');
// //
// //     // Cancel existing timer if any
// //     _statusCheckTimer?.cancel();
// //
// //     // Check immediately first
// //     _checkOrderStatus();
// //
// //     // Then check every 5 seconds
// //     _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
// //       print('⏰ Timer tick - checking order status...');
// //       _checkOrderStatus();
// //     });
// //   }
// //
// //   Future<void> _checkOrderStatus() async {
// //     if (currentOrderId == null || _isSessionEnded) {
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Checking order status for: $currentOrderId');
// //
// //       final response = await http.get(
// //         Uri.parse(ApiConfig.getOrderStatus(currentOrderId!)),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final order = data['data'];
// //           final status = order['status']?.toString().toLowerCase();
// //
// //           print('📊 Current order status: $status');
// //
// //           if (status == 'completed') {
// //             print('🎯 Session ended by doctor, resetting chat...');
// //             _handleSessionEndedByDoctor();
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       print('❌ Error checking order status: $e');
// //     }
// //   }
// //
// //   void _handleSessionEndedByDoctor() async {
// //     if (_isSessionEnded) return;
// //
// //     setState(() {
// //       _isSessionEnded = true;
// //     });
// //
// //     // Stop the timer
// //     _statusCheckTimer?.cancel();
// //
// //     try {
// //       print('🎯 Calling backend to complete order: $currentOrderId');
// //
// //       final response = await http.put(
// //         Uri.parse('${ApiConfig.baseUrl}/completeOrder/$currentOrderId'),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "status": "completed",
// //           "completedBy": "Doctor",
// //           "resetChat": true
// //         }),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           print('✅ Order successfully completed on backend');
// //         } else {
// //           print('❌ Failed to complete order on backend: ${data['message']}');
// //         }
// //       } else {
// //         print('❌ Error completing order: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Error calling completeOrder API: $e');
// //     }
// //
// //     // Show session ended message
// //     final sessionEndedMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Your consultation session has been completed by the doctor. Thank you for using Care Connect! Starting a new chat session...",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages.add(sessionEndedMsg);
// //     });
// //
// //     _scrollToBottom();
// //
// //     // Show notification
// //     Helpers.showSnackBar(
// //         context,
// //         "Session completed by doctor - Starting new chat",
// //         bgColor: Colors.orange
// //     );
// //
// //     // Wait 3 seconds then reset the chat
// //     await Future.delayed(const Duration(seconds: 3));
// //     _resetChatToBeginning();
// //   }
// //
// //   void _resetChatToBeginning() async {
// //     print('🔄 Resetting chat to beginning...');
// //
// //     try {
// //       // Store the completed order ID before clearing
// //       final completedOrderId = currentOrderId;
// //
// //       // Clear current state COMPLETELY
// //       setState(() {
// //         messages.clear();
// //         currentDoctorType = null;
// //         currentSpeciality = null;
// //         paymentCompleted = false;
// //         reportUploadEnabled = false;
// //         hasUploadedReport = false;
// //         assignedDoctorName = null;
// //         assignedDoctorSpeciality = null;
// //         currentOrderId = null; // This ensures new order will be created
// //         _isSessionEnded = false;
// //         _controller.clear();
// //       });
// //
// //       // Stop any existing timers
// //       _statusCheckTimer?.cancel();
// //
// //       print('✅ Local state cleared for order: $completedOrderId');
// //
// //       // Re-initialize a FRESH chat with new order
// //       await _initializeNewChat();
// //
// //       print('✅ New chat session started successfully');
// //
// //       Helpers.showSnackBar(
// //         context,
// //         "New chat session started!",
// //         bgColor: Colors.green,
// //       );
// //
// //     } catch (e) {
// //       print('❌ Error resetting chat: $e');
// //       _createFallbackMessages();
// //     }
// //   }
// //
// //   bool _isOrderCompleted(List messagesData) {
// //     if (messagesData.isEmpty) return false;
// //
// //     for (var msg in messagesData) {
// //       if (msg['text'] != null) {
// //         String text = msg['text'].toString();
// //
// //         if (text.contains("Your consultation session has been completed by the doctor") &&
// //             text.contains("Starting a new chat session")) {
// //           print('🎯 Found explicit session end message - session is completed');
// //           return true;
// //         }
// //       }
// //     }
// //
// //     print('💬 No explicit session end found - preserving chat');
// //     return false;
// //   }
// //
// //   bool _isChatTrulyCompleted(List messagesData) {
// //     if (messagesData.isEmpty) return false;
// //
// //     bool hasPaymentCompletion = false;
// //     bool hasActiveChatPrompt = false;
// //     bool hasSessionEndMessage = false;
// //
// //     final recentMessages = messagesData.length > 5
// //         ? messagesData.sublist(messagesData.length - 5)
// //         : messagesData;
// //
// //     for (var msg in recentMessages.reversed) {
// //       if (msg['text'] != null) {
// //         String text = msg['text'].toString().toLowerCase();
// //
// //         if (text.contains("payment successful") ||
// //             text.contains("payment completed")) {
// //           hasPaymentCompletion = true;
// //         }
// //
// //         if (text.contains("how can we help") ||
// //             text.contains("start chatting") ||
// //             text.contains("upload reports") ||
// //             text.contains("assigned to your case")) {
// //           hasActiveChatPrompt = true;
// //         }
// //
// //         if (text.contains("session completed") ||
// //             text.contains("thank you for using Care Connect") ||
// //             text.contains("starting new chat")) {
// //           hasSessionEndMessage = true;
// //         }
// //       }
// //
// //       if (msg['paymentCompleted'] == true) {
// //         hasPaymentCompletion = true;
// //       }
// //     }
// //
// //     if (hasSessionEndMessage) {
// //       return true;
// //     }
// //
// //     if (hasPaymentCompletion && !hasActiveChatPrompt) {
// //       return _isFreshPaymentWithoutChat(messagesData);
// //     }
// //
// //     return false;
// //   }
// //
// //   bool _isFreshPaymentWithoutChat(List messagesData) {
// //     int paymentCompletionIndex = -1;
// //
// //     for (int i = messagesData.length - 1; i >= 0; i--) {
// //       if (messagesData[i]['paymentCompleted'] == true ||
// //           (messagesData[i]['text'] != null &&
// //               messagesData[i]['text'].toString().toLowerCase().contains("payment successful"))) {
// //         paymentCompletionIndex = i;
// //         break;
// //       }
// //     }
// //
// //     if (paymentCompletionIndex == -1) return false;
// //
// //     for (int i = paymentCompletionIndex + 1; i < messagesData.length; i++) {
// //       var msg = messagesData[i];
// //
// //       if (msg['isBot'] == false && msg['text'] != null && msg['text'].toString().trim().isNotEmpty) {
// //         return false;
// //       }
// //
// //       if (msg['isBot'] == true && msg['text'] != null) {
// //         String text = msg['text'].toString().toLowerCase();
// //         if (text.contains("how can we help") ||
// //             text.contains("start chatting") ||
// //             text.contains("upload reports")) {
// //           return false;
// //         }
// //       }
// //     }
// //
// //     return true;
// //   }
// //
// //   Future<int?> getDynamicConsultationFee(String doctorType, String speciality) async {
// //     try {
// //       print('🔄 Getting dynamic fee for: $doctorType - $speciality');
// //
// //       final response = await http.get(
// //         Uri.parse('${ApiConfig.baseUrl}/api/consultation-fee?doctorType=$doctorType&speciality=${Uri.encodeComponent(speciality)}'),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final estimatedFee = data['data']['estimatedFee'] as int;
// //           print('💰 Dynamic fee received: ₹$estimatedFee');
// //           return estimatedFee;
// //         }
// //       }
// //
// //       print('⚠ Using fallback fee');
// //       const fallbackPricing = {
// //         'Allopathy': 500,
// //         'Ayurvedic': 300,
// //         'Homeopathy': 200
// //       };
// //       return fallbackPricing[doctorType] ?? 300;
// //     } catch (e) {
// //       print('❌ Error getting dynamic fee: $e');
// //       const fallbackPricing = {
// //         'Allopathy': 500,
// //         'Ayurvedic': 300,
// //         'Homeopathy': 200
// //       };
// //       return fallbackPricing[doctorType] ?? 300;
// //     }
// //   }
// //
// //   Future<void> _loadUserId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final storedUserId = prefs.getString('userId');
// //     final storedUserName = prefs.getString('fullName') ?? 'User';
// //     final storedUserPhone = prefs.getString('phone') ?? '';
// //     final storedUserEmail = prefs.getString('email') ?? '';
// //
// //     if (storedUserId == null) {
// //       if (mounted) {
// //         Navigator.pushReplacementNamed(context, '/login');
// //       }
// //       return;
// //     }
// //
// //     setState(() {
// //       userId = storedUserId;
// //       userName = storedUserName;
// //       userPhone = storedUserPhone;
// //       userEmail = storedUserEmail;
// //
// //       if (widget.isExistingOrder && widget.orderId != null) {
// //         currentOrderId = widget.orderId;
// //         print('🔄 Loading existing order: ${widget.orderId}');
// //       }
// //     });
// //
// //     await _loadChatHistoryOrInitialize();
// //   }
// //
// //   Future<void> _loadChatHistoryOrInitialize() async {
// //     if (userId == null) {
// //       print('❌ User ID is null');
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Loading chat history from backend...');
// //
// //       String url = "${ApiConfig.chatHistory}?userId=$userId";
// //
// //       if (widget.isExistingOrder && currentOrderId != null && currentOrderId!.isNotEmpty) {
// //         url += "&orderId=$currentOrderId";
// //         print('📝 Loading existing order: $currentOrderId');
// //       }
// //
// //       final response = await http.get(Uri.parse(url));
// //
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         List messagesData = decoded['data']['messages'] as List? ?? [];
// //
// //         if (messagesData.isEmpty) {
// //           print('📂 No messages found, initializing new chat...');
// //           await _initializeNewChat();
// //           return;
// //         }
// //
// //         print('📥 Loaded ${messagesData.length} messages from backend');
// //
// //         final loadedMessages = messagesData.map((msg) {
// //           try {
// //             return Message.fromMap(msg);
// //           } catch (e) {
// //             print('❌ Error parsing message: $e - $msg');
// //             return Message(
// //               id: UniqueKey().toString(),
// //               text: msg['text']?.toString() ?? 'Error loading message',
// //               isBot: msg['isBot'] ?? false,
// //               createdAt: DateTime.now(),
// //               userId: userId,
// //               userName: msg['userName']?.toString() ?? 'Unknown',
// //             );
// //           }
// //         }).toList();
// //
// //         bool restoredPaymentCompleted = false;
// //         bool restoredReportUploadEnabled = false;
// //         bool restoredHasUploadedReport = false;
// //         String? restoredAssignedDoctorName;
// //         String? restoredCurrentDoctorType;
// //         String? restoredCurrentSpeciality;
// //         String? restoredCurrentOrderId;
// //         bool restoredIsSessionEnded = false;
// //
// //         for (var msg in loadedMessages) {
// //           if (msg.selectedDoctorType != null && msg.selectedDoctorType!.isNotEmpty) {
// //             restoredCurrentDoctorType = msg.selectedDoctorType;
// //           }
// //           if (msg.selectedSpeciality != null && msg.selectedSpeciality!.isNotEmpty) {
// //             restoredCurrentSpeciality = msg.selectedSpeciality;
// //           }
// //           if (msg.orderId != null && msg.orderId!.isNotEmpty) {
// //             restoredCurrentOrderId = msg.orderId;
// //           }
// //           if (msg.paymentCompleted == true) {
// //             restoredPaymentCompleted = true;
// //             print('💰 Found payment completed message');
// //           }
// //           if (msg.wantsToUploadReport == true) {
// //             restoredReportUploadEnabled = true;
// //             print('📤 Found wants to upload report message');
// //           }
// //           if (msg.reportUploaded == true) {
// //             restoredHasUploadedReport = true;
// //             print('✅ Found report uploaded message');
// //           }
// //           if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty) {
// //             restoredAssignedDoctorName = msg.assignedDoctorName;
// //           }
// //
// //           if (msg.text.contains("Your consultation session has been completed by the doctor") &&
// //               msg.text.contains("Starting a new chat session")) {
// //             restoredIsSessionEnded = true;
// //             print('🔍 Found session end message in history');
// //           }
// //         }
// //
// //         if (restoredPaymentCompleted && !restoredReportUploadEnabled) {
// //           for (var msg in loadedMessages.reversed) {
// //             if (msg.showReportUploadQuestion || msg.reportUploadAnswered) {
// //               restoredReportUploadEnabled = true;
// //               print('🔄 Detected report upload flow from messages');
// //               break;
// //             }
// //           }
// //         }
// //
// //         if (restoredPaymentCompleted && !restoredHasUploadedReport) {
// //           bool userDeclinedUpload = false;
// //           for (var msg in loadedMessages) {
// //             if (msg.isBot == false && msg.text.toLowerCase().contains("no, i don't need to upload reports")) {
// //               userDeclinedUpload = true;
// //               break;
// //             }
// //           }
// //
// //           if (!userDeclinedUpload) {
// //             restoredReportUploadEnabled = true;
// //             print('🔧 Auto-enabling upload for paid session');
// //           }
// //         }
// //
// //         setState(() {
// //           messages = loadedMessages;
// //           currentDoctorType = restoredCurrentDoctorType;
// //           currentSpeciality = restoredCurrentSpeciality;
// //           currentOrderId = restoredCurrentOrderId;
// //           paymentCompleted = restoredPaymentCompleted;
// //           reportUploadEnabled = restoredReportUploadEnabled;
// //           hasUploadedReport = restoredHasUploadedReport;
// //           assignedDoctorName = restoredAssignedDoctorName;
// //           _isSessionEnded = restoredIsSessionEnded;
// //           loadingHistory = false;
// //         });
// //
// //         print('🔄 State restored from chat history:');
// //         print('   - Messages: ${messages.length}');
// //         print('   - paymentCompleted: $paymentCompleted');
// //         print('   - reportUploadEnabled: $reportUploadEnabled');
// //         print('   - hasUploadedReport: $hasUploadedReport');
// //         print('   - currentOrderId: $currentOrderId');
// //         print('   - isSessionEnded: $_isSessionEnded');
// //
// //         if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
// //           print('🔍 Starting order status listener for active session');
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             _startOrderStatusListener();
// //           });
// //         }
// //
// //       } else {
// //         print('❌ HTTP error: ${response.statusCode}');
// //         await _initializeNewChat();
// //       }
// //     } catch (e) {
// //       print('❌ Error loading chat history: $e');
// //       await _initializeNewChat();
// //     }
// //
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _initializeNewChat() async {
// //     try {
// //       print('🔄 Initializing new chat...');
// //
// //       final response = await ChatService.initializeChat(
// //         userId: userId!,
// //         userName: userName ?? 'User',
// //         userPhone: userPhone,
// //         userEmail: userEmail,
// //         orderId: currentOrderId,
// //       );
// //
// //       if (response['success'] == true) {
// //         final messagesData = response['data']['messages'] as List? ?? [];
// //         print('📥 Initialized with ${messagesData.length} messages');
// //
// //         final initialMessages = messagesData.map((msg) => Message.fromMap(msg)).toList();
// //
// //         setState(() {
// //           messages = initialMessages;
// //           loadingHistory = false;
// //         });
// //
// //         if (initialMessages.isNotEmpty && initialMessages.first.orderId != null) {
// //           currentOrderId = initialMessages.first.orderId;
// //           print('📝 Set currentOrderId: $currentOrderId');
// //         }
// //       } else {
// //         throw Exception('Backend returned success: false');
// //       }
// //     } catch (e) {
// //       print('❌ Error initializing chat: $e');
// //       _createFallbackMessages();
// //     }
// //   }
// //
// //   void _createFallbackMessages() {
// //     final welcome = Message(
// //       id: UniqueKey().toString(),
// //       text: "Welcome to Care Connect. We provide professional doctor consultations from the comfort of your home.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     final question = Message(
// //       id: UniqueKey().toString(),
// //       // text: "Would you like to receive a second opinion from a specialist?",
// //       text: "Do you want to continue?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages = [welcome, question];
// //       loadingHistory = false;
// //     });
// //
// //     print('📝 Using fallback local messages');
// //   }
// //
// //   Future<void> sendMessage(Message message) async {
// //     try {
// //       await _sendMessageToBackend(message);
// //     } catch (e) {
// //       print("Error sending message to backend: $e");
// //     }
// //   }
// //
// //   Future<void> _sendMessageToBackend(Message message) async {
// //     if (userId == null) {
// //       print('❌ Cannot send message: User ID is null');
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Sending message to backend: ${message.text}');
// //
// //       final response = await ChatService.sendMessage(
// //         userId: userId!,
// //         message: message.text,
// //         userName: userName ?? 'User',
// //         userPhone: userPhone,
// //         userEmail: userEmail,
// //         doctorType: message.selectedDoctorType ?? currentDoctorType ?? '',
// //         speciality: message.selectedSpeciality ?? currentSpeciality ?? '',
// //         orderId: message.orderId ?? currentOrderId ?? '',
// //         paymentCompleted: message.paymentCompleted || paymentCompleted,
// //       );
// //
// //       print('✅ Message sent to backend successfully');
// //
// //       if (!message.isBot && paymentCompleted && response['success'] == true) {
// //         final botResponse = response['data']['botResponse'];
// //         if (botResponse != null) {
// //           print('🤖 Received bot response');
// //           final botMessage = Message.fromMap(botResponse);
// //           setState(() {
// //             messages.add(botMessage);
// //           });
// //           _scrollToBottom();
// //         } else {
// //           print('ℹ No bot response received');
// //         }
// //       }
// //     } catch (e) {
// //       print('❌ Failed to send message to backend: $e');
// //     }
// //   }
// //
// //   void _onUserSend(String text) async {
// //     if (text.trim().isEmpty) return;
// //     if (!paymentCompleted) {
// //       Helpers.showSnackBar(context, "Please complete payment before sending messages", bgColor: Colors.red);
// //       return;
// //     }
// //     if (_isSessionEnded) {
// //       Helpers.showSnackBar(context, "Session completed - cannot send messages", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     final userMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: text,
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages.add(userMsg);
// //     });
// //
// //     await sendMessage(userMsg);
// //     _controller.clear();
// //     _scrollToBottom();
// //   }
// //
// //   void _onYesButtonPressed(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, I would like a second opinion.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final doctorTypeQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your preferred doctor type:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(doctorTypeQuestion);
// //     });
// //
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(doctorTypeQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   void _onDoctorTypeSelected(Message questionMsg, String doctorType) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       pendingDoctorType: doctorType,
// //     );
// //     final confirmationMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "You selected $doctorType. Would you like to confirm this selection?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       showDoctorTypeConfirmation: true,
// //       pendingDoctorType: doctorType,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(confirmationMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(confirmationMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onDoctorTypeConfirmYes(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final doctorType = confirmMsg.pendingDoctorType!;
// //     final updatedMsg = confirmMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       selectedDoctorType: doctorType,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, confirmed $doctorType",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: doctorType,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       currentDoctorType = doctorType;
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //
// //     if (doctorType == 'Allopathy') {
// //       await _loadSpecializations(doctorType);
// //     } else {
// //       final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //       final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
// //
// //       final paymentMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: doctorType,
// //         selectedSpeciality: defaultSpeciality,
// //         showPaymentButton: true,
// //         amount: amount,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //       setState(() {
// //         currentSpeciality = defaultSpeciality;
// //         messages.add(paymentMsg);
// //       });
// //       await sendMessage(paymentMsg);
// //     }
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _loadSpecializations(String doctorType) async {
// //     try {
// //       print('🔄 Loading specializations for $doctorType...');
// //
// //       final response = await http.get(
// //         Uri.parse('${ApiConfig.baseUrl}/api/patients/doctors/specializations/$doctorType'),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final specializations = List<String>.from(data['data']['specializations']);
// //
// //           if (specializations.isNotEmpty) {
// //             final specialityQuestion = Message(
// //               id: UniqueKey().toString(),
// //               text: "Please select your doctor's speciality:",
// //               isBot: true,
// //               showButtons: true,
// //               buttonClicked: false,
// //               createdAt: DateTime.now(),
// //               selectedDoctorType: doctorType,
// //               userId: userId,
// //               userName: 'Care Connect Bot',
// //             );
// //
// //             setState(() {
// //               messages.add(specialityQuestion);
// //             });
// //             await sendMessage(specialityQuestion);
// //           } else {
// //             _proceedToPayment(doctorType);
// //           }
// //         }
// //       } else {
// //         throw Exception('Failed to load specializations');
// //       }
// //     } catch (e) {
// //       print('❌ Error loading specializations: $e');
// //       if (doctorType == 'Allopathy') {
// //         _showDefaultSpecializations(doctorType);
// //       } else {
// //         _proceedToPayment(doctorType);
// //       }
// //     }
// //   }
// //
// //   void _showDefaultSpecializations(String doctorType) {
// //     List<String> specializations = [];
// //
// //     if (doctorType == 'Allopathy') {
// //       specializations = ['MBBS', 'MD', 'Cardiologist', 'Dermatologist', 'Orthopedic', 'Pediatrician', 'Gynecologist', 'Neurologist', 'Psychiatrist'];
// //     }
// //
// //     if (specializations.isNotEmpty) {
// //       final specialityQuestion = Message(
// //         id: UniqueKey().toString(),
// //         text: "Please select your doctor's speciality:",
// //         isBot: true,
// //         showButtons: true,
// //         buttonClicked: false,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: doctorType,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(specialityQuestion);
// //       });
// //     } else {
// //       _proceedToPayment(doctorType);
// //     }
// //   }
// //
// //   void _proceedToPayment(String doctorType) async {
// //     final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //     final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
// //
// //     final paymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: doctorType,
// //       selectedSpeciality: defaultSpeciality,
// //       showPaymentButton: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       currentSpeciality = defaultSpeciality;
// //       messages.add(paymentMsg);
// //     });
// //     sendMessage(paymentMsg);
// //   }
// //
// //   void _onDoctorTypeConfirmNo(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, let me choose again",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final doctorTypeQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your preferred doctor type:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(doctorTypeQuestion);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(doctorTypeQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialitySelected(Message questionMsg, String speciality) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       pendingSpeciality: speciality,
// //     );
// //     final confirmationMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "You selected $speciality. Would you like to confirm this speciality?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       showSpecialityConfirmation: true,
// //       pendingSpeciality: speciality,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(confirmationMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(confirmationMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialityConfirmYes(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final speciality = confirmMsg.pendingSpeciality!;
// //     final updatedMsg = confirmMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       selectedSpeciality: speciality,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, confirmed $speciality",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: speciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     final amount = await getDynamicConsultationFee(currentDoctorType!, speciality) ?? 500;
// //
// //     final paymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Excellent! You've selected $speciality specialist. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: speciality,
// //       showPaymentButton: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       currentSpeciality = speciality;
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(paymentMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(paymentMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialityConfirmNo(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, let me choose again",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final specialityQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your doctor's speciality:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(specialityQuestion);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(specialityQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   // MODIFIED: Added terms and conditions check
// //   Future<void> _onPaymentButtonPressed(Message paymentMsg) async {
// //     final index = messages.indexWhere((m) => m.id == paymentMsg.id);
// //     if (index == -1) return;
// //     if (paymentCompleted) {
// //       Helpers.showSnackBar(context, "Payment already completed", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     // NEW: Show terms and conditions popup
// //     final acceptedTerms = await _showTermsAndConditionsPopup();
// //     if (!acceptedTerms) {
// //       Helpers.showSnackBar(context, "Please accept terms and conditions to proceed with payment", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     final updatedPaymentMsg = paymentMsg.copyWith(buttonClicked: true, showPaymentButton: true);
// //     final userPaymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Proceeding to payment...",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedPaymentMsg;
// //       messages.add(userPaymentMsg);
// //     });
// //     await sendMessage(updatedPaymentMsg);
// //     await sendMessage(userPaymentMsg);
// //     _scrollToBottom();
// //
// //     String doctorCategory = currentSpeciality ?? currentDoctorType ?? "General";
// //     int amount = paymentMsg.amount ?? 500;
// //     createOrder(amount, doctorCategory);
// //   }
// //
// //   Future<void> createOrder(int amount, String doctorCategory) async {
// //     try {
// //       if (userId == null) {
// //         Helpers.showSnackBar(context, "User ID not found! Please login again.");
// //         return;
// //       }
// //
// //       if (currentDoctorType == null || currentDoctorType!.isEmpty) {
// //         Helpers.showSnackBar(context, "Please select a doctor type first");
// //         return;
// //       }
// //
// //       String finalSpeciality = currentSpeciality ?? '';
// //       if ((currentDoctorType == 'Ayurvedic' || currentDoctorType == 'Homeopathy') &&
// //           (finalSpeciality.isEmpty)) {
// //         finalSpeciality = currentDoctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //         setState(() {
// //           currentSpeciality = finalSpeciality;
// //         });
// //         print('🔄 Set default speciality for ${currentDoctorType}: $finalSpeciality');
// //       }
// //
// //       if (finalSpeciality.isEmpty) {
// //         Helpers.showSnackBar(context, "Please select a speciality first");
// //         return;
// //       }
// //
// //       print('🔄 Creating order for doctor: $currentDoctorType, speciality: $finalSpeciality');
// //       print('🔍 Sending data:');
// //       print('   - UserId: $userId');
// //       print('   - userName: $userName');
// //       print('   - doctorType: $currentDoctorType');
// //       print('   - speciality: $finalSpeciality');
// //
// //       var response = await http.post(
// //         Uri.parse(ApiConfig.orders),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "UserId": userId,
// //           "userName": userName ?? 'User',
// //           "userPhone": userPhone ?? '',
// //           "userEmail": userEmail ?? '',
// //           "doctorType": currentDoctorType,
// //           "speciality": finalSpeciality,
// //           "currency": "INR",
// //         }),
// //       );
// //
// //       print('📥 Order creation response: ${response.statusCode}');
// //       print('📥 Response body: ${response.body}');
// //
// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(response.body);
// //         if (data['success'] == true && data['data'] != null) {
// //           String? orderId;
// //           String? razorpayOrderId;
// //           int? actualAmount;
// //
// //           if (data['data']['orderId'] != null) {
// //             orderId = data['data']['orderId'].toString();
// //           } else if (data['data']['id'] != null) {
// //             orderId = data['data']['id'].toString();
// //           }
// //
// //           if (data['data']['razorpayOrderId'] != null) {
// //             razorpayOrderId = data['data']['razorpayOrderId'].toString();
// //           } else if (data['data']['order_id'] != null) {
// //             razorpayOrderId = data['data']['order_id'].toString();
// //           }
// //
// //           if (data['data']['amount'] != null) {
// //             actualAmount = data['data']['amount'] is int
// //                 ? data['data']['amount']
// //                 : (data['data']['amount'] as double).toInt();
// //             print('💰 Backend calculated amount: ₹$actualAmount');
// //           }
// //
// //           if (orderId != null) {
// //             setState(() {
// //               currentOrderId = orderId;
// //             });
// //
// //             String finalRazorpayOrderId = razorpayOrderId ?? orderId;
// //
// //             print('✅ Order created successfully: $currentOrderId');
// //             print('🔑 Razorpay Order ID: $finalRazorpayOrderId');
// //             print('💰 Amount to pay: ₹$actualAmount');
// //
// //             _updatePaymentMessageWithActualAmount(actualAmount ?? amount);
// //
// //             openCheckout(actualAmount ?? amount, doctorCategory, finalRazorpayOrderId);
// //           } else {
// //             Helpers.showSnackBar(context, "Order created but no order ID returned");
// //           }
// //         } else {
// //           Helpers.showSnackBar(context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
// //         }
// //       } else if (response.statusCode == 400) {
// //         var data = jsonDecode(response.body);
// //         Helpers.showSnackBar(context, "Validation error: ${data['message'] ?? 'Check your inputs'}");
// //       } else {
// //         Helpers.showSnackBar(context, "Doctor Not Available.....");
// //       }
// //     } catch (e) {
// //       print('❌ Order creation error: $e');
// //       Helpers.showSnackBar(context, "Network error: $e");
// //     }
// //   }
// //
// //   void _updatePaymentMessageWithActualAmount(int actualAmount) {
// //     for (int i = messages.length - 1; i >= 0; i--) {
// //       if (messages[i].showPaymentButton && !messages[i].paymentCompleted) {
// //         setState(() {
// //           messages[i] = messages[i].copyWith(
// //             amount: actualAmount,
// //             text: "Great! You've selected ${currentDoctorType} - ${currentSpeciality}. Consultation fee: ₹$actualAmount. Please proceed with payment to start your consultation.",
// //           );
// //         });
// //         break;
// //       }
// //     }
// //   }
// //
// //   Future<void> openCheckout(int amount, String doctorCategory, String razorpayOrderId) async {
// //     var options = {
// //       'key': 'rzp_test_vDQGr1D5EBRubo',
// //       'amount': amount * 100,
// //       'name': 'Care Connect',
// //       'description': 'Consultation Fee - $doctorCategory',
// //       'order_id': razorpayOrderId,
// //       'prefill': {
// //         'contact': userPhone ?? '9999999999',
// //         'email': userEmail ?? 'user@example.com',
// //         'name': userName ?? 'User',
// //       },
// //       'theme': {'color': '#00796B'},
// //       'retry': {'enabled': true, 'max_count': 1},
// //       'timeout': 300,
// //     };
// //
// //     try {
// //       print('💰 Opening Razorpay checkout with options: $options');
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint("❌ Error opening Razorpay: $e");
// //       Helpers.showSnackBar(context, "Error opening payment gateway: $e");
// //     }
// //   }
// //
// //   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
// //     try {
// //       print('✅ Payment successful:');
// //       print('   Order ID: ${response.orderId}');
// //       print('   Payment ID: ${response.paymentId}');
// //       print('   Signature: ${response.signature}');
// //
// //       Helpers.showSnackBar(context, "Verifying payment...", bgColor: Colors.orange);
// //
// //       var verifyResponse = await http.post(
// //         Uri.parse(ApiConfig.verifyPayment),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "razorpay_order_id": response.orderId,
// //           "razorpay_payment_id": response.paymentId,
// //           "razorpay_signature": response.signature,
// //           "userId": userId,
// //           "userName": userName,
// //           "userPhone": userPhone,
// //           "userEmail": userEmail,
// //           "orderId": currentOrderId,
// //           "doctorType": currentDoctorType,
// //           "speciality": currentSpeciality,
// //           "amount": getAmountFromMessages() ?? 500,
// //         }),
// //       );
// //
// //       print('📥 Verification response: ${verifyResponse.statusCode}');
// //       print('📥 Verification body: ${verifyResponse.body}');
// //
// //       var verifyData = jsonDecode(verifyResponse.body);
// //
// //       if (verifyData['success'] == true) {
// //         await _handleSuccessfulPayment(response, verifyData);
// //       } else {
// //         Helpers.showSnackBar(
// //             context,
// //             "Payment verification failed: ${verifyData['message'] ?? 'Unknown error'}",
// //             bgColor: Colors.red
// //         );
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Verification error: $e");
// //       Helpers.showSnackBar(context, "Payment verification error: $e", bgColor: Colors.red);
// //     }
// //   }
// //
// //   int? getAmountFromMessages() {
// //     for (int i = messages.length - 1; i >= 0; i--) {
// //       if (messages[i].amount != null) {
// //         return messages[i].amount;
// //       }
// //     }
// //     return null;
// //   }
// //
// //   Future<void> _handleSuccessfulPayment(PaymentSuccessResponse response, Map<String, dynamic> verifyData) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     int currentOrderCount = prefs.getInt('orderCount') ?? 0;
// //     currentOrderCount++;
// //     await prefs.setInt('orderCount', currentOrderCount);
// //     String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');
// //
// //     setState(() {
// //       paymentCompleted = true;
// //     });
// //
// //     final amount = getAmountFromMessages() ?? 500;
// //
// //     final paymentSuccessMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Payment successful and verified! ✅",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       orderId: currentOrderId,
// //       paymentId: response.paymentId,
// //       orderNumber: displayOrderNo,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     final amountMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "₹$amount has been successfully processed for Order #$displayOrderNo",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       paymentCompleted: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages.add(paymentSuccessMsg);
// //       messages.add(amountMsg);
// //     });
// //
// //     await sendMessage(paymentSuccessMsg);
// //     await sendMessage(amountMsg);
// //
// //     await _handleDoctorAssignment(verifyData);
// //
// //     print('💰 Payment completed, starting session end listener...');
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _startOrderStatusListener();
// //     });
// //
// //     await _askReportUploadQuestion();
// //     _scrollToBottom();
// //
// //     Helpers.showSnackBar(
// //         context,
// //         "Payment successful! Order #$displayOrderNo created.",
// //         bgColor: AppColors.accent
// //     );
// //   }
// //
// //   Future<void> _handleDoctorAssignment(Map<String, dynamic> verifyData) async {
// //     if (verifyData['data']['assignedDoctor'] != null) {
// //       final assignedDoctor = verifyData['data']['assignedDoctor'];
// //       setState(() {
// //         assignedDoctorName = assignedDoctor['name'];
// //         assignedDoctorSpeciality = assignedDoctor['speciality'];
// //       });
// //
// //       final doctorAssignmentMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Great news! Dr. ${assignedDoctor['name']} (${assignedDoctor['speciality']}) has been assigned to your case. They will connect with you shortly.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         paymentCompleted: true,
// //         assignedDoctorId: assignedDoctor['id'],
// //         assignedDoctorName: assignedDoctor['name'],
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(doctorAssignmentMsg);
// //       });
// //       await sendMessage(doctorAssignmentMsg);
// //     } else {
// //       final waitingMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Payment successful! We're finding the best ${currentSpeciality} ${currentDoctorType} doctor for you. You'll be notified when a doctor is assigned.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         paymentCompleted: true,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(waitingMsg);
// //       });
// //       await sendMessage(waitingMsg);
// //     }
// //   }
// //
// //   Future<void> _askReportUploadQuestion() async {
// //     final reportQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Would you like to upload any medical reports for the doctor to review?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       showReportUploadQuestion: true,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       messages.add(reportQuestion);
// //     });
// //     await sendMessage(reportQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onReportUploadYes(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       reportUploadAnswered: true,
// //       wantsToUploadReport: true,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, I would like to upload reports.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     // NEW: Show upload button in chat instead of instruction message
// //     final uploadButtonMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Great! Click the button below to upload your medical reports.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       showReportUploadButton: true, // This will show the upload button in chat
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(uploadButtonMsg);
// //       reportUploadEnabled = true;
// //       hasUploadedReport = false;
// //     });
// //
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(uploadButtonMsg);
// //
// //     final chatEnableMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: assignedDoctorName != null
// //           ? "You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
// //           : "You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       assignedDoctorName: assignedDoctorName,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages.add(chatEnableMsg);
// //     });
// //
// //     await sendMessage(chatEnableMsg);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onReportUploadNo(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       reportUploadAnswered: true,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, I don't need to upload reports right now.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final chatEnableMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: assignedDoctorName != null
// //           ? "No problem! You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
// //           : "No problem! You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       assignedDoctorName: assignedDoctorName,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(chatEnableMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(chatEnableMsg);
// //     _scrollToBottom();
// //   }
// //
// //   // MODIFIED: Added report storage functionality
// //   Future<void> _onReportUploadButtonPressed(Message uploadMsg) async {
// //     final index = messages.indexWhere((m) => m.id == uploadMsg.id);
// //     if (index == -1) return;
// //
// //     if (!reportUploadEnabled) {
// //       Helpers.showSnackBar(context, "Please complete payment and confirm report upload first", bgColor: Colors.orange);
// //       return;
// //     }
// //     if (hasUploadedReport) {
// //       Helpers.showSnackBar(context, "You have already uploaded reports. Upload is allowed only once.", bgColor: Colors.orange);
// //       return;
// //     }
// //     if (_isSessionEnded) {
// //       Helpers.showSnackBar(context, "Session completed - cannot upload files", bgColor: Colors.orange);
// //       return;
// //     }
// //     if (currentOrderId == null) {
// //       Helpers.showSnackBar(context, "No active order found", bgColor: Colors.red);
// //       return;
// //     }
// //
// //     print('📤 Navigating to upload with orderId: $currentOrderId, userId: $userId');
// //
// //     final result = await Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => UploadFiles(
// //         orderId: currentOrderId!,
// //         userId: userId!,
// //       )),
// //     );
// //
// //     if (result != null && result is Map<String, dynamic> && result['status'] == 'uploaded') {
// //       List<Map<String, dynamic>> uploadedReports = List<Map<String, dynamic>>.from(result['reports']);
// //
// //       final uploadSuccessMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Medical reports uploaded successfully! ✅\nTotal files: ${uploadedReports.length}",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         reportUploaded: true,
// //         reportFiles: uploadedReports,
// //         assignedDoctorName: assignedDoctorName,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(uploadSuccessMsg);
// //         hasUploadedReport = true;
// //       });
// //
// //       await sendMessage(uploadSuccessMsg);
// //       _scrollToBottom();
// //
// //       Helpers.showSnackBar(context, "Reports uploaded successfully!", bgColor: AppColors.accent);
// //
// //       await _loadChatHistoryOrInitialize();
// //     }
// //   }
// //
// //   // NEW: Method to open uploaded file
// //   Future<void> _openUploadedFile(Map<String, dynamic> report) async {
// //     try {
// //       final filePath = report['filePath']?.toString();
// //       final fileName = report['fileName']?.toString() ?? 'Unknown File';
// //
// //       if (filePath == null || filePath.isEmpty) {
// //         Helpers.showSnackBar(context, "File path not available", bgColor: Colors.red);
// //         return;
// //       }
// //
// //       print('📂 Opening file: $fileName');
// //       print('📍 File path: $filePath');
// //
// //       final result = await OpenFilex.open(filePath);
// //
// //       if (result.type == ResultType.done) {
// //         debugPrint("✅ File opened successfully: $fileName");
// //       } else if (result.type == ResultType.noAppToOpen) {
// //         Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
// //       } else if (result.type == ResultType.fileNotFound) {
// //         Helpers.showSnackBar(context, "File not found at: $filePath", bgColor: Colors.red);
// //       } else {
// //         Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Error opening file: $e");
// //       Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
// //     }
// //   }
// //
// //   // Helper method for file icons
// //   IconData _getFileIcon(String fileType) {
// //     if (fileType.toLowerCase().contains('image')) return Icons.image;
// //     if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
// //     if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
// //       return Icons.description;
// //     return Icons.insert_drive_file;
// //   }
// //
// //   Future<void> _openFile(String filePath, String fileName) async {
// //     try {
// //       final result = await OpenFilex.open(filePath);
// //       if (result.type == ResultType.done) {
// //         debugPrint("✅ File opened successfully: $fileName");
// //       } else if (result.type == ResultType.noAppToOpen) {
// //         Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
// //       } else if (result.type == ResultType.fileNotFound) {
// //         Helpers.showSnackBar(context, "File not found at: $filePath", bgColor: Colors.red);
// //       } else {
// //         Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Error opening file: $e");
// //       Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
// //     }
// //   }
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     final errorMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Payment could not be completed. Please try again.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       messages.add(errorMsg);
// //     });
// //     sendMessage(errorMsg);
// //     Helpers.showSnackBar(context, "Payment failed: ${response.message}", bgColor: Colors.red);
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
// //   }
// //
// //   Widget buildIntroCard(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.all(14),
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: AppColors.primary.withOpacity(0.08),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: AppColors.primary, width: 1.2),
// //         boxShadow: [
// //           BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2)),
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
// //                 "Care Connect",
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
// //             style: TextStyle(fontSize: 15.5, color: Colors.grey[800]),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             children: [
// //               Icon(Icons.verified_user, color: AppColors.accent, size: 20),
// //               const SizedBox(width: 5),
// //               Text(
// //                 "Trusted | Secure | Confidential",
// //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.primary),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 18),
// //           Text(
// //             "How it works:",
// //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
// //           ),
// //           const SizedBox(height: 8),
// //           _buildStep(stepNumber: 1, icon: Icons.person_search, label: "Choose your doctor type and specialty"),
// //           const SizedBox(height: 5),
// //           _buildStep(stepNumber: 2, icon: Icons.payment, label: "Make a secure online payment"),
// //           const SizedBox(height: 5),
// //           _buildStep(stepNumber: 3, icon: Icons.message_outlined, label: "Upload reports, Chat & get advice"),
// //           const SizedBox(height: 18),
// //           GestureDetector(
// //             onTap: () => Navigator.pushNamed(context, '/help'),
// //             child: Text(
// //               "Help & Support",
// //               style: TextStyle(decoration: TextDecoration.underline, color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStep({required int stepNumber, required IconData icon, required String label}) {
// //     return Row(
// //       children: [
// //         CircleAvatar(
// //           radius: 13,
// //           backgroundColor: AppColors.primary,
// //           child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
// //         ),
// //         const SizedBox(width: 8),
// //         Icon(icon, size: 18, color: AppColors.accent),
// //         const SizedBox(width: 7),
// //         Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, color: Colors.grey[800]))),
// //       ],
// //     );
// //   }
// //
// //   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
// //     return ListTile(
// //       leading: Icon(icon, size: 25, color: AppColors.iconColor),
// //       title: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //       ),
// //       onTap: onTap,
// //     );
// //   }
// //
// //   void _scrollToBottom() {
// //     if (!_scrollController.hasClients) return;
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (_scrollController.hasClients) {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: const Duration(milliseconds: 300),
// //           curve: Curves.easeOut,
// //         );
// //       }
// //     });
// //   }
// //
// //   Widget buildMessageBubble(Message msg) {
// //     final isUser = !msg.isBot;
// //
// //     final showSecondOpinionButton = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("second opinion");
// //     final showDoctorTypeDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your preferred doctor type");
// //     final showSpecialityDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your doctor's speciality");
// //     final showReportUploadButtons = msg.showReportUploadQuestion && msg.showButtons && !msg.buttonClicked;
// //     final showDoctorTypeConfirmation = msg.showDoctorTypeConfirmation && msg.showButtons && !msg.buttonClicked;
// //     final showSpecialityConfirmation = msg.showSpecialityConfirmation && msg.showButtons && !msg.buttonClicked;
// //     final shouldShowPaymentButton = msg.showPaymentButton && !paymentCompleted;
// //     final shouldShowReportUploadButton = msg.showReportUploadButton && reportUploadEnabled && !hasUploadedReport && !_isSessionEnded;
// //
// //     return Align(
// //       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //         padding: const EdgeInsets.all(12),
// //         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
// //         decoration: BoxDecoration(
// //           color: isUser ? AppColors.chatUser : AppColors.chatBot,
// //           borderRadius: BorderRadius.only(
// //             topLeft: const Radius.circular(16),
// //             topRight: const Radius.circular(16),
// //             bottomLeft: isUser ? const Radius.circular(16) : Radius.circular(0),
// //             bottomRight: isUser ? Radius.circular(0) : const Radius.circular(16),
// //           ),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               msg.text,
// //               style: TextStyle(color: isUser ? AppColors.chatUserText : AppColors.chatBotText, fontSize: 15),
// //             ),
// //
// //             if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.green.shade50,
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(color: Colors.green.shade200),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.medical_services, color: Colors.green.shade700, size: 16),
// //                       const SizedBox(width: 8),
// //                       Flexible(
// //                         child: Text(
// //                           "Assigned: Dr. ${msg.assignedDoctorName}",
// //                           style: TextStyle(
// //                             color: Colors.green.shade800,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //             // ENHANCED: Better uploaded reports display
// //             if (msg.reportUploaded == true && msg.reportFiles != null && msg.reportFiles!.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "📁 Uploaded Reports (${msg.reportFiles!.length}):",
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         color: isUser ? AppColors.chatUserText : AppColors.chatBotText,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 6),
// //                     ...msg.reportFiles!.map((report) {
// //                       final fileName = report['fileName']?.toString() ?? 'Unknown File';
// //                       final fileSize = report['fileSize'] ?? 0;
// //                       final fileType = report['fileType']?.toString() ?? 'file';
// //
// //                       return GestureDetector(
// //                         onTap: () => _openFile(report['filePath'], fileName),
// //                         child: Container(
// //                           margin: const EdgeInsets.only(bottom: 6),
// //                           padding: const EdgeInsets.all(10),
// //                           decoration: BoxDecoration(
// //                             color: isUser ? Colors.blue.shade50 : Colors.green.shade50,
// //                             borderRadius: BorderRadius.circular(10),
// //                             border: Border.all(color: isUser ? Colors.blue.shade200 : Colors.green.shade200),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               Container(
// //                                 padding: const EdgeInsets.all(6),
// //                                 decoration: BoxDecoration(
// //                                   color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
// //                                   borderRadius: BorderRadius.circular(6),
// //                                 ),
// //                                 child: Icon(
// //                                   _getFileIcon(fileType),
// //                                   color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
// //                                   size: 18,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 10),
// //                               Expanded(
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       fileName,
// //                                       style: TextStyle(
// //                                         color: isUser ? Colors.blue.shade900 : Colors.green.shade900,
// //                                         fontWeight: FontWeight.w600,
// //                                         fontSize: 12,
// //                                       ),
// //                                       maxLines: 1,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                     const SizedBox(height: 2),
// //                                     Text(
// //                                       _formatFileSize(fileSize is int ? fileSize : 0),
// //                                       style: TextStyle(
// //                                         color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
// //                                         fontSize: 10,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               Icon(
// //                                 Icons.visibility_outlined,
// //                                 color: isUser ? Colors.blue.shade600 : Colors.green.shade600,
// //                                 size: 16,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showSecondOpinionButton)
// //               Padding(padding: const EdgeInsets.only(top: 8.0), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onYesButtonPressed(msg), child: const Text("Yes"))),
// //
// //             if (showReportUploadButtons)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onReportUploadYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onReportUploadNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showDoctorTypeConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showSpecialityConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showDoctorTypeDropdown)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
// //                   child: DropdownButton<String>(
// //                     hint: const Text("Select Doctor Type"),
// //                     isExpanded: true,
// //                     underline: const SizedBox(),
// //                     items: const [
// //                       DropdownMenuItem(value: "Allopathy", child: Text("Allopathy ")),
// //                       DropdownMenuItem(value: "Ayurvedic", child: Text("Ayurvedic ")),
// //                       DropdownMenuItem(value: "Homeopathy", child: Text("Homeopathy ")),
// //                     ],
// //                     onChanged: (value) {
// //                       if (value != null) _onDoctorTypeSelected(msg, value);
// //                     },
// //                   ),
// //                 ),
// //               ),
// //
// //             if (showSpecialityDropdown)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
// //                   child: DropdownButton<String>(
// //                     hint: const Text("Select Speciality"),
// //                     isExpanded: true,
// //                     underline: const SizedBox(),
// //                     items: const [
// //                       DropdownMenuItem(value: "MBBS", child: Text("MBBS (General Physician)")),
// //                       DropdownMenuItem(value: "MD", child: Text("MD (Doctor of Medicine)")),
// //                       DropdownMenuItem(value: "Dentist", child: Text("Dentist")),
// //                       DropdownMenuItem(value: "Cardiologist", child: Text("Cardiologist")),
// //                       DropdownMenuItem(value: "Dermatologist", child: Text("Dermatologist")),
// //                       DropdownMenuItem(value: "Orthopedic", child: Text("Orthopedic")),
// //                       DropdownMenuItem(value: "Pediatrician", child: Text("Pediatrician")),
// //                       DropdownMenuItem(value: "Gynecologist", child: Text("Gynecologist")),
// //                     ],
// //                     onChanged: (value) {
// //                       if (value != null) _onSpecialitySelected(msg, value);
// //                     },
// //                   ),
// //                 ),
// //               ),
// //
// //             if (shouldShowPaymentButton)
// //               Builder(builder: (context) {
// //                 final amount = msg.amount ?? 500;
// //                 return Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: !paymentCompleted ? Colors.green[700] : Colors.grey,
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                     ),
// //                     onPressed: !paymentCompleted ? () => _onPaymentButtonPressed(msg) : null,
// //                     icon: const Icon(Icons.payment),
// //                     label: Text("Pay ₹$amount"),
// //                   ),
// //                 );
// //               }),
// //
// //             // Upload report button in chat bubble
// //             if (shouldShowReportUploadButton)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: ElevatedButton.icon(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: AppColors.primary,
// //                     foregroundColor: Colors.white,
// //                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                   ),
// //                   onPressed: () => _onReportUploadButtonPressed(msg),
// //                   icon: const Icon(Icons.upload_file),
// //                   label: const Text("Upload Medical Reports"),
// //                 ),
// //               ),
// //
// //             if (msg.buttonClicked && msg.selectedDoctorType != null && !msg.paymentCompleted && !msg.showDoctorTypeConfirmation && !msg.showSpecialityConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Text(
// //                   msg.selectedSpeciality != null ? "Selected: ${msg.selectedDoctorType} - ${msg.selectedSpeciality}" : "Selected: ${msg.selectedDoctorType}",
// //                   style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12),
// //                 ),
// //               ),
// //
// //             if (msg.createdAt != null)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   _formatMessageTime(msg.createdAt!),
// //                   style: const TextStyle(fontSize: 10, color: Colors.grey),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _refreshChat() async {
// //     setState(() {
// //       loadingHistory = true;
// //     });
// //
// //     await _loadChatHistoryOrInitialize();
// //
// //     setState(() {
// //       loadingHistory = false;
// //     });
// //
// //     Helpers.showSnackBar(context, "Chat refreshed", bgColor: Colors.green);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (loadingHistory || userId == null) {
// //       return const Scaffold(
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               CircularProgressIndicator(),
// //               SizedBox(height: 16),
// //               Text('Restoring your chat session...'),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         iconTheme: IconThemeData(color: AppColors.iconColor),
// //         backgroundColor: AppColors.primary,
// //         titleSpacing: 0,
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Flexible(
// //               child: Text(
// //                 "Care Connect",
// //                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //             ),
// //             if (currentDoctorType != null) ...[
// //               const SizedBox(width: 5),
// //               Flexible(
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                   decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
// //                   child: Text(
// //                     currentDoctorType!,
// //                     style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
// //                     overflow: TextOverflow.ellipsis,
// //                     maxLines: 1,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //         actions: [
// //           IconButton(
// //             onPressed: _refreshChat,
// //             icon: Icon(Icons.refresh, color: AppColors.iconColor),
// //             tooltip: "Refresh Chat",
// //           ),
// //           IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor)),
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
// //                   children: const [
// //                     CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/logo.png"), backgroundColor: Colors.white),
// //                     SizedBox(height: 10),
// //                     Text("CareConnect", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// //                     Text("info@CareConnect.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               Expanded(
// //                 child: ListView(
// //                   padding: EdgeInsets.zero,
// //                   children: [
// //                     drawerItem("Home", Icons.home, () => Navigator.pushNamed(context, '/home')),
// //                     drawerItem("Doctors", Icons.add, () => Navigator.pushNamed(context, '/doctors')),
// //                     // drawerItem("Orders", Icons.file_copy_sharp, () => Navigator.pushNamed(context, '/orders')),
// //                     drawerItem("Terms & Privacy", Icons.privacy_tip, () => Navigator.pushNamed(context, '/terms')),
// //                     drawerItem("Help & Guide", Icons.help_outline, () => Navigator.pushNamed(context, '/help')),
// //                     drawerItem("Log Out", Icons.logout_sharp, () async {
// //                       bool? confirm = await showDialog<bool>(
// //                         context: context,
// //                         builder: (context) => AlertDialog(
// //                           title: const Text("Confirm Logout"),
// //                           content: const Text("Are you sure you want to logout?"),
// //                           actions: [
// //                             TextButton(
// //                                 onPressed: () => Navigator.pop(context, false),
// //                                 child: const Text("Cancel")
// //                             ),
// //                             TextButton(
// //                                 onPressed: () => Navigator.pop(context, true),
// //                                 child: const Text("Logout")
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //
// //                       if (confirm == true && mounted) {
// //                         try {
// //                           final prefs = await SharedPreferences.getInstance();
// //                           final token = prefs.getString('token');
// //
// //                           print('🔐 Attempting logout...');
// //                           print('📱 Token available: ${token != null}');
// //
// //                           if (token != null) {
// //                             final url = Uri.parse("${ApiConfig.baseUrl}/logout");
// //                             print('📤 Calling logout API: $url');
// //
// //                             final response = await http.post(
// //                               url,
// //                               headers: {
// //                                 'Content-Type': 'application/json',
// //                                 'Authorization': 'Bearer $token',
// //                               },
// //                             );
// //
// //                             print('📥 Logout API Response Status: ${response.statusCode}');
// //                             print('📥 Logout API Response Body: ${response.body}');
// //
// //                             if (response.statusCode == 200) {
// //                               final responseData = jsonDecode(response.body);
// //                               if (responseData['success'] == true) {
// //                                 print('✅ Logout API successful');
// //                               } else {
// //                                 print('⚠ Logout API returned success: false');
// //                               }
// //                             } else {
// //                               print('❌ Logout API failed with status: ${response.statusCode}');
// //                             }
// //                           } else {
// //                             print('⚠ No token found, proceeding with local logout');
// //                           }
// //
// //                           await prefs.clear();
// //                           print('✅ Local storage cleared');
// //
// //                           if (mounted) {
// //                             Navigator.pushNamedAndRemoveUntil(
// //                               context,
// //                               '/login',
// //                                   (route) => false,
// //                             );
// //                           }
// //
// //                           Helpers.showSnackBar(
// //                               context,
// //                               "Logged out successfully",
// //                               bgColor: Colors.green
// //                           );
// //
// //                         } catch (e) {
// //                           print('❌ Logout error: $e');
// //
// //                           final prefs = await SharedPreferences.getInstance();
// //                           await prefs.clear();
// //
// //                           if (mounted) {
// //                             Navigator.pushNamedAndRemoveUntil(
// //                               context,
// //                               '/login',
// //                                   (route) => false,
// //                             );
// //                           }
// //
// //                           Helpers.showSnackBar(
// //                               context,
// //                               "Logged out successfully",
// //                               bgColor: Colors.green
// //                           );
// //                         }
// //                       }
// //                     }),
// //                   ],
// //                 ),
// //               ),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               const Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 80),
// //                 child: Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text("Made With", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
// //                       SizedBox(width: 5),
// //                       Icon(Icons.favorite, color: AppColors.textLight, size: 14),
// //                       SizedBox(width: 5),
// //                       Text("By VSGLogic", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
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
// //             child: ListView.builder(
// //               padding: const EdgeInsets.symmetric(vertical: 10),
// //               controller: _scrollController,
// //               itemCount: messages.length + 1,
// //               itemBuilder: (context, index) {
// //                 if (index == 0) return buildIntroCard(context);
// //                 final msg = messages[index - 1];
// //
// //                 bool showDate = false;
// //                 if (index == 1) {
// //                   showDate = true;
// //                 } else {
// //                   final prevMsg = messages[index - 2];
// //                   if (msg.createdAt != null && prevMsg.createdAt != null) {
// //                     showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
// //                   }
// //                 }
// //
// //                 return Column(
// //                   children: [
// //                     if (showDate && msg.createdAt != null)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                           decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
// //                           child: Text(formatDate(msg.createdAt!), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight)),
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
// //               child: Column(
// //                 children: [
// //                   if (_isSessionEnded)
// //                     Container(
// //                       width: double.infinity,
// //                       margin: const EdgeInsets.only(bottom: 8),
// //                       padding: const EdgeInsets.all(12),
// //                       decoration: BoxDecoration(
// //                         color: Colors.orange.shade100,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.info, color: Colors.orange.shade800),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               "Session completed by doctor. Starting new chat...",
// //                               style: TextStyle(
// //                                 color: Colors.orange.shade800,
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                   Row(
// //                     children: [
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                           decoration: BoxDecoration(
// //                             color: paymentCompleted && !_isSessionEnded ? Colors.white : Colors.grey.shade300,
// //                             borderRadius: BorderRadius.circular(21),
// //                           ),
// //                           child: TextField(
// //                             controller: _controller,
// //                             enabled: paymentCompleted && !_isSessionEnded,
// //                             keyboardType: TextInputType.multiline,
// //                             textInputAction: TextInputAction.newline,
// //                             minLines: 1,
// //                             maxLines: 4,
// //                             decoration: InputDecoration.collapsed(
// //                               hintText: _isSessionEnded
// //                                   ? "Session completed - Starting new chat..."
// //                                   : paymentCompleted
// //                                   ? "Type your message here"
// //                                   : "Complete payment to chat",
// //                             ),
// //                             onChanged: (text) {
// //                               WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       GestureDetector(
// //                         onTap: paymentCompleted && !_isSessionEnded
// //                             ? () {
// //                           if (_controller.text.trim().isNotEmpty) {
// //                             _onUserSend(_controller.text.trim());
// //                             _controller.clear();
// //                           }
// //                         }
// //                             : null,
// //                         child: Icon(
// //                             Icons.send,
// //                             color: paymentCompleted && !_isSessionEnded ? AppColors.iconColor : Colors.grey
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// // import 'helper.dart';
// // import 'package:intl/intl.dart';
// // import 'upload_files.dart';
// // import 'package:open_filex/open_filex.dart';
// // import 'services/chat_service.dart';
// // import 'dart:async';
// // import 'dart:math';
// //
// // String formatDate(DateTime date) {
// //   final now = DateTime.now();
// //   if (isSameDay(date, now)) {
// //     return "Today";
// //   }
// //   return DateFormat.yMMMMd().format(date);
// // }
// //
// // bool isSameDay(DateTime a, DateTime b) {
// //   return a.year == b.year && a.month == b.month && a.day == b.day;
// // }
// //
// // String _formatFileSize(dynamic size) {
// //   if (size == null) return 'Unknown';
// //   final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
// //   if (bytes <= 0) return "0 B";
// //   const suffixes = ["B", "KB", "MB", "GB"];
// //   var i = (log(bytes) / log(1024)).floor();
// //   return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
// // }
// //
// // String _formatMessageTime(DateTime dateTime) {
// //   final localTime = dateTime.toLocal();
// //   final hour = localTime.hour.toString().padLeft(2, '0');
// //   final minute = localTime.minute.toString().padLeft(2, '0');
// //   return '$hour:$minute';
// // }
// //
// // class Message {
// //   final String id;
// //   final String text;
// //   final bool isBot;
// //   final bool showButtons;
// //   final bool buttonClicked;
// //   final DateTime? createdAt;
// //   final String? selectedDoctorType;
// //   final String? selectedSpeciality;
// //   final bool showPaymentButton;
// //   final bool paymentCompleted;
// //   final String? orderId;
// //   final String? paymentId;
// //   final String? orderNumber;
// //   final int? amount;
// //   final bool showReportUploadQuestion;
// //   final bool reportUploadAnswered;
// //   final bool wantsToUploadReport;
// //   final bool showReportUploadButton;
// //   final bool reportUploaded;
// //   final List<Map<String, dynamic>>? reportFiles;
// //   final bool showDoctorTypeConfirmation;
// //   final bool showSpecialityConfirmation;
// //   final String? pendingDoctorType;
// //   final String? pendingSpeciality;
// //   final String? userId;
// //   final String? userName;
// //   final String? assignedDoctorId;
// //   final String? assignedDoctorName;
// //   final bool hasUploadPermission;
// //
// //   Message({
// //     required this.id,
// //     required this.text,
// //     required this.isBot,
// //     this.showButtons = false,
// //     this.buttonClicked = false,
// //     this.createdAt,
// //     this.selectedDoctorType,
// //     this.selectedSpeciality,
// //     this.showPaymentButton = false,
// //     this.paymentCompleted = false,
// //     this.orderId,
// //     this.paymentId,
// //     this.orderNumber,
// //     this.amount,
// //     this.showReportUploadQuestion = false,
// //     this.reportUploadAnswered = false,
// //     this.wantsToUploadReport = false,
// //     this.showReportUploadButton = false,
// //     this.reportUploaded = false,
// //     this.reportFiles,
// //     this.showDoctorTypeConfirmation = false,
// //     this.showSpecialityConfirmation = false,
// //     this.pendingDoctorType,
// //     this.pendingSpeciality,
// //     this.userId,
// //     this.userName,
// //     this.assignedDoctorId,
// //     this.assignedDoctorName,
// //     this.hasUploadPermission = false,
// //   });
// //
// //   factory Message.fromMap(Map<String, dynamic> map) {
// //     final bool buttonClicked = map['buttonClicked'] == true;
// //     final bool showButtonsRaw = map['showButtons'] == true;
// //
// //     int? amount;
// //     if (map['amount'] != null) {
// //       if (map['amount'] is int) {
// //         amount = map['amount'];
// //       } else if (map['amount'] is double) {
// //         amount = (map['amount'] as double).toInt();
// //       } else if (map['amount'] is String) {
// //         amount = int.tryParse(map['amount']);
// //       }
// //     }
// //
// //     String? safeString(String? value) {
// //       return (value == null || value.isEmpty) ? null : value;
// //     }
// //
// //     return Message(
// //       id: map['_id'] ?? map['id'] ?? UniqueKey().toString(),
// //       text: map['text'] ?? "",
// //       isBot: map['isBot'] ?? false,
// //       showButtons: showButtonsRaw && !buttonClicked,
// //       buttonClicked: buttonClicked,
// //       createdAt: map['createdAt'] != null
// //           ? DateTime.tryParse(map['createdAt'].toString())
// //           : DateTime.now(),
// //       selectedDoctorType: safeString(map['selectedDoctorType']),
// //       selectedSpeciality: safeString(map['selectedSpeciality']),
// //       showPaymentButton: map['showPaymentButton'] ?? false,
// //       paymentCompleted: map['paymentCompleted'] ?? false,
// //       orderId: safeString(map['orderId']),
// //       paymentId: safeString(map['paymentId']),
// //       orderNumber: safeString(map['orderNumber']),
// //       amount: amount,
// //       showReportUploadQuestion: map['showReportUploadQuestion'] ?? false,
// //       reportUploadAnswered: map['reportUploadAnswered'] ?? false,
// //       wantsToUploadReport: map['wantsToUploadReport'] ?? false,
// //       showReportUploadButton: map['showReportUploadButton'] ?? false,
// //       reportUploaded: map['reportUploaded'] ?? false,
// //       reportFiles: map['reportFiles'] != null && map['reportFiles'] is List
// //           ? List<Map<String, dynamic>>.from(map['reportFiles'])
// //           : null,
// //       showDoctorTypeConfirmation: map['showDoctorTypeConfirmation'] ?? false,
// //       showSpecialityConfirmation: map['showSpecialityConfirmation'] ?? false,
// //       pendingDoctorType: safeString(map['pendingDoctorType']),
// //       pendingSpeciality: safeString(map['pendingSpeciality']),
// //       userId: safeString(map['userId']),
// //       userName: safeString(map['userName']) ?? 'Care Connect Bot',
// //       assignedDoctorId: safeString(map['assignedDoctorId']),
// //       assignedDoctorName: safeString(map['assignedDoctorName']),
// //       hasUploadPermission: map['hasUploadPermission'] ?? false,
// //     );
// //   }
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'text': text,
// //       'isBot': isBot,
// //       'showButtons': showButtons,
// //       'buttonClicked': buttonClicked,
// //       'createdAt': createdAt?.toIso8601String(),
// //       'selectedDoctorType': selectedDoctorType,
// //       'selectedSpeciality': selectedSpeciality,
// //       'showPaymentButton': showPaymentButton,
// //       'paymentCompleted': paymentCompleted,
// //       'orderId': orderId,
// //       'paymentId': paymentId,
// //       'orderNumber': orderNumber,
// //       'amount': amount,
// //       'showReportUploadQuestion': showReportUploadQuestion,
// //       'reportUploadAnswered': reportUploadAnswered,
// //       'wantsToUploadReport': wantsToUploadReport,
// //       'showReportUploadButton': showReportUploadButton,
// //       'reportUploaded': reportUploaded,
// //       'reportFiles': reportFiles,
// //       'showDoctorTypeConfirmation': showDoctorTypeConfirmation,
// //       'showSpecialityConfirmation': showSpecialityConfirmation,
// //       'pendingDoctorType': pendingDoctorType,
// //       'pendingSpeciality': pendingSpeciality,
// //       'userId': userId,
// //       'userName': userName,
// //       'assignedDoctorId': assignedDoctorId,
// //       'assignedDoctorName': assignedDoctorName,
// //       'hasUploadPermission': hasUploadPermission,
// //     };
// //   }
// //
// //   Message copyWith({
// //     String? id,
// //     String? text,
// //     bool? isBot,
// //     bool? showButtons,
// //     bool? buttonClicked,
// //     DateTime? createdAt,
// //     String? selectedDoctorType,
// //     String? selectedSpeciality,
// //     bool? showPaymentButton,
// //     bool? paymentCompleted,
// //     String? orderId,
// //     String? paymentId,
// //     String? orderNumber,
// //     int? amount,
// //     bool? showReportUploadQuestion,
// //     bool? reportUploadAnswered,
// //     bool? wantsToUploadReport,
// //     bool? showReportUploadButton,
// //     bool? reportUploaded,
// //     List<Map<String, dynamic>>? reportFiles,
// //     bool? showDoctorTypeConfirmation,
// //     bool? showSpecialityConfirmation,
// //     String? pendingDoctorType,
// //     String? pendingSpeciality,
// //     String? userId,
// //     String? userName,
// //     String? assignedDoctorId,
// //     String? assignedDoctorName,
// //     bool? hasUploadPermission,
// //   }) {
// //     return Message(
// //       id: id ?? this.id,
// //       text: text ?? this.text,
// //       isBot: isBot ?? this.isBot,
// //       showButtons: showButtons ?? this.showButtons,
// //       buttonClicked: buttonClicked ?? this.buttonClicked,
// //       createdAt: createdAt ?? this.createdAt,
// //       selectedDoctorType: selectedDoctorType ?? this.selectedDoctorType,
// //       selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
// //       showPaymentButton: showPaymentButton ?? this.showPaymentButton,
// //       paymentCompleted: paymentCompleted ?? this.paymentCompleted,
// //       orderId: orderId ?? this.orderId,
// //       paymentId: paymentId ?? this.paymentId,
// //       orderNumber: orderNumber ?? this.orderNumber,
// //       amount: amount ?? this.amount,
// //       showReportUploadQuestion: showReportUploadQuestion ?? this.showReportUploadQuestion,
// //       reportUploadAnswered: reportUploadAnswered ?? this.reportUploadAnswered,
// //       wantsToUploadReport: wantsToUploadReport ?? this.wantsToUploadReport,
// //       showReportUploadButton: showReportUploadButton ?? this.showReportUploadButton,
// //       reportUploaded: reportUploaded ?? this.reportUploaded,
// //       reportFiles: reportFiles ?? this.reportFiles,
// //       showDoctorTypeConfirmation: showDoctorTypeConfirmation ?? this.showDoctorTypeConfirmation,
// //       showSpecialityConfirmation: showSpecialityConfirmation ?? this.showSpecialityConfirmation,
// //       pendingDoctorType: pendingDoctorType ?? this.pendingDoctorType,
// //       pendingSpeciality: pendingSpeciality ?? this.pendingSpeciality,
// //       userId: userId ?? this.userId,
// //       userName: userName ?? this.userName,
// //       assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
// //       assignedDoctorName: assignedDoctorName ?? this.assignedDoctorName,
// //       hasUploadPermission: hasUploadPermission ?? this.hasUploadPermission,
// //     );
// //   }
// // }
// //
// // class HomePage extends StatefulWidget {
// //   final String? orderId;
// //   final bool isExistingOrder;
// //
// //   const HomePage({
// //     super.key,
// //     this.orderId,
// //     this.isExistingOrder = false,
// //   });
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   List<Message> messages = [];
// //   TextEditingController _controller = TextEditingController();
// //   String? userId;
// //   String? userName;
// //   String? userPhone;
// //   String? userEmail;
// //   bool loadingHistory = true;
// //   final ScrollController _scrollController = ScrollController();
// //   String? currentDoctorType;
// //   String? currentSpeciality;
// //   String? currentOrderId;
// //   bool paymentCompleted = false;
// //   bool reportUploadEnabled = false;
// //   bool hasUploadedReport = false;
// //   late Razorpay _razorpay;
// //   String? assignedDoctorName;
// //   String? assignedDoctorSpeciality;
// //
// //   bool _hasUploadPermission = false;
// //   bool _checkingUploadPermission = false;
// //
// //   bool _isSessionEnded = false;
// //   Timer? _statusCheckTimer;
// //   Timer? _uploadPermissionTimer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _razorpay = Razorpay();
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //     _loadUserId();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _statusCheckTimer?.cancel();
// //     _uploadPermissionTimer?.cancel();
// //     _razorpay.clear();
// //     _controller.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<bool> _showTermsAndConditionsPopup() async {
// //     return await showDialog<bool>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text(
// //             "Terms & Conditions",
// //             style: TextStyle(
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.primary,
// //             ),
// //           ),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   "By proceeding with payment, you agree to our terms and conditions:",
// //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //                 ),
// //                 SizedBox(height: 12),
// //                 _buildSimpleTerm("Consultation fees are non-refundable once the service has been provided"),
// //                 _buildSimpleTerm("All medical information shared is kept strictly confidential"),
// //                 _buildSimpleTerm("For emergency medical situations, please visit the nearest hospital immediately"),
// //                 _buildSimpleTerm("Doctors reserve the right to recommend in-person consultation if needed"),
// //                 _buildSimpleTerm("Uploaded medical reports become part of your medical record"),
// //                 SizedBox(height: 12),
// //                 GestureDetector(
// //                   onTap: () => Navigator.pushNamed(context, '/terms'),
// //                   child: Text(
// //                     "View Full Terms & Conditions",
// //                     style: TextStyle(
// //                       color: AppColors.primary,
// //                       decoration: TextDecoration.underline,
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(false),
// //               child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => Navigator.of(context).pop(true),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: AppColors.primary,
// //                 foregroundColor: Colors.white,
// //               ),
// //               child: Text("I Accept & Proceed"),
// //             ),
// //           ],
// //         );
// //       },
// //     ) ?? false;
// //   }
// //
// //   Widget _buildSimpleTerm(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 6.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Icon(Icons.check_circle, size: 16, color: Colors.green),
// //           SizedBox(width: 8),
// //           Expanded(
// //             child: Text(
// //               text,
// //               style: TextStyle(fontSize: 12, color: Colors.grey[800]),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Future<void> _checkUploadPermission() async {
// //     if (userId == null || currentOrderId == null) {
// //       print('❌ Cannot check upload permission: missing userId or orderId');
// //       return;
// //     }
// //
// //     if (_checkingUploadPermission) return;
// //     if (_hasUploadPermission) {
// //       print('ℹ Upload permission already granted, skipping check');
// //       return;
// //     }
// //
// //     try {
// //       setState(() {
// //         _checkingUploadPermission = true;
// //       });
// //
// //       print('🔄 Checking upload permission for user: $userId');
// //
// //       final response = await http.get(
// //         Uri.parse('${ApiConfig.baseUrl}/doctor/get-report-permission/$userId'),
// //         headers: {'Content-Type': 'application/json'},
// //       );
// //
// //       print('📥 Upload permission response: ${response.statusCode}');
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final canSendReports = data['data']['canSendReports'] ?? false;
// //
// //           print('✅ Upload permission status: $canSendReports');
// //
// //           // Only proceed if permission was granted and we haven't shown the message yet
// //           if (canSendReports && paymentCompleted && !_hasUploadPermission) {
// //             setState(() {
// //               _hasUploadPermission = true;
// //             });
// //
// //             _showUploadPermissionGrantedMessage();
// //
// //             // Stop the timer since permission has been granted
// //             _uploadPermissionTimer?.cancel();
// //             _uploadPermissionTimer = null;
// //             print('🛑 Stopped upload permission timer - permission granted');
// //           }
// //         } else {
// //           print('⚠ Upload permission API returned success: false');
// //         }
// //       } else if (response.statusCode == 404) {
// //         print('🔍 Upload permission endpoint not found or user not in permission system');
// //         // This is normal for new sessions - don't show error
// //       } else {
// //         print('❌ Upload permission check failed with status: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Error checking upload permission: $e');
// //       // Don't crash the app on permission check errors
// //     } finally {
// //       setState(() {
// //         _checkingUploadPermission = false;
// //       });
// //     }
// //   }
// //
// //   void _startUploadPermissionListener() {
// //     if (currentOrderId == null || userId == null) {
// //       print('❌ Cannot start upload permission listener: missing orderId or userId');
// //       return;
// //     }
// //
// //     // Don't start if permission is already granted
// //     if (_hasUploadPermission) {
// //       print('ℹ Upload permission already granted, no need for listener');
// //       return;
// //     }
// //
// //     // Don't start if session has ended
// //     if (_isSessionEnded) {
// //       print('ℹ Session ended, not starting upload permission listener');
// //       return;
// //     }
// //
// //     print('🔍 Starting upload permission listener for user: $userId');
// //
// //     _uploadPermissionTimer?.cancel();
// //
// //     // Check immediately
// //     _checkUploadPermission();
// //
// //     // Check every 10 seconds, but stop once permission is granted
// //     _uploadPermissionTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
// //       print('⏰ Checking upload permission...');
// //
// //       // Stop timer if permission is granted
// //       if (_hasUploadPermission) {
// //         timer.cancel();
// //         print('🛑 Upload permission timer stopped - permission granted');
// //         return;
// //       }
// //
// //       // Stop timer if session ended
// //       if (_isSessionEnded) {
// //         timer.cancel();
// //         print('🛑 Upload permission timer stopped - session ended');
// //         return;
// //       }
// //
// //       _checkUploadPermission();
// //     });
// //   }
// //
// //   void _showUploadPermissionGrantedMessage() {
// //     bool alreadyShown = messages.any((msg) =>
// //     msg.text.contains("Upload Access Granted") &&
// //         msg.hasUploadPermission == true);
// //
// //     if (alreadyShown) {
// //       print('ℹ Upload permission message already shown');
// //       return;
// //     }
// //
// //     final uploadPermissionMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "📎 Upload Access Granted!\n\nThe doctor has granted you permission to upload additional medical reports. Click the upload button below to add more files.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       hasUploadPermission: true,
// //       showReportUploadButton: true, // SHOW UPLOAD BUTTON IN CHAT
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages.add(uploadPermissionMsg);
// //       reportUploadEnabled = true;
// //     });
// //
// //     _scrollToBottom();
// //
// //     Helpers.showSnackBar(
// //       context,
// //       "Upload access granted! You can now upload additional reports",
// //       bgColor: Colors.green,
// //     );
// //   }
// //
// //   void _startOrderStatusListener() {
// //     if (currentOrderId == null) {
// //       print('❌ Cannot start order status listener: currentOrderId is null');
// //       return;
// //     }
// //
// //     if (_isSessionEnded) {
// //       print('❌ Cannot start order status listener: session already ended');
// //       return;
// //     }
// //
// //     print('🔍 Starting order status listener for: $currentOrderId');
// //
// //     _statusCheckTimer?.cancel();
// //
// //     _checkOrderStatus();
// //
// //     _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
// //       print('⏰ Timer tick - checking order status...');
// //       _checkOrderStatus();
// //     });
// //
// //     _startUploadPermissionListener();
// //   }
// //
// //   Future<void> _checkOrderStatus() async {
// //     if (currentOrderId == null || _isSessionEnded) {
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Checking order status for: $currentOrderId');
// //
// //       final response = await http.get(
// //         Uri.parse(ApiConfig.getOrderStatus(currentOrderId!)),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final order = data['data'];
// //           final status = order['status']?.toString().toLowerCase();
// //
// //           print('📊 Current order status: $status');
// //
// //           if (status == 'completed') {
// //             print('🎯 Session ended by doctor, resetting chat...');
// //             _handleSessionEndedByDoctor();
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       print('❌ Error checking order status: $e');
// //     }
// //   }
// //
// //   void _handleSessionEndedByDoctor() async {
// //     if (_isSessionEnded) return;
// //
// //     setState(() {
// //       _isSessionEnded = true;
// //     });
// //
// //     _statusCheckTimer?.cancel();
// //     _uploadPermissionTimer?.cancel();
// //
// //     try {
// //       print('🎯 Calling backend to complete order: $currentOrderId');
// //
// //       final response = await http.put(
// //         Uri.parse('${ApiConfig.baseUrl}/completeOrder/$currentOrderId'),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "status": "completed",
// //           "completedBy": "Doctor",
// //           "resetChat": true
// //         }),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           print('✅ Order successfully completed on backend');
// //         } else {
// //           print('❌ Failed to complete order on backend: ${data['message']}');
// //         }
// //       } else {
// //         print('❌ Error completing order: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Error calling completeOrder API: $e');
// //     }
// //
// //     final sessionEndedMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Your consultation session has been completed by the doctor. Thank you for using Care Connect! Starting a new chat session...",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages.add(sessionEndedMsg);
// //     });
// //
// //     _scrollToBottom();
// //
// //     Helpers.showSnackBar(
// //         context,
// //         "Session completed by doctor - Starting new chat",
// //         bgColor: Colors.orange
// //     );
// //
// //     await Future.delayed(const Duration(seconds: 3));
// //     _resetChatToBeginning();
// //   }
// //
// //   void _resetChatToBeginning() async {
// //     print('🔄 Resetting chat to beginning...');
// //
// //     try {
// //       final completedOrderId = currentOrderId;
// //
// //       setState(() {
// //         messages.clear();
// //         currentDoctorType = null;
// //         currentSpeciality = null;
// //         paymentCompleted = false;
// //         reportUploadEnabled = false;
// //         hasUploadedReport = false;
// //         assignedDoctorName = null;
// //         assignedDoctorSpeciality = null;
// //         currentOrderId = null;
// //         _isSessionEnded = false;
// //         _hasUploadPermission = false; // Reset upload permission for new session
// //         _controller.clear();
// //       });
// //
// //       _statusCheckTimer?.cancel();
// //       _uploadPermissionTimer?.cancel();
// //
// //       print('✅ Local state cleared for order: $completedOrderId');
// //
// //       await _initializeNewChat();
// //
// //       print('✅ New chat session started successfully');
// //
// //       Helpers.showSnackBar(
// //         context,
// //         "New chat session started!",
// //         bgColor: Colors.green,
// //       );
// //
// //     } catch (e) {
// //       print('❌ Error resetting chat: $e');
// //       _createFallbackMessages();
// //     }
// //   }
// //
// //   bool _isOrderCompleted(List messagesData) {
// //     if (messagesData.isEmpty) return false;
// //
// //     for (var msg in messagesData) {
// //       if (msg['text'] != null) {
// //         String text = msg['text'].toString();
// //
// //         if (text.contains("Your consultation session has been completed by the doctor") &&
// //             text.contains("Starting a new chat session")) {
// //           print('🎯 Found explicit session end message - session is completed');
// //           return true;
// //         }
// //       }
// //     }
// //
// //     print('💬 No explicit session end found - preserving chat');
// //     return false;
// //   }
// //
// //   bool _isChatTrulyCompleted(List messagesData) {
// //     if (messagesData.isEmpty) return false;
// //
// //     bool hasPaymentCompletion = false;
// //     bool hasActiveChatPrompt = false;
// //     bool hasSessionEndMessage = false;
// //
// //     final recentMessages = messagesData.length > 5
// //         ? messagesData.sublist(messagesData.length - 5)
// //         : messagesData;
// //
// //     for (var msg in recentMessages.reversed) {
// //       if (msg['text'] != null) {
// //         String text = msg['text'].toString().toLowerCase();
// //
// //         if (text.contains("payment successful") ||
// //             text.contains("payment completed")) {
// //           hasPaymentCompletion = true;
// //         }
// //
// //         if (text.contains("how can we help") ||
// //             text.contains("start chatting") ||
// //             text.contains("upload reports") ||
// //             text.contains("assigned to your case")) {
// //           hasActiveChatPrompt = true;
// //         }
// //
// //         if (text.contains("session completed") ||
// //             text.contains("thank you for using Care Connect") ||
// //             text.contains("starting new chat")) {
// //           hasSessionEndMessage = true;
// //         }
// //       }
// //
// //       if (msg['paymentCompleted'] == true) {
// //         hasPaymentCompletion = true;
// //       }
// //     }
// //
// //     if (hasSessionEndMessage) {
// //       return true;
// //     }
// //
// //     if (hasPaymentCompletion && !hasActiveChatPrompt) {
// //       return _isFreshPaymentWithoutChat(messagesData);
// //     }
// //
// //     return false;
// //   }
// //
// //   bool _isFreshPaymentWithoutChat(List messagesData) {
// //     int paymentCompletionIndex = -1;
// //
// //     for (int i = messagesData.length - 1; i >= 0; i--) {
// //       if (messagesData[i]['paymentCompleted'] == true ||
// //           (messagesData[i]['text'] != null &&
// //               messagesData[i]['text'].toString().toLowerCase().contains("payment successful"))) {
// //         paymentCompletionIndex = i;
// //         break;
// //       }
// //     }
// //
// //     if (paymentCompletionIndex == -1) return false;
// //
// //     for (int i = paymentCompletionIndex + 1; i < messagesData.length; i++) {
// //       var msg = messagesData[i];
// //
// //       if (msg['isBot'] == false && msg['text'] != null && msg['text'].toString().trim().isNotEmpty) {
// //         return false;
// //       }
// //
// //       if (msg['isBot'] == true && msg['text'] != null) {
// //         String text = msg['text'].toString().toLowerCase();
// //         if (text.contains("how can we help") ||
// //             text.contains("start chatting") ||
// //             text.contains("upload reports")) {
// //           return false;
// //         }
// //       }
// //     }
// //
// //     return true;
// //   }
// //
// //   Future<int?> getDynamicConsultationFee(String doctorType, String speciality) async {
// //     try {
// //       print('🔄 Getting dynamic fee for: $doctorType - $speciality');
// //
// //       final response = await http.get(
// //         Uri.parse('${ApiConfig.baseUrl}/api/consultation-fee?doctorType=$doctorType&speciality=${Uri.encodeComponent(speciality)}'),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final estimatedFee = data['data']['estimatedFee'] as int;
// //           print('💰 Dynamic fee received: ₹$estimatedFee');
// //           return estimatedFee;
// //         }
// //       }
// //
// //       print('⚠ Using fallback fee');
// //       const fallbackPricing = {
// //         'Allopathy': 500,
// //         'Ayurvedic': 300,
// //         'Homeopathy': 200
// //       };
// //       return fallbackPricing[doctorType] ?? 300;
// //     } catch (e) {
// //       print('❌ Error getting dynamic fee: $e');
// //       const fallbackPricing = {
// //         'Allopathy': 500,
// //         'Ayurvedic': 300,
// //         'Homeopathy': 200
// //       };
// //       return fallbackPricing[doctorType] ?? 300;
// //     }
// //   }
// //
// //   Future<void> _loadUserId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final storedUserId = prefs.getString('userId');
// //     final storedUserName = prefs.getString('fullName') ?? 'User';
// //     final storedUserPhone = prefs.getString('phone') ?? '';
// //     final storedUserEmail = prefs.getString('email') ?? '';
// //
// //     if (storedUserId == null) {
// //       if (mounted) {
// //         Navigator.pushReplacementNamed(context, '/login');
// //       }
// //       return;
// //     }
// //
// //     setState(() {
// //       userId = storedUserId;
// //       userName = storedUserName;
// //       userPhone = storedUserPhone;
// //       userEmail = storedUserEmail;
// //
// //       if (widget.isExistingOrder && widget.orderId != null) {
// //         currentOrderId = widget.orderId;
// //         print('🔄 Loading existing order: ${widget.orderId}');
// //       }
// //     });
// //
// //     await _loadChatHistoryOrInitialize();
// //   }
// //
// //   Future<void> _loadChatHistoryOrInitialize() async {
// //     if (userId == null) {
// //       print('❌ User ID is null');
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Loading chat history from backend...');
// //
// //       String url = "${ApiConfig.chatHistory}?userId=$userId";
// //
// //       if (widget.isExistingOrder && currentOrderId != null && currentOrderId!.isNotEmpty) {
// //         url += "&orderId=$currentOrderId";
// //         print('📝 Loading existing order: $currentOrderId');
// //       }
// //
// //       final response = await http.get(Uri.parse(url));
// //
// //       if (response.statusCode == 200) {
// //         final decoded = jsonDecode(response.body);
// //         List messagesData = decoded['data']['messages'] as List? ?? [];
// //
// //         if (messagesData.isEmpty) {
// //           print('📂 No messages found, initializing new chat...');
// //           await _initializeNewChat();
// //           return;
// //         }
// //
// //         print('📥 Loaded ${messagesData.length} messages from backend');
// //
// //         final loadedMessages = messagesData.map((msg) {
// //           try {
// //             return Message.fromMap(msg);
// //           } catch (e) {
// //             print('❌ Error parsing message: $e - $msg');
// //             return Message(
// //               id: UniqueKey().toString(),
// //               text: msg['text']?.toString() ?? 'Error loading message',
// //               isBot: msg['isBot'] ?? false,
// //               createdAt: DateTime.now(),
// //               userId: userId,
// //               userName: msg['userName']?.toString() ?? 'Unknown',
// //             );
// //           }
// //         }).toList();
// //
// //         bool restoredPaymentCompleted = false;
// //         bool restoredReportUploadEnabled = false;
// //         bool restoredHasUploadedReport = false;
// //         String? restoredAssignedDoctorName;
// //         String? restoredCurrentDoctorType;
// //         String? restoredCurrentSpeciality;
// //         String? restoredCurrentOrderId;
// //         bool restoredIsSessionEnded = false;
// //         bool restoredHasUploadPermission = false;
// //
// //         for (var msg in loadedMessages) {
// //           if (msg.selectedDoctorType != null && msg.selectedDoctorType!.isNotEmpty) {
// //             restoredCurrentDoctorType = msg.selectedDoctorType;
// //           }
// //           if (msg.selectedSpeciality != null && msg.selectedSpeciality!.isNotEmpty) {
// //             restoredCurrentSpeciality = msg.selectedSpeciality;
// //           }
// //           if (msg.orderId != null && msg.orderId!.isNotEmpty) {
// //             restoredCurrentOrderId = msg.orderId;
// //           }
// //           if (msg.paymentCompleted == true) {
// //             restoredPaymentCompleted = true;
// //             print('💰 Found payment completed message');
// //           }
// //           if (msg.wantsToUploadReport == true) {
// //             restoredReportUploadEnabled = true;
// //             print('📤 Found wants to upload report message');
// //           }
// //           if (msg.reportUploaded == true) {
// //             restoredHasUploadedReport = true;
// //             print('✅ Found report uploaded message');
// //           }
// //           if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty) {
// //             restoredAssignedDoctorName = msg.assignedDoctorName;
// //           }
// //           if (msg.hasUploadPermission == true) {
// //             restoredHasUploadPermission = true;
// //             print('🔓 Found upload permission in message');
// //           }
// //
// //           if (msg.text.contains("Your consultation session has been completed by the doctor") &&
// //               msg.text.contains("Starting a new chat session")) {
// //             restoredIsSessionEnded = true;
// //             print('🔍 Found session end message in history');
// //           }
// //         }
// //
// //         if (restoredPaymentCompleted && !restoredReportUploadEnabled) {
// //           for (var msg in loadedMessages.reversed) {
// //             if (msg.showReportUploadQuestion || msg.reportUploadAnswered) {
// //               restoredReportUploadEnabled = true;
// //               print('🔄 Detected report upload flow from messages');
// //               break;
// //             }
// //           }
// //         }
// //
// //         if (restoredPaymentCompleted && !restoredHasUploadedReport) {
// //           bool userDeclinedUpload = false;
// //           for (var msg in loadedMessages) {
// //             if (msg.isBot == false && msg.text.toLowerCase().contains("no, i don't need to upload reports")) {
// //               userDeclinedUpload = true;
// //               break;
// //             }
// //           }
// //
// //           if (!userDeclinedUpload) {
// //             restoredReportUploadEnabled = true;
// //             print('🔧 Auto-enabling upload for paid session');
// //           }
// //         }
// //
// //         setState(() {
// //           messages = loadedMessages;
// //           currentDoctorType = restoredCurrentDoctorType;
// //           currentSpeciality = restoredCurrentSpeciality;
// //           currentOrderId = restoredCurrentOrderId;
// //           paymentCompleted = restoredPaymentCompleted;
// //           reportUploadEnabled = restoredReportUploadEnabled;
// //           hasUploadedReport = restoredHasUploadedReport;
// //           assignedDoctorName = restoredAssignedDoctorName;
// //           _isSessionEnded = restoredIsSessionEnded;
// //           _hasUploadPermission = restoredHasUploadPermission;
// //           loadingHistory = false;
// //         });
// //
// //         print('🔄 State restored from chat history:');
// //         print('   - Messages: ${messages.length}');
// //         print('   - paymentCompleted: $paymentCompleted');
// //         print('   - reportUploadEnabled: $reportUploadEnabled');
// //         print('   - hasUploadedReport: $hasUploadedReport');
// //         print('   - currentOrderId: $currentOrderId');
// //         print('   - isSessionEnded: $_isSessionEnded');
// //         print('   - hasUploadPermission: $_hasUploadPermission');
// //
// //         if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
// //           print('🔍 Starting order status listener for active session');
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             _startOrderStatusListener();
// //           });
// //         }
// //
// //         if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             _checkUploadPermission();
// //           });
// //         }
// //
// //       } else {
// //         print('❌ HTTP error: ${response.statusCode}');
// //         await _initializeNewChat();
// //       }
// //     } catch (e) {
// //       print('❌ Error loading chat history: $e');
// //       await _initializeNewChat();
// //     }
// //
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _initializeNewChat() async {
// //     try {
// //       print('🔄 Initializing new chat...');
// //
// //       final response = await ChatService.initializeChat(
// //         userId: userId!,
// //         userName: userName ?? 'User',
// //         userPhone: userPhone,
// //         userEmail: userEmail,
// //         orderId: currentOrderId,
// //       );
// //
// //       if (response['success'] == true) {
// //         final messagesData = response['data']['messages'] as List? ?? [];
// //         print('📥 Initialized with ${messagesData.length} messages');
// //
// //         final initialMessages = messagesData.map((msg) => Message.fromMap(msg)).toList();
// //
// //         setState(() {
// //           messages = initialMessages;
// //           loadingHistory = false;
// //         });
// //
// //         if (initialMessages.isNotEmpty && initialMessages.first.orderId != null) {
// //           currentOrderId = initialMessages.first.orderId;
// //           print('📝 Set currentOrderId: $currentOrderId');
// //         }
// //       } else {
// //         throw Exception('Backend returned success: false');
// //       }
// //     } catch (e) {
// //       print('❌ Error initializing chat: $e');
// //       _createFallbackMessages();
// //     }
// //   }
// //
// //   void _createFallbackMessages() {
// //     final welcome = Message(
// //       id: UniqueKey().toString(),
// //       text: "Welcome to Care Connect. We provide professional doctor consultations from the comfort of your home.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     final question = Message(
// //       id: UniqueKey().toString(),
// //       text: "Do you want to continue?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages = [welcome, question];
// //       loadingHistory = false;
// //     });
// //
// //     print('📝 Using fallback local messages');
// //   }
// //
// //   Future<void> sendMessage(Message message) async {
// //     try {
// //       await _sendMessageToBackend(message);
// //     } catch (e) {
// //       print("Error sending message to backend: $e");
// //     }
// //   }
// //
// //   Future<void> _sendMessageToBackend(Message message) async {
// //     if (userId == null) {
// //       print('❌ Cannot send message: User ID is null');
// //       return;
// //     }
// //
// //     try {
// //       print('🔄 Sending message to backend: ${message.text}');
// //
// //       final response = await ChatService.sendMessage(
// //         userId: userId!,
// //         message: message.text,
// //         userName: userName ?? 'User',
// //         userPhone: userPhone,
// //         userEmail: userEmail,
// //         doctorType: message.selectedDoctorType ?? currentDoctorType ?? '',
// //         speciality: message.selectedSpeciality ?? currentSpeciality ?? '',
// //         orderId: message.orderId ?? currentOrderId ?? '',
// //         paymentCompleted: message.paymentCompleted || paymentCompleted,
// //       );
// //
// //       print('✅ Message sent to backend successfully');
// //
// //       if (!message.isBot && paymentCompleted && response['success'] == true) {
// //         final botResponse = response['data']['botResponse'];
// //         if (botResponse != null) {
// //           print('🤖 Received bot response');
// //           final botMessage = Message.fromMap(botResponse);
// //           setState(() {
// //             messages.add(botMessage);
// //           });
// //           _scrollToBottom();
// //         } else {
// //           print('ℹ No bot response received');
// //         }
// //       }
// //     } catch (e) {
// //       print('❌ Failed to send message to backend: $e');
// //     }
// //   }
// //
// //   void _onUserSend(String text) async {
// //     if (text.trim().isEmpty) return;
// //     if (!paymentCompleted) {
// //       Helpers.showSnackBar(context, "Please complete payment before sending messages", bgColor: Colors.red);
// //       return;
// //     }
// //     if (_isSessionEnded) {
// //       Helpers.showSnackBar(context, "Session completed - cannot send messages", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     final userMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: text,
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages.add(userMsg);
// //     });
// //
// //     await sendMessage(userMsg);
// //     _controller.clear();
// //     _scrollToBottom();
// //   }
// //
// //   void _onYesButtonPressed(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, I would like a second opinion.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final doctorTypeQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your preferred doctor type:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(doctorTypeQuestion);
// //     });
// //
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(doctorTypeQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   void _onDoctorTypeSelected(Message questionMsg, String doctorType) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       pendingDoctorType: doctorType,
// //     );
// //     final confirmationMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "You selected $doctorType. Would you like to confirm this selection?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       showDoctorTypeConfirmation: true,
// //       pendingDoctorType: doctorType,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(confirmationMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(confirmationMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onDoctorTypeConfirmYes(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final doctorType = confirmMsg.pendingDoctorType!;
// //     final updatedMsg = confirmMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       selectedDoctorType: doctorType,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, confirmed $doctorType",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: doctorType,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       currentDoctorType = doctorType;
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //
// //     if (doctorType == 'Allopathy') {
// //       await _loadSpecializations(doctorType);
// //     } else {
// //       final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //       final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
// //
// //       final paymentMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: doctorType,
// //         selectedSpeciality: defaultSpeciality,
// //         showPaymentButton: true,
// //         amount: amount,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //       setState(() {
// //         currentSpeciality = defaultSpeciality;
// //         messages.add(paymentMsg);
// //       });
// //       await sendMessage(paymentMsg);
// //     }
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _loadSpecializations(String doctorType) async {
// //     try {
// //       print('🔄 Loading specializations for $doctorType...');
// //
// //       final response = await http.get(
// //         Uri.parse('${ApiConfig.baseUrl}/api/patients/doctors/specializations/$doctorType'),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           final specializations = List<String>.from(data['data']['specializations']);
// //
// //           if (specializations.isNotEmpty) {
// //             final specialityQuestion = Message(
// //               id: UniqueKey().toString(),
// //               text: "Please select your doctor's speciality:",
// //               isBot: true,
// //               showButtons: true,
// //               buttonClicked: false,
// //               createdAt: DateTime.now(),
// //               selectedDoctorType: doctorType,
// //               userId: userId,
// //               userName: 'Care Connect Bot',
// //             );
// //
// //             setState(() {
// //               messages.add(specialityQuestion);
// //             });
// //             await sendMessage(specialityQuestion);
// //           } else {
// //             _proceedToPayment(doctorType);
// //           }
// //         }
// //       } else {
// //         throw Exception('Failed to load specializations');
// //       }
// //     } catch (e) {
// //       print('❌ Error loading specializations: $e');
// //       if (doctorType == 'Allopathy') {
// //         _showDefaultSpecializations(doctorType);
// //       } else {
// //         _proceedToPayment(doctorType);
// //       }
// //     }
// //   }
// //
// //   void _showDefaultSpecializations(String doctorType) {
// //     List<String> specializations = [];
// //
// //     if (doctorType == 'Allopathy') {
// //       specializations = ['MBBS', 'MD', 'Cardiologist', 'Dermatologist', 'Orthopedic', 'Pediatrician', 'Gynecologist', 'Neurologist', 'Psychiatrist'];
// //     }
// //
// //     if (specializations.isNotEmpty) {
// //       final specialityQuestion = Message(
// //         id: UniqueKey().toString(),
// //         text: "Please select your doctor's speciality:",
// //         isBot: true,
// //         showButtons: true,
// //         buttonClicked: false,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: doctorType,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(specialityQuestion);
// //       });
// //     } else {
// //       _proceedToPayment(doctorType);
// //     }
// //   }
// //
// //   void _proceedToPayment(String doctorType) async {
// //     final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //     final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
// //
// //     final paymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: doctorType,
// //       selectedSpeciality: defaultSpeciality,
// //       showPaymentButton: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       currentSpeciality = defaultSpeciality;
// //       messages.add(paymentMsg);
// //     });
// //     sendMessage(paymentMsg);
// //   }
// //
// //   void _onDoctorTypeConfirmNo(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, let me choose again",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final doctorTypeQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your preferred doctor type:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(doctorTypeQuestion);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(doctorTypeQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialitySelected(Message questionMsg, String speciality) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       pendingSpeciality: speciality,
// //     );
// //     final confirmationMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "You selected $speciality. Would you like to confirm this speciality?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       showSpecialityConfirmation: true,
// //       pendingSpeciality: speciality,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(confirmationMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(confirmationMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialityConfirmYes(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final speciality = confirmMsg.pendingSpeciality!;
// //     final updatedMsg = confirmMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       selectedSpeciality: speciality,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, confirmed $speciality",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: speciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     final amount = await getDynamicConsultationFee(currentDoctorType!, speciality) ?? 500;
// //
// //     final paymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Excellent! You've selected $speciality specialist. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: speciality,
// //       showPaymentButton: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       currentSpeciality = speciality;
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(paymentMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(paymentMsg);
// //     _scrollToBottom();
// //   }
// //
// //   void _onSpecialityConfirmNo(Message confirmMsg) async {
// //     final index = messages.indexWhere((m) => m.id == confirmMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, let me choose again",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final specialityQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Please select your doctor's speciality:",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(specialityQuestion);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(specialityQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onPaymentButtonPressed(Message paymentMsg) async {
// //     final index = messages.indexWhere((m) => m.id == paymentMsg.id);
// //     if (index == -1) return;
// //     if (paymentCompleted) {
// //       Helpers.showSnackBar(context, "Payment already completed", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     final acceptedTerms = await _showTermsAndConditionsPopup();
// //     if (!acceptedTerms) {
// //       Helpers.showSnackBar(context, "Please accept terms and conditions to proceed with payment", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     final updatedPaymentMsg = paymentMsg.copyWith(buttonClicked: true, showPaymentButton: true);
// //     final userPaymentMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Proceeding to payment...",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedPaymentMsg;
// //       messages.add(userPaymentMsg);
// //     });
// //     await sendMessage(updatedPaymentMsg);
// //     await sendMessage(userPaymentMsg);
// //     _scrollToBottom();
// //
// //     String doctorCategory = currentSpeciality ?? currentDoctorType ?? "General";
// //     int amount = paymentMsg.amount ?? 500;
// //     createOrder(amount, doctorCategory);
// //   }
// //
// //   Future<void> createOrder(int amount, String doctorCategory) async {
// //     try {
// //       if (userId == null) {
// //         Helpers.showSnackBar(context, "User ID not found! Please login again.");
// //         return;
// //       }
// //
// //       if (currentDoctorType == null || currentDoctorType!.isEmpty) {
// //         Helpers.showSnackBar(context, "Please select a doctor type first");
// //         return;
// //       }
// //
// //       String finalSpeciality = currentSpeciality ?? '';
// //       if ((currentDoctorType == 'Ayurvedic' || currentDoctorType == 'Homeopathy') &&
// //           (finalSpeciality.isEmpty)) {
// //         finalSpeciality = currentDoctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
// //         setState(() {
// //           currentSpeciality = finalSpeciality;
// //         });
// //         print('🔄 Set default speciality for ${currentDoctorType}: $finalSpeciality');
// //       }
// //
// //       if (finalSpeciality.isEmpty) {
// //         Helpers.showSnackBar(context, "Please select a speciality first");
// //         return;
// //       }
// //
// //       print('🔄 Creating order for doctor: $currentDoctorType, speciality: $finalSpeciality');
// //       print('🔍 Sending data:');
// //       print('   - UserId: $userId');
// //       print('   - userName: $userName');
// //       print('   - doctorType: $currentDoctorType');
// //       print('   - speciality: $finalSpeciality');
// //
// //       var response = await http.post(
// //         Uri.parse(ApiConfig.orders),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "UserId": userId,
// //           "userName": userName ?? 'User',
// //           "userPhone": userPhone ?? '',
// //           "userEmail": userEmail ?? '',
// //           "doctorType": currentDoctorType,
// //           "speciality": finalSpeciality,
// //           "currency": "INR",
// //         }),
// //       );
// //
// //       print('📥 Order creation response: ${response.statusCode}');
// //       print('📥 Response body: ${response.body}');
// //
// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(response.body);
// //         if (data['success'] == true && data['data'] != null) {
// //           String? orderId;
// //           String? razorpayOrderId;
// //           int? actualAmount;
// //
// //           if (data['data']['orderId'] != null) {
// //             orderId = data['data']['orderId'].toString();
// //           } else if (data['data']['id'] != null) {
// //             orderId = data['data']['id'].toString();
// //           }
// //
// //           if (data['data']['razorpayOrderId'] != null) {
// //             razorpayOrderId = data['data']['razorpayOrderId'].toString();
// //           } else if (data['data']['order_id'] != null) {
// //             razorpayOrderId = data['data']['order_id'].toString();
// //           }
// //
// //           if (data['data']['amount'] != null) {
// //             actualAmount = data['data']['amount'] is int
// //                 ? data['data']['amount']
// //                 : (data['data']['amount'] as double).toInt();
// //             print('💰 Backend calculated amount: ₹$actualAmount');
// //           }
// //
// //           if (orderId != null) {
// //             setState(() {
// //               currentOrderId = orderId;
// //             });
// //
// //             String finalRazorpayOrderId = razorpayOrderId ?? orderId;
// //
// //             print('✅ Order created successfully: $currentOrderId');
// //             print('🔑 Razorpay Order ID: $finalRazorpayOrderId');
// //             print('💰 Amount to pay: ₹$actualAmount');
// //
// //             _updatePaymentMessageWithActualAmount(actualAmount ?? amount);
// //
// //             openCheckout(actualAmount ?? amount, doctorCategory, finalRazorpayOrderId);
// //           } else {
// //             Helpers.showSnackBar(context, "Order created but no order ID returned");
// //           }
// //         } else {
// //           Helpers.showSnackBar(context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
// //         }
// //       } else if (response.statusCode == 400) {
// //         var data = jsonDecode(response.body);
// //         Helpers.showSnackBar(context, "Validation error: ${data['message'] ?? 'Check your inputs'}");
// //       } else {
// //         Helpers.showSnackBar(context, "Doctor Not Available.....");
// //       }
// //     } catch (e) {
// //       print('❌ Order creation error: $e');
// //       Helpers.showSnackBar(context, "Network error: $e");
// //     }
// //   }
// //
// //   void _updatePaymentMessageWithActualAmount(int actualAmount) {
// //     for (int i = messages.length - 1; i >= 0; i--) {
// //       if (messages[i].showPaymentButton && !messages[i].paymentCompleted) {
// //         setState(() {
// //           messages[i] = messages[i].copyWith(
// //             amount: actualAmount,
// //             text: "Great! You've selected ${currentDoctorType} - ${currentSpeciality}. Consultation fee: ₹$actualAmount. Please proceed with payment to start your consultation.",
// //           );
// //         });
// //         break;
// //       }
// //     }
// //   }
// //
// //   Future<void> openCheckout(int amount, String doctorCategory, String razorpayOrderId) async {
// //     var options = {
// //       'key': 'rzp_test_vDQGr1D5EBRubo',
// //       'amount': amount * 100,
// //       'name': 'Care Connect',
// //       'description': 'Consultation Fee - $doctorCategory',
// //       'order_id': razorpayOrderId,
// //       'prefill': {
// //         'contact': userPhone ?? '9999999999',
// //         'email': userEmail ?? 'user@example.com',
// //         'name': userName ?? 'User',
// //       },
// //       'theme': {'color': '#00796B'},
// //       'retry': {'enabled': true, 'max_count': 1},
// //       'timeout': 300,
// //     };
// //
// //     try {
// //       print('💰 Opening Razorpay checkout with options: $options');
// //       _razorpay.open(options);
// //     } catch (e) {
// //       debugPrint("❌ Error opening Razorpay: $e");
// //       Helpers.showSnackBar(context, "Error opening payment gateway: $e");
// //     }
// //   }
// //
// //   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
// //     try {
// //       print('✅ Payment successful:');
// //       print('   Order ID: ${response.orderId}');
// //       print('   Payment ID: ${response.paymentId}');
// //       print('   Signature: ${response.signature}');
// //
// //       Helpers.showSnackBar(context, "Verifying payment...", bgColor: Colors.orange);
// //
// //       var verifyResponse = await http.post(
// //         Uri.parse(ApiConfig.verifyPayment),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "razorpay_order_id": response.orderId,
// //           "razorpay_payment_id": response.paymentId,
// //           "razorpay_signature": response.signature,
// //           "userId": userId,
// //           "userName": userName,
// //           "userPhone": userPhone,
// //           "userEmail": userEmail,
// //           "orderId": currentOrderId,
// //           "doctorType": currentDoctorType,
// //           "speciality": currentSpeciality,
// //           "amount": getAmountFromMessages() ?? 500,
// //         }),
// //       );
// //
// //       print('📥 Verification response: ${verifyResponse.statusCode}');
// //       print('📥 Verification body: ${verifyResponse.body}');
// //
// //       var verifyData = jsonDecode(verifyResponse.body);
// //
// //       if (verifyData['success'] == true) {
// //         await _handleSuccessfulPayment(response, verifyData);
// //       } else {
// //         Helpers.showSnackBar(
// //             context,
// //             "Payment verification failed: ${verifyData['message'] ?? 'Unknown error'}",
// //             bgColor: Colors.red
// //         );
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Verification error: $e");
// //       Helpers.showSnackBar(context, "Payment verification error: $e", bgColor: Colors.red);
// //     }
// //   }
// //
// //   int? getAmountFromMessages() {
// //     for (int i = messages.length - 1; i >= 0; i--) {
// //       if (messages[i].amount != null) {
// //         return messages[i].amount;
// //       }
// //     }
// //     return null;
// //   }
// //
// //   Future<void> _handleSuccessfulPayment(PaymentSuccessResponse response, Map<String, dynamic> verifyData) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     int currentOrderCount = prefs.getInt('orderCount') ?? 0;
// //     currentOrderCount++;
// //     await prefs.setInt('orderCount', currentOrderCount);
// //     String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');
// //
// //     setState(() {
// //       paymentCompleted = true;
// //     });
// //
// //     final amount = getAmountFromMessages() ?? 500;
// //
// //     final paymentSuccessMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Payment successful and verified! ✅",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       orderId: currentOrderId,
// //       paymentId: response.paymentId,
// //       orderNumber: displayOrderNo,
// //       amount: amount,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     final amountMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "₹$amount has been successfully processed for Order #$displayOrderNo",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       paymentCompleted: true,
// //       amount: amount,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     setState(() {
// //       messages.add(paymentSuccessMsg);
// //       messages.add(amountMsg);
// //     });
// //
// //     await sendMessage(paymentSuccessMsg);
// //     await sendMessage(amountMsg);
// //
// //     await _handleDoctorAssignment(verifyData);
// //
// //     print('💰 Payment completed, starting session end listener...');
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _startOrderStatusListener();
// //       // Also start upload permission listener for the new paid session
// //       _startUploadPermissionListener();
// //     });
// //
// //     await _askReportUploadQuestion();
// //     _scrollToBottom();
// //
// //     Helpers.showSnackBar(
// //         context,
// //         "Payment successful! Order #$displayOrderNo created.",
// //         bgColor: AppColors.accent
// //     );
// //   }
// //
// //   Future<void> _handleDoctorAssignment(Map<String, dynamic> verifyData) async {
// //     if (verifyData['data']['assignedDoctor'] != null) {
// //       final assignedDoctor = verifyData['data']['assignedDoctor'];
// //       setState(() {
// //         assignedDoctorName = assignedDoctor['name'];
// //         assignedDoctorSpeciality = assignedDoctor['speciality'];
// //       });
// //
// //       final doctorAssignmentMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Great news! Dr. ${assignedDoctor['name']} (${assignedDoctor['speciality']}) has been assigned to your case. They will connect with you shortly.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         paymentCompleted: true,
// //         assignedDoctorId: assignedDoctor['id'],
// //         assignedDoctorName: assignedDoctor['name'],
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(doctorAssignmentMsg);
// //       });
// //       await sendMessage(doctorAssignmentMsg);
// //     } else {
// //       final waitingMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Payment successful! We're finding the best ${currentSpeciality} ${currentDoctorType} doctor for you. You'll be notified when a doctor is assigned.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         paymentCompleted: true,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(waitingMsg);
// //       });
// //       await sendMessage(waitingMsg);
// //     }
// //   }
// //
// //   Future<void> _askReportUploadQuestion() async {
// //     final reportQuestion = Message(
// //       id: UniqueKey().toString(),
// //       text: "Would you like to upload any medical reports for the doctor to review?",
// //       isBot: true,
// //       showButtons: true,
// //       buttonClicked: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       showReportUploadQuestion: true,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       messages.add(reportQuestion);
// //     });
// //     await sendMessage(reportQuestion);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onReportUploadYes(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       reportUploadAnswered: true,
// //       wantsToUploadReport: true,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "Yes, I would like to upload reports.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //
// //     final uploadButtonMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Great! Click the button below to upload your medical reports.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       showReportUploadButton: true,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(uploadButtonMsg);
// //       reportUploadEnabled = true;
// //       hasUploadedReport = false;
// //     });
// //
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(uploadButtonMsg);
// //
// //     final chatEnableMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: assignedDoctorName != null
// //           ? "You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
// //           : "You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       assignedDoctorName: assignedDoctorName,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages.add(chatEnableMsg);
// //     });
// //
// //     await sendMessage(chatEnableMsg);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onReportUploadNo(Message questionMsg) async {
// //     final index = messages.indexWhere((m) => m.id == questionMsg.id);
// //     if (index == -1) return;
// //
// //     final updatedMsg = questionMsg.copyWith(
// //       showButtons: false,
// //       buttonClicked: true,
// //       reportUploadAnswered: true,
// //     );
// //     final userResponse = Message(
// //       id: UniqueKey().toString(),
// //       text: "No, I don't need to upload reports right now.",
// //       isBot: false,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       userId: userId,
// //       userName: userName,
// //     );
// //     final chatEnableMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: assignedDoctorName != null
// //           ? "No problem! You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
// //           : "No problem! You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       selectedDoctorType: currentDoctorType,
// //       selectedSpeciality: currentSpeciality,
// //       paymentCompleted: true,
// //       assignedDoctorName: assignedDoctorName,
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //
// //     setState(() {
// //       messages[index] = updatedMsg;
// //       messages.add(userResponse);
// //       messages.add(chatEnableMsg);
// //     });
// //     await sendMessage(updatedMsg);
// //     await sendMessage(userResponse);
// //     await sendMessage(chatEnableMsg);
// //     _scrollToBottom();
// //   }
// //
// //   Future<void> _onReportUploadButtonPressed(Message uploadMsg) async {
// //     final index = messages.indexWhere((m) => m.id == uploadMsg.id);
// //     if (index == -1) return;
// //
// //     final canUpload = reportUploadEnabled || _hasUploadPermission;
// //
// //     if (!canUpload) {
// //       Helpers.showSnackBar(context, "Please complete payment and confirm report upload first", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     if (hasUploadedReport && !_hasUploadPermission) {
// //       Helpers.showSnackBar(context, "You have already uploaded reports. Upload is allowed only once.", bgColor: Colors.orange);
// //       return;
// //     }
// //
// //     if (_isSessionEnded) {
// //       Helpers.showSnackBar(context, "Session completed - cannot upload files", bgColor: Colors.orange);
// //       return;
// //     }
// //     if (currentOrderId == null) {
// //       Helpers.showSnackBar(context, "No active order found", bgColor: Colors.red);
// //       return;
// //     }
// //
// //     print('📤 Navigating to upload with orderId: $currentOrderId, userId: $userId');
// //     print('🔓 Upload permission status: $_hasUploadPermission');
// //
// //     final result = await Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => UploadFiles(
// //         orderId: currentOrderId!,
// //         userId: userId!,
// //       )),
// //     );
// //
// //     if (result != null && result is Map<String, dynamic> && result['status'] == 'uploaded') {
// //       List<Map<String, dynamic>> uploadedReports = List<Map<String, dynamic>>.from(result['reports']);
// //
// //       String successMessage;
// //       if (_hasUploadPermission && hasUploadedReport) {
// //         successMessage = "Additional medical reports uploaded successfully! ✅\nTotal new files: ${uploadedReports.length}";
// //       } else {
// //         successMessage = "Medical reports uploaded successfully! ✅\nTotal files: ${uploadedReports.length}";
// //       }
// //
// //       final uploadSuccessMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: successMessage,
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         selectedDoctorType: currentDoctorType,
// //         selectedSpeciality: currentSpeciality,
// //         reportUploaded: true,
// //         reportFiles: uploadedReports,
// //         assignedDoctorName: assignedDoctorName,
// //         hasUploadPermission: _hasUploadPermission,
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(uploadSuccessMsg);
// //         hasUploadedReport = true;
// //         if (!_hasUploadPermission) {
// //           reportUploadEnabled = false;
// //         }
// //       });
// //
// //       await sendMessage(uploadSuccessMsg);
// //       _scrollToBottom();
// //
// //       Helpers.showSnackBar(context, "Reports uploaded successfully!", bgColor: AppColors.accent);
// //
// //       await _loadChatHistoryOrInitialize();
// //     }
// //   }
// //
// //   IconData _getFileIcon(String fileType) {
// //     if (fileType.toLowerCase().contains('image')) return Icons.image;
// //     if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
// //     if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
// //       return Icons.description;
// //     return Icons.insert_drive_file;
// //   }
// //
// //   Future<void> _openFile(String filePath, String fileName) async {
// //     try {
// //       final result = await OpenFilex.open(filePath);
// //       if (result.type == ResultType.done) {
// //         debugPrint("✅ File opened successfully: $fileName");
// //       } else if (result.type == ResultType.noAppToOpen) {
// //         Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
// //       } else if (result.type == ResultType.fileNotFound) {
// //         Helpers.showSnackBar(context, "File not found at: $filePath", bgColor: Colors.red);
// //       } else {
// //         Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       debugPrint("❌ Error opening file: $e");
// //       Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
// //     }
// //   }
// //
// //   void _handlePaymentError(PaymentFailureResponse response) {
// //     final errorMsg = Message(
// //       id: UniqueKey().toString(),
// //       text: "Payment could not be completed. Please try again.",
// //       isBot: true,
// //       createdAt: DateTime.now(),
// //       userId: userId,
// //       userName: 'Care Connect Bot',
// //     );
// //     setState(() {
// //       messages.add(errorMsg);
// //     });
// //     sendMessage(errorMsg);
// //     Helpers.showSnackBar(context, "Payment failed: ${response.message}", bgColor: Colors.red);
// //   }
// //
// //   void _handleExternalWallet(ExternalWalletResponse response) {
// //     Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
// //   }
// //
// //   Widget buildIntroCard(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.all(14),
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: AppColors.primary.withOpacity(0.08),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: AppColors.primary, width: 1.2),
// //         boxShadow: [
// //           BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2)),
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
// //                 "Care Connect",
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
// //             style: TextStyle(fontSize: 15.5, color: Colors.grey[800]),
// //           ),
// //           const SizedBox(height: 16),
// //           Row(
// //             children: [
// //               Icon(Icons.verified_user, color: AppColors.accent, size: 20),
// //               const SizedBox(width: 5),
// //               Text(
// //                 "Trusted | Secure | Confidential",
// //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.primary),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 18),
// //           Text(
// //             "How it works:",
// //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
// //           ),
// //           const SizedBox(height: 8),
// //           _buildStep(stepNumber: 1, icon: Icons.person_search, label: "Choose your doctor type and specialty"),
// //           const SizedBox(height: 5),
// //           _buildStep(stepNumber: 2, icon: Icons.payment, label: "Make a secure online payment"),
// //           const SizedBox(height: 5),
// //           _buildStep(stepNumber: 3, icon: Icons.message_outlined, label: "Upload reports, Chat & get advice"),
// //           const SizedBox(height: 18),
// //           GestureDetector(
// //             onTap: () => Navigator.pushNamed(context, '/help'),
// //             child: Text(
// //               "Help & Support",
// //               style: TextStyle(decoration: TextDecoration.underline, color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStep({required int stepNumber, required IconData icon, required String label}) {
// //     return Row(
// //       children: [
// //         CircleAvatar(
// //           radius: 13,
// //           backgroundColor: AppColors.primary,
// //           child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
// //         ),
// //         const SizedBox(width: 8),
// //         Icon(icon, size: 18, color: AppColors.accent),
// //         const SizedBox(width: 7),
// //         Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, color: Colors.grey[800]))),
// //       ],
// //     );
// //   }
// //
// //   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
// //     return ListTile(
// //       leading: Icon(icon, size: 25, color: AppColors.iconColor),
// //       title: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //       ),
// //       onTap: onTap,
// //     );
// //   }
// //
// //   void _scrollToBottom() {
// //     if (!_scrollController.hasClients) return;
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (_scrollController.hasClients) {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: const Duration(milliseconds: 300),
// //           curve: Curves.easeOut,
// //         );
// //       }
// //     });
// //   }
// //
// //   Widget buildMessageBubble(Message msg) {
// //     final isUser = !msg.isBot;
// //
// //     final showSecondOpinionButton = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("second opinion");
// //     final showDoctorTypeDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your preferred doctor type");
// //     final showSpecialityDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your doctor's speciality");
// //     final showReportUploadButtons = msg.showReportUploadQuestion && msg.showButtons && !msg.buttonClicked;
// //     final showDoctorTypeConfirmation = msg.showDoctorTypeConfirmation && msg.showButtons && !msg.buttonClicked;
// //     final showSpecialityConfirmation = msg.showSpecialityConfirmation && msg.showButtons && !msg.buttonClicked;
// //     final shouldShowPaymentButton = msg.showPaymentButton && !paymentCompleted;
// //
// //     // UPLOAD BUTTON WILL SHOW IN CHAT BUBBLE AFTER DOCTOR GRANTS PERMISSION
// //     final shouldShowReportUploadButton =
// //         (msg.showReportUploadButton && reportUploadEnabled && !hasUploadedReport && !_isSessionEnded) ||
// //             (msg.hasUploadPermission && _hasUploadPermission && !_isSessionEnded && !hasUploadedReport);
// //
// //     return Align(
// //       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //         padding: const EdgeInsets.all(12),
// //         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
// //         decoration: BoxDecoration(
// //           color: isUser ? AppColors.chatUser : AppColors.chatBot,
// //           borderRadius: BorderRadius.only(
// //             topLeft: const Radius.circular(16),
// //             topRight: const Radius.circular(16),
// //             bottomLeft: isUser ? const Radius.circular(16) : Radius.circular(0),
// //             bottomRight: isUser ? Radius.circular(0) : const Radius.circular(16),
// //           ),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               msg.text,
// //               style: TextStyle(color: isUser ? AppColors.chatUserText : AppColors.chatBotText, fontSize: 15),
// //             ),
// //
// //             if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.green.shade50,
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(color: Colors.green.shade200),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.medical_services, color: Colors.green.shade700, size: 16),
// //                       const SizedBox(width: 8),
// //                       Flexible(
// //                         child: Text(
// //                           "Assigned: Dr. ${msg.assignedDoctorName}",
// //                           style: TextStyle(
// //                             color: Colors.green.shade800,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //             if (msg.hasUploadPermission && _hasUploadPermission)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.all(6),
// //                   decoration: BoxDecoration(
// //                     color: Colors.orange.shade50,
// //                     borderRadius: BorderRadius.circular(6),
// //                     border: Border.all(color: Colors.orange.shade200),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.upload_file, color: Colors.orange.shade700, size: 14),
// //                       const SizedBox(width: 6),
// //                       Text(
// //                         "Upload access granted by doctor",
// //                         style: TextStyle(
// //                           color: Colors.orange.shade800,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 11,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //             if (msg.reportUploaded == true && msg.reportFiles != null && msg.reportFiles!.isNotEmpty)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "📁 Uploaded Reports (${msg.reportFiles!.length}):",
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         color: isUser ? AppColors.chatUserText : AppColors.chatBotText,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 6),
// //                     ...msg.reportFiles!.map((report) {
// //                       final fileName = report['fileName']?.toString() ?? 'Unknown File';
// //                       final fileSize = report['fileSize'] ?? 0;
// //                       final fileType = report['fileType']?.toString() ?? 'file';
// //
// //                       return GestureDetector(
// //                         onTap: () => _openFile(report['filePath'], fileName),
// //                         child: Container(
// //                           margin: const EdgeInsets.only(bottom: 6),
// //                           padding: const EdgeInsets.all(10),
// //                           decoration: BoxDecoration(
// //                             color: isUser ? Colors.blue.shade50 : Colors.green.shade50,
// //                             borderRadius: BorderRadius.circular(10),
// //                             border: Border.all(color: isUser ? Colors.blue.shade200 : Colors.green.shade200),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               Container(
// //                                 padding: const EdgeInsets.all(6),
// //                                 decoration: BoxDecoration(
// //                                   color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
// //                                   borderRadius: BorderRadius.circular(6),
// //                                 ),
// //                                 child: Icon(
// //                                   _getFileIcon(fileType),
// //                                   color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
// //                                   size: 18,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 10),
// //                               Expanded(
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       fileName,
// //                                       style: TextStyle(
// //                                         color: isUser ? Colors.blue.shade900 : Colors.green.shade900,
// //                                         fontWeight: FontWeight.w600,
// //                                         fontSize: 12,
// //                                       ),
// //                                       maxLines: 1,
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                     const SizedBox(height: 2),
// //                                     Text(
// //                                       _formatFileSize(fileSize is int ? fileSize : 0),
// //                                       style: TextStyle(
// //                                         color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
// //                                         fontSize: 10,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               Icon(
// //                                 Icons.visibility_outlined,
// //                                 color: isUser ? Colors.blue.shade600 : Colors.green.shade600,
// //                                 size: 16,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showSecondOpinionButton)
// //               Padding(padding: const EdgeInsets.only(top: 8.0), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onYesButtonPressed(msg), child: const Text("Yes"))),
// //
// //             if (showReportUploadButtons)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onReportUploadYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onReportUploadNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showDoctorTypeConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showSpecialityConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Row(
// //                   children: [
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmYes(msg), child: const Text("Yes")),
// //                     const SizedBox(width: 8),
// //                     ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmNo(msg), child: const Text("No")),
// //                   ],
// //                 ),
// //               ),
// //
// //             if (showDoctorTypeDropdown)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
// //                   child: DropdownButton<String>(
// //                     hint: const Text("Select Doctor Type"),
// //                     isExpanded: true,
// //                     underline: const SizedBox(),
// //                     items: const [
// //                       DropdownMenuItem(value: "Allopathy", child: Text("Allopathy ")),
// //                       DropdownMenuItem(value: "Ayurvedic", child: Text("Ayurvedic ")),
// //                       DropdownMenuItem(value: "Homeopathy", child: Text("Homeopathy ")),
// //                     ],
// //                     onChanged: (value) {
// //                       if (value != null) _onDoctorTypeSelected(msg, value);
// //                     },
// //                   ),
// //                 ),
// //               ),
// //
// //             if (showSpecialityDropdown)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12),
// //                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
// //                   child: DropdownButton<String>(
// //                     hint: const Text("Select Speciality"),
// //                     isExpanded: true,
// //                     underline: const SizedBox(),
// //                     items: const [
// //                       DropdownMenuItem(value: "MBBS", child: Text("MBBS (General Physician)")),
// //                       DropdownMenuItem(value: "MD", child: Text("MD (Doctor of Medicine)")),
// //                       DropdownMenuItem(value: "Dentist", child: Text("Dentist")),
// //                       DropdownMenuItem(value: "Cardiologist", child: Text("Cardiologist")),
// //                       DropdownMenuItem(value: "Dermatologist", child: Text("Dermatologist")),
// //                       DropdownMenuItem(value: "Orthopedic", child: Text("Orthopedic")),
// //                       DropdownMenuItem(value: "Pediatrician", child: Text("Pediatrician")),
// //                       DropdownMenuItem(value: "Gynecologist", child: Text("Gynecologist")),
// //                     ],
// //                     onChanged: (value) {
// //                       if (value != null) _onSpecialitySelected(msg, value);
// //                     },
// //                   ),
// //                 ),
// //               ),
// //
// //             if (shouldShowPaymentButton)
// //               Builder(builder: (context) {
// //                 final amount = msg.amount ?? 500;
// //                 return Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: !paymentCompleted ? Colors.green[700] : Colors.grey,
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                     ),
// //                     onPressed: !paymentCompleted ? () => _onPaymentButtonPressed(msg) : null,
// //                     icon: const Icon(Icons.payment),
// //                     label: Text("Pay ₹$amount"),
// //                   ),
// //                 );
// //               }),
// //
// //             // UPLOAD BUTTON IN CHAT BUBBLE - WILL SHOW AFTER DOCTOR GRANTS PERMISSION
// //             if (shouldShowReportUploadButton)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: ElevatedButton.icon(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: _hasUploadPermission ? Colors.orange : AppColors.primary,
// //                     foregroundColor: Colors.white,
// //                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                   ),
// //                   onPressed: () => _onReportUploadButtonPressed(msg),
// //                   icon: Icon(_hasUploadPermission ? Icons.add_circle : Icons.upload_file),
// //                   label: Text(_hasUploadPermission ? "Upload Additional Reports" : "Upload Medical Reports"),
// //                 ),
// //               ),
// //
// //             if (msg.buttonClicked && msg.selectedDoctorType != null && !msg.paymentCompleted && !msg.showDoctorTypeConfirmation && !msg.showSpecialityConfirmation)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8.0),
// //                 child: Text(
// //                   msg.selectedSpeciality != null ? "Selected: ${msg.selectedDoctorType} - ${msg.selectedSpeciality}" : "Selected: ${msg.selectedDoctorType}",
// //                   style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12),
// //                 ),
// //               ),
// //
// //             if (msg.createdAt != null)
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   _formatMessageTime(msg.createdAt!),
// //                   style: const TextStyle(fontSize: 10, color: Colors.grey),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _refreshChat() async {
// //     setState(() {
// //       loadingHistory = true;
// //     });
// //
// //     await _loadChatHistoryOrInitialize();
// //
// //     setState(() {
// //       loadingHistory = false;
// //     });
// //
// //     Helpers.showSnackBar(context, "Chat refreshed", bgColor: Colors.green);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (loadingHistory || userId == null) {
// //       return const Scaffold(
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               CircularProgressIndicator(),
// //               SizedBox(height: 16),
// //               Text('Restoring your chat session...'),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         iconTheme: IconThemeData(color: AppColors.iconColor),
// //         backgroundColor: AppColors.primary,
// //         titleSpacing: 0,
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Flexible(
// //               child: Text(
// //                 "Care Connect",
// //                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //             ),
// //             if (currentDoctorType != null) ...[
// //               const SizedBox(width: 5),
// //               Flexible(
// //                 child: Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                   decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
// //                   child: Text(
// //                     currentDoctorType!,
// //                     style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
// //                     overflow: TextOverflow.ellipsis,
// //                     maxLines: 1,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ],
// //         ),
// //         actions: [
// //           IconButton(
// //             onPressed: _refreshChat,
// //             icon: Icon(Icons.refresh, color: AppColors.iconColor),
// //             tooltip: "Refresh Chat",
// //           ),
// //           IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor)),
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
// //                   children: const [
// //                     CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/logo.png"), backgroundColor: Colors.white),
// //                     SizedBox(height: 10),
// //                     Text("CareConnect", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// //                     Text("info@CareConnect.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               Expanded(
// //                 child: ListView(
// //                   padding: EdgeInsets.zero,
// //                   children: [
// //                     drawerItem("Home", Icons.home, () => Navigator.pushNamed(context, '/home')),
// //                     drawerItem("Doctors", Icons.add, () => Navigator.pushNamed(context, '/doctors')),
// //                     drawerItem("Terms & Privacy", Icons.privacy_tip, () => Navigator.pushNamed(context, '/terms')),
// //                     drawerItem("Help & Guide", Icons.help_outline, () => Navigator.pushNamed(context, '/help')),
// //                     drawerItem("Log Out", Icons.logout_sharp, () async {
// //                       bool? confirm = await showDialog<bool>(
// //                         context: context,
// //                         builder: (context) => AlertDialog(
// //                           title: const Text("Confirm Logout"),
// //                           content: const Text("Are you sure you want to logout?"),
// //                           actions: [
// //                             TextButton(
// //                                 onPressed: () => Navigator.pop(context, false),
// //                                 child: const Text("Cancel")
// //                             ),
// //                             TextButton(
// //                                 onPressed: () => Navigator.pop(context, true),
// //                                 child: const Text("Logout")
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //
// //                       if (confirm == true && mounted) {
// //                         try {
// //                           final prefs = await SharedPreferences.getInstance();
// //                           final token = prefs.getString('token');
// //
// //                           print('🔐 Attempting logout...');
// //                           print('📱 Token available: ${token != null}');
// //
// //                           if (token != null) {
// //                             final url = Uri.parse("${ApiConfig.baseUrl}/logout");
// //                             print('📤 Calling logout API: $url');
// //
// //                             final response = await http.post(
// //                               url,
// //                               headers: {
// //                                 'Content-Type': 'application/json',
// //                                 'Authorization': 'Bearer $token',
// //                               },
// //                             );
// //
// //                             print('📥 Logout API Response Status: ${response.statusCode}');
// //                             print('📥 Logout API Response Body: ${response.body}');
// //
// //                             if (response.statusCode == 200) {
// //                               final responseData = jsonDecode(response.body);
// //                               if (responseData['success'] == true) {
// //                                 print('✅ Logout API successful');
// //                               } else {
// //                                 print('⚠ Logout API returned success: false');
// //                               }
// //                             } else {
// //                               print('❌ Logout API failed with status: ${response.statusCode}');
// //                             }
// //                           } else {
// //                             print('⚠ No token found, proceeding with local logout');
// //                           }
// //
// //                           await prefs.clear();
// //                           print('✅ Local storage cleared');
// //
// //                           if (mounted) {
// //                             Navigator.pushNamedAndRemoveUntil(
// //                               context,
// //                               '/login',
// //                                   (route) => false,
// //                             );
// //                           }
// //
// //                           Helpers.showSnackBar(
// //                               context,
// //                               "Logged out successfully",
// //                               bgColor: Colors.green
// //                           );
// //
// //                         } catch (e) {
// //                           print('❌ Logout error: $e');
// //
// //                           final prefs = await SharedPreferences.getInstance();
// //                           await prefs.clear();
// //
// //                           if (mounted) {
// //                             Navigator.pushNamedAndRemoveUntil(
// //                               context,
// //                               '/login',
// //                                   (route) => false,
// //                             );
// //                           }
// //
// //                           Helpers.showSnackBar(
// //                               context,
// //                               "Logged out successfully",
// //                               bgColor: Colors.green
// //                           );
// //                         }
// //                       }
// //                     }),
// //                   ],
// //                 ),
// //               ),
// //               Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //               const Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 80),
// //                 child: Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text("Made With", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
// //                       SizedBox(width: 5),
// //                       Icon(Icons.favorite, color: AppColors.textLight, size: 14),
// //                       SizedBox(width: 5),
// //                       Text("By VSGLogic", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
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
// //             child: ListView.builder(
// //               padding: const EdgeInsets.symmetric(vertical: 10),
// //               controller: _scrollController,
// //               itemCount: messages.length + 1,
// //               itemBuilder: (context, index) {
// //                 if (index == 0) return buildIntroCard(context);
// //                 final msg = messages[index - 1];
// //
// //                 bool showDate = false;
// //                 if (index == 1) {
// //                   showDate = true;
// //                 } else {
// //                   final prevMsg = messages[index - 2];
// //                   if (msg.createdAt != null && prevMsg.createdAt != null) {
// //                     showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
// //                   }
// //                 }
// //
// //                 return Column(
// //                   children: [
// //                     if (showDate && msg.createdAt != null)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                           decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
// //                           child: Text(formatDate(msg.createdAt!), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight)),
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
// //               child: Column(
// //                 children: [
// //                   if (_isSessionEnded)
// //                     Container(
// //                       width: double.infinity,
// //                       margin: const EdgeInsets.only(bottom: 8),
// //                       padding: const EdgeInsets.all(12),
// //                       decoration: BoxDecoration(
// //                         color: Colors.orange.shade100,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.info, color: Colors.orange.shade800),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               "Session completed by doctor. Starting new chat...",
// //                               style: TextStyle(
// //                                 color: Colors.orange.shade800,
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                   if (_hasUploadPermission && !_isSessionEnded)
// //                     Container(
// //                       width: double.infinity,
// //                       margin: const EdgeInsets.only(bottom: 8),
// //                       padding: const EdgeInsets.all(10),
// //                       decoration: BoxDecoration(
// //                         color: Colors.orange.shade100,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.upload_file, color: Colors.orange.shade800, size: 16),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               "Upload access granted - You can upload additional reports using the upload button in chat",
// //                               style: TextStyle(
// //                                 color: Colors.orange.shade800,
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                   Row(
// //                     children: [
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                           decoration: BoxDecoration(
// //                             color: paymentCompleted && !_isSessionEnded ? Colors.white : Colors.grey.shade300,
// //                             borderRadius: BorderRadius.circular(21),
// //                           ),
// //                           child: TextField(
// //                             controller: _controller,
// //                             enabled: paymentCompleted && !_isSessionEnded,
// //                             keyboardType: TextInputType.multiline,
// //                             textInputAction: TextInputAction.newline,
// //                             minLines: 1,
// //                             maxLines: 4,
// //                             decoration: InputDecoration.collapsed(
// //                               hintText: _isSessionEnded
// //                                   ? "Session completed - Starting new chat..."
// //                                   : paymentCompleted
// //                                   ? "Type your message here"
// //                                   : "Complete payment to chat",
// //                             ),
// //                             onChanged: (text) {
// //                               WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       GestureDetector(
// //                         onTap: paymentCompleted && !_isSessionEnded
// //                             ? () {
// //                           if (_controller.text.trim().isNotEmpty) {
// //                             _onUserSend(_controller.text.trim());
// //                             _controller.clear();
// //                           }
// //                         }
// //                             : null,
// //                         child: Icon(
// //                             Icons.send,
// //                             color: paymentCompleted && !_isSessionEnded ? AppColors.iconColor : Colors.grey
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
//
//
//
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
// import 'dart:async';
// import 'dart:math';
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
// String _formatFileSize(dynamic size) {
//   if (size == null) return 'Unknown';
//   final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
//   if (bytes <= 0) return "0 B";
//   const suffixes = ["B", "KB", "MB", "GB"];
//   var i = (log(bytes) / log(1024)).floor();
//   return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
// }
//
// String _formatMessageTime(DateTime dateTime) {
//   final localTime = dateTime.toLocal();
//   final hour = localTime.hour.toString().padLeft(2, '0');
//   final minute = localTime.minute.toString().padLeft(2, '0');
//   return '$hour:$minute';
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
//   final String? assignedDoctorId;
//   final String? assignedDoctorName;
//   final bool hasUploadPermission;
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
//     this.assignedDoctorId,
//     this.assignedDoctorName,
//     this.hasUploadPermission = false,
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
//       userName: safeString(map['userName']) ?? 'Care Connect Bot',
//       assignedDoctorId: safeString(map['assignedDoctorId']),
//       assignedDoctorName: safeString(map['assignedDoctorName']),
//       hasUploadPermission: map['hasUploadPermission'] ?? false,
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
//       'assignedDoctorId': assignedDoctorId,
//       'assignedDoctorName': assignedDoctorName,
//       'hasUploadPermission': hasUploadPermission,
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
//     String? assignedDoctorId,
//     String? assignedDoctorName,
//     bool? hasUploadPermission,
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
//       assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
//       assignedDoctorName: assignedDoctorName ?? this.assignedDoctorName,
//       hasUploadPermission: hasUploadPermission ?? this.hasUploadPermission,
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
//   String? assignedDoctorName;
//   String? assignedDoctorSpeciality;
//
//   bool _hasUploadPermission = false;
//   bool _checkingUploadPermission = false;
//   Timer? _uploadPermissionTimer;
//
//   bool _isSessionEnded = false;
//   Timer? _statusCheckTimer;
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
//     _statusCheckTimer?.cancel();
//     _uploadPermissionTimer?.cancel();
//     _razorpay.clear();
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   // UPLOAD PERMISSION METHODS
//   void _startUploadPermissionListener() {
//     if (currentOrderId == null || userId == null) {
//       print('❌ Cannot start upload permission listener: missing orderId or userId');
//       return;
//     }
//
//     if (_hasUploadPermission) {
//       print('ℹ Upload permission already granted, no need for listener');
//       return;
//     }
//
//     if (_isSessionEnded) {
//       print('ℹ Session ended, not starting upload permission listener');
//       return;
//     }
//
//     print('🔍 Starting upload permission listener for user: $userId');
//
//     _uploadPermissionTimer?.cancel();
//
//     _checkUploadPermission();
//
//     _uploadPermissionTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       print('⏰ Checking upload permission...');
//
//       if (_hasUploadPermission) {
//         timer.cancel();
//         print('🛑 Upload permission timer stopped - permission granted');
//         return;
//       }
//
//       if (_isSessionEnded) {
//         timer.cancel();
//         print('🛑 Upload permission timer stopped - session ended');
//         return;
//       }
//
//       _checkUploadPermission();
//     });
//   }
//
//   Future<void> _checkUploadPermission() async {
//     if (userId == null || currentOrderId == null) {
//       print('❌ Cannot check upload permission: missing userId or orderId');
//       return;
//     }
//
//     if (_checkingUploadPermission) return;
//
//     try {
//       setState(() {
//         _checkingUploadPermission = true;
//       });
//
//       print('🔄 Checking upload permission for user: $userId');
//
//       final response = await http.get(
//         Uri.parse('${ApiConfig.baseUrl}/doctor/get-report-permission/$userId'),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       print('📥 Upload permission response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final canSendReports = data['data']['canSendReports'] ?? false;
//
//           print('✅ Upload permission status: $canSendReports');
//
//           if (canSendReports && paymentCompleted && !_hasUploadPermission) {
//             setState(() {
//               _hasUploadPermission = true;
//             });
//
//             _showUploadPermissionGrantedMessage();
//
//             _uploadPermissionTimer?.cancel();
//             _uploadPermissionTimer = null;
//             print('🛑 Stopped upload permission timer - permission granted');
//           }
//         } else {
//           print('⚠ Upload permission API returned success: false');
//         }
//       } else if (response.statusCode == 404) {
//         print('🔍 Upload permission endpoint not found or user not in permission system');
//       } else {
//         print('❌ Upload permission check failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Error checking upload permission: $e');
//     } finally {
//       setState(() {
//         _checkingUploadPermission = false;
//       });
//     }
//   }
//
//   void _showUploadPermissionGrantedMessage() {
//     bool alreadyShown = messages.any((msg) =>
//     msg.text.contains("Upload Access Granted") &&
//         msg.hasUploadPermission == true);
//
//     if (alreadyShown) {
//       print('ℹ Upload permission message already shown');
//       return;
//     }
//
//     final uploadPermissionMsg = Message(
//       id: UniqueKey().toString(),
//       text: "📎 Upload Access Granted!\n\nThe doctor has granted you permission to upload additional medical reports. Click the upload button below to add more files.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       hasUploadPermission: true,
//       showReportUploadButton: true,
//       userId: userId,
//       userName: 'Care Connect Bot',
//     );
//
//     setState(() {
//       messages.add(uploadPermissionMsg);
//       reportUploadEnabled = true;
//       hasUploadedReport = false; // Reset so user can upload again
//     });
//
//     _scrollToBottom();
//
//     Helpers.showSnackBar(
//       context,
//       "Upload access granted! You can now upload additional reports",
//       bgColor: Colors.green,
//     );
//   }
//
//   // EXISTING METHODS (keep all your existing methods as they are)
//   Future<bool> _showTermsAndConditionsPopup() async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             "Terms & Conditions",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "By proceeding with payment, you agree to our terms and conditions:",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(height: 12),
//                 _buildSimpleTerm("Consultation fees are non-refundable once the service has been provided"),
//                 _buildSimpleTerm("All medical information shared is kept strictly confidential"),
//                 _buildSimpleTerm("For emergency medical situations, please visit the nearest hospital immediately"),
//                 _buildSimpleTerm("Doctors reserve the right to recommend in-person consultation if needed"),
//                 _buildSimpleTerm("Uploaded medical reports become part of your medical record"),
//                 SizedBox(height: 12),
//                 GestureDetector(
//                   onTap: () => Navigator.pushNamed(context, '/terms'),
//                   child: Text(
//                     "View Full Terms & Conditions",
//                     style: TextStyle(
//                       color: AppColors.primary,
//                       decoration: TextDecoration.underline,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//               ),
//               child: Text("I Accept & Proceed"),
//             ),
//           ],
//         );
//       },
//     ) ?? false;
//   }
//
//   Widget _buildSimpleTerm(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.check_circle, size: 16, color: Colors.green),
//           SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(fontSize: 12, color: Colors.grey[800]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _startOrderStatusListener() {
//     if (currentOrderId == null) {
//       print('❌ Cannot start order status listener: currentOrderId is null');
//       return;
//     }
//
//     if (_isSessionEnded) {
//       print('❌ Cannot start order status listener: session already ended');
//       return;
//     }
//
//     print('🔍 Starting order status listener for: $currentOrderId');
//
//     _statusCheckTimer?.cancel();
//
//     _checkOrderStatus();
//
//     _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       print('⏰ Timer tick - checking order status...');
//       _checkOrderStatus();
//     });
//
//     _startUploadPermissionListener();
//   }
//
//   Future<void> _checkOrderStatus() async {
//     if (currentOrderId == null || _isSessionEnded) {
//       return;
//     }
//
//     try {
//       print('🔄 Checking order status for: $currentOrderId');
//
//       final response = await http.get(
//         Uri.parse(ApiConfig.getOrderStatus(currentOrderId!)),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final order = data['data'];
//           final status = order['status']?.toString().toLowerCase();
//
//           print('📊 Current order status: $status');
//
//           if (status == 'completed') {
//             print('🎯 Session ended by doctor, resetting chat...');
//             _handleSessionEndedByDoctor();
//           }
//         }
//       }
//     } catch (e) {
//       print('❌ Error checking order status: $e');
//     }
//   }
//
//   void _handleSessionEndedByDoctor() async {
//     if (_isSessionEnded) return;
//
//     setState(() {
//       _isSessionEnded = true;
//     });
//
//     _statusCheckTimer?.cancel();
//     _uploadPermissionTimer?.cancel();
//
//     try {
//       print('🎯 Calling backend to complete order: $currentOrderId');
//
//       final response = await http.put(
//         Uri.parse('${ApiConfig.baseUrl}/completeOrder/$currentOrderId'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "status": "completed",
//           "completedBy": "Doctor",
//           "resetChat": true
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           print('✅ Order successfully completed on backend');
//         } else {
//           print('❌ Failed to complete order on backend: ${data['message']}');
//         }
//       } else {
//         print('❌ Error completing order: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Error calling completeOrder API: $e');
//     }
//
//     final sessionEndedMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Your consultation session has been completed by the doctor. Thank you for using Care Connect! Starting a new chat session...",
//       isBot: true,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Care Connect Bot',
//     );
//
//     setState(() {
//       messages.add(sessionEndedMsg);
//     });
//
//     _scrollToBottom();
//
//     Helpers.showSnackBar(
//         context,
//         "Session completed by doctor - Starting new chat",
//         bgColor: Colors.orange
//     );
//
//     await Future.delayed(const Duration(seconds: 3));
//     _resetChatToBeginning();
//   }
//
//   void _resetChatToBeginning() async {
//     print('🔄 Resetting chat to beginning...');
//
//     try {
//       final completedOrderId = currentOrderId;
//
//       setState(() {
//         messages.clear();
//         currentDoctorType = null;
//         currentSpeciality = null;
//         paymentCompleted = false;
//         reportUploadEnabled = false;
//         hasUploadedReport = false;
//         assignedDoctorName = null;
//         assignedDoctorSpeciality = null;
//         currentOrderId = null;
//         _isSessionEnded = false;
//         _hasUploadPermission = false;
//         _controller.clear();
//       });
//
//       _statusCheckTimer?.cancel();
//       _uploadPermissionTimer?.cancel();
//
//       print('✅ Local state cleared for order: $completedOrderId');
//
//       await _initializeNewChat();
//
//       print('✅ New chat session started successfully');
//
//       Helpers.showSnackBar(
//         context,
//         "New chat session started!",
//         bgColor: Colors.green,
//       );
//
//     } catch (e) {
//       print('❌ Error resetting chat: $e');
//       _createFallbackMessages();
//     }
//   }
//
//   bool _isOrderCompleted(List messagesData) {
//     if (messagesData.isEmpty) return false;
//
//     for (var msg in messagesData) {
//       if (msg['text'] != null) {
//         String text = msg['text'].toString();
//
//         if (text.contains("Your consultation session has been completed by the doctor") &&
//             text.contains("Starting a new chat session")) {
//           print('🎯 Found explicit session end message - session is completed');
//           return true;
//         }
//       }
//     }
//
//     print('💬 No explicit session end found - preserving chat');
//     return false;
//   }
//
//   bool _isChatTrulyCompleted(List messagesData) {
//     if (messagesData.isEmpty) return false;
//
//     bool hasPaymentCompletion = false;
//     bool hasActiveChatPrompt = false;
//     bool hasSessionEndMessage = false;
//
//     final recentMessages = messagesData.length > 5
//         ? messagesData.sublist(messagesData.length - 5)
//         : messagesData;
//
//     for (var msg in recentMessages.reversed) {
//       if (msg['text'] != null) {
//         String text = msg['text'].toString().toLowerCase();
//
//         if (text.contains("payment successful") ||
//             text.contains("payment completed")) {
//           hasPaymentCompletion = true;
//         }
//
//         if (text.contains("how can we help") ||
//             text.contains("start chatting") ||
//             text.contains("upload reports") ||
//             text.contains("assigned to your case")) {
//           hasActiveChatPrompt = true;
//         }
//
//         if (text.contains("session completed") ||
//             text.contains("thank you for using Care Connect") ||
//             text.contains("starting new chat")) {
//           hasSessionEndMessage = true;
//         }
//       }
//
//       if (msg['paymentCompleted'] == true) {
//         hasPaymentCompletion = true;
//       }
//     }
//
//     if (hasSessionEndMessage) {
//       return true;
//     }
//
//     if (hasPaymentCompletion && !hasActiveChatPrompt) {
//       return _isFreshPaymentWithoutChat(messagesData);
//     }
//
//     return false;
//   }
//
//   bool _isFreshPaymentWithoutChat(List messagesData) {
//     int paymentCompletionIndex = -1;
//
//     for (int i = messagesData.length - 1; i >= 0; i--) {
//       if (messagesData[i]['paymentCompleted'] == true ||
//           (messagesData[i]['text'] != null &&
//               messagesData[i]['text'].toString().toLowerCase().contains("payment successful"))) {
//         paymentCompletionIndex = i;
//         break;
//       }
//     }
//
//     if (paymentCompletionIndex == -1) return false;
//
//     for (int i = paymentCompletionIndex + 1; i < messagesData.length; i++) {
//       var msg = messagesData[i];
//
//       if (msg['isBot'] == false && msg['text'] != null && msg['text'].toString().trim().isNotEmpty) {
//         return false;
//       }
//
//       if (msg['isBot'] == true && msg['text'] != null) {
//         String text = msg['text'].toString().toLowerCase();
//         if (text.contains("how can we help") ||
//             text.contains("start chatting") ||
//             text.contains("upload reports")) {
//           return false;
//         }
//       }
//     }
//
//     return true;
//   }
//
//   Future<int?> getDynamicConsultationFee(String doctorType, String speciality) async {
//     try {
//       print('🔄 Getting dynamic fee for: $doctorType - $speciality');
//
//       final response = await http.get(
//         Uri.parse('${ApiConfig.baseUrl}/api/consultation-fee?doctorType=$doctorType&speciality=${Uri.encodeComponent(speciality)}'),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final estimatedFee = data['data']['estimatedFee'] as int;
//           print('💰 Dynamic fee received: ₹$estimatedFee');
//           return estimatedFee;
//         }
//       }
//
//       print('⚠ Using fallback fee');
//       const fallbackPricing = {
//         'Allopathy': 500,
//         'Ayurvedic': 300,
//         'Homeopathy': 200
//       };
//       return fallbackPricing[doctorType] ?? 300;
//     } catch (e) {
//       print('❌ Error getting dynamic fee: $e');
//       const fallbackPricing = {
//         'Allopathy': 500,
//         'Ayurvedic': 300,
//         'Homeopathy': 200
//       };
//       return fallbackPricing[doctorType] ?? 300;
//     }
//   }
//
//   Future<void> _loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedUserId = prefs.getString('userId');
//     final storedUserName = prefs.getString('fullName') ?? 'User';
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
//       String url = "${ApiConfig.chatHistory}?userId=$userId";
//
//       if (widget.isExistingOrder && currentOrderId != null && currentOrderId!.isNotEmpty) {
//         url += "&orderId=$currentOrderId";
//         print('📝 Loading existing order: $currentOrderId');
//       }
//
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         List messagesData = decoded['data']['messages'] as List? ?? [];
//
//         if (messagesData.isEmpty) {
//           print('📂 No messages found, initializing new chat...');
//           await _initializeNewChat();
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
//         bool restoredPaymentCompleted = false;
//         bool restoredReportUploadEnabled = false;
//         bool restoredHasUploadedReport = false;
//         String? restoredAssignedDoctorName;
//         String? restoredCurrentDoctorType;
//         String? restoredCurrentSpeciality;
//         String? restoredCurrentOrderId;
//         bool restoredIsSessionEnded = false;
//         bool restoredHasUploadPermission = false;
//
//         for (var msg in loadedMessages) {
//           if (msg.selectedDoctorType != null && msg.selectedDoctorType!.isNotEmpty) {
//             restoredCurrentDoctorType = msg.selectedDoctorType;
//           }
//           if (msg.selectedSpeciality != null && msg.selectedSpeciality!.isNotEmpty) {
//             restoredCurrentSpeciality = msg.selectedSpeciality;
//           }
//           if (msg.orderId != null && msg.orderId!.isNotEmpty) {
//             restoredCurrentOrderId = msg.orderId;
//           }
//           if (msg.paymentCompleted == true) {
//             restoredPaymentCompleted = true;
//             print('💰 Found payment completed message');
//           }
//           if (msg.wantsToUploadReport == true) {
//             restoredReportUploadEnabled = true;
//             print('📤 Found wants to upload report message');
//           }
//           if (msg.reportUploaded == true) {
//             restoredHasUploadedReport = true;
//             print('✅ Found report uploaded message');
//           }
//           if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty) {
//             restoredAssignedDoctorName = msg.assignedDoctorName;
//           }
//           if (msg.hasUploadPermission == true) {
//             restoredHasUploadPermission = true;
//             print('🔓 Found upload permission in message');
//           }
//
//           if (msg.text.contains("Your consultation session has been completed by the doctor") &&
//               msg.text.contains("Starting a new chat session")) {
//             restoredIsSessionEnded = true;
//             print('🔍 Found session end message in history');
//           }
//         }
//
//         if (restoredPaymentCompleted && !restoredReportUploadEnabled) {
//           for (var msg in loadedMessages.reversed) {
//             if (msg.showReportUploadQuestion || msg.reportUploadAnswered) {
//               restoredReportUploadEnabled = true;
//               print('🔄 Detected report upload flow from messages');
//               break;
//             }
//           }
//         }
//
//         if (restoredPaymentCompleted && !restoredHasUploadedReport) {
//           bool userDeclinedUpload = false;
//           for (var msg in loadedMessages) {
//             if (msg.isBot == false && msg.text.toLowerCase().contains("no, i don't need to upload reports")) {
//               userDeclinedUpload = true;
//               break;
//             }
//           }
//
//           if (!userDeclinedUpload) {
//             restoredReportUploadEnabled = true;
//             print('🔧 Auto-enabling upload for paid session');
//           }
//         }
//
//         setState(() {
//           messages = loadedMessages;
//           currentDoctorType = restoredCurrentDoctorType;
//           currentSpeciality = restoredCurrentSpeciality;
//           currentOrderId = restoredCurrentOrderId;
//           paymentCompleted = restoredPaymentCompleted;
//           reportUploadEnabled = restoredReportUploadEnabled;
//           hasUploadedReport = restoredHasUploadedReport;
//           assignedDoctorName = restoredAssignedDoctorName;
//           _isSessionEnded = restoredIsSessionEnded;
//           _hasUploadPermission = restoredHasUploadPermission;
//           loadingHistory = false;
//         });
//
//         print('🔄 State restored from chat history:');
//         print('   - Messages: ${messages.length}');
//         print('   - paymentCompleted: $paymentCompleted');
//         print('   - reportUploadEnabled: $reportUploadEnabled');
//         print('   - hasUploadedReport: $hasUploadedReport');
//         print('   - currentOrderId: $currentOrderId');
//         print('   - isSessionEnded: $_isSessionEnded');
//         print('   - hasUploadPermission: $_hasUploadPermission');
//
//         if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
//           print('🔍 Starting order status listener for active session');
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _startOrderStatusListener();
//           });
//         }
//
//         if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _checkUploadPermission();
//           });
//         }
//
//       } else {
//         print('❌ HTTP error: ${response.statusCode}');
//         await _initializeNewChat();
//       }
//     } catch (e) {
//       print('❌ Error loading chat history: $e');
//       await _initializeNewChat();
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
//       text: "Welcome to Care Connect. We provide professional doctor consultations from the comfort of your home.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Care Connect Bot',
//     );
//     final question = Message(
//       id: UniqueKey().toString(),
//       text: "Do you want to continue?",
//       isBot: true,
//       showButtons: true,
//       buttonClicked: false,
//       createdAt: DateTime.now(),
//       userId: userId,
//       userName: 'Care Connect Bot',
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
//     if (_isSessionEnded) {
//       Helpers.showSnackBar(context, "Session completed - cannot send messages", bgColor: Colors.orange);
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
//       userName: 'Care Connect Bot',
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
//       userName: 'Care Connect Bot',
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
//     if (doctorType == 'Allopathy') {
//       await _loadSpecializations(doctorType);
//     } else {
//       final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
//       final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
//
//       final paymentMsg = Message(
//         id: UniqueKey().toString(),
//         text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
//         isBot: true,
//         createdAt: DateTime.now(),
//         selectedDoctorType: doctorType,
//         selectedSpeciality: defaultSpeciality,
//         showPaymentButton: true,
//         amount: amount,
//         userId: userId,
//         userName: 'Care Connect Bot',
//       );
//       setState(() {
//         currentSpeciality = defaultSpeciality;
//         messages.add(paymentMsg);
//       });
//       await sendMessage(paymentMsg);
//     }
//     _scrollToBottom();
//   }
//
//   Future<void> _loadSpecializations(String doctorType) async {
//     try {
//       print('🔄 Loading specializations for $doctorType...');
//
//       final response = await http.get(
//         Uri.parse('${ApiConfig.baseUrl}/api/patients/doctors/specializations/$doctorType'),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           final specializations = List<String>.from(data['data']['specializations']);
//
//           if (specializations.isNotEmpty) {
//             final specialityQuestion = Message(
//               id: UniqueKey().toString(),
//               text: "Please select your doctor's speciality:",
//               isBot: true,
//               showButtons: true,
//               buttonClicked: false,
//               createdAt: DateTime.now(),
//               selectedDoctorType: doctorType,
//               userId: userId,
//               userName: 'Care Connect Bot',
//             );
//
//             setState(() {
//               messages.add(specialityQuestion);
//             });
//             await sendMessage(specialityQuestion);
//           } else {
//             _proceedToPayment(doctorType);
//           }
//         }
//       } else {
//         throw Exception('Failed to load specializations');
//       }
//     } catch (e) {
//       print('❌ Error loading specializations: $e');
//       if (doctorType == 'Allopathy') {
//         _showDefaultSpecializations(doctorType);
//       } else {
//         _proceedToPayment(doctorType);
//       }
//     }
//   }
//
//   void _showDefaultSpecializations(String doctorType) {
//     List<String> specializations = [];
//
//     if (doctorType == 'Allopathy') {
//       specializations = ['MBBS', 'MD', 'Cardiologist', 'Dermatologist', 'Orthopedic', 'Pediatrician', 'Gynecologist', 'Neurologist', 'Psychiatrist'];
//     }
//
//     if (specializations.isNotEmpty) {
//       final specialityQuestion = Message(
//         id: UniqueKey().toString(),
//         text: "Please select your doctor's speciality:",
//         isBot: true,
//         showButtons: true,
//         buttonClicked: false,
//         createdAt: DateTime.now(),
//         selectedDoctorType: doctorType,
//         userId: userId,
//         userName: 'Care Connect Bot',
//       );
//
//       setState(() {
//         messages.add(specialityQuestion);
//       });
//     } else {
//       _proceedToPayment(doctorType);
//     }
//   }
//
//   void _proceedToPayment(String doctorType) async {
//     final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
//     final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;
//
//     final paymentMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: doctorType,
//       selectedSpeciality: defaultSpeciality,
//       showPaymentButton: true,
//       amount: amount,
//       userId: userId,
//       userName: 'Care Connect Bot',
//     );
//     setState(() {
//       currentSpeciality = defaultSpeciality;
//       messages.add(paymentMsg);
//     });
//     sendMessage(paymentMsg);
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
//       userName: 'Care Connect Bot',
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
//       userName: 'Care Connect Bot',
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
//
//     final amount = await getDynamicConsultationFee(currentDoctorType!, speciality) ?? 500;
//
//     final paymentMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Excellent! You've selected $speciality specialist. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: speciality,
//       showPaymentButton: true,
//       amount: amount,
//       userId: userId,
//       userName: 'Care Connect Bot',
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
//       userName: 'Care Connect Bot',
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
//     final acceptedTerms = await _showTermsAndConditionsPopup();
//     if (!acceptedTerms) {
//       Helpers.showSnackBar(context, "Please accept terms and conditions to proceed with payment", bgColor: Colors.orange);
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
//     int amount = paymentMsg.amount ?? 500;
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
//       if (currentDoctorType == null || currentDoctorType!.isEmpty) {
//         Helpers.showSnackBar(context, "Please select a doctor type first");
//         return;
//       }
//
//       String finalSpeciality = currentSpeciality ?? '';
//       if ((currentDoctorType == 'Ayurvedic' || currentDoctorType == 'Homeopathy') &&
//           (finalSpeciality.isEmpty)) {
//         finalSpeciality = currentDoctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
//         setState(() {
//           currentSpeciality = finalSpeciality;
//         });
//         print('🔄 Set default speciality for ${currentDoctorType}: $finalSpeciality');
//       }
//
//       if (finalSpeciality.isEmpty) {
//         Helpers.showSnackBar(context, "Please select a speciality first");
//         return;
//       }
//
//       print('🔄 Creating order for doctor: $currentDoctorType, speciality: $finalSpeciality');
//       print('🔍 Sending data:');
//       print('   - UserId: $userId');
//       print('   - userName: $userName');
//       print('   - doctorType: $currentDoctorType');
//       print('   - speciality: $finalSpeciality');
//
//       var response = await http.post(
//         Uri.parse(ApiConfig.orders),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "UserId": userId,
//           "userName": userName ?? 'User',
//           "userPhone": userPhone ?? '',
//           "userEmail": userEmail ?? '',
//           "doctorType": currentDoctorType,
//           "speciality": finalSpeciality,
//           "currency": "INR",
//         }),
//       );
//
//       print('📥 Order creation response: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['success'] == true && data['data'] != null) {
//           String? orderId;
//           String? razorpayOrderId;
//           int? actualAmount;
//
//           if (data['data']['orderId'] != null) {
//             orderId = data['data']['orderId'].toString();
//           } else if (data['data']['id'] != null) {
//             orderId = data['data']['id'].toString();
//           }
//
//           if (data['data']['razorpayOrderId'] != null) {
//             razorpayOrderId = data['data']['razorpayOrderId'].toString();
//           } else if (data['data']['order_id'] != null) {
//             razorpayOrderId = data['data']['order_id'].toString();
//           }
//
//           if (data['data']['amount'] != null) {
//             actualAmount = data['data']['amount'] is int
//                 ? data['data']['amount']
//                 : (data['data']['amount'] as double).toInt();
//             print('💰 Backend calculated amount: ₹$actualAmount');
//           }
//
//           if (orderId != null) {
//             setState(() {
//               currentOrderId = orderId;
//             });
//
//             String finalRazorpayOrderId = razorpayOrderId ?? orderId;
//
//             print('✅ Order created successfully: $currentOrderId');
//             print('🔑 Razorpay Order ID: $finalRazorpayOrderId');
//             print('💰 Amount to pay: ₹$actualAmount');
//
//             _updatePaymentMessageWithActualAmount(actualAmount ?? amount);
//
//             openCheckout(actualAmount ?? amount, doctorCategory, finalRazorpayOrderId);
//           } else {
//             Helpers.showSnackBar(context, "Order created but no order ID returned");
//           }
//         } else {
//           Helpers.showSnackBar(context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
//         }
//       } else if (response.statusCode == 400) {
//         var data = jsonDecode(response.body);
//         Helpers.showSnackBar(context, "Validation error: ${data['message'] ?? 'Check your inputs'}");
//       } else {
//         Helpers.showSnackBar(context, "Doctor Not Available.....");
//       }
//     } catch (e) {
//       print('❌ Order creation error: $e');
//       Helpers.showSnackBar(context, "Network error: $e");
//     }
//   }
//
//   void _updatePaymentMessageWithActualAmount(int actualAmount) {
//     for (int i = messages.length - 1; i >= 0; i--) {
//       if (messages[i].showPaymentButton && !messages[i].paymentCompleted) {
//         setState(() {
//           messages[i] = messages[i].copyWith(
//             amount: actualAmount,
//             text: "Great! You've selected ${currentDoctorType} - ${currentSpeciality}. Consultation fee: ₹$actualAmount. Please proceed with payment to start your consultation.",
//           );
//         });
//         break;
//       }
//     }
//   }
//
//   Future<void> openCheckout(int amount, String doctorCategory, String razorpayOrderId) async {
//     var options = {
//       'key': 'rzp_test_vDQGr1D5EBRubo',
//       'amount': amount * 100,
//       'name': 'Care Connect',
//       'description': 'Consultation Fee - $doctorCategory',
//       'order_id': razorpayOrderId,
//       'prefill': {
//         'contact': userPhone ?? '9999999999',
//         'email': userEmail ?? 'user@example.com',
//         'name': userName ?? 'User',
//       },
//       'theme': {'color': '#00796B'},
//       'retry': {'enabled': true, 'max_count': 1},
//       'timeout': 300,
//     };
//
//     try {
//       print('💰 Opening Razorpay checkout with options: $options');
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint("❌ Error opening Razorpay: $e");
//       Helpers.showSnackBar(context, "Error opening payment gateway: $e");
//     }
//   }
//
//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     try {
//       print('✅ Payment successful:');
//       print('   Order ID: ${response.orderId}');
//       print('   Payment ID: ${response.paymentId}');
//       print('   Signature: ${response.signature}');
//
//       Helpers.showSnackBar(context, "Verifying payment...", bgColor: Colors.orange);
//
//       var verifyResponse = await http.post(
//         Uri.parse(ApiConfig.verifyPayment),
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
//           "amount": getAmountFromMessages() ?? 500,
//         }),
//       );
//
//       print('📥 Verification response: ${verifyResponse.statusCode}');
//       print('📥 Verification body: ${verifyResponse.body}');
//
//       var verifyData = jsonDecode(verifyResponse.body);
//
//       if (verifyData['success'] == true) {
//         await _handleSuccessfulPayment(response, verifyData);
//       } else {
//         Helpers.showSnackBar(
//             context,
//             "Payment verification failed: ${verifyData['message'] ?? 'Unknown error'}",
//             bgColor: Colors.red
//         );
//       }
//     } catch (e) {
//       debugPrint("❌ Verification error: $e");
//       Helpers.showSnackBar(context, "Payment verification error: $e", bgColor: Colors.red);
//     }
//   }
//
//   int? getAmountFromMessages() {
//     for (int i = messages.length - 1; i >= 0; i--) {
//       if (messages[i].amount != null) {
//         return messages[i].amount;
//       }
//     }
//     return null;
//   }
//
//   Future<void> _handleSuccessfulPayment(PaymentSuccessResponse response, Map<String, dynamic> verifyData) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int currentOrderCount = prefs.getInt('orderCount') ?? 0;
//     currentOrderCount++;
//     await prefs.setInt('orderCount', currentOrderCount);
//     String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');
//
//     setState(() {
//       paymentCompleted = true;
//     });
//
//     final amount = getAmountFromMessages() ?? 500;
//
//     final paymentSuccessMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Payment successful and verified! ✅",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       paymentCompleted: true,
//       orderId: currentOrderId,
//       paymentId: response.paymentId,
//       orderNumber: displayOrderNo,
//       amount: amount,
//       userId: userId,
//       userName: 'Care Connect Bot',
//     );
//
//     final amountMsg = Message(
//       id: UniqueKey().toString(),
//       text: "₹$amount has been successfully processed for Order #$displayOrderNo",
//       isBot: false,
//       createdAt: DateTime.now(),
//       paymentCompleted: true,
//       amount: amount,
//       userId: userId,
//       userName: userName,
//     );
//
//     setState(() {
//       messages.add(paymentSuccessMsg);
//       messages.add(amountMsg);
//     });
//
//     await sendMessage(paymentSuccessMsg);
//     await sendMessage(amountMsg);
//
//     await _handleDoctorAssignment(verifyData);
//
//     print('💰 Payment completed, starting session end listener...');
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startOrderStatusListener();
//       _startUploadPermissionListener();
//     });
//
//     await _askReportUploadQuestion();
//     _scrollToBottom();
//
//     Helpers.showSnackBar(
//         context,
//         "Payment successful! Order #$displayOrderNo created.",
//         bgColor: AppColors.accent
//     );
//   }
//
//   Future<void> _handleDoctorAssignment(Map<String, dynamic> verifyData) async {
//     if (verifyData['data']['assignedDoctor'] != null) {
//       final assignedDoctor = verifyData['data']['assignedDoctor'];
//       setState(() {
//         assignedDoctorName = assignedDoctor['name'];
//         assignedDoctorSpeciality = assignedDoctor['speciality'];
//       });
//
//       final doctorAssignmentMsg = Message(
//         id: UniqueKey().toString(),
//         text: "Great news! Dr. ${assignedDoctor['name']} (${assignedDoctor['speciality']}) has been assigned to your case. They will connect with you shortly.",
//         isBot: true,
//         createdAt: DateTime.now(),
//         selectedDoctorType: currentDoctorType,
//         selectedSpeciality: currentSpeciality,
//         paymentCompleted: true,
//         assignedDoctorId: assignedDoctor['id'],
//         assignedDoctorName: assignedDoctor['name'],
//         userId: userId,
//         userName: 'Care Connect Bot',
//       );
//
//       setState(() {
//         messages.add(doctorAssignmentMsg);
//       });
//       await sendMessage(doctorAssignmentMsg);
//     } else {
//       final waitingMsg = Message(
//         id: UniqueKey().toString(),
//         text: "Payment successful! We're finding the best ${currentSpeciality} ${currentDoctorType} doctor for you. You'll be notified when a doctor is assigned.",
//         isBot: true,
//         createdAt: DateTime.now(),
//         selectedDoctorType: currentDoctorType,
//         selectedSpeciality: currentSpeciality,
//         paymentCompleted: true,
//         userId: userId,
//         userName: 'Care Connect Bot',
//       );
//
//       setState(() {
//         messages.add(waitingMsg);
//       });
//       await sendMessage(waitingMsg);
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
//       userName: 'Care Connect Bot',
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
//
//     final uploadButtonMsg = Message(
//       id: UniqueKey().toString(),
//       text: "Great! Click the button below to upload your medical reports.",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       showReportUploadButton: true,
//       userId: userId,
//       userName: 'Care Connect Bot',
//     );
//
//     setState(() {
//       messages[index] = updatedMsg;
//       messages.add(userResponse);
//       messages.add(uploadButtonMsg);
//       reportUploadEnabled = true;
//       hasUploadedReport = false;
//     });
//
//     await sendMessage(updatedMsg);
//     await sendMessage(userResponse);
//     await sendMessage(uploadButtonMsg);
//
//     final chatEnableMsg = Message(
//       id: UniqueKey().toString(),
//       text: assignedDoctorName != null
//           ? "You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
//           : "You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       paymentCompleted: true,
//       assignedDoctorName: assignedDoctorName,
//       userId: userId,
//       userName: 'Care Connect Bot',
//     );
//
//     setState(() {
//       messages.add(chatEnableMsg);
//     });
//
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
//       text: assignedDoctorName != null
//           ? "No problem! You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
//           : "No problem! You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
//       isBot: true,
//       createdAt: DateTime.now(),
//       selectedDoctorType: currentDoctorType,
//       selectedSpeciality: currentSpeciality,
//       paymentCompleted: true,
//       assignedDoctorName: assignedDoctorName,
//       userId: userId,
//       userName: 'Care Connect Bot',
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
//   // UPDATED UPLOAD BUTTON HANDLER
//   Future<void> _onReportUploadButtonPressed(Message uploadMsg) async {
//     final index = messages.indexWhere((m) => m.id == uploadMsg.id);
//     if (index == -1) return;
//
//     final canUpload = reportUploadEnabled || _hasUploadPermission;
//
//     if (!canUpload) {
//       Helpers.showSnackBar(context, "Please complete payment and confirm report upload first", bgColor: Colors.orange);
//       return;
//     }
//
//     // If user has upload permission, they can upload multiple times
//     // Otherwise, they can only upload once
//     if (hasUploadedReport && !_hasUploadPermission) {
//       Helpers.showSnackBar(context, "You have already uploaded reports. Upload is allowed only once.", bgColor: Colors.orange);
//       return;
//     }
//
//     if (_isSessionEnded) {
//       Helpers.showSnackBar(context, "Session completed - cannot upload files", bgColor: Colors.orange);
//       return;
//     }
//     if (currentOrderId == null) {
//       Helpers.showSnackBar(context, "No active order found", bgColor: Colors.red);
//       return;
//     }
//
//     print('📤 Navigating to upload with orderId: $currentOrderId, userId: $userId');
//     print('🔓 Upload permission status: $_hasUploadPermission');
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => UploadFiles(
//         orderId: currentOrderId!,
//         userId: userId!,
//       )),
//     );
//
//     if (result != null && result is Map<String, dynamic> && result['status'] == 'uploaded') {
//       List<Map<String, dynamic>> uploadedReports = List<Map<String, dynamic>>.from(result['reports']);
//
//       String successMessage;
//       if (_hasUploadPermission && hasUploadedReport) {
//         successMessage = "Additional medical reports uploaded successfully! ✅\nTotal new files: ${uploadedReports.length}";
//       } else {
//         successMessage = "Medical reports uploaded successfully! ✅\nTotal files: ${uploadedReports.length}";
//       }
//
//       final uploadSuccessMsg = Message(
//         id: UniqueKey().toString(),
//         text: successMessage,
//         isBot: true,
//         createdAt: DateTime.now(),
//         selectedDoctorType: currentDoctorType,
//         selectedSpeciality: currentSpeciality,
//         reportUploaded: true,
//         reportFiles: uploadedReports,
//         assignedDoctorName: assignedDoctorName,
//         hasUploadPermission: _hasUploadPermission,
//         userId: userId,
//         userName: 'Care Connect Bot',
//       );
//
//       setState(() {
//         messages.add(uploadSuccessMsg);
//         hasUploadedReport = true;
//
//         // Only disable upload if user doesn't have special permission
//         if (!_hasUploadPermission) {
//           reportUploadEnabled = false;
//         }
//       });
//
//       await sendMessage(uploadSuccessMsg);
//       _scrollToBottom();
//
//       Helpers.showSnackBar(context, "Reports uploaded successfully!", bgColor: AppColors.accent);
//
//       await _loadChatHistoryOrInitialize();
//     }
//   }
//
//   IconData _getFileIcon(String fileType) {
//     if (fileType.toLowerCase().contains('image')) return Icons.image;
//     if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
//     if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
//       return Icons.description;
//     return Icons.insert_drive_file;
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
//       userName: 'Care Connect Bot',
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
//                 "Care Connect",
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
//           GestureDetector(
//             onTap: () => Navigator.pushNamed(context, '/help'),
//             child: Text(
//               "Help & Support",
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
//     // UPDATED UPLOAD BUTTON CONDITION - WILL APPEAR WHEN DOCTOR GRANTS PERMISSION
//     final shouldShowReportUploadButton =
//         (msg.showReportUploadButton && reportUploadEnabled && !hasUploadedReport && !_isSessionEnded) ||
//             (msg.hasUploadPermission && _hasUploadPermission && !_isSessionEnded && !hasUploadedReport);
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
//             if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green.shade200),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.medical_services, color: Colors.green.shade700, size: 16),
//                       const SizedBox(width: 8),
//                       Flexible(
//                         child: Text(
//                           "Assigned: Dr. ${msg.assignedDoctorName}",
//                           style: TextStyle(
//                             color: Colors.green.shade800,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//             if (msg.hasUploadPermission && _hasUploadPermission)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade50,
//                     borderRadius: BorderRadius.circular(6),
//                     border: Border.all(color: Colors.orange.shade200),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.upload_file, color: Colors.orange.shade700, size: 14),
//                       const SizedBox(width: 6),
//                       Text(
//                         "Upload access granted by doctor",
//                         style: TextStyle(
//                           color: Colors.orange.shade800,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//             if (msg.reportUploaded == true && msg.reportFiles != null && msg.reportFiles!.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "📁 Uploaded Reports (${msg.reportFiles!.length}):",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: isUser ? AppColors.chatUserText : AppColors.chatBotText,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     ...msg.reportFiles!.map((report) {
//                       final fileName = report['fileName']?.toString() ?? 'Unknown File';
//                       final fileSize = report['fileSize'] ?? 0;
//                       final fileType = report['fileType']?.toString() ?? 'file';
//
//                       return GestureDetector(
//                         onTap: () => _openFile(report['filePath'], fileName),
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 6),
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: isUser ? Colors.blue.shade50 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: isUser ? Colors.blue.shade200 : Colors.green.shade200),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Icon(
//                                   _getFileIcon(fileType),
//                                   color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
//                                   size: 18,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       fileName,
//                                       style: TextStyle(
//                                         color: isUser ? Colors.blue.shade900 : Colors.green.shade900,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 12,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       _formatFileSize(fileSize is int ? fileSize : 0),
//                                       style: TextStyle(
//                                         color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
//                                         fontSize: 10,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.visibility_outlined,
//                                 color: isUser ? Colors.blue.shade600 : Colors.green.shade600,
//                                 size: 16,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ],
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
//                       DropdownMenuItem(value: "Allopathy", child: Text("Allopathy ")),
//                       DropdownMenuItem(value: "Ayurvedic", child: Text("Ayurvedic ")),
//                       DropdownMenuItem(value: "Homeopathy", child: Text("Homeopathy ")),
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
//                 final amount = msg.amount ?? 500;
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
//             // UPLOAD BUTTON - WILL REAPPEAR WHEN DOCTOR GRANTS PERMISSION
//             if (shouldShowReportUploadButton)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _hasUploadPermission ? Colors.orange : AppColors.primary,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   ),
//                   onPressed: () => _onReportUploadButtonPressed(msg),
//                   icon: Icon(_hasUploadPermission ? Icons.add_circle : Icons.upload_file),
//                   label: Text(_hasUploadPermission ? "Upload Additional Reports" : "Upload Medical Reports"),
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
//                 child: Text(
//                   _formatMessageTime(msg.createdAt!),
//                   style: const TextStyle(fontSize: 10, color: Colors.grey),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _refreshChat() async {
//     setState(() {
//       loadingHistory = true;
//     });
//
//     await _loadChatHistoryOrInitialize();
//
//     setState(() {
//       loadingHistory = false;
//     });
//
//     Helpers.showSnackBar(context, "Chat refreshed", bgColor: Colors.green);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loadingHistory || userId == null) {
//       return const Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Restoring your chat session...'),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppColors.iconColor),
//         backgroundColor: AppColors.primary,
//         titleSpacing: 0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Flexible(
//               child: Text(
//                 "Care Connect",
//                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             if (currentDoctorType != null) ...[
//               const SizedBox(width: 5),
//               Flexible(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
//                   child: Text(
//                     currentDoctorType!,
//                     style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: _refreshChat,
//             icon: Icon(Icons.refresh, color: AppColors.iconColor),
//             tooltip: "Refresh Chat",
//           ),
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
//                     Text("CareConnect", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//                     Text("info@CareConnect.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
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
//                     drawerItem("Terms & Privacy", Icons.privacy_tip, () => Navigator.pushNamed(context, '/terms')),
//                     drawerItem("Help & Guide", Icons.help_outline, () => Navigator.pushNamed(context, '/help')),
//                     drawerItem("Log Out", Icons.logout_sharp, () async {
//                       bool? confirm = await showDialog<bool>(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text("Confirm Logout"),
//                           content: const Text("Are you sure you want to logout?"),
//                           actions: [
//                             TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 child: const Text("Cancel")
//                             ),
//                             TextButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 child: const Text("Logout")
//                             ),
//                           ],
//                         ),
//                       );
//
//                       if (confirm == true && mounted) {
//                         try {
//                           final prefs = await SharedPreferences.getInstance();
//                           final token = prefs.getString('token');
//
//                           print('🔐 Attempting logout...');
//                           print('📱 Token available: ${token != null}');
//
//                           if (token != null) {
//                             final url = Uri.parse("${ApiConfig.baseUrl}/logout");
//                             print('📤 Calling logout API: $url');
//
//                             final response = await http.post(
//                               url,
//                               headers: {
//                                 'Content-Type': 'application/json',
//                                 'Authorization': 'Bearer $token',
//                               },
//                             );
//
//                             print('📥 Logout API Response Status: ${response.statusCode}');
//                             print('📥 Logout API Response Body: ${response.body}');
//
//                             if (response.statusCode == 200) {
//                               final responseData = jsonDecode(response.body);
//                               if (responseData['success'] == true) {
//                                 print('✅ Logout API successful');
//                               } else {
//                                 print('⚠ Logout API returned success: false');
//                               }
//                             } else {
//                               print('❌ Logout API failed with status: ${response.statusCode}');
//                             }
//                           } else {
//                             print('⚠ No token found, proceeding with local logout');
//                           }
//
//                           await prefs.clear();
//                           print('✅ Local storage cleared');
//
//                           if (mounted) {
//                             Navigator.pushNamedAndRemoveUntil(
//                               context,
//                               '/login',
//                                   (route) => false,
//                             );
//                           }
//
//                           Helpers.showSnackBar(
//                               context,
//                               "Logged out successfully",
//                               bgColor: Colors.green
//                           );
//
//                         } catch (e) {
//                           print('❌ Logout error: $e');
//
//                           final prefs = await SharedPreferences.getInstance();
//                           await prefs.clear();
//
//                           if (mounted) {
//                             Navigator.pushNamedAndRemoveUntil(
//                               context,
//                               '/login',
//                                   (route) => false,
//                             );
//                           }
//
//                           Helpers.showSnackBar(
//                               context,
//                               "Logged out successfully",
//                               bgColor: Colors.green
//                           );
//                         }
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
//               child: Column(
//                 children: [
//                   if (_isSessionEnded)
//                     Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.only(bottom: 8),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.info, color: Colors.orange.shade800),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               "Session completed by doctor. Starting new chat...",
//                               style: TextStyle(
//                                 color: Colors.orange.shade800,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                   if (_hasUploadPermission && !_isSessionEnded)
//                     Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.only(bottom: 8),
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.upload_file, color: Colors.orange.shade800, size: 16),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               "Upload access granted - You can upload additional reports using the upload button in chat",
//                               style: TextStyle(
//                                 color: Colors.orange.shade800,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                   Row(
//                     children: [
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: paymentCompleted && !_isSessionEnded ? Colors.white : Colors.grey.shade300,
//                             borderRadius: BorderRadius.circular(21),
//                           ),
//                           child: TextField(
//                             controller: _controller,
//                             enabled: paymentCompleted && !_isSessionEnded,
//                             keyboardType: TextInputType.multiline,
//                             textInputAction: TextInputAction.newline,
//                             minLines: 1,
//                             maxLines: 4,
//                             decoration: InputDecoration.collapsed(
//                               hintText: _isSessionEnded
//                                   ? "Session completed - Starting new chat..."
//                                   : paymentCompleted
//                                   ? "Type your message here"
//                                   : "Complete payment to chat",
//                             ),
//                             onChanged: (text) {
//                               WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       GestureDetector(
//                         onTap: paymentCompleted && !_isSessionEnded
//                             ? () {
//                           if (_controller.text.trim().isNotEmpty) {
//                             _onUserSend(_controller.text.trim());
//                             _controller.clear();
//                           }
//                         }
//                             : null,
//                         child: Icon(
//                             Icons.send,
//                             color: paymentCompleted && !_isSessionEnded ? AppColors.iconColor : Colors.grey
//                         ),
//                       ),
//                     ],
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
// //   import 'package:flutter/material.dart';
// //   import 'package:http/http.dart' as http;
// //   import 'dart:convert';
// //   import 'package:shared_preferences/shared_preferences.dart';
// //   import 'package:razorpay_flutter/razorpay_flutter.dart';
// //   import 'helper.dart';
// //   import 'package:intl/intl.dart';
// //   import 'upload_files.dart';
// //   import 'package:open_filex/open_filex.dart';
// //   import 'services/chat_service.dart';
// //   import 'dart:async';
// //   import 'dart:math';
// //
// //   // Message model
// //   class Message {
// //     final String id;
// //     final String text;
// //     final bool isBot;
// //     final bool showButtons;
// //     final bool buttonClicked;
// //     final DateTime? createdAt;
// //     final String? selectedDoctorType;
// //     final String? selectedSpeciality;
// //     final bool showPaymentButton;
// //     final bool paymentCompleted;
// //     final String? orderId;
// //     final String? paymentId;
// //     final String? orderNumber;
// //     final int? amount;
// //     final bool showReportUploadQuestion;
// //     final bool reportUploadAnswered;
// //     final bool wantsToUploadReport;
// //     final bool showReportUploadButton;
// //     final bool reportUploaded;
// //     final List<Map<String, dynamic>>? reportFiles;
// //     final bool showDoctorTypeConfirmation;
// //     final bool showSpecialityConfirmation;
// //     final String? pendingDoctorType;
// //     final String? pendingSpeciality;
// //     final String? userId;
// //     final String? userName;
// //     final String? assignedDoctorId;
// //     final String? assignedDoctorName;
// //     final List<dynamic>? buttons;
// //
// //     Message({
// //       required this.id,
// //       required this.text,
// //       required this.isBot,
// //       this.showButtons = false,
// //       this.buttonClicked = false,
// //       this.createdAt,
// //       this.selectedDoctorType,
// //       this.selectedSpeciality,
// //       this.showPaymentButton = false,
// //       this.paymentCompleted = false,
// //       this.orderId,
// //       this.paymentId,
// //       this.orderNumber,
// //       this.amount,
// //       this.showReportUploadQuestion = false,
// //       this.reportUploadAnswered = false,
// //       this.wantsToUploadReport = false,
// //       this.showReportUploadButton = false,
// //       this.reportUploaded = false,
// //       this.reportFiles,
// //       this.showDoctorTypeConfirmation = false,
// //       this.showSpecialityConfirmation = false,
// //       this.pendingDoctorType,
// //       this.pendingSpeciality,
// //       this.userId,
// //       this.userName,
// //       this.assignedDoctorId,
// //       this.assignedDoctorName,
// //       this.buttons,
// //     });
// //
// //     // factory Message.fromMap(Map<String, dynamic> map) {
// //     //   // FIXED: Properly handle buttonClicked - only set to true if it's explicitly true in the data
// //     //   final bool buttonClicked = map['buttonClicked'] == true;
// //     //
// //     //   int? amount;
// //     //   if (map['amount'] != null) {
// //     //     if (map['amount'] is int) {
// //     //       amount = map['amount'];
// //     //     } else if (map['amount'] is double) {
// //     //       amount = (map['amount'] as double).toInt();
// //     //     } else if (map['amount'] is String) {
// //     //       amount = int.tryParse(map['amount']);
// //     //     }
// //     //   }
// //     //
// //     //   String? safeString(String? value) {
// //     //     return (value == null || value.isEmpty) ? null : value;
// //     //   }
// //     //
// //     //   // FIXED: Better button handling
// //     //   List<dynamic>? buttons;
// //     //   if (map['buttons'] != null && map['buttons'] is List) {
// //     //     buttons = map['buttons'] as List;
// //     //     print('🔘 Processing ${buttons.length} buttons from backend');
// //     //
// //     //     // Debug each button
// //     //     for (int i = 0; i < buttons.length; i++) {
// //     //       print('   Button $i: ${buttons[i]}');
// //     //     }
// //     //   } else {
// //     //     print('⚠ No buttons or invalid buttons format from backend');
// //     //     buttons = [];
// //     //   }
// //     //
// //     //   // FIXED: Only show buttons if we actually have valid buttons AND buttonClicked is false
// //     //   final bool shouldShowButtons = buttons.isNotEmpty &&
// //     //       !buttonClicked &&
// //     //       (map['showButtons'] == true);
// //     //
// //     //   print('🎯 Button display decision:');
// //     //   print('   - buttons count: ${buttons.length}');
// //     //   print('   - buttonClicked: $buttonClicked');
// //     //   print('   - showButtons from map: ${map['showButtons']}');
// //     //   print('   - shouldShowButtons: $shouldShowButtons');
// //     //
// //     //   return Message(
// //     //     id: map['_id'] ?? map['id'] ?? UniqueKey().toString(),
// //     //     text: map['text'] ?? "",
// //     //     isBot: map['isBot'] ?? false,
// //     //     showButtons: shouldShowButtons,
// //     //     buttonClicked: buttonClicked, // Use the actual value from backend
// //     //     createdAt: map['createdAt'] != null
// //     //         ? DateTime.tryParse(map['createdAt'].toString())
// //     //         : DateTime.now(),
// //     //     selectedDoctorType: safeString(map['selectedDoctorType']),
// //     //     selectedSpeciality: safeString(map['selectedSpeciality']),
// //     //     showPaymentButton: map['showPaymentButton'] ?? false,
// //     //     paymentCompleted: map['paymentCompleted'] ?? false,
// //     //     orderId: safeString(map['orderId']),
// //     //     paymentId: safeString(map['paymentId']),
// //     //     orderNumber: safeString(map['orderNumber']),
// //     //     amount: amount,
// //     //     showReportUploadQuestion: map['showReportUploadQuestion'] ?? false,
// //     //     reportUploadAnswered: map['reportUploadAnswered'] ?? false,
// //     //     wantsToUploadReport: map['wantsToUploadReport'] ?? false,
// //     //     showReportUploadButton: map['showReportUploadButton'] ?? false,
// //     //     reportUploaded: map['reportUploaded'] ?? false,
// //     //     reportFiles: map['reportFiles'] != null && map['reportFiles'] is List
// //     //         ? List<Map<String, dynamic>>.from(map['reportFiles'])
// //     //         : null,
// //     //     showDoctorTypeConfirmation: map['showDoctorTypeConfirmation'] ?? false,
// //     //     showSpecialityConfirmation: map['showSpecialityConfirmation'] ?? false,
// //     //     pendingDoctorType: safeString(map['pendingDoctorType']),
// //     //     pendingSpeciality: safeString(map['pendingSpeciality']),
// //     //     userId: safeString(map['userId']),
// //     //     userName: safeString(map['userName']) ?? 'Care Connect Bot',
// //     //     assignedDoctorId: safeString(map['assignedDoctorId']),
// //     //     assignedDoctorName: safeString(map['assignedDoctorName']),
// //     //     buttons: buttons, // Use the processed buttons
// //     //   );
// //     // }
// //
// //     factory Message.fromMap(Map<String, dynamic> map) {
// //       // Handle buttonClicked - only true if explicitly true in data
// //       final bool buttonClicked = map['buttonClicked'] == true;
// //
// //       int? amount;
// //       if (map['amount'] != null) {
// //         if (map['amount'] is int) {
// //           amount = map['amount'];
// //         } else if (map['amount'] is double) {
// //           amount = (map['amount'] as double).toInt();
// //         } else if (map['amount'] is String) {
// //           amount = int.tryParse(map['amount']);
// //         }
// //       }
// //
// //       String? safeString(String? value) {
// //         return (value == null || value.isEmpty) ? null : value;
// //       }
// //
// //       // IMPROVED: Better button handling with comprehensive fallback
// //       List<dynamic>? buttons;
// //       bool hasValidButtons = false;
// //
// //       if (map['buttons'] != null && map['buttons'] is List) {
// //         buttons = map['buttons'] as List;
// //         hasValidButtons = buttons.isNotEmpty;
// //         print('🔘 Processing ${buttons.length} buttons from backend');
// //       } else {
// //         print('⚠ No buttons or invalid buttons format from backend');
// //         buttons = [];
// //       }
// //
// //       // CRITICAL FIX: Create fallback buttons when showButtons is true but buttons are empty
// //       bool shouldShowButtons = false;
// //       final bool showButtonsFromBackend = map['showButtons'] == true;
// //
// //       if (showButtonsFromBackend && !buttonClicked) {
// //         if (hasValidButtons) {
// //           // Use backend buttons if available
// //           shouldShowButtons = true;
// //         } else {
// //           // Create comprehensive fallback buttons based on message context
// //           buttons = _createComprehensiveFallbackButtons(map);
// //           shouldShowButtons = buttons.isNotEmpty;
// //           print('🔄 Created ${buttons.length} comprehensive fallback buttons');
// //         }
// //       }
// //
// //       print('🎯 Button display decision:');
// //       print('   - showButtons from backend: $showButtonsFromBackend');
// //       print('   - hasValidButtons: $hasValidButtons');
// //       print('   - buttonClicked: $buttonClicked');
// //       print('   - shouldShowButtons: $shouldShowButtons');
// //
// //       return Message(
// //         id: map['_id'] ?? map['id'] ?? UniqueKey().toString(),
// //         text: map['text'] ?? "",
// //         isBot: map['isBot'] ?? false,
// //         showButtons: shouldShowButtons,
// //         buttonClicked: buttonClicked,
// //         createdAt: map['createdAt'] != null
// //             ? DateTime.tryParse(map['createdAt'].toString())
// //             : DateTime.now(),
// //         selectedDoctorType: safeString(map['selectedDoctorType']),
// //         selectedSpeciality: safeString(map['selectedSpeciality']),
// //         showPaymentButton: map['showPaymentButton'] ?? false,
// //         paymentCompleted: map['paymentCompleted'] ?? false,
// //         orderId: safeString(map['orderId']),
// //         paymentId: safeString(map['paymentId']),
// //         orderNumber: safeString(map['orderNumber']),
// //         amount: amount,
// //         showReportUploadQuestion: map['showReportUploadQuestion'] ?? false,
// //         reportUploadAnswered: map['reportUploadAnswered'] ?? false,
// //         wantsToUploadReport: map['wantsToUploadReport'] ?? false,
// //         showReportUploadButton: map['showReportUploadButton'] ?? false,
// //         reportUploaded: map['reportUploaded'] ?? false,
// //         reportFiles: map['reportFiles'] != null && map['reportFiles'] is List
// //             ? List<Map<String, dynamic>>.from(map['reportFiles'])
// //             : null,
// //         showDoctorTypeConfirmation: map['showDoctorTypeConfirmation'] ?? false,
// //         showSpecialityConfirmation: map['showSpecialityConfirmation'] ?? false,
// //         pendingDoctorType: safeString(map['pendingDoctorType']),
// //         pendingSpeciality: safeString(map['pendingSpeciality']),
// //         userId: safeString(map['userId']),
// //         userName: safeString(map['userName']) ?? 'Care Connect Bot',
// //         assignedDoctorId: safeString(map['assignedDoctorId']),
// //         assignedDoctorName: safeString(map['assignedDoctorName']),
// //         buttons: buttons,
// //       );
// //     }
// //
// // // ENHANCED: Create comprehensive fallback buttons based on message context
// //     static List<Map<String, dynamic>> _createComprehensiveFallbackButtons(Map<String, dynamic> map) {
// //       final text = (map['text']?.toString() ?? '').toLowerCase();
// //       final currentState = map['currentState']?.toString() ?? '';
// //
// //       print('🔍 Creating fallback buttons for:');
// //       print('   Text: $text');
// //       print('   Current State: $currentState');
// //       print('   Selected Doctor Type: ${map['selectedDoctorType']}');
// //       print('   Selected Speciality: ${map['selectedSpeciality']}');
// //       print('   Show Payment Button: ${map['showPaymentButton']}');
// //
// //       // Decision tree based on conversation flow
// //       if (text.contains('second opinion') || text.contains('would you like')) {
// //         return [
// //           {
// //             "text": "Yes, I would like a second opinion",
// //             "value": "second_opinion_yes",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "No, not right now",
// //             "value": "second_opinion_no",
// //             "type": "secondary"
// //           }
// //         ];
// //       }
// //       else if (text.contains('doctor type') || text.contains('type of doctor') ||
// //           currentState.contains('doctor_type')) {
// //         return [
// //           {
// //             "text": "Allopathy (Modern Medicine)",
// //             "value": "allopathy",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "Ayurvedic",
// //             "value": "ayurvedic",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "Homeopathy",
// //             "value": "homeopathy",
// //             "type": "primary"
// //           }
// //         ];
// //       }
// //       else if (text.contains('special') || text.contains('specialty') ||
// //           currentState.contains('speciality')) {
// //         return [
// //           {
// //             "text": "General Physician",
// //             "value": "general_physician",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "Cardiologist",
// //             "value": "cardiologist",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "Dermatologist",
// //             "value": "dermatologist",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "More Specialties...",
// //             "value": "more_specialties",
// //             "type": "secondary"
// //           }
// //         ];
// //       }
// //       else if (text.contains('upload') || text.contains('report') ||
// //           map['showReportUploadQuestion'] == true) {
// //         return [
// //           {
// //             "text": "Yes, upload medical reports",
// //             "value": "upload_yes",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "No, continue without reports",
// //             "value": "upload_no",
// //             "type": "secondary"
// //           }
// //         ];
// //       }
// //       else if (map['showPaymentButton'] == true) {
// //         final amount = map['amount'] ?? 500;
// //         return [
// //           {
// //             "text": "Pay ₹$amount Now",
// //             "value": "proceed_payment",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "Cancel",
// //             "value": "cancel_payment",
// //             "type": "secondary"
// //           }
// //         ];
// //       }
// //       else if (text.contains('confirm') || text.contains('proceed') ||
// //           map['showDoctorTypeConfirmation'] == true) {
// //         return [
// //           {
// //             "text": "Yes, Confirm",
// //             "value": "confirm_yes",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "No, Change",
// //             "value": "confirm_no",
// //             "type": "secondary"
// //           }
// //         ];
// //       }
// //
// //       // Default fallback for unknown states
// //       return [
// //         {
// //           "text": "Continue",
// //           "value": "continue",
// //           "type": "primary"
// //         },
// //         {
// //           "text": "Cancel",
// //           "value": "cancel",
// //           "type": "secondary"
// //         }
// //       ];
// //     }
// //     Map<String, dynamic> toMap() {
// //       return {
// //         'id': id,
// //         'text': text,
// //         'isBot': isBot,
// //         'showButtons': showButtons,
// //         'buttonClicked': buttonClicked,
// //         'createdAt': createdAt?.toIso8601String(),
// //         'selectedDoctorType': selectedDoctorType,
// //         'selectedSpeciality': selectedSpeciality,
// //         'showPaymentButton': showPaymentButton,
// //         'paymentCompleted': paymentCompleted,
// //         'orderId': orderId,
// //         'paymentId': paymentId,
// //         'orderNumber': orderNumber,
// //         'amount': amount,
// //         'showReportUploadQuestion': showReportUploadQuestion,
// //         'reportUploadAnswered': reportUploadAnswered,
// //         'wantsToUploadReport': wantsToUploadReport,
// //         'showReportUploadButton': showReportUploadButton,
// //         'reportUploaded': reportUploaded,
// //         'reportFiles': reportFiles,
// //         'showDoctorTypeConfirmation': showDoctorTypeConfirmation,
// //         'showSpecialityConfirmation': showSpecialityConfirmation,
// //         'pendingDoctorType': pendingDoctorType,
// //         'pendingSpeciality': pendingSpeciality,
// //         'userId': userId,
// //         'userName': userName,
// //         'assignedDoctorId': assignedDoctorId,
// //         'assignedDoctorName': assignedDoctorName,
// //         'buttons': buttons,
// //       };
// //     }
// //
// //     Message copyWith({
// //       String? id,
// //       String? text,
// //       bool? isBot,
// //       bool? showButtons,
// //       bool? buttonClicked,
// //       DateTime? createdAt,
// //       String? selectedDoctorType,
// //       String? selectedSpeciality,
// //       bool? showPaymentButton,
// //       bool? paymentCompleted,
// //       String? orderId,
// //       String? paymentId,
// //       String? orderNumber,
// //       int? amount,
// //       bool? showReportUploadQuestion,
// //       bool? reportUploadAnswered,
// //       bool? wantsToUploadReport,
// //       bool? showReportUploadButton,
// //       bool? reportUploaded,
// //       List<Map<String, dynamic>>? reportFiles,
// //       bool? showDoctorTypeConfirmation,
// //       bool? showSpecialityConfirmation,
// //       String? pendingDoctorType,
// //       String? pendingSpeciality,
// //       String? userId,
// //       String? userName,
// //       String? assignedDoctorId,
// //       String? assignedDoctorName,
// //       List<dynamic>? buttons,
// //     }) {
// //       return Message(
// //         id: id ?? this.id,
// //         text: text ?? this.text,
// //         isBot: isBot ?? this.isBot,
// //         showButtons: showButtons ?? this.showButtons,
// //         buttonClicked: buttonClicked ?? this.buttonClicked,
// //         createdAt: createdAt ?? this.createdAt,
// //         selectedDoctorType: selectedDoctorType ?? this.selectedDoctorType,
// //         selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
// //         showPaymentButton: showPaymentButton ?? this.showPaymentButton,
// //         paymentCompleted: paymentCompleted ?? this.paymentCompleted,
// //         orderId: orderId ?? this.orderId,
// //         paymentId: paymentId ?? this.paymentId,
// //         orderNumber: orderNumber ?? this.orderNumber,
// //         amount: amount ?? this.amount,
// //         showReportUploadQuestion: showReportUploadQuestion ?? this.showReportUploadQuestion,
// //         reportUploadAnswered: reportUploadAnswered ?? this.reportUploadAnswered,
// //         wantsToUploadReport: wantsToUploadReport ?? this.wantsToUploadReport,
// //         showReportUploadButton: showReportUploadButton ?? this.showReportUploadButton,
// //         reportUploaded: reportUploaded ?? this.reportUploaded,
// //         reportFiles: reportFiles ?? this.reportFiles,
// //         showDoctorTypeConfirmation: showDoctorTypeConfirmation ?? this.showDoctorTypeConfirmation,
// //         showSpecialityConfirmation: showSpecialityConfirmation ?? this.showSpecialityConfirmation,
// //         pendingDoctorType: pendingDoctorType ?? this.pendingDoctorType,
// //         pendingSpeciality: pendingSpeciality ?? this.pendingSpeciality,
// //         userId: userId ?? this.userId,
// //         userName: userName ?? this.userName,
// //         assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
// //         assignedDoctorName: assignedDoctorName ?? this.assignedDoctorName,
// //         buttons: buttons ?? this.buttons,
// //       );
// //     }
// //   }
// //
// //   class HomePage extends StatefulWidget {
// //     final String? orderId;
// //     final bool isExistingOrder;
// //
// //     const HomePage({
// //       super.key,
// //       this.orderId,
// //       this.isExistingOrder = false,
// //     });
// //
// //     @override
// //     State<HomePage> createState() => _HomePageState();
// //   }
// //
// //   class _HomePageState extends State<HomePage> {
// //     List<Message> messages = [];
// //     TextEditingController _controller = TextEditingController();
// //     String? userId;
// //     String? userName;
// //     String? userPhone;
// //     String? userEmail;
// //     bool loadingHistory = true;
// //     final ScrollController _scrollController = ScrollController();
// //     String? currentOrderId;
// //     bool paymentCompleted = false;
// //     bool reportUploadEnabled = false;
// //     bool hasUploadedReport = false;
// //     late Razorpay _razorpay;
// //     String? assignedDoctorName;
// //     String? assignedDoctorSpeciality;
// //
// //     // Conversation state managed by backend
// //     String _currentState = 'initial';
// //     Timer? _statusCheckTimer;
// //
// //     // Session end variables
// //     bool _isSessionEnded = false;
// //
// //     @override
// //     void initState() {
// //       super.initState();
// //       _razorpay = Razorpay();
// //       _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
// //       _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
// //       _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
// //       _loadUserId();
// //     }
// //
// //     @override
// //     void dispose() {
// //       _statusCheckTimer?.cancel();
// //       _razorpay.clear();
// //       _controller.dispose();
// //       _scrollController.dispose();
// //       super.dispose();
// //     }
// //
// //     // Load user ID and initialize conversation
// //     Future<void> _loadUserId() async {
// //       final prefs = await SharedPreferences.getInstance();
// //       final storedUserId = prefs.getString('userId');
// //       final storedUserName = prefs.getString('fullName') ?? 'User';
// //       final storedUserPhone = prefs.getString('phone') ?? '';
// //       final storedUserEmail = prefs.getString('email') ?? '';
// //
// //       if (storedUserId == null) {
// //         if (mounted) {
// //           Navigator.pushReplacementNamed(context, '/login');
// //         }
// //         return;
// //       }
// //
// //       setState(() {
// //         userId = storedUserId;
// //         userName = storedUserName;
// //         userPhone = storedUserPhone;
// //         userEmail = storedUserEmail;
// //         currentOrderId = widget.orderId;
// //       });
// //
// //       await _initializeConversation();
// //     }
// //
// //     // Initialize complete conversation from backend
// //     Future<void> _initializeConversation() async {
// //       try {
// //         print('🚀 Initializing complete conversation from backend...');
// //
// //         final response = await ChatService.initializeConversation(
// //           userId: userId!,
// //           userName: userName ?? 'User',
// //           userPhone: userPhone ?? '',
// //           userEmail: userEmail ?? '',
// //           orderId: currentOrderId,
// //         );
// //
// //         if (response['success'] == true) {
// //           final messagesData = response['data']['messages'] as List? ?? [];
// //           final currentState = response['data']['currentState'] ?? 'initial';
// //
// //           print('📥 Backend provided ${messagesData.length} messages');
// //           print('🔧 Current state: $currentState');
// //
// //           // If no messages from backend, create fallback
// //           if (messagesData.isEmpty) {
// //             print('⚠ No messages from backend, creating fallback');
// //             _createFallbackMessages();
// //             return;
// //           }
// //
// //           final initialMessages = messagesData.map((msg) => Message.fromMap(msg)).toList();
// //
// //           // Debug the parsed messages
// //           print('🔍 PARSED MESSAGES DEBUG:');
// //           for (int i = 0; i < initialMessages.length; i++) {
// //             final msg = initialMessages[i];
// //             print('Message $i: "${msg.text}"');
// //             print('  - isBot: ${msg.isBot}');
// //             print('  - showButtons: ${msg.showButtons}');
// //             print('  - buttonClicked: ${msg.buttonClicked}');
// //             print('  - buttons: ${msg.buttons}');
// //             print('  - buttons length: ${msg.buttons?.length ?? 0}');
// //             if (msg.buttons != null && msg.buttons!.isNotEmpty) {
// //               print('  - Button details:');
// //               for (var button in msg.buttons!) {
// //                 print('    * ${button}');
// //               }
// //             }
// //             print('---');
// //           }
// //
// //           setState(() {
// //             messages = initialMessages;
// //             _currentState = currentState;
// //             loadingHistory = false;
// //           });
// //
// //           // Set currentOrderId from messages
// //           for (var msg in initialMessages) {
// //             if (msg.orderId != null && msg.orderId!.isNotEmpty) {
// //               currentOrderId = msg.orderId;
// //               break;
// //             }
// //           }
// //
// //           // Check if session is ended
// //           _checkSessionStatus(initialMessages);
// //
// //           print('✅ Conversation initialized successfully');
// //           _scrollToBottom();
// //
// //           // Start order status listener if payment is completed
// //           if (_currentState == 'chat_active' && !_isSessionEnded) {
// //             _startOrderStatusListener();
// //           }
// //         } else {
// //           print('❌ Backend returned success: false - ${response['message']}');
// //           _createFallbackMessages();
// //         }
// //       } catch (e) {
// //         print('❌ Error initializing conversation: $e');
// //         setState(() {
// //           loadingHistory = false;
// //         });
// //         _createFallbackMessages();
// //       }
// //     }
// //
// //     // Check session status from messages
// //     void _checkSessionStatus(List<Message> messages) {
// //       for (var msg in messages.reversed) {
// //         if (msg.text.contains("Your consultation session has been completed by the doctor") ||
// //             msg.text.contains("Session completed") ||
// //             msg.text.contains("Starting a new chat session")) {
// //           setState(() {
// //             _isSessionEnded = true;
// //           });
// //           break;
// //         }
// //       }
// //     }
// //
// //     // Session end detection methods
// //     void _startOrderStatusListener() {
// //       if (currentOrderId == null) {
// //         print('❌ Cannot start order status listener: currentOrderId is null');
// //         return;
// //       }
// //
// //       if (_isSessionEnded) {
// //         print('❌ Cannot start order status listener: session already ended');
// //         return;
// //       }
// //
// //       print('🔍 Starting order status listener for: $currentOrderId');
// //
// //       // Cancel existing timer if any
// //       _statusCheckTimer?.cancel();
// //
// //       // Check immediately first
// //       _checkOrderStatus();
// //
// //       // Then check every 5 seconds
// //       _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
// //         print('⏰ Timer tick - checking order status...');
// //         _checkOrderStatus();
// //       });
// //     }
// //
// //     Future<void> _checkOrderStatus() async {
// //       if (currentOrderId == null || _isSessionEnded) {
// //         return;
// //       }
// //
// //       try {
// //         print('🔄 Checking order status for: $currentOrderId');
// //
// //         final response = await http.get(
// //           Uri.parse(ApiConfig.getOrderStatus(currentOrderId!)),
// //         );
// //
// //         if (response.statusCode == 200) {
// //           final data = jsonDecode(response.body);
// //           if (data['success'] == true) {
// //             final order = data['data'];
// //             final status = order['status']?.toString().toLowerCase();
// //
// //             print('📊 Current order status: $status');
// //
// //             if (status == 'completed') {
// //               print('🎯 Session ended by doctor, resetting chat...');
// //               _handleSessionEndedByDoctor();
// //             }
// //           }
// //         }
// //       } catch (e) {
// //         print('❌ Error checking order status: $e');
// //       }
// //     }
// //
// //     void _handleSessionEndedByDoctor() async {
// //       if (_isSessionEnded) return;
// //
// //       setState(() {
// //         _isSessionEnded = true;
// //       });
// //
// //       // Stop the timer
// //       _statusCheckTimer?.cancel();
// //
// //       try {
// //         print('🎯 Calling backend to complete order: $currentOrderId');
// //
// //         final response = await http.put(
// //           Uri.parse('${ApiConfig.baseUrl}/completeOrder/$currentOrderId'),
// //           headers: {"Content-Type": "application/json"},
// //           body: jsonEncode({
// //             "status": "completed",
// //             "completedBy": "Doctor",
// //             "resetChat": true
// //           }),
// //         );
// //
// //         if (response.statusCode == 200) {
// //           final data = jsonDecode(response.body);
// //           if (data['success'] == true) {
// //             print('✅ Order successfully completed on backend');
// //           } else {
// //             print('❌ Failed to complete order on backend: ${data['message']}');
// //           }
// //         } else {
// //           print('❌ Error completing order: ${response.statusCode}');
// //         }
// //       } catch (e) {
// //         print('❌ Error calling completeOrder API: $e');
// //       }
// //
// //       // Show session ended message
// //       final sessionEndedMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Your consultation session has been completed by the doctor. Thank you for using Care Connect! Starting a new chat session...",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //
// //       setState(() {
// //         messages.add(sessionEndedMsg);
// //       });
// //
// //       _scrollToBottom();
// //
// //       // Show notification
// //       Helpers.showSnackBar(
// //           context,
// //           "Session completed by doctor - Starting new chat",
// //           bgColor: Colors.orange
// //       );
// //
// //       // Wait 3 seconds then reset the chat
// //       await Future.delayed(const Duration(seconds: 3));
// //       _resetChatToBeginning();
// //     }
// //
// //     void _resetChatToBeginning() async {
// //       print('🔄 Resetting chat to beginning...');
// //
// //       try {
// //         // Store the completed order ID before clearing
// //         final completedOrderId = currentOrderId;
// //
// //         // Clear current state COMPLETELY
// //         setState(() {
// //           messages.clear();
// //           paymentCompleted = false;
// //           reportUploadEnabled = false;
// //           hasUploadedReport = false;
// //           assignedDoctorName = null;
// //           assignedDoctorSpeciality = null;
// //           currentOrderId = null; // This ensures new order will be created
// //           _isSessionEnded = false;
// //           _currentState = 'initial';
// //           _controller.clear();
// //         });
// //
// //         // Stop any existing timers
// //         _statusCheckTimer?.cancel();
// //
// //         print('✅ Local state cleared for order: $completedOrderId');
// //
// //         // Re-initialize a FRESH chat with new order
// //         await _initializeConversation();
// //
// //         print('✅ New chat session started successfully');
// //
// //         Helpers.showSnackBar(
// //           context,
// //           "New chat session started!",
// //           bgColor: Colors.green,
// //         );
// //
// //       } catch (e) {
// //         print('❌ Error resetting chat: $e');
// //         _createFallbackMessages();
// //       }
// //     }
// //
// //     void _createFallbackMessages() {
// //       final welcome = Message(
// //         id: UniqueKey().toString(),
// //         text: "Hello! Welcome to Care Connect. We provide professional doctor consultations from the comfort of your home.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //       final question = Message(
// //         id: UniqueKey().toString(),
// //         text: "Would you like to receive a second opinion from a specialist?",
// //         isBot: true,
// //         showButtons: true,
// //         buttonClicked: false,
// //         createdAt: DateTime.now(),
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //         buttons: [
// //           {
// //             "text": "Yes, I would like a second opinion",
// //             "value": "second_opinion_yes",
// //             "type": "primary"
// //           },
// //           {
// //             "text": "No, not right now",
// //             "value": "second_opinion_no",
// //             "type": "secondary"
// //           }
// //         ],
// //       );
// //
// //       setState(() {
// //         messages = [welcome, question];
// //         loadingHistory = false;
// //       });
// //
// //       print('📝 Using fallback local messages');
// //     }
// //
// //     // Progress conversation when user interacts - FIXED VERSION
// //     Future<void> _progressConversation(String buttonValue, {String? userMessage}) async {
// //       try {
// //         print('🔄 Progressing conversation with button: $buttonValue');
// //
// //         final response = await ChatService.progressConversation(
// //           userId: userId!,
// //           buttonValue: buttonValue,
// //           userMessage: userMessage,
// //           orderId: currentOrderId,
// //           currentState: _currentState,
// //         );
// //
// //         if (response['success'] == true) {
// //           final botMessagesData = response['data']['botMessages'] as List? ?? [];
// //           final newState = response['data']['currentState'] ?? _currentState;
// //           final orderId = response['data']['orderId'];
// //           final paymentData = response['data']['paymentData'];
// //
// //           print('📥 Received ${botMessagesData.length} bot messages');
// //           print('🔧 New state: $newState');
// //
// //           final botMessages = botMessagesData.map((msg) => Message.fromMap(msg)).toList();
// //
// //           // FIXED: Update ALL messages to ensure button states are correct
// //           setState(() {
// //             _currentState = newState;
// //             if (orderId != null) currentOrderId = orderId;
// //             messages.addAll(botMessages);
// //           });
// //
// //           _scrollToBottom();
// //
// //           // NEW: Handle payment data if present
// //           if (paymentData != null && paymentData['triggerPayment'] == true) {
// //             print('💰 Payment triggered by backend');
// //             await _openRazorpayCheckout(paymentData['razorpay']);
// //           }
// //
// //           // Start order status listener if chat becomes active
// //           if (newState == 'chat_active' && !_isSessionEnded) {
// //             _startOrderStatusListener();
// //           }
// //         }
// //       } catch (e) {
// //         print('❌ Error progressing conversation: $e');
// //         Helpers.showSnackBar(context, "Failed to process action", bgColor: Colors.red);
// //       }
// //     }
// //
// //     // Handle payment message from backend - FIXED VERSION
// //     void _handlePaymentMessage(Message paymentMsg) async {
// //       if (paymentCompleted) return;
// //
// //       print('💰 Processing payment message from backend');
// //
// //       try {
// //         // Get payment data from backend
// //         final response = await ChatService.initiatePayment(
// //           orderId: currentOrderId!,
// //           userId: userId!,
// //         );
// //
// //         if (response['success'] == true) {
// //           final paymentData = response['data']['razorpay'];
// //           final amount = paymentData['amount'] ~/ 100; // Convert from paise to rupees
// //           final orderId = paymentData['order_id'];
// //
// //           print('✅ Payment data received from backend');
// //           print('   Amount: ₹$amount');
// //           print('   Order ID: $orderId');
// //
// //           // Open Razorpay with backend data
// //           await _openRazorpayCheckout(paymentData);
// //         } else {
// //           Helpers.showSnackBar(context, "Failed to initialize payment", bgColor: Colors.red);
// //         }
// //       } catch (e) {
// //         print('❌ Error getting payment data: $e');
// //         Helpers.showSnackBar(context, "Payment initialization failed", bgColor: Colors.red);
// //       }
// //     }
// //
// //     // Open Razorpay checkout with backend data - FIXED VERSION
// //     Future<void> _openRazorpayCheckout(Map<String, dynamic> paymentData) async {
// //       try {
// //         var options = {
// //           'key': paymentData['key'], // Use key from backend
// //           'amount': paymentData['amount'], // Amount in paise
// //           'currency': paymentData['currency'] ?? 'INR',
// //           'name': paymentData['name'] ?? 'Care Connect',
// //           'description': paymentData['description'] ?? 'Medical Consultation',
// //           'order_id': paymentData['order_id'],
// //           'prefill': {
// //             'contact': userPhone ?? '9999999999',
// //             'email': userEmail ?? 'user@example.com',
// //             'name': userName ?? 'User',
// //           },
// //           'theme': {'color': '#00796B'},
// //           'retry': {'enabled': true, 'max_count': 1},
// //           'timeout': 300,
// //         };
// //
// //         print('💰 Opening Razorpay with options:');
// //         print('   Order ID: ${options['order_id']}');
// //         print('   Amount: ${options['amount']}');
// //         print('   Key: ${options['key']}');
// //
// //         _razorpay.open(options);
// //
// //       } catch (e) {
// //         debugPrint("❌ Error opening Razorpay: $e");
// //         Helpers.showSnackBar(context, "Error opening payment gateway", bgColor: Colors.red);
// //       }
// //     }
// //
// //     // User sends text message
// //     void _onUserSend(String text) async {
// //       if (text.trim().isEmpty) return;
// //       if (!paymentCompleted && _currentState != 'chat_active') {
// //         Helpers.showSnackBar(context, "Please complete the consultation setup first", bgColor: Colors.orange);
// //         return;
// //       }
// //       if (_isSessionEnded) {
// //         Helpers.showSnackBar(context, "Session completed - cannot send messages", bgColor: Colors.orange);
// //         return;
// //       }
// //
// //       final userMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: text,
// //         isBot: false,
// //         createdAt: DateTime.now(),
// //         userId: userId,
// //         userName: userName,
// //       );
// //
// //       setState(() {
// //         messages.add(userMsg);
// //       });
// //
// //       // Send to backend for processing
// //       await _sendUserMessage(text);
// //       _controller.clear();
// //       _scrollToBottom();
// //     }
// //
// //     // Send user message to backend
// //     Future<void> _sendUserMessage(String text) async {
// //       try {
// //         final response = await ChatService.sendUserMessage(
// //           userId: userId!,
// //           message: text,
// //           orderId: currentOrderId,
// //         );
// //
// //         if (response['success'] == true) {
// //           final botResponse = response['data']['botResponse'];
// //           if (botResponse != null) {
// //             final botMessage = Message.fromMap(botResponse);
// //             setState(() {
// //               messages.add(botMessage);
// //             });
// //             _scrollToBottom();
// //           }
// //         }
// //       } catch (e) {
// //         print('❌ Error sending user message: $e');
// //       }
// //     }
// //
// //     // Handle button press from UI
// //     void _onButtonPressed(String buttonValue, Message message) async {
// //       print('🔘 Button pressed: $buttonValue');
// //
// //       // Update the message to show button clicked
// //       final index = messages.indexWhere((m) => m.id == message.id);
// //       if (index != -1) {
// //         setState(() {
// //           messages[index] = message.copyWith(buttonClicked: true, showButtons: false);
// //         });
// //       }
// //
// //       // Progress conversation
// //       await _progressConversation(buttonValue);
// //     }
// //
// //     // Handle payment button
// //     void _onPaymentButtonPressed(Message paymentMsg) async {
// //       if (paymentCompleted) {
// //         Helpers.showSnackBar(context, "Payment already completed", bgColor: Colors.orange);
// //         return;
// //       }
// //
// //       final amount = paymentMsg.amount ?? 500;
// //       final doctorCategory = paymentMsg.selectedSpeciality ?? paymentMsg.selectedDoctorType ?? "General";
// //
// //       await createOrder(amount, doctorCategory);
// //     }
// //
// //     // Handle upload button
// //     void _onUploadButtonPressed(Message uploadMsg) async {
// //       if (currentOrderId == null) {
// //         Helpers.showSnackBar(context, "No active order found", bgColor: Colors.red);
// //         return;
// //       }
// //       if (_isSessionEnded) {
// //         Helpers.showSnackBar(context, "Session completed - cannot upload files", bgColor: Colors.orange);
// //         return;
// //       }
// //
// //       print('📤 Navigating to upload with orderId: $currentOrderId');
// //
// //       final result = await Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => UploadFiles(
// //           orderId: currentOrderId!,
// //           userId: userId!,
// //         )),
// //       );
// //
// //       if (result != null && result is Map<String, dynamic> && result['status'] == 'uploaded') {
// //         List<Map<String, dynamic>> uploadedReports = List<Map<String, dynamic>>.from(result['reports']);
// //
// //         final uploadSuccessMsg = Message(
// //           id: UniqueKey().toString(),
// //           text: "Medical reports uploaded successfully! ✅\nTotal files: ${uploadedReports.length}",
// //           isBot: true,
// //           createdAt: DateTime.now(),
// //           reportUploaded: true,
// //           reportFiles: uploadedReports,
// //           assignedDoctorName: assignedDoctorName,
// //           userId: userId,
// //           userName: 'Care Connect Bot',
// //         );
// //
// //         setState(() {
// //           messages.add(uploadSuccessMsg);
// //           hasUploadedReport = true;
// //         });
// //
// //         _scrollToBottom();
// //         Helpers.showSnackBar(context, "Reports uploaded successfully!", bgColor: AppColors.accent);
// //       }
// //     }
// //
// //     // Payment methods - FIXED VERSION
// //     Future<void> createOrder(int amount, String doctorCategory) async {
// //       try {
// //         if (userId == null) {
// //           Helpers.showSnackBar(context, "User ID not found! Please login again.");
// //           return;
// //         }
// //
// //         print('🔄 Creating order for: $doctorCategory, amount: ₹$amount');
// //
// //         var response = await http.post(
// //           Uri.parse(ApiConfig.orders),
// //           headers: {"Content-Type": "application/json"},
// //           body: jsonEncode({
// //             "UserId": userId,
// //             "userName": userName ?? 'User',
// //             "userPhone": userPhone ?? '',
// //             "userEmail": userEmail ?? '',
// //             "doctorType": _getDoctorTypeFromCategory(doctorCategory),
// //             "speciality": doctorCategory,
// //             "currency": "INR",
// //           }),
// //         );
// //
// //         print('📥 Order creation response: ${response.statusCode}');
// //         print('📥 Response body: ${response.body}');
// //
// //         if (response.statusCode == 200) {
// //           var data = jsonDecode(response.body);
// //
// //           if (data['success'] == true && data['data'] != null) {
// //             final orderData = data['data'];
// //
// //             // Store order ID
// //             setState(() {
// //               currentOrderId = orderData['orderId']?.toString();
// //             });
// //
// //             print('✅ Order created successfully: $currentOrderId');
// //
// //             // Now initiate payment with the created order
// //             await _initiatePaymentWithOrder();
// //
// //           } else {
// //             Helpers.showSnackBar(context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
// //           }
// //         } else {
// //           Helpers.showSnackBar(context, "Failed to create order. Status: ${response.statusCode}");
// //         }
// //       } catch (e) {
// //         print('❌ Order creation error: $e');
// //         Helpers.showSnackBar(context, "Network error: $e");
// //       }
// //     }
// //
// //     // Initiate payment after order creation - NEW METHOD
// //     Future<void> _initiatePaymentWithOrder() async {
// //       try {
// //         if (currentOrderId == null) {
// //           Helpers.showSnackBar(context, "No order ID available");
// //           return;
// //         }
// //
// //         print('💰 Initiating payment for order: $currentOrderId');
// //
// //         final response = await http.post(
// //           Uri.parse('${ApiConfig.baseUrl}/initiate-payment'),
// //           headers: {"Content-Type": "application/json"},
// //           body: jsonEncode({
// //             "orderId": currentOrderId,
// //             "userId": userId,
// //           }),
// //         );
// //
// //         print('📥 Payment initiation response: ${response.statusCode}');
// //         print('📥 Response body: ${response.body}');
// //
// //         if (response.statusCode == 200) {
// //           final data = jsonDecode(response.body);
// //
// //           if (data['success'] == true) {
// //             final paymentData = data['data']['razorpay'];
// //             print('✅ Payment initiated successfully');
// //
// //             // Open Razorpay with the payment data
// //             await _openRazorpayCheckout(paymentData);
// //           } else {
// //             Helpers.showSnackBar(context, "Payment initiation failed: ${data['message']}");
// //           }
// //         } else {
// //           Helpers.showSnackBar(context, "Payment initiation failed: ${response.statusCode}");
// //         }
// //       } catch (e) {
// //         print('❌ Payment initiation error: $e');
// //         Helpers.showSnackBar(context, "Payment initialization error");
// //       }
// //     }
// //
// //     String _getDoctorTypeFromCategory(String category) {
// //       if (category.toLowerCase().contains('ayurvedic')) return 'Ayurvedic';
// //       if (category.toLowerCase().contains('homeopathy')) return 'Homeopathy';
// //       return 'Allopathy'; // default
// //     }
// //
// //     void _handlePaymentSuccess(PaymentSuccessResponse response) async {
// //       try {
// //         print('✅ Payment successful:');
// //         print('   Order ID: ${response.orderId}');
// //         print('   Payment ID: ${response.paymentId}');
// //
// //         Helpers.showSnackBar(context, "Verifying payment...", bgColor: Colors.orange);
// //
// //         final verifyResponse = await http.post(
// //           Uri.parse('${ApiConfig.baseUrl}/verify-payment'),
// //           headers: {"Content-Type": "application/json"},
// //           body: jsonEncode({
// //             "razorpay_order_id": response.orderId,
// //             "razorpay_payment_id": response.paymentId,
// //             "razorpay_signature": response.signature,
// //             "userId": userId,
// //             "userName": userName,
// //             "userPhone": userPhone,
// //             "userEmail": userEmail,
// //             "orderId": currentOrderId,
// //             "amount": getAmountFromMessages() ?? 500,
// //           }),
// //         );
// //
// //         print('📥 Verification response: ${verifyResponse.statusCode}');
// //
// //         if (verifyResponse.statusCode == 200) {
// //           final verifyData = jsonDecode(verifyResponse.body);
// //           if (verifyData['success'] == true) {
// //             // Progress conversation to payment completed
// //             await _progressConversation('payment_completed');
// //
// //             setState(() {
// //               paymentCompleted = true;
// //             });
// //
// //             Helpers.showSnackBar(
// //                 context,
// //                 "Payment successful!",
// //                 bgColor: AppColors.accent
// //             );
// //
// //             // Start order status listener after successful payment
// //             _startOrderStatusListener();
// //           } else {
// //             Helpers.showSnackBar(
// //                 context,
// //                 "Payment verification failed: ${verifyData['message'] ?? 'Unknown error'}",
// //                 bgColor: Colors.red
// //             );
// //           }
// //         }
// //       } catch (e) {
// //         debugPrint("❌ Verification error: $e");
// //         Helpers.showSnackBar(context, "Payment verification error: $e", bgColor: Colors.red);
// //       }
// //     }
// //
// //     void _handlePaymentError(PaymentFailureResponse response) {
// //       final errorMsg = Message(
// //         id: UniqueKey().toString(),
// //         text: "Payment could not be completed. Please try again.",
// //         isBot: true,
// //         createdAt: DateTime.now(),
// //         userId: userId,
// //         userName: 'Care Connect Bot',
// //       );
// //       setState(() {
// //         messages.add(errorMsg);
// //       });
// //       Helpers.showSnackBar(context, "Payment failed: ${response.message}", bgColor: Colors.red);
// //     }
// //
// //     void _handleExternalWallet(ExternalWalletResponse response) {
// //       Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
// //     }
// //
// //     int? getAmountFromMessages() {
// //       for (int i = messages.length - 1; i >= 0; i--) {
// //         if (messages[i].amount != null) {
// //           return messages[i].amount;
// //         }
// //       }
// //       return null;
// //     }
// //
// //     Future<void> _openFile(String filePath, String fileName) async {
// //       try {
// //         final result = await OpenFilex.open(filePath);
// //         if (result.type == ResultType.done) {
// //           debugPrint("✅ File opened successfully: $fileName");
// //         } else if (result.type == ResultType.noAppToOpen) {
// //           Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
// //         } else if (result.type == ResultType.fileNotFound) {
// //           Helpers.showSnackBar(context, "File not found at: $filePath", bgColor: Colors.red);
// //         } else {
// //           Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
// //         }
// //       } catch (e) {
// //         debugPrint("❌ Error opening file: $e");
// //         Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
// //       }
// //     }
// //
// //     void _scrollToBottom() {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         if (_scrollController.hasClients) {
// //           _scrollController.animateTo(
// //             _scrollController.position.maxScrollExtent,
// //             duration: const Duration(milliseconds: 300),
// //             curve: Curves.easeOut,
// //           );
// //         }
// //       });
// //     }
// //
// //     // Drawer item helper
// //     Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
// //       return ListTile(
// //         leading: Icon(icon, size: 25, color: AppColors.iconColor),
// //         title: Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// //         ),
// //         onTap: onTap,
// //       );
// //     }
// //
// //     // Format file size
// //     String _formatFileSize(dynamic size) {
// //       if (size == null) return 'Unknown';
// //       final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
// //       if (bytes <= 0) return "0 B";
// //       const suffixes = ["B", "KB", "MB", "GB"];
// //       var i = (log(bytes) / log(1024)).floor();
// //       return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
// //     }
// //
// //     // Format message time
// //     String _formatMessageTime(DateTime dateTime) {
// //       final localTime = dateTime.toLocal();
// //       final hour = localTime.hour.toString().padLeft(2, '0');
// //       final minute = localTime.minute.toString().padLeft(2, '0');
// //       return '$hour:$minute';
// //     }
// //
// //     // Build intro card
// //     Widget buildIntroCard(BuildContext context) {
// //       return Container(
// //         margin: const EdgeInsets.all(14),
// //         padding: const EdgeInsets.all(18),
// //         decoration: BoxDecoration(
// //           color: AppColors.primary.withOpacity(0.08),
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: AppColors.primary, width: 1.2),
// //           boxShadow: [
// //             BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2)),
// //           ],
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(Icons.medical_services, color: AppColors.primary, size: 28),
// //                 const SizedBox(width: 10),
// //                 Text(
// //                   "Care Connect",
// //                   style: TextStyle(
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.bold,
// //                     color: AppColors.primary,
// //                     letterSpacing: 0.5,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             Text(
// //               "Get expert medical advice from the comfort of your home.\nOur experienced doctors are ready to help you confidently at every step.",
// //               style: TextStyle(fontSize: 15.5, color: Colors.grey[800]),
// //             ),
// //             const SizedBox(height: 16),
// //             Row(
// //               children: [
// //                 Icon(Icons.verified_user, color: AppColors.accent, size: 20),
// //                 const SizedBox(width: 5),
// //                 Text(
// //                   "Trusted | Secure | Confidential",
// //                   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.primary),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 18),
// //             Text(
// //               "How it works:",
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
// //             ),
// //             const SizedBox(height: 8),
// //             _buildStep(stepNumber: 1, icon: Icons.person_search, label: "Choose your doctor type and specialty"),
// //             const SizedBox(height: 5),
// //             _buildStep(stepNumber: 2, icon: Icons.payment, label: "Make a secure online payment"),
// //             const SizedBox(height: 5),
// //             _buildStep(stepNumber: 3, icon: Icons.message_outlined, label: "Upload reports, Chat & get advice"),
// //             const SizedBox(height: 18),
// //             GestureDetector(
// //               onTap: () => Navigator.pushNamed(context, '/help'),
// //               child: Text(
// //                 "Help & Support",
// //                 style: TextStyle(decoration: TextDecoration.underline, color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //
// //     Widget _buildStep({required int stepNumber, required IconData icon, required String label}) {
// //       return Row(
// //         children: [
// //           CircleAvatar(
// //             radius: 13,
// //             backgroundColor: AppColors.primary,
// //             child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
// //           ),
// //           const SizedBox(width: 8),
// //           Icon(icon, size: 18, color: AppColors.accent),
// //           const SizedBox(width: 7),
// //           Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, color: Colors.grey[800]))),
// //         ],
// //       );
// //     }
// //
// //     // UI Build methods
// //     Widget buildMessageBubble(Message msg) {
// //       final isUser = !msg.isBot;
// //
// //       // Debug each message
// //       print('🎯 BUILDING BUBBLE DEBUG:');
// //       print('   Text: "${msg.text.substring(0, min(30, msg.text.length))}..."');
// //       print('   showButtons: ${msg.showButtons}');
// //       print('   buttonClicked: ${msg.buttonClicked}');
// //       print('   buttons count: ${msg.buttons?.length ?? 0}');
// //       print('   Should display buttons: ${msg.showButtons && msg.buttons != null && msg.buttons!.isNotEmpty}');
// //
// //       return Align(
// //         alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
// //         child: Container(
// //           margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //           padding: const EdgeInsets.all(12),
// //           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
// //           decoration: BoxDecoration(
// //             color: isUser ? AppColors.chatUser : AppColors.chatBot,
// //             borderRadius: BorderRadius.only(
// //               topLeft: const Radius.circular(16),
// //               topRight: const Radius.circular(16),
// //               bottomLeft: isUser ? const Radius.circular(16) : Radius.circular(0),
// //               bottomRight: isUser ? Radius.circular(0) : const Radius.circular(16),
// //             ),
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 msg.text,
// //                 style: TextStyle(color: isUser ? AppColors.chatUserText : AppColors.chatBotText, fontSize: 15),
// //               ),
// //
// //               // Backend-managed buttons - FIXED VERSION
// //               if (msg.showButtons && msg.buttons != null && msg.buttons!.isNotEmpty)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: Wrap(
// //                     spacing: 8,
// //                     runSpacing: 8,
// //                     children: msg.buttons!.map((button) {
// //                       // Debug each button
// //                       print('   🛎 Rendering button: $button');
// //
// //                       final buttonData = button as Map<String, dynamic>;
// //                       final buttonText = buttonData['text']?.toString() ?? 'Button';
// //                       final buttonValue = buttonData['value']?.toString() ?? '';
// //                       final buttonType = buttonData['type']?.toString() ?? 'primary';
// //
// //                       return ElevatedButton(
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: buttonType == 'primary' ? AppColors.primary : Colors.grey[600],
// //                           foregroundColor: Colors.white,
// //                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                         ),
// //                         onPressed: () {
// //                           print('🔘 Button pressed: $buttonValue');
// //                           _onButtonPressed(buttonValue, msg);
// //                         },
// //                         child: Text(buttonText),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 ),
// //
// //               // Payment button from backend
// //               if (msg.showPaymentButton && !paymentCompleted)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.green[700],
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                     ),
// //                     onPressed: () => _onPaymentButtonPressed(msg),
// //                     icon: const Icon(Icons.payment),
// //                     label: Text("Pay ₹${msg.amount ?? 500}"),
// //                   ),
// //                 ),
// //
// //               // Upload button from backend
// //               if (msg.showReportUploadButton && !hasUploadedReport)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: AppColors.primary,
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                     ),
// //                     onPressed: () => _onUploadButtonPressed(msg),
// //                     icon: const Icon(Icons.upload_file),
// //                     label: const Text("Upload Medical Reports"),
// //                   ),
// //                 ),
// //
// //               // Doctor assignment info
// //               if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: Container(
// //                     padding: const EdgeInsets.all(8),
// //                     decoration: BoxDecoration(
// //                       color: Colors.green.shade50,
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(color: Colors.green.shade200),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Icon(Icons.medical_services, color: Colors.green.shade700, size: 16),
// //                         const SizedBox(width: 8),
// //                         Flexible(
// //                           child: Text(
// //                             "Assigned: Dr. ${msg.assignedDoctorName}",
// //                             style: TextStyle(
// //                               color: Colors.green.shade800,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //
// //               // File attachments
// //               if (msg.reportUploaded == true && msg.reportFiles != null && msg.reportFiles!.isNotEmpty)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 8.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: msg.reportFiles!.map((report) {
// //                       return GestureDetector(
// //                         onTap: () => _openFile(report['filePath'], report['fileName']),
// //                         child: Container(
// //                           margin: const EdgeInsets.only(bottom: 6),
// //                           padding: const EdgeInsets.all(8),
// //                           decoration: BoxDecoration(
// //                             color: Colors.blue.shade50,
// //                             borderRadius: BorderRadius.circular(8),
// //                             border: Border.all(color: Colors.blue.shade200),
// //                           ),
// //                           child: Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               Icon(Icons.file_present, color: Colors.blue.shade700, size: 20),
// //                               const SizedBox(width: 8),
// //                               Flexible(
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       report['category'] ?? 'Medical Report',
// //                                       style: TextStyle(
// //                                           color: Colors.blue.shade900,
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 12
// //                                       ),
// //                                     ),
// //                                     Text(
// //                                       report['fileName'] ?? "View File",
// //                                       style: TextStyle(
// //                                         color: Colors.blue.shade700,
// //                                         decoration: TextDecoration.underline,
// //                                         fontSize: 11,
// //                                       ),
// //                                       overflow: TextOverflow.ellipsis,
// //                                     ),
// //                                     if (report['fileSize'] != null)
// //                                       Text(
// //                                         "Size: ${_formatFileSize(report['fileSize'])}",
// //                                         style: TextStyle(
// //                                           color: Colors.grey.shade600,
// //                                           fontSize: 10,
// //                                         ),
// //                                       ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 ),
// //
// //               // Timestamp
// //               if (msg.createdAt != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 4.0),
// //                   child: Text(
// //                     _formatMessageTime(msg.createdAt!),
// //                     style: const TextStyle(fontSize: 10, color: Colors.grey),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     @override
// //     Widget build(BuildContext context) {
// //       if (loadingHistory || userId == null) {
// //         return const Scaffold(
// //           body: Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 CircularProgressIndicator(),
// //                 SizedBox(height: 16),
// //                 Text('Loading your conversation...'),
// //               ],
// //             ),
// //           ),
// //         );
// //       }
// //
// //       return Scaffold(
// //           appBar: AppBar(
// //             iconTheme: IconThemeData(color: AppColors.iconColor),
// //             backgroundColor: AppColors.primary,
// //             title: const Text(
// //               "Care Connect",
// //               style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             actions: [
// //               IconButton(
// //                 onPressed: _initializeConversation,
// //                 icon: Icon(Icons.refresh, color: AppColors.iconColor),
// //                 tooltip: "Refresh Chat",
// //               ),
// //               IconButton(
// //                 onPressed: () => Navigator.pushNamed(context, '/profile'),
// //                 icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor),
// //               ),
// //             ],
// //           ),
// //           drawer: Drawer(
// //             backgroundColor: AppColors.primary,
// //             child: SafeArea(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                 children: [
// //                   const SizedBox(height: 30),
// //                   Center(
// //                     child: Column(
// //                       children: const [
// //                         CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/logo.png"), backgroundColor: Colors.white),
// //                         SizedBox(height: 10),
// //                         Text("CareConnect", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
// //                         Text("info@CareConnect.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //                   Expanded(
// //                     child: ListView(
// //                       padding: EdgeInsets.zero,
// //                       children: [
// //                         drawerItem("Home", Icons.home, () => Navigator.pop(context)),
// //                         drawerItem("Doctors", Icons.medical_services, () => Navigator.pushNamed(context, '/doctors')),
// //                         drawerItem("Orders", Icons.file_copy_sharp, () => Navigator.pushNamed(context, '/orders')),
// //                         drawerItem("Terms & Privacy", Icons.privacy_tip, () => Navigator.pushNamed(context, '/terms')),
// //                         drawerItem("Help & Guide", Icons.help_outline, () => Navigator.pushNamed(context, '/help')),
// //                         drawerItem("Log Out", Icons.logout_sharp, () async {
// //                           bool? confirm = await showDialog<bool>(
// //                             context: context,
// //                             builder: (context) => AlertDialog(
// //                               title: const Text("Confirm Logout"),
// //                               content: const Text("Are you sure you want to logout?"),
// //                               actions: [
// //                                 TextButton(
// //                                     onPressed: () => Navigator.pop(context, false),
// //                                     child: const Text("Cancel")
// //                                 ),
// //                                 TextButton(
// //                                     onPressed: () => Navigator.pop(context, true),
// //                                     child: const Text("Logout")
// //                                 ),
// //                               ],
// //                             ),
// //                           );
// //
// //                           if (confirm == true && mounted) {
// //                             try {
// //                               final prefs = await SharedPreferences.getInstance();
// //                               final token = prefs.getString('token');
// //
// //                               print('🔐 Attempting logout...');
// //                               print('📱 Token available: ${token != null}');
// //
// //                               if (token != null) {
// //                                 final url = Uri.parse("${ApiConfig.baseUrl}/logout");
// //                                 print('📤 Calling logout API: $url');
// //
// //                                 final response = await http.post(
// //                                   url,
// //                                   headers: {
// //                                     'Content-Type': 'application/json',
// //                                     'Authorization': 'Bearer $token',
// //                                   },
// //                                 );
// //
// //                                 print('📥 Logout API Response Status: ${response.statusCode}');
// //                                 print('📥 Logout API Response Body: ${response.body}');
// //
// //                                 if (response.statusCode == 200) {
// //                                   final responseData = jsonDecode(response.body);
// //                                   if (responseData['success'] == true) {
// //                                     print('✅ Logout API successful');
// //                                   } else {
// //                                     print('⚠ Logout API returned success: false');
// //                                   }
// //                                 } else {
// //                                   print('❌ Logout API failed with status: ${response.statusCode}');
// //                                 }
// //                               } else {
// //                                 print('⚠ No token found, proceeding with local logout');
// //                               }
// //
// //                               await prefs.clear();
// //                               print('✅ Local storage cleared');
// //
// //                               if (mounted) {
// //                                 Navigator.pushNamedAndRemoveUntil(
// //                                   context,
// //                                   '/login',
// //                                       (route) => false,
// //                                 );
// //                               }
// //
// //                               Helpers.showSnackBar(
// //                                   context,
// //                                   "Logged out successfully",
// //                                   bgColor: Colors.green
// //                               );
// //
// //                             } catch (e) {
// //                               print('❌ Logout error: $e');
// //
// //                               final prefs = await SharedPreferences.getInstance();
// //                               await prefs.clear();
// //
// //                               if (mounted) {
// //                                 Navigator.pushNamedAndRemoveUntil(
// //                                   context,
// //                                   '/login',
// //                                       (route) => false,
// //                                 );
// //                               }
// //
// //                               Helpers.showSnackBar(
// //                                   context,
// //                                   "Logged out successfully",
// //                                   bgColor: Colors.green
// //                               );
// //                             }
// //                           }
// //                         }),
// //                       ],
// //                     ),
// //                   ),
// //                   Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
// //                   const Padding(
// //                     padding: EdgeInsets.symmetric(vertical: 80),
// //                     child: Center(
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Text("Made With", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
// //                           SizedBox(width: 5),
// //                           Icon(Icons.favorite, color: AppColors.textLight, size: 14),
// //                           SizedBox(width: 5),
// //                           Text("By VSGLogic", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           body: Column(
// //           children: [
// //           // Show intro card when there are no messages or it's initial state
// //           if (messages.isEmpty || _currentState == 'initial')
// //       buildIntroCard(context),
// //
// //       Expanded(
// //       child: ListView.builder(
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       controller: _scrollController,
// //       itemCount: messages.length,
// //       itemBuilder: (context, index) {
// //       final msg = messages[index];
// //       return buildMessageBubble(msg);
// //       },
// //       ),
// //       ),
// //
// //       // Session ended banner
// //       if (_isSessionEnded)
// //       Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(12),
// //       color: Colors.orange.shade100,
// //       child: Row(
// //       children: [
// //       Icon(Icons.info, color: Colors.orange.shade800),
// //       const SizedBox(width: 8),
// //       Expanded(
// //       child: Text(
// //       "Session completed by doctor. Starting new chat...",
// //       style: TextStyle(
// //       color: Colors.orange.shade800,
// //       fontWeight: FontWeight.bold,
// //       fontSize: 12,
// //       ),
// //       ),
// //       ),
// //       ],
// //       ),
// //       ),
// //
// //       // ========== UPDATED BOTTOM CHAT SECTION ==========
// //       SafeArea(
// //       child: Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //       color: AppColors.primary,
// //       child: Column(
// //       children: [
// //       if (_isSessionEnded)
// //       Container(
// //       width: double.infinity,
// //       margin: const EdgeInsets.only(bottom: 8),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //       color: Colors.orange.shade100,
// //       borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Row(
// //       children: [
// //       Icon(Icons.info, color: Colors.orange.shade800),
// //       const SizedBox(width: 8),
// //       Expanded(
// //       child: Text(
// //       "Session completed by doctor. Starting new chat...",
// //       style: TextStyle(
// //       color: Colors.orange.shade800,
// //       fontWeight: FontWeight.bold,
// //       fontSize: 12,
// //       ),
// //       ),
// //       ),
// //       ],
// //       ),
// //       ),
// //
// //       Row(
// //       children: [
// //       // Upload file button
// //       GestureDetector(
// //       onTap: paymentCompleted &&
// //       !hasUploadedReport &&
// //       !_isSessionEnded
// //       ? () => _onUploadButtonPressed(messages.isNotEmpty ? messages.last : Message(
// //       id: UniqueKey().toString(),
// //       text: "Upload files",
// //       isBot: true,
// //       ))
// //           : null,
// //       child: Icon(
// //       Icons.attach_file,
// //       color: paymentCompleted &&
// //       !hasUploadedReport &&
// //       !_isSessionEnded
// //       ? AppColors.iconColor
// //           : Colors.grey.shade600,
// //       size: 28,
// //       ),
// //       ),
// //       const SizedBox(width: 8),
// //       Expanded(
// //       child: Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(
// //       color: paymentCompleted && !_isSessionEnded ? Colors.white : Colors.grey.shade300,
// //       borderRadius: BorderRadius.circular(21),
// //       ),
// //       child: TextField(
// //       controller: _controller,
// //       enabled: paymentCompleted && !_isSessionEnded,
// //       keyboardType: TextInputType.multiline,
// //       textInputAction: TextInputAction.newline,
// //       minLines: 1,
// //       maxLines: 4,
// //       decoration: InputDecoration.collapsed(
// //       hintText: _isSessionEnded
// //       ? "Session completed - Starting new chat..."
// //           : paymentCompleted
// //       ? "Type your message here"
// //           : "Complete payment to chat",
// //       ),
// //       onChanged: (text) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
// //       },
// //       ),
// //       ),
// //       ),
// //       const SizedBox(width: 8),
// //       GestureDetector(
// //       onTap: paymentCompleted && !_isSessionEnded
// //       ? () {
// //       if (_controller.text.trim().isNotEmpty) {
// //       _onUserSend(_controller.text.trim());
// //       _controller.clear();
// //       }
// //       }
// //           : null,
// //       child: Icon(
// //       Icons.send,
// //       color: paymentCompleted && !_isSessionEnded ? AppColors.iconColor : Colors.grey
// //       ),
// //       ),
// //       ],
// //       ),
// //       ],
// //       ),
// //       ),
// //       ),
// //           ],
// //           ),
// //       );
// //     }
// //   }







import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'helper.dart';
import 'package:intl/intl.dart';
import 'upload_files.dart';
import 'package:open_filex/open_filex.dart';
import 'services/chat_service.dart';
import 'dart:async';
import 'dart:math';

String formatDate(DateTime date) {
  final now = DateTime.now();
  if (isSameDay(date, now)) {
    return "Today";
  }
  return DateFormat.yMMMMd().format(date);
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _formatFileSize(dynamic size) {
  if (size == null) return 'Unknown';
  final bytes = size is int ? size : int.tryParse(size.toString()) ?? 0;
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
}

String _formatMessageTime(DateTime dateTime) {
  final localTime = dateTime.toLocal();
  final hour = localTime.hour.toString().padLeft(2, '0');
  final minute = localTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class Message {
  final String id;
  final String text;
  final bool isBot;
  final bool showButtons;
  final bool buttonClicked;
  final DateTime? createdAt;
  final String? selectedDoctorType;
  final String? selectedSpeciality;
  final bool showPaymentButton;
  final bool paymentCompleted;
  final String? orderId;
  final String? paymentId;
  final String? orderNumber;
  final int? amount;
  final bool showReportUploadQuestion;
  final bool reportUploadAnswered;
  final bool wantsToUploadReport;
  final bool showReportUploadButton;
  final bool reportUploaded;
  final List<Map<String, dynamic>>? reportFiles;
  final bool showDoctorTypeConfirmation;
  final bool showSpecialityConfirmation;
  final String? pendingDoctorType;
  final String? pendingSpeciality;
  final String? userId;
  final String? userName;
  final String? assignedDoctorId;
  final String? assignedDoctorName;
  final bool hasUploadPermission;

  Message({
    required this.id,
    required this.text,
    required this.isBot,
    this.showButtons = false,
    this.buttonClicked = false,
    this.createdAt,
    this.selectedDoctorType,
    this.selectedSpeciality,
    this.showPaymentButton = false,
    this.paymentCompleted = false,
    this.orderId,
    this.paymentId,
    this.orderNumber,
    this.amount,
    this.showReportUploadQuestion = false,
    this.reportUploadAnswered = false,
    this.wantsToUploadReport = false,
    this.showReportUploadButton = false,
    this.reportUploaded = false,
    this.reportFiles,
    this.showDoctorTypeConfirmation = false,
    this.showSpecialityConfirmation = false,
    this.pendingDoctorType,
    this.pendingSpeciality,
    this.userId,
    this.userName,
    this.assignedDoctorId,
    this.assignedDoctorName,
    this.hasUploadPermission = false,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    final bool buttonClicked = map['buttonClicked'] == true;
    final bool showButtonsRaw = map['showButtons'] == true;

    int? amount;
    if (map['amount'] != null) {
      if (map['amount'] is int) {
        amount = map['amount'];
      } else if (map['amount'] is double) {
        amount = (map['amount'] as double).toInt();
      } else if (map['amount'] is String) {
        amount = int.tryParse(map['amount']);
      }
    }

    String? safeString(String? value) {
      return (value == null || value.isEmpty) ? null : value;
    }

    return Message(
      id: map['_id'] ?? map['id'] ?? UniqueKey().toString(),
      text: map['text'] ?? "",
      isBot: map['isBot'] ?? false,
      showButtons: showButtonsRaw && !buttonClicked,
      buttonClicked: buttonClicked,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : DateTime.now(),
      selectedDoctorType: safeString(map['selectedDoctorType']),
      selectedSpeciality: safeString(map['selectedSpeciality']),
      showPaymentButton: map['showPaymentButton'] ?? false,
      paymentCompleted: map['paymentCompleted'] ?? false,
      orderId: safeString(map['orderId']),
      paymentId: safeString(map['paymentId']),
      orderNumber: safeString(map['orderNumber']),
      amount: amount,
      showReportUploadQuestion: map['showReportUploadQuestion'] ?? false,
      reportUploadAnswered: map['reportUploadAnswered'] ?? false,
      wantsToUploadReport: map['wantsToUploadReport'] ?? false,
      showReportUploadButton: map['showReportUploadButton'] ?? false,
      reportUploaded: map['reportUploaded'] ?? false,
      reportFiles: map['reportFiles'] != null && map['reportFiles'] is List
          ? List<Map<String, dynamic>>.from(map['reportFiles'])
          : null,
      showDoctorTypeConfirmation: map['showDoctorTypeConfirmation'] ?? false,
      showSpecialityConfirmation: map['showSpecialityConfirmation'] ?? false,
      pendingDoctorType: safeString(map['pendingDoctorType']),
      pendingSpeciality: safeString(map['pendingSpeciality']),
      userId: safeString(map['userId']),
      userName: safeString(map['userName']) ?? 'Care Connect Bot',
      assignedDoctorId: safeString(map['assignedDoctorId']),
      assignedDoctorName: safeString(map['assignedDoctorName']),
      hasUploadPermission: map['hasUploadPermission'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isBot': isBot,
      'showButtons': showButtons,
      'buttonClicked': buttonClicked,
      'createdAt': createdAt?.toIso8601String(),
      'selectedDoctorType': selectedDoctorType,
      'selectedSpeciality': selectedSpeciality,
      'showPaymentButton': showPaymentButton,
      'paymentCompleted': paymentCompleted,
      'orderId': orderId,
      'paymentId': paymentId,
      'orderNumber': orderNumber,
      'amount': amount,
      'showReportUploadQuestion': showReportUploadQuestion,
      'reportUploadAnswered': reportUploadAnswered,
      'wantsToUploadReport': wantsToUploadReport,
      'showReportUploadButton': showReportUploadButton,
      'reportUploaded': reportUploaded,
      'reportFiles': reportFiles,
      'showDoctorTypeConfirmation': showDoctorTypeConfirmation,
      'showSpecialityConfirmation': showSpecialityConfirmation,
      'pendingDoctorType': pendingDoctorType,
      'pendingSpeciality': pendingSpeciality,
      'userId': userId,
      'userName': userName,
      'assignedDoctorId': assignedDoctorId,
      'assignedDoctorName': assignedDoctorName,
      'hasUploadPermission': hasUploadPermission,
    };
  }

  Message copyWith({
    String? id,
    String? text,
    bool? isBot,
    bool? showButtons,
    bool? buttonClicked,
    DateTime? createdAt,
    String? selectedDoctorType,
    String? selectedSpeciality,
    bool? showPaymentButton,
    bool? paymentCompleted,
    String? orderId,
    String? paymentId,
    String? orderNumber,
    int? amount,
    bool? showReportUploadQuestion,
    bool? reportUploadAnswered,
    bool? wantsToUploadReport,
    bool? showReportUploadButton,
    bool? reportUploaded,
    List<Map<String, dynamic>>? reportFiles,
    bool? showDoctorTypeConfirmation,
    bool? showSpecialityConfirmation,
    String? pendingDoctorType,
    String? pendingSpeciality,
    String? userId,
    String? userName,
    String? assignedDoctorId,
    String? assignedDoctorName,
    bool? hasUploadPermission,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isBot: isBot ?? this.isBot,
      showButtons: showButtons ?? this.showButtons,
      buttonClicked: buttonClicked ?? this.buttonClicked,
      createdAt: createdAt ?? this.createdAt,
      selectedDoctorType: selectedDoctorType ?? this.selectedDoctorType,
      selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
      showPaymentButton: showPaymentButton ?? this.showPaymentButton,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
      orderId: orderId ?? this.orderId,
      paymentId: paymentId ?? this.paymentId,
      orderNumber: orderNumber ?? this.orderNumber,
      amount: amount ?? this.amount,
      showReportUploadQuestion: showReportUploadQuestion ?? this.showReportUploadQuestion,
      reportUploadAnswered: reportUploadAnswered ?? this.reportUploadAnswered,
      wantsToUploadReport: wantsToUploadReport ?? this.wantsToUploadReport,
      showReportUploadButton: showReportUploadButton ?? this.showReportUploadButton,
      reportUploaded: reportUploaded ?? this.reportUploaded,
      reportFiles: reportFiles ?? this.reportFiles,
      showDoctorTypeConfirmation: showDoctorTypeConfirmation ?? this.showDoctorTypeConfirmation,
      showSpecialityConfirmation: showSpecialityConfirmation ?? this.showSpecialityConfirmation,
      pendingDoctorType: pendingDoctorType ?? this.pendingDoctorType,
      pendingSpeciality: pendingSpeciality ?? this.pendingSpeciality,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
      assignedDoctorName: assignedDoctorName ?? this.assignedDoctorName,
      hasUploadPermission: hasUploadPermission ?? this.hasUploadPermission,
    );
  }
}

class HomePage extends StatefulWidget {
  final String? orderId;
  final bool isExistingOrder;

  const HomePage({
    super.key,
    this.orderId,
    this.isExistingOrder = false,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Message> messages = [];
  TextEditingController _controller = TextEditingController();
  String? userId;
  String? userName;
  String? userPhone;
  String? userEmail;
  bool loadingHistory = true;
  final ScrollController _scrollController = ScrollController();
  String? currentDoctorType;
  String? currentSpeciality;
  String? currentOrderId;
  bool paymentCompleted = false;
  bool reportUploadEnabled = false;
  bool hasUploadedReport = false;
  late Razorpay _razorpay;
  String? assignedDoctorName;
  String? assignedDoctorSpeciality;

  bool _hasUploadPermission = false;
  bool _checkingUploadPermission = false;

  bool _isSessionEnded = false;
  Timer? _statusCheckTimer;
  Timer? _uploadPermissionTimer;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadUserId();
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    _uploadPermissionTimer?.cancel();
    _razorpay.clear();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _showTermsAndConditionsPopup() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Terms & Conditions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "By proceeding with payment, you agree to our terms and conditions:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                _buildSimpleTerm("Consultation fees are non-refundable once the service has been provided"),
                _buildSimpleTerm("All medical information shared is kept strictly confidential"),
                _buildSimpleTerm("For emergency medical situations, please visit the nearest hospital immediately"),
                _buildSimpleTerm("Doctors reserve the right to recommend in-person consultation if needed"),
                _buildSimpleTerm("Uploaded medical reports become part of your medical record"),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/terms'),
                  child: Text(
                    "View Full Terms & Conditions",
                    style: TextStyle(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text("I Accept & Proceed"),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Widget _buildSimpleTerm(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkUploadPermission() async {
    if (userId == null || currentOrderId == null) {
      print('❌ Cannot check upload permission: missing userId or orderId');
      return;
    }

    if (_checkingUploadPermission) return;
    if (_hasUploadPermission) {
      print('ℹ Upload permission already granted, skipping check');
      return;
    }

    try {
      setState(() {
        _checkingUploadPermission = true;
      });

      print('🔄 Checking upload permission for user: $userId');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/doctor/get-report-permission/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('📥 Upload permission response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final canSendReports = data['data']['canSendReports'] ?? false;

          print('✅ Upload permission status: $canSendReports');

          // Only proceed if permission was granted and we haven't shown the message yet
          if (canSendReports && paymentCompleted && !_hasUploadPermission) {
            setState(() {
              _hasUploadPermission = true;
            });

            _showUploadPermissionGrantedMessage();

            // Stop the timer since permission has been granted
            _uploadPermissionTimer?.cancel();
            _uploadPermissionTimer = null;
            print('🛑 Stopped upload permission timer - permission granted');
          }
        } else {
          print('⚠ Upload permission API returned success: false');
        }
      } else if (response.statusCode == 404) {
        print('🔍 Upload permission endpoint not found or user not in permission system');
        // This is normal for new sessions - don't show error
      } else {
        print('❌ Upload permission check failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error checking upload permission: $e');
      // Don't crash the app on permission check errors
    } finally {
      setState(() {
        _checkingUploadPermission = false;
      });
    }
  }

  void _startUploadPermissionListener() {
    if (currentOrderId == null || userId == null) {
      print('❌ Cannot start upload permission listener: missing orderId or userId');
      return;
    }

    // Don't start if permission is already granted
    if (_hasUploadPermission) {
      print('ℹ Upload permission already granted, no need for listener');
      return;
    }

    // Don't start if session has ended
    if (_isSessionEnded) {
      print('ℹ Session ended, not starting upload permission listener');
      return;
    }

    print('🔍 Starting upload permission listener for user: $userId');

    _uploadPermissionTimer?.cancel();

    // Check immediately
    _checkUploadPermission();

    // Check every 10 seconds, but stop once permission is granted
    _uploadPermissionTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      print('⏰ Checking upload permission...');

      // Stop timer if permission is granted
      if (_hasUploadPermission) {
        timer.cancel();
        print('🛑 Upload permission timer stopped - permission granted');
        return;
      }

      // Stop timer if session ended
      if (_isSessionEnded) {
        timer.cancel();
        print('🛑 Upload permission timer stopped - session ended');
        return;
      }

      _checkUploadPermission();
    });
  }

  void _showUploadPermissionGrantedMessage() {
    bool alreadyShown = messages.any((msg) =>
    msg.text.contains("Upload Access Granted") &&
        msg.hasUploadPermission == true);

    if (alreadyShown) {
      print('ℹ Upload permission message already shown');
      return;
    }

    final uploadPermissionMsg = Message(
      id: UniqueKey().toString(),
      text: "📎 Upload Access Granted!\n\nThe doctor has granted you permission to upload additional medical reports. Click the upload button below to add more files.",
      isBot: true,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      hasUploadPermission: true,
      showReportUploadButton: true, // SHOW UPLOAD BUTTON IN CHAT
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages.add(uploadPermissionMsg);
      reportUploadEnabled = true;
    });

    _scrollToBottom();

    Helpers.showSnackBar(
      context,
      "Upload access granted! You can now upload additional reports",
      bgColor: Colors.green,
    );
  }

  void _startOrderStatusListener() {
    if (currentOrderId == null) {
      print('❌ Cannot start order status listener: currentOrderId is null');
      return;
    }

    if (_isSessionEnded) {
      print('❌ Cannot start order status listener: session already ended');
      return;
    }

    print('🔍 Starting order status listener for: $currentOrderId');

    _statusCheckTimer?.cancel();

    _checkOrderStatus();

    _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('⏰ Timer tick - checking order status...');
      _checkOrderStatus();
    });

    _startUploadPermissionListener();
  }

  Future<void> _checkOrderStatus() async {
    if (currentOrderId == null || _isSessionEnded) {
      return;
    }

    try {
      print('🔄 Checking order status for: $currentOrderId');

      final response = await http.get(
        Uri.parse(ApiConfig.getOrderStatus(currentOrderId!)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final order = data['data'];
          final status = order['status']?.toString().toLowerCase();

          print('📊 Current order status: $status');

          if (status == 'completed') {
            print('🎯 Session ended by doctor, resetting chat...');
            _handleSessionEndedByDoctor();
          }
        }
      }
    } catch (e) {
      print('❌ Error checking order status: $e');
    }
  }

  void _handleSessionEndedByDoctor() async {
    if (_isSessionEnded) return;

    setState(() {
      _isSessionEnded = true;
    });

    _statusCheckTimer?.cancel();
    _uploadPermissionTimer?.cancel();

    try {
      print('🎯 Calling backend to complete order: $currentOrderId');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/completeOrder/$currentOrderId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "status": "completed",
          "completedBy": "Doctor",
          "resetChat": true
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          print('✅ Order successfully completed on backend');
        } else {
          print('❌ Failed to complete order on backend: ${data['message']}');
        }
      } else {
        print('❌ Error completing order: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error calling completeOrder API: $e');
    }

    final sessionEndedMsg = Message(
      id: UniqueKey().toString(),
      text: "Your consultation session has been completed by the doctor. Thank you for using Care Connect! Starting a new chat session...",
      isBot: true,
      createdAt: DateTime.now(),
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages.add(sessionEndedMsg);
    });

    _scrollToBottom();

    Helpers.showSnackBar(
        context,
        "Session completed by doctor - Starting new chat",
        bgColor: Colors.orange
    );

    await Future.delayed(const Duration(seconds: 3));
    _resetChatToBeginning();
  }

  void _resetChatToBeginning() async {
    print('🔄 Resetting chat to beginning...');

    try {
      final completedOrderId = currentOrderId;

      setState(() {
        messages.clear();
        currentDoctorType = null;
        currentSpeciality = null;
        paymentCompleted = false;
        reportUploadEnabled = false;
        hasUploadedReport = false;
        assignedDoctorName = null;
        assignedDoctorSpeciality = null;
        currentOrderId = null;
        _isSessionEnded = false;
        _hasUploadPermission = false; // Reset upload permission for new session
        _controller.clear();
      });

      _statusCheckTimer?.cancel();
      _uploadPermissionTimer?.cancel();

      print('✅ Local state cleared for order: $completedOrderId');

      await _initializeNewChat();

      print('✅ New chat session started successfully');

      Helpers.showSnackBar(
        context,
        "New chat session started!",
        bgColor: Colors.green,
      );

    } catch (e) {
      print('❌ Error resetting chat: $e');
      _createFallbackMessages();
    }
  }

  bool _isOrderCompleted(List messagesData) {
    if (messagesData.isEmpty) return false;

    for (var msg in messagesData) {
      if (msg['text'] != null) {
        String text = msg['text'].toString();

        if (text.contains("Your consultation session has been completed by the doctor") &&
            text.contains("Starting a new chat session")) {
          print('🎯 Found explicit session end message - session is completed');
          return true;
        }
      }
    }

    print('💬 No explicit session end found - preserving chat');
    return false;
  }

  bool _isChatTrulyCompleted(List messagesData) {
    if (messagesData.isEmpty) return false;

    bool hasPaymentCompletion = false;
    bool hasActiveChatPrompt = false;
    bool hasSessionEndMessage = false;

    final recentMessages = messagesData.length > 5
        ? messagesData.sublist(messagesData.length - 5)
        : messagesData;

    for (var msg in recentMessages.reversed) {
      if (msg['text'] != null) {
        String text = msg['text'].toString().toLowerCase();

        if (text.contains("payment successful") ||
            text.contains("payment completed")) {
          hasPaymentCompletion = true;
        }

        if (text.contains("how can we help") ||
            text.contains("start chatting") ||
            text.contains("upload reports") ||
            text.contains("assigned to your case")) {
          hasActiveChatPrompt = true;
        }

        if (text.contains("session completed") ||
            text.contains("thank you for using Care Connect") ||
            text.contains("starting new chat")) {
          hasSessionEndMessage = true;
        }
      }

      if (msg['paymentCompleted'] == true) {
        hasPaymentCompletion = true;
      }
    }

    if (hasSessionEndMessage) {
      return true;
    }

    if (hasPaymentCompletion && !hasActiveChatPrompt) {
      return _isFreshPaymentWithoutChat(messagesData);
    }

    return false;
  }

  bool _isFreshPaymentWithoutChat(List messagesData) {
    int paymentCompletionIndex = -1;

    for (int i = messagesData.length - 1; i >= 0; i--) {
      if (messagesData[i]['paymentCompleted'] == true ||
          (messagesData[i]['text'] != null &&
              messagesData[i]['text'].toString().toLowerCase().contains("payment successful"))) {
        paymentCompletionIndex = i;
        break;
      }
    }

    if (paymentCompletionIndex == -1) return false;

    for (int i = paymentCompletionIndex + 1; i < messagesData.length; i++) {
      var msg = messagesData[i];

      if (msg['isBot'] == false && msg['text'] != null && msg['text'].toString().trim().isNotEmpty) {
        return false;
      }

      if (msg['isBot'] == true && msg['text'] != null) {
        String text = msg['text'].toString().toLowerCase();
        if (text.contains("how can we help") ||
            text.contains("start chatting") ||
            text.contains("upload reports")) {
          return false;
        }
      }
    }

    return true;
  }

  Future<int?> getDynamicConsultationFee(String doctorType, String speciality) async {
    try {
      print('🔄 Getting dynamic fee for: $doctorType - $speciality');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/consultation-fee?doctorType=$doctorType&speciality=${Uri.encodeComponent(speciality)}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final estimatedFee = data['data']['estimatedFee'] as int;
          print('💰 Dynamic fee received: ₹$estimatedFee');
          return estimatedFee;
        }
      }

      print('⚠ Using fallback fee');
      const fallbackPricing = {
        'Allopathy': 500,
        'Ayurvedic': 300,
        'Homeopathy': 200
      };
      return fallbackPricing[doctorType] ?? 300;
    } catch (e) {
      print('❌ Error getting dynamic fee: $e');
      const fallbackPricing = {
        'Allopathy': 500,
        'Ayurvedic': 300,
        'Homeopathy': 200
      };
      return fallbackPricing[doctorType] ?? 300;
    }
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('userId');
    final storedUserName = prefs.getString('fullName') ?? 'User';
    final storedUserPhone = prefs.getString('phone') ?? '';
    final storedUserEmail = prefs.getString('email') ?? '';

    if (storedUserId == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    setState(() {
      userId = storedUserId;
      userName = storedUserName;
      userPhone = storedUserPhone;
      userEmail = storedUserEmail;

      if (widget.isExistingOrder && widget.orderId != null) {
        currentOrderId = widget.orderId;
        print('🔄 Loading existing order: ${widget.orderId}');
      }
    });

    await _loadChatHistoryOrInitialize();
  }

  Future<void> _loadChatHistoryOrInitialize() async {
    if (userId == null) {
      print('❌ User ID is null');
      return;
    }

    try {
      print('🔄 Loading chat history from backend...');

      String url = "${ApiConfig.chatHistory}?userId=$userId";

      if (widget.isExistingOrder && currentOrderId != null && currentOrderId!.isNotEmpty) {
        url += "&orderId=$currentOrderId";
        print('📝 Loading existing order: $currentOrderId');
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List messagesData = decoded['data']['messages'] as List? ?? [];

        if (messagesData.isEmpty) {
          print('📂 No messages found, initializing new chat...');
          await _initializeNewChat();
          return;
        }

        print('📥 Loaded ${messagesData.length} messages from backend');

        final loadedMessages = messagesData.map((msg) {
          try {
            return Message.fromMap(msg);
          } catch (e) {
            print('❌ Error parsing message: $e - $msg');
            return Message(
              id: UniqueKey().toString(),
              text: msg['text']?.toString() ?? 'Error loading message',
              isBot: msg['isBot'] ?? false,
              createdAt: DateTime.now(),
              userId: userId,
              userName: msg['userName']?.toString() ?? 'Unknown',
            );
          }
        }).toList();

        bool restoredPaymentCompleted = false;
        bool restoredReportUploadEnabled = false;
        bool restoredHasUploadedReport = false;
        String? restoredAssignedDoctorName;
        String? restoredCurrentDoctorType;
        String? restoredCurrentSpeciality;
        String? restoredCurrentOrderId;
        bool restoredIsSessionEnded = false;
        bool restoredHasUploadPermission = false;

        for (var msg in loadedMessages) {
          if (msg.selectedDoctorType != null && msg.selectedDoctorType!.isNotEmpty) {
            restoredCurrentDoctorType = msg.selectedDoctorType;
          }
          if (msg.selectedSpeciality != null && msg.selectedSpeciality!.isNotEmpty) {
            restoredCurrentSpeciality = msg.selectedSpeciality;
          }
          if (msg.orderId != null && msg.orderId!.isNotEmpty) {
            restoredCurrentOrderId = msg.orderId;
          }
          if (msg.paymentCompleted == true) {
            restoredPaymentCompleted = true;
            print('💰 Found payment completed message');
          }
          if (msg.wantsToUploadReport == true) {
            restoredReportUploadEnabled = true;
            print('📤 Found wants to upload report message');
          }
          if (msg.reportUploaded == true) {
            restoredHasUploadedReport = true;
            print('✅ Found report uploaded message');
          }
          if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty) {
            restoredAssignedDoctorName = msg.assignedDoctorName;
          }
          if (msg.hasUploadPermission == true) {
            restoredHasUploadPermission = true;
            print('🔓 Found upload permission in message');
          }

          if (msg.text.contains("Your consultation session has been completed by the doctor") &&
              msg.text.contains("Starting a new chat session")) {
            restoredIsSessionEnded = true;
            print('🔍 Found session end message in history');
          }
        }

        if (restoredPaymentCompleted && !restoredReportUploadEnabled) {
          for (var msg in loadedMessages.reversed) {
            if (msg.showReportUploadQuestion || msg.reportUploadAnswered) {
              restoredReportUploadEnabled = true;
              print('🔄 Detected report upload flow from messages');
              break;
            }
          }
        }

        if (restoredPaymentCompleted && !restoredHasUploadedReport) {
          bool userDeclinedUpload = false;
          for (var msg in loadedMessages) {
            if (msg.isBot == false && msg.text.toLowerCase().contains("no, i don't need to upload reports")) {
              userDeclinedUpload = true;
              break;
            }
          }

          if (!userDeclinedUpload) {
            restoredReportUploadEnabled = true;
            print('🔧 Auto-enabling upload for paid session');
          }
        }

        setState(() {
          messages = loadedMessages;
          currentDoctorType = restoredCurrentDoctorType;
          currentSpeciality = restoredCurrentSpeciality;
          currentOrderId = restoredCurrentOrderId;
          paymentCompleted = restoredPaymentCompleted;
          reportUploadEnabled = restoredReportUploadEnabled;
          hasUploadedReport = restoredHasUploadedReport;
          assignedDoctorName = restoredAssignedDoctorName;
          _isSessionEnded = restoredIsSessionEnded;
          _hasUploadPermission = restoredHasUploadPermission;
          loadingHistory = false;
        });

        print('🔄 State restored from chat history:');
        print('   - Messages: ${messages.length}');
        print('   - paymentCompleted: $paymentCompleted');
        print('   - reportUploadEnabled: $reportUploadEnabled');
        print('   - hasUploadedReport: $hasUploadedReport');
        print('   - currentOrderId: $currentOrderId');
        print('   - isSessionEnded: $_isSessionEnded');
        print('   - hasUploadPermission: $_hasUploadPermission');

        if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
          print('🔍 Starting order status listener for active session');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startOrderStatusListener();
          });
        }

        if (paymentCompleted && currentOrderId != null && !_isSessionEnded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkUploadPermission();
          });
        }

      } else {
        print('❌ HTTP error: ${response.statusCode}');
        await _initializeNewChat();
      }
    } catch (e) {
      print('❌ Error loading chat history: $e');
      await _initializeNewChat();
    }

    _scrollToBottom();
  }

  Future<void> _initializeNewChat() async {
    try {
      print('🔄 Initializing new chat...');

      final response = await ChatService.initializeChat(
        userId: userId!,
        userName: userName ?? 'User',
        userPhone: userPhone,
        userEmail: userEmail,
        orderId: currentOrderId,
      );

      if (response['success'] == true) {
        final messagesData = response['data']['messages'] as List? ?? [];
        print('📥 Initialized with ${messagesData.length} messages');

        final initialMessages = messagesData.map((msg) => Message.fromMap(msg)).toList();

        setState(() {
          messages = initialMessages;
          loadingHistory = false;
        });

        if (initialMessages.isNotEmpty && initialMessages.first.orderId != null) {
          currentOrderId = initialMessages.first.orderId;
          print('📝 Set currentOrderId: $currentOrderId');
        }
      } else {
        throw Exception('Backend returned success: false');
      }
    } catch (e) {
      print('❌ Error initializing chat: $e');
      _createFallbackMessages();
    }
  }

  void _createFallbackMessages() {
    final welcome = Message(
      id: UniqueKey().toString(),
      text: "Welcome to Care Connect. We provide professional doctor consultations from the comfort of your home.",
      isBot: true,
      createdAt: DateTime.now(),
      userId: userId,
      userName: 'Care Connect Bot',
    );
    final question = Message(
      id: UniqueKey().toString(),
      text: "Do you want to continue?",
      isBot: true,
      showButtons: true,
      buttonClicked: false,
      createdAt: DateTime.now(),
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages = [welcome, question];
      loadingHistory = false;
    });

    print('📝 Using fallback local messages');
  }

  Future<void> sendMessage(Message message) async {
    try {
      await _sendMessageToBackend(message);
    } catch (e) {
      print("Error sending message to backend: $e");
    }
  }

  Future<void> _sendMessageToBackend(Message message) async {
    if (userId == null) {
      print('❌ Cannot send message: User ID is null');
      return;
    }

    try {
      print('🔄 Sending message to backend: ${message.text}');

      final response = await ChatService.sendMessage(
        userId: userId!,
        message: message.text,
        userName: userName ?? 'User',
        userPhone: userPhone,
        userEmail: userEmail,
        doctorType: message.selectedDoctorType ?? currentDoctorType ?? '',
        speciality: message.selectedSpeciality ?? currentSpeciality ?? '',
        orderId: message.orderId ?? currentOrderId ?? '',
        paymentCompleted: message.paymentCompleted || paymentCompleted,
      );

      print('✅ Message sent to backend successfully');

      if (!message.isBot && paymentCompleted && response['success'] == true) {
        final botResponse = response['data']['botResponse'];
        if (botResponse != null) {
          print('🤖 Received bot response');
          final botMessage = Message.fromMap(botResponse);
          setState(() {
            messages.add(botMessage);
          });
          _scrollToBottom();
        } else {
          print('ℹ No bot response received');
        }
      }
    } catch (e) {
      print('❌ Failed to send message to backend: $e');
    }
  }

  void _onUserSend(String text) async {
    if (text.trim().isEmpty) return;
    if (!paymentCompleted) {
      Helpers.showSnackBar(context, "Please complete payment before sending messages", bgColor: Colors.red);
      return;
    }
    if (_isSessionEnded) {
      Helpers.showSnackBar(context, "Session completed - cannot send messages", bgColor: Colors.orange);
      return;
    }

    final userMsg = Message(
      id: UniqueKey().toString(),
      text: text,
      isBot: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      userId: userId,
      userName: userName,
    );

    setState(() {
      messages.add(userMsg);
    });

    await sendMessage(userMsg);
    _controller.clear();
    _scrollToBottom();
  }

  void _onYesButtonPressed(Message questionMsg) async {
    final index = messages.indexWhere((m) => m.id == questionMsg.id);
    if (index == -1) return;

    final updatedMsg = questionMsg.copyWith(showButtons: false, buttonClicked: true);
    final userResponse = Message(
      id: UniqueKey().toString(),
      text: "Yes, I would like a second opinion.",
      isBot: false,
      createdAt: DateTime.now(),
      userId: userId,
      userName: userName,
    );
    final doctorTypeQuestion = Message(
      id: UniqueKey().toString(),
      text: "Please select your preferred doctor type:",
      isBot: true,
      showButtons: true,
      buttonClicked: false,
      createdAt: DateTime.now(),
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages[index] = updatedMsg;
      messages.add(userResponse);
      messages.add(doctorTypeQuestion);
    });

    await sendMessage(updatedMsg);
    await sendMessage(userResponse);
    await sendMessage(doctorTypeQuestion);
    _scrollToBottom();
  }

  void _onDoctorTypeSelected(Message questionMsg, String doctorType) async {
    final index = messages.indexWhere((m) => m.id == questionMsg.id);
    if (index == -1) return;

    final updatedMsg = questionMsg.copyWith(
      showButtons: false,
      buttonClicked: true,
      pendingDoctorType: doctorType,
    );
    final confirmationMsg = Message(
      id: UniqueKey().toString(),
      text: "You selected $doctorType. Would you like to confirm this selection?",
      isBot: true,
      showButtons: true,
      buttonClicked: false,
      createdAt: DateTime.now(),
      showDoctorTypeConfirmation: true,
      pendingDoctorType: doctorType,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages[index] = updatedMsg;
      messages.add(confirmationMsg);
    });
    await sendMessage(updatedMsg);
    await sendMessage(confirmationMsg);
    _scrollToBottom();
  }

  void _onDoctorTypeConfirmYes(Message confirmMsg) async {
    final index = messages.indexWhere((m) => m.id == confirmMsg.id);
    if (index == -1) return;

    final doctorType = confirmMsg.pendingDoctorType!;
    final updatedMsg = confirmMsg.copyWith(
      showButtons: false,
      buttonClicked: true,
      selectedDoctorType: doctorType,
    );
    final userResponse = Message(
      id: UniqueKey().toString(),
      text: "Yes, confirmed $doctorType",
      isBot: false,
      createdAt: DateTime.now(),
      selectedDoctorType: doctorType,
      userId: userId,
      userName: userName,
    );

    setState(() {
      currentDoctorType = doctorType;
      messages[index] = updatedMsg;
      messages.add(userResponse);
    });
    await sendMessage(updatedMsg);
    await sendMessage(userResponse);

    if (doctorType == 'Allopathy') {
      await _loadSpecializations(doctorType);
    } else {
      final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
      final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;

      final paymentMsg = Message(
        id: UniqueKey().toString(),
        text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
        isBot: true,
        createdAt: DateTime.now(),
        selectedDoctorType: doctorType,
        selectedSpeciality: defaultSpeciality,
        showPaymentButton: true,
        amount: amount,
        userId: userId,
        userName: 'Care Connect Bot',
      );
      setState(() {
        currentSpeciality = defaultSpeciality;
        messages.add(paymentMsg);
      });
      await sendMessage(paymentMsg);
    }
    _scrollToBottom();
  }

  Future<void> _loadSpecializations(String doctorType) async {
    try {
      print('🔄 Loading specializations for $doctorType...');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/patients/doctors/specializations/$doctorType'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final specializations = List<String>.from(data['data']['specializations']);

          if (specializations.isNotEmpty) {
            final specialityQuestion = Message(
              id: UniqueKey().toString(),
              text: "Please select your doctor's speciality:",
              isBot: true,
              showButtons: true,
              buttonClicked: false,
              createdAt: DateTime.now(),
              selectedDoctorType: doctorType,
              userId: userId,
              userName: 'Care Connect Bot',
            );

            setState(() {
              messages.add(specialityQuestion);
            });
            await sendMessage(specialityQuestion);
          } else {
            _proceedToPayment(doctorType);
          }
        }
      } else {
        throw Exception('Failed to load specializations');
      }
    } catch (e) {
      print('❌ Error loading specializations: $e');
      if (doctorType == 'Allopathy') {
        _showDefaultSpecializations(doctorType);
      } else {
        _proceedToPayment(doctorType);
      }
    }
  }

  void _showDefaultSpecializations(String doctorType) {
    List<String> specializations = [];

    if (doctorType == 'Allopathy') {
      specializations = ['MBBS', 'MD', 'Cardiologist', 'Dermatologist', 'Orthopedic', 'Pediatrician', 'Gynecologist', 'Neurologist', 'Psychiatrist'];
    }

    if (specializations.isNotEmpty) {
      final specialityQuestion = Message(
        id: UniqueKey().toString(),
        text: "Please select your doctor's speciality:",
        isBot: true,
        showButtons: true,
        buttonClicked: false,
        createdAt: DateTime.now(),
        selectedDoctorType: doctorType,
        userId: userId,
        userName: 'Care Connect Bot',
      );

      setState(() {
        messages.add(specialityQuestion);
      });
    } else {
      _proceedToPayment(doctorType);
    }
  }

  void _proceedToPayment(String doctorType) async {
    final defaultSpeciality = doctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
    final amount = await getDynamicConsultationFee(doctorType, defaultSpeciality) ?? 300;

    final paymentMsg = Message(
      id: UniqueKey().toString(),
      text: "Great! You've selected $doctorType. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
      isBot: true,
      createdAt: DateTime.now(),
      selectedDoctorType: doctorType,
      selectedSpeciality: defaultSpeciality,
      showPaymentButton: true,
      amount: amount,
      userId: userId,
      userName: 'Care Connect Bot',
    );
    setState(() {
      currentSpeciality = defaultSpeciality;
      messages.add(paymentMsg);
    });
    sendMessage(paymentMsg);
  }

  void _onDoctorTypeConfirmNo(Message confirmMsg) async {
    final index = messages.indexWhere((m) => m.id == confirmMsg.id);
    if (index == -1) return;

    final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
    final userResponse = Message(
      id: UniqueKey().toString(),
      text: "No, let me choose again",
      isBot: false,
      createdAt: DateTime.now(),
      userId: userId,
      userName: userName,
    );
    final doctorTypeQuestion = Message(
      id: UniqueKey().toString(),
      text: "Please select your preferred doctor type:",
      isBot: true,
      showButtons: true,
      buttonClicked: false,
      createdAt: DateTime.now(),
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages[index] = updatedMsg;
      messages.add(userResponse);
      messages.add(doctorTypeQuestion);
    });
    await sendMessage(updatedMsg);
    await sendMessage(userResponse);
    await sendMessage(doctorTypeQuestion);
    _scrollToBottom();
  }

  void _onSpecialitySelected(Message questionMsg, String speciality) async {
    final index = messages.indexWhere((m) => m.id == questionMsg.id);
    if (index == -1) return;

    final updatedMsg = questionMsg.copyWith(
      showButtons: false,
      buttonClicked: true,
      pendingSpeciality: speciality,
    );
    final confirmationMsg = Message(
      id: UniqueKey().toString(),
      text: "You selected $speciality. Would you like to confirm this speciality?",
      isBot: true,
      showButtons: true,
      buttonClicked: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      showSpecialityConfirmation: true,
      pendingSpeciality: speciality,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages[index] = updatedMsg;
      messages.add(confirmationMsg);
    });
    await sendMessage(updatedMsg);
    await sendMessage(confirmationMsg);
    _scrollToBottom();
  }

  void _onSpecialityConfirmYes(Message confirmMsg) async {
    final index = messages.indexWhere((m) => m.id == confirmMsg.id);
    if (index == -1) return;

    final speciality = confirmMsg.pendingSpeciality!;
    final updatedMsg = confirmMsg.copyWith(
      showButtons: false,
      buttonClicked: true,
      selectedSpeciality: speciality,
    );
    final userResponse = Message(
      id: UniqueKey().toString(),
      text: "Yes, confirmed $speciality",
      isBot: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: speciality,
      userId: userId,
      userName: userName,
    );

    final amount = await getDynamicConsultationFee(currentDoctorType!, speciality) ?? 500;

    final paymentMsg = Message(
      id: UniqueKey().toString(),
      text: "Excellent! You've selected $speciality specialist. Consultation fee: ₹$amount. Please proceed with payment to start your consultation.",
      isBot: true,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: speciality,
      showPaymentButton: true,
      amount: amount,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      currentSpeciality = speciality;
      messages[index] = updatedMsg;
      messages.add(userResponse);
      messages.add(paymentMsg);
    });
    await sendMessage(updatedMsg);
    await sendMessage(userResponse);
    await sendMessage(paymentMsg);
    _scrollToBottom();
  }

  void _onSpecialityConfirmNo(Message confirmMsg) async {
    final index = messages.indexWhere((m) => m.id == confirmMsg.id);
    if (index == -1) return;

    final updatedMsg = confirmMsg.copyWith(showButtons: false, buttonClicked: true);
    final userResponse = Message(
      id: UniqueKey().toString(),
      text: "No, let me choose again",
      isBot: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      userId: userId,
      userName: userName,
    );
    final specialityQuestion = Message(
      id: UniqueKey().toString(),
      text: "Please select your doctor's speciality:",
      isBot: true,
      showButtons: true,
      buttonClicked: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages[index] = updatedMsg;
      messages.add(userResponse);
      messages.add(specialityQuestion);
    });
    await sendMessage(updatedMsg);
    await sendMessage(userResponse);
    await sendMessage(specialityQuestion);
    _scrollToBottom();
  }

  Future<void> _onPaymentButtonPressed(Message paymentMsg) async {
    final index = messages.indexWhere((m) => m.id == paymentMsg.id);
    if (index == -1) return;
    if (paymentCompleted) {
      Helpers.showSnackBar(context, "Payment already completed", bgColor: Colors.orange);
      return;
    }

    final acceptedTerms = await _showTermsAndConditionsPopup();
    if (!acceptedTerms) {
      Helpers.showSnackBar(context, "Please accept terms and conditions to proceed with payment", bgColor: Colors.orange);
      return;
    }

    final updatedPaymentMsg = paymentMsg.copyWith(buttonClicked: true, showPaymentButton: true);
    final userPaymentMsg = Message(
      id: UniqueKey().toString(),
      text: "Proceeding to payment...",
      isBot: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      userId: userId,
      userName: userName,
    );

    setState(() {
      messages[index] = updatedPaymentMsg;
      messages.add(userPaymentMsg);
    });
    await sendMessage(updatedPaymentMsg);
    await sendMessage(userPaymentMsg);
    _scrollToBottom();

    String doctorCategory = currentSpeciality ?? currentDoctorType ?? "General";
    int amount = paymentMsg.amount ?? 500;
    createOrder(amount, doctorCategory);
  }

  Future<void> createOrder(int amount, String doctorCategory) async {
    try {
      if (userId == null) {
        Helpers.showSnackBar(context, "User ID not found! Please login again.");
        return;
      }

      if (currentDoctorType == null || currentDoctorType!.isEmpty) {
        Helpers.showSnackBar(context, "Please select a doctor type first");
        return;
      }

      String finalSpeciality = currentSpeciality ?? '';
      if ((currentDoctorType == 'Ayurvedic' || currentDoctorType == 'Homeopathy') &&
          (finalSpeciality.isEmpty)) {
        finalSpeciality = currentDoctorType == 'Ayurvedic' ? 'General Ayurveda' : 'General Homeopathy';
        setState(() {
          currentSpeciality = finalSpeciality;
        });
        print('🔄 Set default speciality for ${currentDoctorType}: $finalSpeciality');
      }

      if (finalSpeciality.isEmpty) {
        Helpers.showSnackBar(context, "Please select a speciality first");
        return;
      }

      print('🔄 Creating order for doctor: $currentDoctorType, speciality: $finalSpeciality');
      print('🔍 Sending data:');
      print('   - UserId: $userId');
      print('   - userName: $userName');
      print('   - doctorType: $currentDoctorType');
      print('   - speciality: $finalSpeciality');

      var response = await http.post(
        Uri.parse(ApiConfig.orders),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "UserId": userId,
          "userName": userName ?? 'User',
          "userPhone": userPhone ?? '',
          "userEmail": userEmail ?? '',
          "doctorType": currentDoctorType,
          "speciality": finalSpeciality,
          "currency": "INR",
        }),
      );

      print('📥 Order creation response: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          String? orderId;
          String? razorpayOrderId;
          int? actualAmount;

          if (data['data']['orderId'] != null) {
            orderId = data['data']['orderId'].toString();
          } else if (data['data']['id'] != null) {
            orderId = data['data']['id'].toString();
          }

          if (data['data']['razorpayOrderId'] != null) {
            razorpayOrderId = data['data']['razorpayOrderId'].toString();
          } else if (data['data']['order_id'] != null) {
            razorpayOrderId = data['data']['order_id'].toString();
          }

          if (data['data']['amount'] != null) {
            actualAmount = data['data']['amount'] is int
                ? data['data']['amount']
                : (data['data']['amount'] as double).toInt();
            print('💰 Backend calculated amount: ₹$actualAmount');
          }

          if (orderId != null) {
            setState(() {
              currentOrderId = orderId;
            });

            String finalRazorpayOrderId = razorpayOrderId ?? orderId;

            print('✅ Order created successfully: $currentOrderId');
            print('🔑 Razorpay Order ID: $finalRazorpayOrderId');
            print('💰 Amount to pay: ₹$actualAmount');

            _updatePaymentMessageWithActualAmount(actualAmount ?? amount);

            openCheckout(actualAmount ?? amount, doctorCategory, finalRazorpayOrderId);
          } else {
            Helpers.showSnackBar(context, "Order created but no order ID returned");
          }
        } else {
          Helpers.showSnackBar(context, "Order creation failed: ${data['message'] ?? 'Unknown error'}");
        }
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body);
        Helpers.showSnackBar(context, "Validation error: ${data['message'] ?? 'Check your inputs'}");
      } else {
        Helpers.showSnackBar(context, "Doctor Not Available.....");
      }
    } catch (e) {
      print('❌ Order creation error: $e');
      Helpers.showSnackBar(context, "Network error: $e");
    }
  }

  void _updatePaymentMessageWithActualAmount(int actualAmount) {
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].showPaymentButton && !messages[i].paymentCompleted) {
        setState(() {
          messages[i] = messages[i].copyWith(
            amount: actualAmount,
            text: "Great! You've selected ${currentDoctorType} - ${currentSpeciality}. Consultation fee: ₹$actualAmount. Please proceed with payment to start your consultation.",
          );
        });
        break;
      }
    }
  }

  Future<void> openCheckout(int amount, String doctorCategory, String razorpayOrderId) async {
    var options = {
      'key': 'rzp_test_vDQGr1D5EBRubo',
      'amount': amount * 100,
      'name': 'Care Connect',
      'description': 'Consultation Fee - $doctorCategory',
      'order_id': razorpayOrderId,
      'prefill': {
        'contact': userPhone ?? '9999999999',
        'email': userEmail ?? 'user@example.com',
        'name': userName ?? 'User',
      },
      'theme': {'color': '#00796B'},
      'retry': {'enabled': true, 'max_count': 1},
      'timeout': 300,
    };

    try {
      print('💰 Opening Razorpay checkout with options: $options');
      _razorpay.open(options);
    } catch (e) {
      debugPrint("❌ Error opening Razorpay: $e");
      Helpers.showSnackBar(context, "Error opening payment gateway: $e");
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      print('✅ Payment successful:');
      print('   Order ID: ${response.orderId}');
      print('   Payment ID: ${response.paymentId}');
      print('   Signature: ${response.signature}');

      Helpers.showSnackBar(context, "Verifying payment...", bgColor: Colors.orange);

      var verifyResponse = await http.post(
        Uri.parse(ApiConfig.verifyPayment),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "razorpay_order_id": response.orderId,
          "razorpay_payment_id": response.paymentId,
          "razorpay_signature": response.signature,
          "userId": userId,
          "userName": userName,
          "userPhone": userPhone,
          "userEmail": userEmail,
          "orderId": currentOrderId,
          "doctorType": currentDoctorType,
          "speciality": currentSpeciality,
          "amount": getAmountFromMessages() ?? 500,
        }),
      );

      print('📥 Verification response: ${verifyResponse.statusCode}');
      print('📥 Verification body: ${verifyResponse.body}');

      var verifyData = jsonDecode(verifyResponse.body);

      if (verifyData['success'] == true) {
        await _handleSuccessfulPayment(response, verifyData);
      } else {
        Helpers.showSnackBar(
            context,
            "Payment verification failed: ${verifyData['message'] ?? 'Unknown error'}",
            bgColor: Colors.red
        );
      }
    } catch (e) {
      debugPrint("❌ Verification error: $e");
      Helpers.showSnackBar(context, "Payment verification error: $e", bgColor: Colors.red);
    }
  }

  int? getAmountFromMessages() {
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].amount != null) {
        return messages[i].amount;
      }
    }
    return null;
  }

  Future<void> _handleSuccessfulPayment(PaymentSuccessResponse response, Map<String, dynamic> verifyData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentOrderCount = prefs.getInt('orderCount') ?? 0;
    currentOrderCount++;
    await prefs.setInt('orderCount', currentOrderCount);
    String displayOrderNo = currentOrderCount.toString().padLeft(3, '0');

    setState(() {
      paymentCompleted = true;
    });

    final amount = getAmountFromMessages() ?? 500;

    final paymentSuccessMsg = Message(
      id: UniqueKey().toString(),
      text: "Payment successful and verified! ✅",
      isBot: true,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      paymentCompleted: true,
      orderId: currentOrderId,
      paymentId: response.paymentId,
      orderNumber: displayOrderNo,
      amount: amount,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    final amountMsg = Message(
      id: UniqueKey().toString(),
      text: "₹$amount has been successfully processed for Order #$displayOrderNo",
      isBot: false,
      createdAt: DateTime.now(),
      paymentCompleted: true,
      amount: amount,
      userId: userId,
      userName: userName,
    );

    setState(() {
      messages.add(paymentSuccessMsg);
      messages.add(amountMsg);
    });

    await sendMessage(paymentSuccessMsg);
    await sendMessage(amountMsg);

    await _handleDoctorAssignment(verifyData);

    print('💰 Payment completed, starting session end listener...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startOrderStatusListener();
      // Also start upload permission listener for the new paid session
      _startUploadPermissionListener();
    });

    await _askReportUploadQuestion();
    _scrollToBottom();

    Helpers.showSnackBar(
        context,
        "Payment successful! Order #$displayOrderNo created.",
        bgColor: AppColors.accent
    );
  }

  Future<void> _handleDoctorAssignment(Map<String, dynamic> verifyData) async {
    if (verifyData['data']['assignedDoctor'] != null) {
      final assignedDoctor = verifyData['data']['assignedDoctor'];
      setState(() {
        assignedDoctorName = assignedDoctor['name'];
        assignedDoctorSpeciality = assignedDoctor['speciality'];
      });

      final doctorAssignmentMsg = Message(
        id: UniqueKey().toString(),
        text: "Great news! Dr. ${assignedDoctor['name']} (${assignedDoctor['speciality']}) has been assigned to your case. They will connect with you shortly.",
        isBot: true,
        createdAt: DateTime.now(),
        selectedDoctorType: currentDoctorType,
        selectedSpeciality: currentSpeciality,
        paymentCompleted: true,
        assignedDoctorId: assignedDoctor['id'],
        assignedDoctorName: assignedDoctor['name'],
        userId: userId,
        userName: 'Care Connect Bot',
      );

      setState(() {
        messages.add(doctorAssignmentMsg);
      });
      await sendMessage(doctorAssignmentMsg);
    } else {
      final waitingMsg = Message(
        id: UniqueKey().toString(),
        text: "Payment successful! We're finding the best ${currentSpeciality} ${currentDoctorType} doctor for you. You'll be notified when a doctor is assigned.",
        isBot: true,
        createdAt: DateTime.now(),
        selectedDoctorType: currentDoctorType,
        selectedSpeciality: currentSpeciality,
        paymentCompleted: true,
        userId: userId,
        userName: 'Care Connect Bot',
      );

      setState(() {
        messages.add(waitingMsg);
      });
      await sendMessage(waitingMsg);
    }
  }

  Future<void> _askReportUploadQuestion() async {
    final reportQuestion = Message(
      id: UniqueKey().toString(),
      text: "Would you like to upload any medical reports for the doctor to review?",
      isBot: true,
      showButtons: true,
      buttonClicked: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      showReportUploadQuestion: true,
      userId: userId,
      userName: 'Care Connect Bot',
    );
    setState(() {
      messages.add(reportQuestion);
    });
    await sendMessage(reportQuestion);
    _scrollToBottom();
  }

  Future<void> _onReportUploadYes(Message questionMsg) async {
    final index = messages.indexWhere((m) => m.id == questionMsg.id);
    if (index == -1) return;

    final updatedMsg = questionMsg.copyWith(
      showButtons: false,
      buttonClicked: true,
      reportUploadAnswered: true,
      wantsToUploadReport: true,
    );
    final userResponse = Message(
      id: UniqueKey().toString(),
      text: "Yes, I would like to upload reports.",
      isBot: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      userId: userId,
      userName: userName,
    );

    final uploadButtonMsg = Message(
      id: UniqueKey().toString(),
      text: "Great! Click the button below to upload your medical reports.",
      isBot: true,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      showReportUploadButton: true,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages[index] = updatedMsg;
      messages.add(userResponse);
      messages.add(uploadButtonMsg);
      reportUploadEnabled = true;
      hasUploadedReport = false;
    });

    await sendMessage(updatedMsg);
    await sendMessage(userResponse);
    await sendMessage(uploadButtonMsg);

    final chatEnableMsg = Message(
      id: UniqueKey().toString(),
      text: assignedDoctorName != null
          ? "You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
          : "You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
      isBot: true,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      paymentCompleted: true,
      assignedDoctorName: assignedDoctorName,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages.add(chatEnableMsg);
    });

    await sendMessage(chatEnableMsg);
    _scrollToBottom();
  }

  Future<void> _onReportUploadNo(Message questionMsg) async {
    final index = messages.indexWhere((m) => m.id == questionMsg.id);
    if (index == -1) return;

    final updatedMsg = questionMsg.copyWith(
      showButtons: false,
      buttonClicked: true,
      reportUploadAnswered: true,
    );
    final userResponse = Message(
      id: UniqueKey().toString(),
      text: "No, I don't need to upload reports right now.",
      isBot: false,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      userId: userId,
      userName: userName,
    );
    final chatEnableMsg = Message(
      id: UniqueKey().toString(),
      text: assignedDoctorName != null
          ? "No problem! You can now start chatting with Dr. $assignedDoctorName. How can we help you today?"
          : "No problem! You can now start chatting with our ${currentSpeciality ?? currentDoctorType} specialists. How can we help you today?",
      isBot: true,
      createdAt: DateTime.now(),
      selectedDoctorType: currentDoctorType,
      selectedSpeciality: currentSpeciality,
      paymentCompleted: true,
      assignedDoctorName: assignedDoctorName,
      userId: userId,
      userName: 'Care Connect Bot',
    );

    setState(() {
      messages[index] = updatedMsg;
      messages.add(userResponse);
      messages.add(chatEnableMsg);
    });
    await sendMessage(updatedMsg);
    await sendMessage(userResponse);
    await sendMessage(chatEnableMsg);
    _scrollToBottom();
  }

  Future<void> _onReportUploadButtonPressed(Message uploadMsg) async {
    final index = messages.indexWhere((m) => m.id == uploadMsg.id);
    if (index == -1) return;

    final canUpload = reportUploadEnabled || _hasUploadPermission;

    if (!canUpload) {
      Helpers.showSnackBar(context, "Please complete payment and confirm report upload first", bgColor: Colors.orange);
      return;
    }

    if (hasUploadedReport && !_hasUploadPermission) {
      Helpers.showSnackBar(context, "You have already uploaded reports. Upload is allowed only once.", bgColor: Colors.orange);
      return;
    }

    if (_isSessionEnded) {
      Helpers.showSnackBar(context, "Session completed - cannot upload files", bgColor: Colors.orange);
      return;
    }
    if (currentOrderId == null) {
      Helpers.showSnackBar(context, "No active order found", bgColor: Colors.red);
      return;
    }

    print('📤 Navigating to upload with orderId: $currentOrderId, userId: $userId');
    print('🔓 Upload permission status: $_hasUploadPermission');

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadFiles(
        orderId: currentOrderId!,
        userId: userId!,
      )),
    );

    if (result != null && result is Map<String, dynamic> && result['status'] == 'uploaded') {
      List<Map<String, dynamic>> uploadedReports = List<Map<String, dynamic>>.from(result['reports']);

      String successMessage;
      if (_hasUploadPermission && hasUploadedReport) {
        successMessage = "Additional medical reports uploaded successfully! ✅\nTotal new files: ${uploadedReports.length}";
      } else {
        successMessage = "Medical reports uploaded successfully! ✅\nTotal files: ${uploadedReports.length}";
      }

      final uploadSuccessMsg = Message(
        id: UniqueKey().toString(),
        text: successMessage,
        isBot: true,
        createdAt: DateTime.now(),
        selectedDoctorType: currentDoctorType,
        selectedSpeciality: currentSpeciality,
        reportUploaded: true,
        reportFiles: uploadedReports,
        assignedDoctorName: assignedDoctorName,
        hasUploadPermission: _hasUploadPermission,
        userId: userId,
        userName: 'Care Connect Bot',
      );

      setState(() {
        messages.add(uploadSuccessMsg);
        hasUploadedReport = true;
        // Only disable report upload if we don't have permission from doctor
        if (!_hasUploadPermission) {
          reportUploadEnabled = false;
        }
      });

      await sendMessage(uploadSuccessMsg);
      _scrollToBottom();

      Helpers.showSnackBar(context, "Reports uploaded successfully!", bgColor: AppColors.accent);

      await _loadChatHistoryOrInitialize();
    }
  }

  IconData _getFileIcon(String fileType) {
    if (fileType.toLowerCase().contains('image')) return Icons.image;
    if (fileType.toLowerCase().contains('pdf')) return Icons.picture_as_pdf;
    if (fileType.toLowerCase().contains('word') || fileType.toLowerCase().contains('document'))
      return Icons.description;
    return Icons.insert_drive_file;
  }

  Future<void> _openFile(String filePath, String fileName) async {
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type == ResultType.done) {
        debugPrint("✅ File opened successfully: $fileName");
      } else if (result.type == ResultType.noAppToOpen) {
        Helpers.showSnackBar(context, "No application available to open this file type", bgColor: Colors.orange);
      } else if (result.type == ResultType.fileNotFound) {
        Helpers.showSnackBar(context, "File not found at: $filePath", bgColor: Colors.red);
      } else {
        Helpers.showSnackBar(context, "Could not open file: ${result.message}", bgColor: Colors.red);
      }
    } catch (e) {
      debugPrint("❌ Error opening file: $e");
      Helpers.showSnackBar(context, "Error opening file: $e", bgColor: Colors.red);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final errorMsg = Message(
      id: UniqueKey().toString(),
      text: "Payment could not be completed. Please try again.",
      isBot: true,
      createdAt: DateTime.now(),
      userId: userId,
      userName: 'Care Connect Bot',
    );
    setState(() {
      messages.add(errorMsg);
    });
    sendMessage(errorMsg);
    Helpers.showSnackBar(context, "Payment failed: ${response.message}", bgColor: Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Helpers.showSnackBar(context, "Wallet selected: ${response.walletName}");
  }

  Widget buildIntroCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1.2),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services, color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Text(
                "Care Connect",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Get expert medical advice from the comfort of your home.\nOur experienced doctors are ready to help you confidently at every step.",
            style: TextStyle(fontSize: 15.5, color: Colors.grey[800]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.verified_user, color: AppColors.accent, size: 20),
              const SizedBox(width: 5),
              Text(
                "Trusted | Secure | Confidential",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            "How it works:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          _buildStep(stepNumber: 1, icon: Icons.person_search, label: "Choose your doctor type and specialty"),
          const SizedBox(height: 5),
          _buildStep(stepNumber: 2, icon: Icons.payment, label: "Make a secure online payment"),
          const SizedBox(height: 5),
          _buildStep(stepNumber: 3, icon: Icons.message_outlined, label: "Upload reports, Chat & get advice"),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/help'),
            child: Text(
              "Help & Support",
              style: TextStyle(decoration: TextDecoration.underline, color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({required int stepNumber, required IconData icon, required String label}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: AppColors.primary,
          child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 7),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, color: Colors.grey[800]))),
      ],
    );
  }

  Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, size: 25, color: AppColors.iconColor),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      onTap: onTap,
    );
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget buildMessageBubble(Message msg) {
    final isUser = !msg.isBot;

    final showSecondOpinionButton = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("second opinion");
    final showDoctorTypeDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your preferred doctor type");
    final showSpecialityDropdown = msg.showButtons && !msg.buttonClicked && msg.text.toLowerCase().contains("select your doctor's speciality");
    final showReportUploadButtons = msg.showReportUploadQuestion && msg.showButtons && !msg.buttonClicked;
    final showDoctorTypeConfirmation = msg.showDoctorTypeConfirmation && msg.showButtons && !msg.buttonClicked;
    final showSpecialityConfirmation = msg.showSpecialityConfirmation && msg.showButtons && !msg.buttonClicked;
    final shouldShowPaymentButton = msg.showPaymentButton && !paymentCompleted;

    // UPLOAD BUTTON WILL SHOW IN CHAT BUBBLE AFTER DOCTOR GRANTS PERMISSION
    final shouldShowReportUploadButton =
        (msg.showReportUploadButton && reportUploadEnabled && !hasUploadedReport && !_isSessionEnded) ||
            (msg.hasUploadPermission && _hasUploadPermission && !_isSessionEnded);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.chatUser : AppColors.chatBot,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.circular(0),
            bottomRight: isUser ? Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(color: isUser ? AppColors.chatUserText : AppColors.chatBotText, fontSize: 15),
            ),

            if (msg.assignedDoctorName != null && msg.assignedDoctorName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.medical_services, color: Colors.green.shade700, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "Assigned: Dr. ${msg.assignedDoctorName}",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (msg.hasUploadPermission && _hasUploadPermission)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: Colors.orange.shade700, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        "Upload access granted by doctor",
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (msg.reportUploaded == true && msg.reportFiles != null && msg.reportFiles!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📁 Uploaded Reports (${msg.reportFiles!.length}):",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUser ? AppColors.chatUserText : AppColors.chatBotText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...msg.reportFiles!.map((report) {
                      final fileName = report['fileName']?.toString() ?? 'Unknown File';
                      final fileSize = report['fileSize'] ?? 0;
                      final fileType = report['fileType']?.toString() ?? 'file';

                      return GestureDetector(
                        onTap: () => _openFile(report['filePath'], fileName),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue.shade50 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isUser ? Colors.blue.shade200 : Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isUser ? Colors.blue.shade100 : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  _getFileIcon(fileType),
                                  color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName,
                                      style: TextStyle(
                                        color: isUser ? Colors.blue.shade900 : Colors.green.shade900,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatFileSize(fileSize is int ? fileSize : 0),
                                      style: TextStyle(
                                        color: isUser ? Colors.blue.shade700 : Colors.green.shade700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.visibility_outlined,
                                color: isUser ? Colors.blue.shade600 : Colors.green.shade600,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

            if (showSecondOpinionButton)
              Padding(padding: const EdgeInsets.only(top: 8.0), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onYesButtonPressed(msg), child: const Text("Yes"))),

            if (showReportUploadButtons)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onReportUploadYes(msg), child: const Text("Yes")),
                    const SizedBox(width: 8),
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onReportUploadNo(msg), child: const Text("No")),
                  ],
                ),
              ),

            if (showDoctorTypeConfirmation)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmYes(msg), child: const Text("Yes")),
                    const SizedBox(width: 8),
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onDoctorTypeConfirmNo(msg), child: const Text("No")),
                  ],
                ),
              ),

            if (showSpecialityConfirmation)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmYes(msg), child: const Text("Yes")),
                    const SizedBox(width: 8),
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], foregroundColor: Colors.white), onPressed: () => _onSpecialityConfirmNo(msg), child: const Text("No")),
                  ],
                ),
              ),

            if (showDoctorTypeDropdown)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
                  child: DropdownButton<String>(
                    hint: const Text("Select Doctor Type"),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: "Allopathy", child: Text("Allopathy ")),
                      DropdownMenuItem(value: "Ayurvedic", child: Text("Ayurvedic ")),
                      DropdownMenuItem(value: "Homeopathy", child: Text("Homeopathy ")),
                    ],
                    onChanged: (value) {
                      if (value != null) _onDoctorTypeSelected(msg, value);
                    },
                  ),
                ),
              ),

            if (showSpecialityDropdown)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary)),
                  child: DropdownButton<String>(
                    hint: const Text("Select Speciality"),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: "MBBS", child: Text("MBBS (General Physician)")),
                      DropdownMenuItem(value: "MD", child: Text("MD (Doctor of Medicine)")),
                      DropdownMenuItem(value: "Dentist", child: Text("Dentist")),
                      DropdownMenuItem(value: "Cardiologist", child: Text("Cardiologist")),
                      DropdownMenuItem(value: "Dermatologist", child: Text("Dermatologist")),
                      DropdownMenuItem(value: "Orthopedic", child: Text("Orthopedic")),
                      DropdownMenuItem(value: "Pediatrician", child: Text("Pediatrician")),
                      DropdownMenuItem(value: "Gynecologist", child: Text("Gynecologist")),
                    ],
                    onChanged: (value) {
                      if (value != null) _onSpecialitySelected(msg, value);
                    },
                  ),
                ),
              ),

            if (shouldShowPaymentButton)
              Builder(builder: (context) {
                final amount = msg.amount ?? 500;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !paymentCompleted ? Colors.green[700] : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: !paymentCompleted ? () => _onPaymentButtonPressed(msg) : null,
                    icon: const Icon(Icons.payment),
                    label: Text("Pay ₹$amount"),
                  ),
                );
              }),

            // UPLOAD BUTTON IN CHAT BUBBLE - WILL SHOW AFTER DOCTOR GRANTS PERMISSION
            if (shouldShowReportUploadButton)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasUploadPermission ? Colors.orange : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => _onReportUploadButtonPressed(msg),
                  icon: Icon(_hasUploadPermission ? Icons.add_circle : Icons.upload_file),
                  label: Text(_hasUploadPermission ? "Upload Additional Reports" : "Upload Medical Reports"),
                ),
              ),

            if (msg.buttonClicked && msg.selectedDoctorType != null && !msg.paymentCompleted && !msg.showDoctorTypeConfirmation && !msg.showSpecialityConfirmation)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  msg.selectedSpeciality != null ? "Selected: ${msg.selectedDoctorType} - ${msg.selectedSpeciality}" : "Selected: ${msg.selectedDoctorType}",
                  style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),

            if (msg.createdAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _formatMessageTime(msg.createdAt!),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshChat() async {
    setState(() {
      loadingHistory = true;
    });

    await _loadChatHistoryOrInitialize();

    setState(() {
      loadingHistory = false;
    });

    Helpers.showSnackBar(context, "Chat refreshed", bgColor: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    if (loadingHistory || userId == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Restoring your chat session...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.iconColor),
        backgroundColor: AppColors.primary,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              child: Text(
                "Care Connect",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (currentDoctorType != null) ...[
              const SizedBox(width: 5),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    currentDoctorType!,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            onPressed: _refreshChat,
            icon: Icon(Icons.refresh, color: AppColors.iconColor),
            tooltip: "Refresh Chat",
          ),
          IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor)),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.primary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: const [
                    CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/logo.png"), backgroundColor: Colors.white),
                    SizedBox(height: 10),
                    Text("CareConnect", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("info@CareConnect.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    drawerItem("Home", Icons.home, () => Navigator.pushNamed(context, '/home')),
                    drawerItem("Doctors", Icons.add, () => Navigator.pushNamed(context, '/doctors')),
                    drawerItem("Terms & Privacy", Icons.privacy_tip, () => Navigator.pushNamed(context, '/terms')),
                    drawerItem("Help & Guide", Icons.help_outline, () => Navigator.pushNamed(context, '/help')),
                    drawerItem("Log Out", Icons.logout_sharp, () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel")
                            ),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Logout")
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        try {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('token');

                          print('🔐 Attempting logout...');
                          print('📱 Token available: ${token != null}');

                          if (token != null) {
                            final url = Uri.parse("${ApiConfig.baseUrl}/logout");
                            print('📤 Calling logout API: $url');

                            final response = await http.post(
                              url,
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer $token',
                              },
                            );

                            print('📥 Logout API Response Status: ${response.statusCode}');
                            print('📥 Logout API Response Body: ${response.body}');

                            if (response.statusCode == 200) {
                              final responseData = jsonDecode(response.body);
                              if (responseData['success'] == true) {
                                print('✅ Logout API successful');
                              } else {
                                print('⚠ Logout API returned success: false');
                              }
                            } else {
                              print('❌ Logout API failed with status: ${response.statusCode}');
                            }
                          } else {
                            print('⚠ No token found, proceeding with local logout');
                          }

                          await prefs.clear();
                          print('✅ Local storage cleared');

                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                                  (route) => false,
                            );
                          }

                          Helpers.showSnackBar(
                              context,
                              "Logged out successfully",
                              bgColor: Colors.green
                          );

                        } catch (e) {
                          print('❌ Logout error: $e');

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();

                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                                  (route) => false,
                            );
                          }

                          Helpers.showSnackBar(
                              context,
                              "Logged out successfully",
                              bgColor: Colors.green
                          );
                        }
                      }
                    }),
                  ],
                ),
              ),
              Divider(color: AppColors.iconColor, thickness: 2, indent: 12, endIndent: 12),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Made With", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                      SizedBox(width: 5),
                      Icon(Icons.favorite, color: AppColors.textLight, size: 14),
                      SizedBox(width: 5),
                      Text("By VSGLogic", style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              controller: _scrollController,
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return buildIntroCard(context);
                final msg = messages[index - 1];

                bool showDate = false;
                if (index == 1) {
                  showDate = true;
                } else {
                  final prevMsg = messages[index - 2];
                  if (msg.createdAt != null && prevMsg.createdAt != null) {
                    showDate = !isSameDay(msg.createdAt!, prevMsg.createdAt!);
                  }
                }

                return Column(
                  children: [
                    if (showDate && msg.createdAt != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                          child: Text(formatDate(msg.createdAt!), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                        ),
                      ),
                    buildMessageBubble(msg),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: AppColors.primary,
              child: Column(
                children: [
                  if (_isSessionEnded)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange.shade800),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Session completed by doctor. Starting new chat...",
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_hasUploadPermission && !_isSessionEnded)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.upload_file, color: Colors.orange.shade800, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Upload access granted - You can upload additional reports using the upload button in chat",
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: paymentCompleted && !_isSessionEnded ? Colors.white : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: TextField(
                            controller: _controller,
                            enabled: paymentCompleted && !_isSessionEnded,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration.collapsed(
                              hintText: _isSessionEnded
                                  ? "Session completed - Starting new chat..."
                                  : paymentCompleted
                                  ? "Type your message here"
                                  : "Complete payment to chat",
                            ),
                            onChanged: (text) {
                              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: paymentCompleted && !_isSessionEnded
                            ? () {
                          if (_controller.text.trim().isNotEmpty) {
                            _onUserSend(_controller.text.trim());
                            _controller.clear();
                          }
                        }
                            : null,
                        child: Icon(
                            Icons.send,
                            color: paymentCompleted && !_isSessionEnded ? AppColors.iconColor : Colors.grey
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}