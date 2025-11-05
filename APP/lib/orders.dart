// // import 'package:flutter/material.dart';
// // import 'helper.dart'; // <- connected helper.dart
// //
// // class OrderPage extends StatefulWidget {
// //   const OrderPage({super.key});
// //
// //   @override
// //   State<OrderPage> createState() => _OrderPageState();
// // }
// //
// // class _OrderPageState extends State<OrderPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         iconTheme: IconThemeData(color: AppColors.iconColor), // use AppColors
// //         backgroundColor: AppColors.primary,                   // use AppColors
// //         centerTitle: true,
// //         title: const Column(
// //           children: [
// //             SizedBox(height: 10),
// //             Padding(
// //               padding: EdgeInsets.all(6.0),
// //               child: Text(
// //                 "My Orders",
// //                 style: TextStyle(
// //                     color: Colors.white, // use buttonText for title
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Center(
// //         child: Text(
// //           "No orders yet!",
// //           style: TextStyle(
// //             fontSize: 18,
// //             fontWeight: FontWeight.w500,
// //             color: AppColors.textDark, // use centralized text color
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
// import 'helper.dart';
//
// // Re-importing the models (in a real app, these would be in separate files)
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
// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});
//
//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }
//
// class _OrdersPageState extends State<OrdersPage> {
//   List<ChatOrder> orders = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadOrders();
//   }
//
//   Future<void> _loadOrders() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       List<String>? savedOrdersJson = prefs.getStringList('saved_orders');
//
//       if (savedOrdersJson != null && savedOrdersJson.isNotEmpty) {
//         orders = savedOrdersJson
//             .map((orderJson) => ChatOrder.fromMap(jsonDecode(orderJson)))
//             .toList();
//
//         // Sort orders by creation date (newest first)
//         orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//       }
//     } catch (e) {
//       debugPrint("Error loading orders: $e");
//       Helpers.showSnackBar(context, "Error loading orders", bgColor: Colors.red);
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> _deleteOrder(String orderNumber) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       // Remove order from list
//       orders.removeWhere((order) => order.orderNumber == orderNumber);
//
//       // Save updated list back to preferences
//       List<String> updatedOrdersJson = orders
//           .map((order) => jsonEncode(order.toMap()))
//           .toList();
//
//       await prefs.setStringList('saved_orders', updatedOrdersJson);
//
//       setState(() {});
//
//       Helpers.showSnackBar(
//           context,
//           "Order #$orderNumber deleted successfully",
//           bgColor: AppColors.accent
//       );
//     } catch (e) {
//       debugPrint("Error deleting order: $e");
//       Helpers.showSnackBar(context, "Error deleting order", bgColor: Colors.red);
//     }
//   }
//
//   String _getOrderSummary(ChatOrder order) {
//     if (order.patientQuery != null && order.patientQuery!.isNotEmpty) {
//       return order.patientQuery!.length > 50
//           ? "${order.patientQuery!.substring(0, 50)}..."
//           : order.patientQuery!;
//     }
//
//     // Find last user message
//     for (Message msg in order.messages.reversed) {
//       if (!msg.isBot && !msg.isSystem && msg.text.isNotEmpty && msg.text != "Yes") {
//         return msg.text.length > 50
//             ? "${msg.text.substring(0, 50)}..."
//             : msg.text;
//       }
//     }
//
//     return "Consultation completed";
//   }
//
//   void _showOrderDetails(ChatOrder order) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => OrderDetailPage(order: order),
//       ),
//     );
//   }
//
//   Widget _buildOrderCard(ChatOrder order) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: () => _showOrderDetails(order),
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           "Order ${order.orderNumber}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: order.paymentCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: order.paymentCompleted ? Colors.green : Colors.orange,
//                             width: 1,
//                           ),
//                         ),
//                         child: Text(
//                           order.status,
//                           style: TextStyle(
//                             color: order.paymentCompleted ? Colors.green.shade700 : Colors.orange.shade700,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == 'delete') {
//                         _showDeleteConfirmation(order.orderNumber);
//                       }
//                     },
//                     itemBuilder: (BuildContext context) => [
//                       const PopupMenuItem<String>(
//                         value: 'delete',
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete, color: Colors.red, size: 20),
//                             SizedBox(width: 8),
//                             Text('Delete'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Icon(Icons.medical_services, color: AppColors.primary, size: 16),
//                   const SizedBox(width: 6),
//                   Text(
//                     "${order.doctorType ?? 'General'} ${order.doctorCategory != null ? '• ${order.doctorCategory}' : ''}",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[700],
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _getOrderSummary(order),
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                   height: 1.3,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.access_time, color: Colors.grey[500], size: 14),
//                       const SizedBox(width: 4),
//                       Text(
//                         DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
//                         style: TextStyle(
//                           color: Colors.grey[500],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.message, color: Colors.grey[500], size: 14),
//                       const SizedBox(width: 4),
//                       Text(
//                         "${order.messages.length} messages",
//                         style: TextStyle(
//                           color: Colors.grey[500],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteConfirmation(String orderNumber) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Order'),
//           content: Text('Are you sure you want to delete Order #$orderNumber? This action cannot be undone.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _deleteOrder(orderNumber);
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               child: const Text('Delete', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "My Orders",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             onPressed: _loadOrders,
//             icon: const Icon(Icons.refresh),
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : orders.isEmpty
//           ? _buildEmptyState()
//           : RefreshIndicator(
//         onRefresh: _loadOrders,
//         child: ListView.builder(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           itemCount: orders.length,
//           itemBuilder: (context, index) {
//             return _buildOrderCard(orders[index]);
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.receipt_long_outlined,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               "No Orders Yet",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Your completed consultations will appear here",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/home');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text("Start New Consultation"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Order Detail Page
// class OrderDetailPage extends StatefulWidget {
//   final ChatOrder order;
//
//   const OrderDetailPage({super.key, required this.order});
//
//   @override
//   State<OrderDetailPage> createState() => _OrderDetailPageState();
// }
//
// class _OrderDetailPageState extends State<OrderDetailPage> {
//   final ScrollController _scrollController = ScrollController();
//
//   Widget _buildMessageBubble(Message msg) {
//     final isBot = msg.isBot;
//     return Align(
//       alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.all(12),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         decoration: BoxDecoration(
//           color: msg.filePath != null
//               ? Colors.white
//               : (isBot ? AppColors.chatBot : AppColors.chatUser),
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(16),
//             bottomRight: isBot ? const Radius.circular(16) : const Radius.circular(0),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 3,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               msg.text,
//               style: TextStyle(
//                 color: isBot ? AppColors.chatBotText : AppColors.chatUserText,
//                 fontSize: 15,
//               ),
//             ),
//             if (msg.createdAt != null) ...[
//               const SizedBox(height: 4),
//               Text(
//                 DateFormat('hh:mm a').format(msg.createdAt!.toLocal()),
//                 style: TextStyle(
//                   color: (isBot ? AppColors.chatBotText : AppColors.chatUserText).withOpacity(0.7),
//                   fontSize: 10,
//                 ),
//               ),
//             ],
//             if (msg.filePath != null) ...[
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.attachment,
//                     size: 14,
//                     color: (isBot ? AppColors.chatBotText : AppColors.chatUserText).withOpacity(0.7),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     "Attachment",
//                     style: TextStyle(
//                       color: (isBot ? AppColors.chatBotText : AppColors.chatUserText).withOpacity(0.7),
//                       fontSize: 10,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);
//
//   bool _isSameDay(DateTime d1, DateTime d2) =>
//       d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Order ${widget.order.orderNumber}",
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'info') {
//                 _showOrderInfo();
//               }
//             },
//             itemBuilder: (BuildContext context) => [
//               const PopupMenuItem<String>(
//                 value: 'info',
//                 child: Row(
//                   children: [
//                     Icon(Icons.info_outline),
//                     SizedBox(width: 8),
//                     Text('Order Info'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Order summary header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.05),
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey.shade200),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.medical_services, color: AppColors.primary, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       "${widget.order.doctorType ?? 'General'} ${widget.order.doctorCategory != null ? '• ${widget.order.doctorCategory}' : ''}",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: widget.order.paymentCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: widget.order.paymentCompleted ? Colors.green : Colors.orange,
//                           width: 1,
//                         ),
//                       ),
//                       child: Text(
//                         widget.order.status,
//                         style: TextStyle(
//                           color: widget.order.paymentCompleted ? Colors.green.shade700 : Colors.orange.shade700,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.access_time, color: Colors.grey[600], size: 14),
//                     const SizedBox(width: 4),
//                     Text(
//                       DateFormat('MMM dd, yyyy • hh:mm a').format(widget.order.createdAt),
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Chat messages
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               itemCount: widget.order.messages.length,
//               itemBuilder: (context, index) {
//                 final msg = widget.order.messages[index];
//
//                 // Check if date separator should be shown
//                 bool showDate = false;
//                 if (index == 0 && msg.createdAt != null) {
//                   showDate = true;
//                 } else if (index > 0 && msg.createdAt != null) {
//                   final prevMsg = widget.order.messages[index - 1];
//                   if (prevMsg.createdAt != null) {
//                     showDate = !_isSameDay(msg.createdAt!, prevMsg.createdAt!);
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
//                           decoration: BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             _formatDate(msg.createdAt!),
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     _buildMessageBubble(msg),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showOrderInfo() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Order ${widget.order.orderNumber} Details"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildInfoRow("Doctor Type:", widget.order.doctorType ?? "General"),
//               if (widget.order.doctorCategory != null)
//                 _buildInfoRow("Specialty:", widget.order.doctorCategory!),
//               _buildInfoRow("Status:", widget.order.status),
//               _buildInfoRow("Payment:", widget.order.paymentCompleted ? "Completed" : "Pending"),
//               _buildInfoRow("Messages:", "${widget.order.messages.length}"),
//               _buildInfoRow("Date:", DateFormat('MMM dd, yyyy • hh:mm a').format(widget.order.createdAt)),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'helper.dart';
import 'order_models.dart'; // Import the shared models

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<ChatOrder> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedOrdersJson = prefs.getStringList('saved_orders');

      if (savedOrdersJson != null && savedOrdersJson.isNotEmpty) {
        orders = savedOrdersJson
            .map((orderJson) => ChatOrder.fromMap(jsonDecode(orderJson)))
            .toList();

        // Sort orders by creation date (newest first)
        orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      debugPrint("Error loading orders: $e");
      Helpers.showSnackBar(context, "Error loading orders", bgColor: Colors.red);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteOrder(String orderNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Remove order from list
      orders.removeWhere((order) => order.orderNumber == orderNumber);

      // Save updated list back to preferences
      List<String> updatedOrdersJson = orders
          .map((order) => jsonEncode(order.toMap()))
          .toList();

      await prefs.setStringList('saved_orders', updatedOrdersJson);

      setState(() {});

      Helpers.showSnackBar(
          context,
          "Order #$orderNumber deleted successfully",
          bgColor: AppColors.accent
      );
    } catch (e) {
      debugPrint("Error deleting order: $e");
      Helpers.showSnackBar(context, "Error deleting order", bgColor: Colors.red);
    }
  }

  String _getOrderSummary(ChatOrder order) {
    if (order.patientQuery != null && order.patientQuery!.isNotEmpty) {
      return order.patientQuery!.length > 50
          ? "${order.patientQuery!.substring(0, 50)}..."
          : order.patientQuery!;
    }

    // Find last user message
    for (OrderMessage msg in order.messages.reversed) {
      if (!msg.isBot && !msg.isSystem && msg.text.isNotEmpty && msg.text != "Yes") {
        return msg.text.length > 50
            ? "${msg.text.substring(0, 50)}..."
            : msg.text;
      }
    }

    return "Consultation completed";
  }

  void _showOrderDetails(ChatOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(order: order),
      ),
    );
  }

  Widget _buildOrderCard(ChatOrder order) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Order ${order.orderNumber}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.paymentCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: order.paymentCompleted ? Colors.green : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            color: order.paymentCompleted ? Colors.green.shade700 : Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(order.orderNumber);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.medical_services, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "${order.doctorType ?? 'General'} ${order.doctorCategory != null ? '• ${order.doctorCategory}' : ''}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _getOrderSummary(order),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[500], size: 14),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.message, color: Colors.grey[500], size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${order.messages.length} messages",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String orderNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Order'),
          content: Text('Are you sure you want to delete Order #$orderNumber? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteOrder(orderNumber);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : orders.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _loadOrders,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(orders[index]);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No Orders Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your completed consultations will appear here",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Start New Consultation"),
            ),
          ],
        ),
      ),
    );
  }
}

