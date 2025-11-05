// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import '../helper.dart'; // import ApiConfig
// // //
// // // class ChatService {
// // //   static Map<String, String> get headers => {
// // //     'Content-Type': 'application/json',
// // //   };
// // //
// // //   // Initialize Chat
// // //   static Future<Map<String, dynamic>> initializeChat({
// // //     required String userId,
// // //     required String userName,
// // //     String? userPhone,
// // //     String? userEmail,
// // //     String? orderId,
// // //   }) async {
// // //     try {
// // //       print('🔄 Initializing chat for user: $userId');
// // //
// // //       final response = await http
// // //           .post(
// // //         Uri.parse(ApiConfig.chatInitialize),
// // //         headers: headers,
// // //         body: json.encode({
// // //           'userId': userId,
// // //           'userName': userName,
// // //           'userPhone': userPhone ?? '',
// // //           'userEmail': userEmail ?? '',
// // //           'orderId': orderId ??
// // //               'ORDER_${DateTime.now().millisecondsSinceEpoch}',
// // //         }),
// // //       )
// // //           .timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         print('✅ Chat initialized successfully');
// // //         return data;
// // //       } else {
// // //         print(
// // //             '❌ Initialize failed: ${response.statusCode} - ${response.body}');
// // //         throw Exception(
// // //             'Failed to initialize chat: ${response.statusCode}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ Initialize error: $e');
// // //       rethrow;
// // //     }
// // //   }
// // //
// // //   // Send Message
// // //   static Future<Map<String, dynamic>> sendMessage({
// // //     required String userId,
// // //     required String message,
// // //     required String userName,
// // //     String? userPhone,
// // //     String? userEmail,
// // //     String? doctorType,
// // //     String? speciality,
// // //     String? orderId,
// // //     bool paymentCompleted = false,
// // //   }) async {
// // //     try {
// // //       print('🔄 Sending message: $message');
// // //
// // //       final response = await http
// // //           .post(
// // //         Uri.parse(ApiConfig.chatSend),
// // //         headers: headers,
// // //         body: json.encode({
// // //           'userId': userId,
// // //           'userName': userName,
// // //           'userPhone': userPhone ?? '',
// // //           'userEmail': userEmail ?? '',
// // //           'message': message,
// // //           'doctorType': doctorType ?? '',
// // //           'speciality': speciality ?? '',
// // //           'orderId': orderId ?? '',
// // //           'paymentCompleted': paymentCompleted,
// // //         }),
// // //       )
// // //           .timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         print('✅ Message sent successfully');
// // //         return data;
// // //       } else {
// // //         print(
// // //             '❌ Send message failed: ${response.statusCode} - ${response.body}');
// // //         throw Exception('Failed to send message: ${response.statusCode}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ Send message error: $e');
// // //       rethrow;
// // //     }
// // //   }
// // //
// // //   // Get Chat History
// // //   static Future<Map<String, dynamic>> getChatHistory({
// // //     required String userId,
// // //     String? orderId,
// // //   }) async {
// // //     try {
// // //       print('🔄 Loading : $userId');
// // //
// // //       // Always include userId
// // //       String url = "${ApiConfig.chatHistory}?userId=$userId";
// // //       if (orderId != null && orderId.isNotEmpty) {
// // //         url += "&orderId=$orderId";
// // //       }
// // //
// // //       final response = await http
// // //           .get(Uri.parse(url))
// // //           .timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         print(
// // //             '✅ History fetched successfully. Messages: ${data['data']?['messages']?.length ?? 0}');
// // //         return data;
// // //       } else {
// // //         print(
// // //             '❌ History fetch failed: ${response.statusCode} - ${response.body}');
// // //         throw Exception('Failed to get chat history: ${response.statusCode}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ History fetch error: $e');
// // //       rethrow;
// // //     }
// // //   }
// // //
// // //
// // //   // Get Messages by Order
// // //   static Future<Map<String, dynamic>> getMessagesByOrder(
// // //       String orderId) async {
// // //     try {
// // //       print('🔄 Fetching messages for order: $orderId');
// // //
// // //       final response = await http
// // //           .get(Uri.parse(ApiConfig.getChatByOrder(orderId)))
// // //           .timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         print('✅ Order messages fetched successfully');
// // //         return data;
// // //       } else {
// // //         print(
// // //             '❌ Order messages fetch failed: ${response.statusCode} - ${response.body}');
// // //         throw Exception(
// // //             'Failed to fetch order messages: ${response.statusCode}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ Order messages fetch error: $e');
// // //       rethrow;
// // //     }
// // //   }
// // //
// // //   // Update Message
// // //   static Future<Map<String, dynamic>> updateMessage({
// // //     required String messageId,
// // //     required Map<String, dynamic> updateData,
// // //   }) async {
// // //     try {
// // //       print('🔄 Updating message: $messageId');
// // //
// // //       final response = await http
// // //           .put(
// // //         Uri.parse(ApiConfig.updateMessage(messageId)),
// // //         headers: headers,
// // //         body: json.encode(updateData),
// // //       )
// // //           .timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         print('✅ Message updated successfully');
// // //         return data;
// // //       } else {
// // //         print(
// // //             '❌ Update message failed: ${response.statusCode} - ${response.body}');
// // //         throw Exception('Failed to update message: ${response.statusCode}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ Update message error: $e');
// // //       rethrow;
// // //     }
// // //   }
// // //
// // //   // Delete Message
// // //   static Future<Map<String, dynamic>> deleteMessage(
// // //       String messageId) async {
// // //     try {
// // //       print('🔄 Deleting message: $messageId');
// // //
// // //       final response = await http
// // //           .delete(Uri.parse(ApiConfig.deleteMessage(messageId)))
// // //           .timeout(const Duration(seconds: 10));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         print('✅ Message deleted successfully');
// // //         return data;
// // //       } else {
// // //         print(
// // //             '❌ Delete message failed: ${response.statusCode} - ${response.body}');
// // //         throw Exception('Failed to delete message: ${response.statusCode}');
// // //       }
// // //     } catch (e) {
// // //       print('❌ Delete message error: $e');
// // //       rethrow;
// // //     }
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import '../helper.dart'; // import ApiConfig
// //
// // class ChatService {
// //   static Map<String, String> get headers => {
// //     'Content-Type': 'application/json',
// //   };
// //
// //   // Initialize Complete Conversation (NEW)
// //   // static Future<Map<String, dynamic>> initializeConversation({
// //   //   required String userId,
// //   //   // required String userName,
// //   //   String? userPhone,
// //   //   String? userName,
// //   //   String? userEmail,
// //   //   String? orderId,
// //   // }) async {
// //   //   try {
// //   //     print('🚀 Initializing complete conversation for user: $userId');
// //   //
// //   //     final response = await http
// //   //         .post(
// //   //       Uri.parse('${ApiConfig.baseUrl}/conversation/initialize'),
// //   //       headers: headers,
// //   //       body: json.encode({
// //   //         'userId': userId,
// //   //         'userName': userName,
// //   //         'userPhone': userPhone ?? '',
// //   //         'userEmail': userEmail ?? '',
// //   //         'orderId': orderId,
// //   //       }),
// //   //     )
// //   //         .timeout(const Duration(seconds: 10));
// //   //
// //   //     if (response.statusCode == 200) {
// //   //       final data = json.decode(response.body);
// //   //       print('✅ Complete conversation initialized successfully');
// //   //       print('📥 Messages received: ${data['data']?['messages']?.length ?? 0}');
// //   //       print('🔧 Current state: ${data['data']?['currentState']}');
// //   //       return data;
// //   //     } else {
// //   //       print('❌ Conversation initialize failed: ${response.statusCode} - ${response.body}');
// //   //       throw Exception('Failed to initialize conversation: ${response.statusCode}');
// //   //     }
// //   //   } catch (e) {
// //   //     print('❌ Conversation initialize error: $e');
// //   //     rethrow;
// //   //   }
// //   // }
// //
// //   // Initialize Complete Conversation (NEW)
// //   static Future<Map<String, dynamic>> initializeConversation({
// //     required String userId,
// //     required String? userName, // Remove comment, make it required but nullable
// //     String? userPhone,
// //     String? userEmail,
// //     String? orderId,
// //   }) async {
// //     try {
// //       print('🚀 Initializing complete conversation for user: $userId');
// //
// //       final response = await http
// //           .post(
// //         Uri.parse('${ApiConfig.baseUrl}/conversation/initialize'),
// //         headers: headers,
// //         body: json.encode({
// //           'userId': userId,
// //           'userName': userName ?? 'User', // Provide default value
// //           'userPhone': userPhone ?? '',
// //           'userEmail': userEmail ?? '',
// //           'orderId': orderId,
// //         }),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Complete conversation initialized successfully');
// //         print('📥 Messages received: ${data['data']?['messages']?.length ?? 0}');
// //         print('🔧 Current state: ${data['data']?['currentState']}');
// //
// //         // Debug the response structure
// //         print('🔍 Response structure:');
// //         print('   - success: ${data['success']}');
// //         print('   - data: ${data['data'] != null}');
// //         print('   - messages: ${data['data']?['messages'] is List}');
// //         print('   - currentState: ${data['data']?['currentState']}');
// //
// //         if (data['data']?['messages'] is List) {
// //           final messages = data['data']?['messages'] as List;
// //           for (int i = 0; i < messages.length; i++) {
// //             final msg = messages[i];
// //             print('   📝 Message $i: ${msg['text']}');
// //             print('     - showButtons: ${msg['showButtons']}');
// //             print('     - buttons: ${msg['buttons']}');
// //           }
// //         }
// //
// //         return data;
// //       } else {
// //         print('❌ Conversation initialize failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to initialize conversation: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Conversation initialize error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //
// //
// //   // Progress Conversation (NEW)
// //   static Future<Map<String, dynamic>> progressConversation({
// //     required String userId,
// //     String? buttonValue,
// //     String? userMessage,
// //     String? orderId,
// //     String? currentState,
// //   }) async {
// //     try {
// //       print('🔄 Progressing conversation for user: $userId');
// //       print('🔘 Button value: $buttonValue');
// //       print('📝 User message: $userMessage');
// //       print('🔧 Current state: $currentState');
// //
// //       final response = await http
// //           .post(
// //         Uri.parse('${ApiConfig.baseUrl}/conversation/progress'),
// //         headers: headers,
// //         body: json.encode({
// //           'userId': userId,
// //           'buttonValue': buttonValue,
// //           'userMessage': userMessage,
// //           'orderId': orderId,
// //           'currentState': currentState,
// //         }),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Conversation progressed successfully');
// //         print('📥 Bot messages received: ${data['data']?['botMessages']?.length ?? 0}');
// //         print('🔧 New state: ${data['data']?['currentState']}');
// //         print('📦 Order ID: ${data['data']?['orderId']}');
// //         return data;
// //       } else {
// //         print('❌ Conversation progress failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to progress conversation: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Conversation progress error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Send User Message (UPDATED - for active chat)
// //   static Future<Map<String, dynamic>> sendUserMessage({
// //     required String userId,
// //     required String message,
// //     String? orderId,
// //   }) async {
// //     try {
// //       print('💬 Sending user message: ${message.length > 50 ? '${message.substring(0, 50)}...' : message}');
// //
// //       final response = await http
// //           .post(
// //         Uri.parse('${ApiConfig.baseUrl}/send'),
// //         headers: headers,
// //         body: json.encode({
// //           'userId': userId,
// //           'message': message,
// //           'orderId': orderId,
// //         }),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ User message sent successfully');
// //         print('🤖 Bot response received: ${data['data']?['botResponse'] != null}');
// //         return data;
// //       } else {
// //         print('❌ Send user message failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to send user message: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Send user message error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Handle Payment Completion (NEW)
// //   static Future<Map<String, dynamic>> handlePaymentCompletion({
// //     required String orderId,
// //     required String paymentId,
// //     required int amount,
// //     required String userId,
// //   }) async {
// //     try {
// //       print('💰 Handling payment completion for order: $orderId');
// //
// //       final response = await http
// //           .post(
// //         Uri.parse('${ApiConfig.baseUrl}/conversation/payment-complete'),
// //         headers: headers,
// //         body: json.encode({
// //           'orderId': orderId,
// //           'paymentId': paymentId,
// //           'amount': amount,
// //           'userId': userId,
// //         }),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Payment completion handled successfully');
// //         return data;
// //       } else {
// //         print('❌ Payment completion failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to handle payment completion: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Payment completion error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Get Conversation State (NEW)
// //   static Future<Map<String, dynamic>> getConversationState({
// //     required String userId,
// //     String? orderId,
// //   }) async {
// //     try {
// //       print('🔍 Getting conversation state for user: $userId');
// //
// //       String url = '${ApiConfig.baseUrl}/conversation/state/$userId';
// //       if (orderId != null && orderId.isNotEmpty) {
// //         url += '/$orderId';
// //       }
// //
// //       final response = await http
// //           .get(Uri.parse(url))
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ Conversation state fetched successfully');
// //         print('🔧 Current state: ${data['data']?['currentState']}');
// //         return data;
// //       } else {
// //         print('❌ Conversation state fetch failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to get conversation state: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ Conversation state fetch error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // ========== KEEP YOUR EXISTING METHODS FOR BACKWARD COMPATIBILITY ==========
// //
// //   // Initialize Chat (LEGACY - kept for backward compatibility)
// //   static Future<Map<String, dynamic>> initializeChat({
// //     required String userId,
// //     required String userName,
// //     String? userPhone,
// //     String? userEmail,
// //     String? orderId,
// //   }) async {
// //     try {
// //       print('🔄 [LEGACY] Initializing chat for user: $userId');
// //
// //       final response = await http
// //           .post(
// //         Uri.parse(ApiConfig.chatInitialize),
// //         headers: headers,
// //         body: json.encode({
// //           'userId': userId,
// //           'userName': userName,
// //           'userPhone': userPhone ?? '',
// //           'userEmail': userEmail ?? '',
// //           'orderId': orderId ?? 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
// //         }),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ [LEGACY] Chat initialized successfully');
// //         return data;
// //       } else {
// //         print('❌ [LEGACY] Initialize failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to initialize chat: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ [LEGACY] Initialize error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Send Message (LEGACY - kept for backward compatibility)
// //   static Future<Map<String, dynamic>> sendMessage({
// //     required String userId,
// //     required String message,
// //     required String userName,
// //     String? userPhone,
// //     String? userEmail,
// //     String? doctorType,
// //     String? speciality,
// //     String? orderId,
// //     bool paymentCompleted = false,
// //   }) async {
// //     try {
// //       print('🔄 [LEGACY] Sending message: $message');
// //
// //       final response = await http
// //           .post(
// //         Uri.parse(ApiConfig.chatSend),
// //         headers: headers,
// //         body: json.encode({
// //           'userId': userId,
// //           'userName': userName,
// //           'userPhone': userPhone ?? '',
// //           'userEmail': userEmail ?? '',
// //           'message': message,
// //           'doctorType': doctorType ?? '',
// //           'speciality': speciality ?? '',
// //           'orderId': orderId ?? '',
// //           'paymentCompleted': paymentCompleted,
// //         }),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ [LEGACY] Message sent successfully');
// //         return data;
// //       } else {
// //         print('❌ [LEGACY] Send message failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to send message: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ [LEGACY] Send message error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Get Chat History (LEGACY - kept for backward compatibility)
// //   static Future<Map<String, dynamic>> getChatHistory({
// //     required String userId,
// //     String? orderId,
// //   }) async {
// //     try {
// //       print('🔄 [LEGACY] Fetching chat history for user: $userId');
// //
// //       // Always include userId
// //       String url = "${ApiConfig.chatHistory}?userId=$userId";
// //       if (orderId != null && orderId.isNotEmpty) {
// //         url += "&orderId=$orderId";
// //       }
// //
// //       final response = await http
// //           .get(Uri.parse(url))
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ [LEGACY] History fetched successfully. Messages: ${data['data']?['messages']?.length ?? 0}');
// //         return data;
// //       } else {
// //         print('❌ [LEGACY] History fetch failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to get chat history: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ [LEGACY] History fetch error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Get Messages by Order (LEGACY - kept for backward compatibility)
// //   static Future<Map<String, dynamic>> getMessagesByOrder(
// //       String orderId) async {
// //     try {
// //       print('🔄 [LEGACY] Fetching messages for order: $orderId');
// //
// //       final response = await http
// //           .get(Uri.parse(ApiConfig.getChatByOrder(orderId)))
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ [LEGACY] Order messages fetched successfully');
// //         return data;
// //       } else {
// //         print('❌ [LEGACY] Order messages fetch failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to fetch order messages: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ [LEGACY] Order messages fetch error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Update Message (LEGACY - kept for backward compatibility)
// //   static Future<Map<String, dynamic>> updateMessage({
// //     required String messageId,
// //     required Map<String, dynamic> updateData,
// //   }) async {
// //     try {
// //       print('🔄 [LEGACY] Updating message: $messageId');
// //
// //       final response = await http
// //           .put(
// //         Uri.parse(ApiConfig.updateMessage(messageId)),
// //         headers: headers,
// //         body: json.encode(updateData),
// //       )
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ [LEGACY] Message updated successfully');
// //         return data;
// //       } else {
// //         print('❌ [LEGACY] Update message failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to update message: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ [LEGACY] Update message error: $e');
// //       rethrow;
// //     }
// //   }
// //
// //   // Delete Message (LEGACY - kept for backward compatibility)
// //   static Future<Map<String, dynamic>> deleteMessage(
// //       String messageId) async {
// //     try {
// //       print('🔄 [LEGACY] Deleting message: $messageId');
// //
// //       final response = await http
// //           .delete(Uri.parse(ApiConfig.deleteMessage(messageId)))
// //           .timeout(const Duration(seconds: 10));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         print('✅ [LEGACY] Message deleted successfully');
// //         return data;
// //       } else {
// //         print('❌ [LEGACY] Delete message failed: ${response.statusCode} - ${response.body}');
// //         throw Exception('Failed to delete message: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('❌ [LEGACY] Delete message error: $e');
// //       rethrow;
// //     }
// //   }
// // }
//
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helper.dart'; // import ApiConfig

