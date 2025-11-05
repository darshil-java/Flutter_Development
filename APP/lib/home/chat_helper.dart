// import 'dart:convert';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'message_model.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import '../helper.dart';
//
// class ChatHelpers {
//   static Future<void> fetchChatHistory(dynamic state) async {
//     if (state.userId == null) return;
//     try {
//       final url = Uri.parse(ApiConfig.getChatHistory(state.userId!));
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//
//         if (responseData['success'] == true && responseData['data'] != null) {
//           final List data = responseData['data'];
//           data.sort((a, b) =>
//               DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt'])));
//           state.messages = data.map((chat) {
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
//             String? filePath;
//             if (chat.containsKey('filePath')) {
//               filePath = chat['filePath'];
//             }
//
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
//
//           state.setState(() {});
//           state._scrollToBottom();
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching chat history: $e");
//     }
//   }
//
//   static Future<void> sendMessage(String senderId, String receiverId, String message) async {
//     final url = Uri.parse(ApiConfig.chat);
//
//     final body = {
//       "senderId": senderId,
//       "receiverId": receiverId,
//       "message": message,
//     };
//
//     try {
//       await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );
//     } catch (e) {
//       debugPrint("❌ Error sending message: $e");
//     }
//   }
//
//   static void addMessage(Message msg, dynamic state) async {
//     state.setState(() {
//       state.messages.add(msg);
//     });
//
//     state._scrollToBottom();
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
//     String prefixedMessage = msg.isBot ? "Bot: ${msg.text}" : "User: ${msg.text}";
//     await sendMessage(senderId, receiverId, prefixedMessage);
//   }
//
//   static Future<String?> downloadFile(String url, String fileName, dynamic state) async {
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
//   static bool canUseChat(dynamic state) {
//     if (state.selectedDoctorType == null) return false;
//     if (state.selectedDoctorType == "Allopathy") {
//       return state.reportUploaded && !state.queryAsked;
//     }
//     if (state.selectedDoctorType == "Ayurvedic" ||
//         state.selectedDoctorType == "Homeopathic") {
//       return state.paymentDone && !state.queryAsked;
//     }
//     return false;
//   }
// }