// Order Detail Page
class OrderDetailPage extends StatefulWidget {
  final ChatOrder order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final ScrollController _scrollController = ScrollController();

  Widget _buildMessageBubble(OrderMessage msg) {
    final isBot = msg.isBot;
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: msg.filePath != null
              ? Colors.white
              : (isBot ? AppColors.chatBot : AppColors.chatUser),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(16),
            bottomRight: isBot ? const Radius.circular(16) : const Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: isBot ? AppColors.chatBotText : AppColors.chatUserText,
                fontSize: 15,
              ),
            ),
            if (msg.createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                DateFormat('hh:mm a').format(msg.createdAt!.toLocal()),
                style: TextStyle(
                  color: (isBot ? AppColors.chatBotText : AppColors.chatUserText).withOpacity(0.7),
                  fontSize: 10,
                ),
              ),
            ],
            if (msg.filePath != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.attachment,
                    size: 14,
                    color: (isBot ? AppColors.chatBotText : AppColors.chatUserText).withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Attachment",
                    style: TextStyle(
                      color: (isBot ? AppColors.chatBotText : AppColors.chatUserText).withOpacity(0.7),
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  bool _isSameDay(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order ${widget.order.orderNumber}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'info') {
                _showOrderInfo();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 8),
                    Text('Order Info'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Order summary header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_services, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "${widget.order.doctorType ?? 'General'} ${widget.order.doctorCategory != null ? '• ${widget.order.doctorCategory}' : ''}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.order.paymentCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.order.paymentCompleted ? Colors.green : Colors.orange,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.order.status,
                        style: TextStyle(
                          color: widget.order.paymentCompleted ? Colors.green.shade700 : Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, color: Colors.grey[600], size: 14),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a').format(widget.order.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.order.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.order.messages[index];

                // Check if date separator should be shown
                bool showDate = false;
                if (index == 0 && msg.createdAt != null) {
                  showDate = true;
                } else if (index > 0 && msg.createdAt != null) {
                  final prevMsg = widget.order.messages[index - 1];
                  if (prevMsg.createdAt != null) {
                    showDate = !_isSameDay(msg.createdAt!, prevMsg.createdAt!);
                  }
                }

                return Column(
                  children: [
                    if (showDate && msg.createdAt != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _formatDate(msg.createdAt!),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    _buildMessageBubble(msg),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order ${widget.order.orderNumber} Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow("Doctor Type:", widget.order.doctorType ?? "General"),
              if (widget.order.doctorCategory != null)
                _buildInfoRow("Specialty:", widget.order.doctorCategory!),
              _buildInfoRow("Status:", widget.order.status),
              _buildInfoRow("Payment:", widget.order.paymentCompleted ? "Completed" : "Pending"),
              _buildInfoRow("Messages:", "${widget.order.messages.length}"),
              _buildInfoRow("Date:", DateFormat('MMM dd, yyyy • hh:mm a').format(widget.order.createdAt)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}