class ChatService {
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  // Initialize Complete Conversation (NEW)
  static Future<Map<String, dynamic>> initializeConversation({
    required String userId,
    required String? userName,
    String? userPhone,
    String? userEmail,
    String? orderId,
  }) async {
    try {
      print('🚀 Initializing complete conversation for user: $userId');

      final response = await http
          .post(
        Uri.parse('${ApiConfig.baseUrl}/conversation/initialize'),
        headers: headers,
        body: json.encode({
          'userId': userId,
          'userName': userName ?? 'User',
          'userPhone': userPhone ?? '',
          'userEmail': userEmail ?? '',
          'orderId': orderId,
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Complete conversation initialized successfully');
        print('📥 Messages received: ${data['data']?['messages']?.length ?? 0}');
        print('🔧 Current state: ${data['data']?['currentState']}');

        // Debug the response structure
        print('🔍 Response structure:');
        print('   - success: ${data['success']}');
        print('   - data: ${data['data'] != null}');
        print('   - messages: ${data['data']?['messages'] is List}');
        print('   - currentState: ${data['data']?['currentState']}');

        if (data['data']?['messages'] is List) {
          final messages = data['data']?['messages'] as List;
          for (int i = 0; i < messages.length; i++) {
            final msg = messages[i];
            print('   📝 Message $i: ${msg['text']}');
            print('     - showButtons: ${msg['showButtons']}');
            print('     - buttons: ${msg['buttons']}');
          }
        }

        return data;
      } else {
        print('❌ Conversation initialize failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to initialize conversation: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Conversation initialize error: $e');
      rethrow;
    }
  }

  // Progress Conversation (NEW)
  static Future<Map<String, dynamic>> progressConversation({
    required String userId,
    required String? buttonValue,
    String? userMessage,
    String? orderId,
    required String? currentState,
  }) async {
    try {
      print('🔄 Progressing conversation for user: $userId');
      print('🔘 Button value: $buttonValue');
      print('📝 User message: $userMessage');
      print('🔧 Current state: $currentState');

      final response = await http
          .post(
        Uri.parse('${ApiConfig.baseUrl}/conversation/progress'),
        headers: headers,
        body: json.encode({
          'userId': userId,
          'buttonValue': buttonValue,
          'userMessage': userMessage,
          'orderId': orderId,
          'currentState': currentState,
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Conversation progressed successfully');
        print('📥 Bot messages received: ${data['data']?['botMessages']?.length ?? 0}');
        print('🔧 New state: ${data['data']?['currentState']}');
        print('📦 Order ID: ${data['data']?['orderId']}');

        // Debug bot messages
        if (data['data']?['botMessages'] is List) {
          final botMessages = data['data']?['botMessages'] as List;
          for (int i = 0; i < botMessages.length; i++) {
            final msg = botMessages[i];
            print('   🤖 Bot Message $i: ${msg['text']}');
            print('     - showButtons: ${msg['showButtons']}');
            print('     - buttons: ${msg['buttons']}');
          }
        }

        return data;
      } else {
        print('❌ Conversation progress failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to progress conversation: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Conversation progress error: $e');
      rethrow;
    }
  }

  // Send User Message (UPDATED - for active chat)
  static Future<Map<String, dynamic>> sendUserMessage({
    required String userId,
    required String message,
    String? orderId,
  }) async {
    try {
      print('💬 Sending user message: ${message.length > 50 ? '${message.substring(0, 50)}...' : message}');

      final response = await http
          .post(
        Uri.parse('${ApiConfig.baseUrl}/conversation/send'),
        headers: headers,
        body: json.encode({
          'userId': userId,
          'message': message,
          'orderId': orderId,
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ User message sent successfully');
        print('🤖 Bot response received: ${data['data']?['botResponse'] != null}');

        if (data['data']?['botResponse'] != null) {
          final botResponse = data['data']?['botResponse'];
          print('   📝 Bot response: ${botResponse['text']}');
          print('     - showButtons: ${botResponse['showButtons']}');
          print('     - buttons: ${botResponse['buttons']}');
        }

        return data;
      } else {
        print('❌ Send user message failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to send user message: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Send user message error: $e');
      rethrow;
    }
  }

  // Handle Payment Completion (NEW)
  static Future<Map<String, dynamic>> handlePaymentCompletion({
    required String orderId,
    required String paymentId,
    required int amount,
    required String userId,
  }) async {
    try {
      print('💰 Handling payment completion for order: $orderId');

      final response = await http
          .post(
        Uri.parse('${ApiConfig.baseUrl}/conversation/payment-complete'),
        headers: headers,
        body: json.encode({
          'orderId': orderId,
          'paymentId': paymentId,
          'amount': amount,
          'userId': userId,
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Payment completion handled successfully');
        return data;
      } else {
        print('❌ Payment completion failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to handle payment completion: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Payment completion error: $e');
      rethrow;
    }
  }

  // Get Conversation State (NEW)
  static Future<Map<String, dynamic>> getConversationState({
    required String userId,
    String? orderId,
  }) async {
    try {
      print('🔍 Getting conversation state for user: $userId');

      String url = '${ApiConfig.baseUrl}/conversation/state/$userId';
      if (orderId != null && orderId.isNotEmpty) {
        url += '/$orderId';
      }

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Conversation state fetched successfully');
        print('🔧 Current state: ${data['data']?['currentState']}');
        return data;
      } else {
        print('❌ Conversation state fetch failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get conversation state: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Conversation state fetch error: $e');
      rethrow;
    }
  }

  // ========== KEEP YOUR EXISTING METHODS FOR BACKWARD COMPATIBILITY ==========

  // Initialize Chat (LEGACY - kept for backward compatibility)
  static Future<Map<String, dynamic>> initializeChat({
    required String userId,
    required String userName,
    String? userPhone,
    String? userEmail,
    String? orderId,
  }) async {
    try {
      print('🔄 [LEGACY] Initializing chat for user: $userId');

      final response = await http
          .post(
        Uri.parse(ApiConfig.chatInitialize),
        headers: headers,
        body: json.encode({
          'userId': userId,
          'userName': userName,
          'userPhone': userPhone ?? '',
          'userEmail': userEmail ?? '',
          'orderId': orderId ?? 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ [LEGACY] Chat initialized successfully');
        return data;
      } else {
        print('❌ [LEGACY] Initialize failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to initialize chat: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [LEGACY] Initialize error: $e');
      rethrow;
    }
  }

  // Send Message (LEGACY - kept for backward compatibility)
  static Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String message,
    required String userName,
    String? userPhone,
    String? userEmail,
    String? doctorType,
    String? speciality,
    String? orderId,
    bool paymentCompleted = false,
  }) async {
    try {
      print('🔄 [LEGACY] Sending message: $message');

      final response = await http
          .post(
        Uri.parse(ApiConfig.chatSend),
        headers: headers,
        body: json.encode({
          'userId': userId,
          'userName': userName,
          'userPhone': userPhone ?? '',
          'userEmail': userEmail ?? '',
          'message': message,
          'doctorType': doctorType ?? '',
          'speciality': speciality ?? '',
          'orderId': orderId ?? '',
          'paymentCompleted': paymentCompleted,
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ [LEGACY] Message sent successfully');
        return data;
      } else {
        print('❌ [LEGACY] Send message failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [LEGACY] Send message error: $e');
      rethrow;
    }
  }

  // Get Chat History (LEGACY - kept for backward compatibility)
  static Future<Map<String, dynamic>> getChatHistory({
    required String userId,
    String? orderId,
  }) async {
    try {
      print('🔄 [LEGACY] Fetching chat history for user: $userId');

      // Always include userId
      String url = "${ApiConfig.chatHistory}?userId=$userId";
      if (orderId != null && orderId.isNotEmpty) {
        url += "&orderId=$orderId";
      }

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ [LEGACY] History fetched successfully. Messages: ${data['data']?['messages']?.length ?? 0}');
        return data;
      } else {
        print('❌ [LEGACY] History fetch failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get chat history: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [LEGACY] History fetch error: $e');
      rethrow;
    }
  }

  // Get Messages by Order (LEGACY - kept for backward compatibility)
  static Future<Map<String, dynamic>> getMessagesByOrder(
      String orderId) async {
    try {
      print('🔄 [LEGACY] Fetching messages for order: $orderId');

      final response = await http
          .get(Uri.parse(ApiConfig.getChatByOrder(orderId)))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ [LEGACY] Order messages fetched successfully');
        return data;
      } else {
        print('❌ [LEGACY] Order messages fetch failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch order messages: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [LEGACY] Order messages fetch error: $e');
      rethrow;
    }
  }

  // Update Message (LEGACY - kept for backward compatibility)
  static Future<Map<String, dynamic>> updateMessage({
    required String messageId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      print('🔄 [LEGACY] Updating message: $messageId');

      final response = await http
          .put(
        Uri.parse(ApiConfig.updateMessage(messageId)),
        headers: headers,
        body: json.encode(updateData),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ [LEGACY] Message updated successfully');
        return data;
      } else {
        print('❌ [LEGACY] Update message failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to update message: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [LEGACY] Update message error: $e');
      rethrow;
    }
  }

  // Delete Message (LEGACY - kept for backward compatibility)
  static Future<Map<String, dynamic>> deleteMessage(
      String messageId) async {
    try {
      print('🔄 [LEGACY] Deleting message: $messageId');

      final response = await http
          .delete(Uri.parse(ApiConfig.deleteMessage(messageId)))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ [LEGACY] Message deleted successfully');
        return data;
      } else {
        print('❌ [LEGACY] Delete message failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to delete message: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [LEGACY] Delete message error: $e');
      rethrow;
    }
  }
}







//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../helper.dart';
//
// class ChatService {
//   static const String baseUrl = ApiConfig.baseUrl;
//
//   // Initialize conversation with backend
//   static Future<Map<String, dynamic>> initializeConversation({
//     required String userId,
//     required String userName,
//     required String userPhone,
//     required String userEmail,
//     String? orderId,
//   }) async {
//     try {
//       print('🚀 Initializing conversation for user: $userId');
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/initialize-legacy'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "userId": userId,
//           "userName": userName,
//           "userPhone": userPhone,
//           "userEmail": userEmail,
//           "orderId": orderId,
//           "timestamp": DateTime.now().toIso8601String(),
//         }),
//       );
//
//       print('📥 Initialize conversation response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ Conversation initialized successfully');
//         return data;
//       } else {
//         print('❌ Failed to initialize conversation: ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Failed to initialize conversation: ${response.statusCode}',
//           'data': {'messages': [], 'currentState': 'initial'}
//         };
//       }
//     } catch (e) {
//       print('❌ Error initializing conversation: $e');
//       return {
//         'success': false,
//         'message': 'Network error: $e',
//         'data': {'messages': [], 'currentState': 'initial'}
//       };
//     }
//   }
//
//   // Progress conversation when user interacts
//   // static Future<Map<String, dynamic>> progressConversation({
//   //   required String userId,
//   //   required String buttonValue,
//   //   String? userMessage,
//   //   String? orderId,
//   //   String? currentState,
//   // }) async {
//   //   try {
//   //     print('🔄 Progressing conversation for user: $userId');
//   //     print('   Button value: $buttonValue');
//   //     print('   Current state: $currentState');
//   //     print('   Order ID: $orderId');
//   //
//   //     final Map<String, dynamic> requestBody = {
//   //       "userId": userId,
//   //       "buttonValue": buttonValue,
//   //       "timestamp": DateTime.now().toIso8601String(),
//   //     };
//   //
//   //     if (userMessage != null && userMessage.isNotEmpty) {
//   //       requestBody["userMessage"] = userMessage;
//   //     }
//   //     if (orderId != null && orderId.isNotEmpty) {
//   //       requestBody["orderId"] = orderId;
//   //     }
//   //     if (currentState != null && currentState.isNotEmpty) {
//   //       requestBody["currentState"] = currentState;
//   //     }
//   //
//   //     final response = await http.post(
//   //       Uri.parse('$baseUrl/conversation/progress'),
//   //       headers: {"Content-Type": "application/json"},
//   //       body: jsonEncode(requestBody),
//   //     );
//   //
//   //     print('📥 Progress conversation response: ${response.statusCode}');
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = jsonDecode(response.body);
//   //       print('✅ Conversation progressed successfully');
//   //       print('   New state: ${data['data']?['currentState']}');
//   //       print('   Bot messages: ${(data['data']?['botMessages'] as List?)?.length ?? 0}');
//   //       return data;
//   //     } else {
//   //       print('❌ Failed to progress conversation: ${response.statusCode}');
//   //       return {
//   //         'success': false,
//   //         'message': 'Failed to progress conversation: ${response.statusCode}',
//   //         'data': {'botMessages': [], 'currentState': currentState ?? 'initial'}
//   //       };
//   //     }
//   //   } catch (e) {
//   //     print('❌ Error progressing conversation: $e');
//   //     return {
//   //       'success': false,
//   //       'message': 'Network error: $e',
//   //       'data': {'botMessages': [], 'currentState': currentState ?? 'initial'}
//   //     };
//   //   }
//   // }
//
//
//   static Future<Map<String, dynamic>> progressConversation({
//     required String userId,
//     required String buttonValue,
//     String? userMessage,
//     String? orderId,
//     String? currentState,
//   }) async {
//     try {
//       print('🔄 Progressing conversation for user: $userId');
//       print('   Button value: $buttonValue');
//       print('   Current state: $currentState');
//       print('   Order ID: $orderId');
//
//       final Map<String, dynamic> requestBody = {
//         "userId": userId,
//         "buttonValue": buttonValue,
//         "timestamp": DateTime.now().toIso8601String(),
//       };
//
//       if (userMessage != null && userMessage.isNotEmpty) {
//         requestBody["userMessage"] = userMessage;
//       }
//       if (orderId != null && orderId.isNotEmpty) {
//         requestBody["orderId"] = orderId;
//       }
//       if (currentState != null && currentState.isNotEmpty) {
//         requestBody["currentState"] = currentState;
//       }
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/conversation/progress'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestBody),
//       );
//
//       print('📥 Progress conversation response: ${response.statusCode}');
//       print('📥 Response body: ${response.body}'); // ADD THIS TO SEE RAW RESPONSE
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ Conversation progressed successfully');
//         print('   New state: ${data['data']?['currentState']}');
//         print('   Bot messages: ${(data['data']?['botMessages'] as List?)?.length ?? 0}');
//
//         // ADD FALLBACK FOR EMPTY BACKEND RESPONSES
//         if (data['data'] == null || (data['data']?['botMessages'] as List?)?.isEmpty == true) {
//           print('⚠ Empty response from backend, creating local fallback');
//           return _createLocalFallbackResponse(buttonValue, currentState);
//         }
//
//         return data;
//       } else {
//         print('❌ Failed to progress conversation: ${response.statusCode}');
//         return _createLocalFallbackResponse(buttonValue, currentState);
//       }
//     } catch (e) {
//       print('❌ Error progressing conversation: $e');
//       return _createLocalFallbackResponse(buttonValue, currentState);
//     }
//   }
//
// // ADD THIS HELPER METHOD FOR LOCAL FALLBACK
//   static Map<String, dynamic> _createLocalFallbackResponse(String buttonValue, String? currentState) {
//     List<Map<String, dynamic>> fallbackMessages = [];
//     String newState = currentState ?? 'initial';
//
//     switch (buttonValue) {
//       case 'second_opinion_yes':
//         fallbackMessages = [
//           {
//             "id": "fallback_1",
//             "text": "Great! I'm glad you'd like a second opinion. What type of doctor would you prefer?",
//             "isBot": true,
//             "showButtons": true,
//             "buttonClicked": false,
//             "buttons": [
//               {
//                 "text": "Allopathy (Modern Medicine)",
//                 "value": "allopathy",
//                 "type": "primary"
//               },
//               {
//                 "text": "Ayurvedic",
//                 "value": "ayurvedic",
//                 "type": "primary"
//               },
//               {
//                 "text": "Homeopathy",
//                 "value": "homeopathy",
//                 "type": "primary"
//               }
//             ]
//           }
//         ];
//         newState = 'doctor_type_selection';
//         break;
//
//       case 'second_opinion_no':
//         fallbackMessages = [
//           {
//             "id": "fallback_1",
//             "text": "No problem! If you change your mind, I'm here to help. Is there anything else I can assist you with?",
//             "isBot": true,
//             "showButtons": false,
//             "buttonClicked": false,
//           }
//         ];
//         break;
//
//       case 'allopathy':
//       case 'ayurvedic':
//       case 'homeopathy':
//         fallbackMessages = [
//           {
//             "id": "fallback_1",
//             "text": "Excellent choice! You've selected $buttonValue medicine. Now, please choose your specialty:",
//             "isBot": true,
//             "showButtons": true,
//             "buttonClicked": false,
//             "selectedDoctorType": buttonValue,
//             "buttons": [
//               {
//                 "text": "General Physician",
//                 "value": "general_physician",
//                 "type": "primary"
//               },
//               {
//                 "text": "Cardiologist",
//                 "value": "cardiologist",
//                 "type": "primary"
//               },
//               {
//                 "text": "Dermatologist",
//                 "value": "dermatologist",
//                 "type": "primary"
//               },
//               {
//                 "text": "More Specialties...",
//                 "value": "more_specialties",
//                 "type": "secondary"
//               }
//             ]
//           }
//         ];
//         newState = 'speciality_selection';
//         break;
//
//       default:
//         fallbackMessages = [
//           {
//             "id": "fallback_1",
//             "text": "Thank you for your response. Let me help you with that.",
//             "isBot": true,
//             "showButtons": false,
//             "buttonClicked": false,
//           }
//         ];
//     }
//
//     return {
//       'success': true,
//       'message': 'Using local fallback response',
//       'data': {
//         'botMessages': fallbackMessages,
//         'currentState': newState,
//       }
//     };
//   }
//   // Send user message to backend
//   static Future<Map<String, dynamic>> sendUserMessage({
//     required String userId,
//     required String message,
//     String? orderId,
//   }) async {
//     try {
//       print('💬 Sending user message: ${message.substring(0, min(50, message.length))}...');
//
//       final Map<String, dynamic> requestBody = {
//         "userId": userId,
//         "message": message,
//         "timestamp": DateTime.now().toIso8601String(),
//       };
//
//       if (orderId != null && orderId.isNotEmpty) {
//         requestBody["orderId"] = orderId;
//       }
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/send-user-message'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestBody),
//       );
//
//       print('📥 Send message response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ User message sent successfully');
//         return data;
//       } else {
//         print('❌ Failed to send user message: ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Failed to send message: ${response.statusCode}',
//           'data': {'botResponse': null}
//         };
//       }
//     } catch (e) {
//       print('❌ Error sending user message: $e');
//       return {
//         'success': false,
//         'message': 'Network error: $e',
//         'data': {'botResponse': null}
//       };
//     }
//   }
//
//
//
//   // NEW: Initiate payment
//   static Future<Map<String, dynamic>> initiatePayment({
//     required String orderId,
//     required String userId,
//   }) async {
//     try {
//       print('💰 Initiating payment for order: $orderId');
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/initiate-payment'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "orderId": orderId,
//           "userId": userId,
//           "timestamp": DateTime.now().toIso8601String(),
//         }),
//       );
//
//       print('📥 Initiate payment response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ Payment initiated successfully');
//         return data;
//       } else {
//         print('❌ Failed to initiate payment: ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Failed to initiate payment: ${response.statusCode}'
//         };
//       }
//     } catch (e) {
//       print('❌ Error initiating payment: $e');
//       return {
//         'success': false,
//         'message': 'Network error: $e'
//       };
//     }
//   }
//
//   // Get conversation history
//   static Future<Map<String, dynamic>> getConversationHistory({
//     required String userId,
//     String? orderId,
//   }) async {
//     try {
//       print('📚 Getting conversation history for user: $userId');
//
//       String url = '$baseUrl/conversation-history/$userId';
//       if (orderId != null && orderId.isNotEmpty) {
//         url += '?orderId=$orderId';
//       }
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//       );
//
//       print('📥 Conversation history response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ Conversation history retrieved successfully');
//         print('   Messages count: ${(data['data']?['messages'] as List?)?.length ?? 0}');
//         return data;
//       } else {
//         print('❌ Failed to get conversation history: ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Failed to get conversation history: ${response.statusCode}',
//           'data': {'messages': []}
//         };
//       }
//     } catch (e) {
//       print('❌ Error getting conversation history: $e');
//       return {
//         'success': false,
//         'message': 'Network error: $e',
//         'data': {'messages': []}
//       };
//     }
//   }
//
//   // Reset conversation
//   static Future<Map<String, dynamic>> resetConversation({
//     required String userId,
//   }) async {
//     try {
//       print('🔄 Resetting conversation for user: $userId');
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/reset-conversation'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "userId": userId,
//           "timestamp": DateTime.now().toIso8601String(),
//         }),
//       );
//
//       print('📥 Reset conversation response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ Conversation reset successfully');
//         return data;
//       } else {
//         print('❌ Failed to reset conversation: ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Failed to reset conversation: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print('❌ Error resetting conversation: $e');
//       return {
//         'success': false,
//         'message': 'Network error: $e',
//       };
//     }
//   }
//
//   // Update message status (e.g., mark buttons as clicked)
//   static Future<Map<String, dynamic>> updateMessageStatus({
//     required String messageId,
//     required String userId,
//     required Map<String, dynamic> updates,
//   }) async {
//     try {
//       print('📝 Updating message status: $messageId');
//
//       final response = await http.put(
//         Uri.parse('$baseUrl/update-message-status'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "messageId": messageId,
//           "userId": userId,
//           "updates": updates,
//           "timestamp": DateTime.now().toIso8601String(),
//         }),
//       );
//
//       print('📥 Update message status response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ Message status updated successfully');
//         return data;
//       } else {
//         print('❌ Failed to update message status: ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Failed to update message status: ${response.statusCode}',
//         };
//       }
//     } catch (e) {
//       print('❌ Error updating message status: $e');
//       return {
//         'success': false,
//         'message': 'Network error: $e',
//       };
//     }
//   }
//
//   // Get current conversation state
//   static Future<Map<String, dynamic>> getCurrentState({
//     required String userId,
//     String? orderId,
//   }) async {
//     try {
//       print('🔍 Getting current state for user: $userId');
//
//       String url = '$baseUrl/current-state/$userId';
//       if (orderId != null && orderId.isNotEmpty) {
//         url += '?orderId=$orderId';
//       }
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//       );
//
//       print('📥 Current state response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ Current state retrieved successfully');
//         return data;
//       } else {
//         print('❌ Failed to get current state: ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Failed to get current state: ${response.statusCode}',
//           'data': {'currentState': 'initial'}
//         };
//       }
//     } catch (e) {
//       print('❌ Error getting current state: $e');
//       return {
//         'success': false,
//         'message': 'Network error: $e',
//         'data': {'currentState': 'initial'}
//       };
//     }
//   }
// }
//
//
// // Add this temporary debug method
// void _debugBackendResponse() async {
//   try {
//     print('🔍 DEBUG: Testing backend response...');
//
//     final response = await http.post(
//       Uri.parse('${ApiConfig.baseUrl}/conversation/progress'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         //"userId": userId,
//         "buttonValue": "second_opinion_yes",
//         "timestamp": DateTime.now().toIso8601String(),
//       }),
//     );
//
//     print('🔍 DEBUG RAW BACKEND RESPONSE:');
//     print('Status: ${response.statusCode}');
//     print('Body: ${response.body}');
//
//   } catch (e) {
//     print('❌ Debug request failed: $e');
//   }
// }
//
// // Call this temporarily in your initState or after initialization
// // _debugBackendResponse();
// // Helper function to get minimum of two numbers
// int min(int a, int b) => a < b ? a : b;
//


