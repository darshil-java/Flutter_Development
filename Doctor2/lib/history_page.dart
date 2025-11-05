// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'order.dart';
// import 'order_chat_page.dart';
// import 'helper.dart';
//
// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});
//
//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }
//
// class _HistoryPageState extends State<HistoryPage> {
//   bool isLoading = true;
//   List<Order> completedOrders = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCompletedOrders();
//   }
//
//   Future<void> _fetchCompletedOrders() async {
//     try {
//       final url = Uri.parse("${ApiConfig.baseUrl}/getOrders");
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         final dataList = decoded['data'] as List?;
//
//         if (dataList != null) {
//           // Filter only completed orders
//           final completedOrdersList = dataList.where((order) {
//             final status = order['status']?.toString().toLowerCase();
//             return status == 'completed';
//           }).toList();
//
//           setState(() {
//             completedOrders = completedOrdersList.map((e) => Order.fromMap(e)).toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             completedOrders = [];
//             isLoading = false;
//           });
//         }
//       } else {
//         throw Exception('Failed to load orders: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Error fetching completed orders: $e');
//       setState(() {
//         isLoading = false;
//       });
//       if (mounted) {
//         Helpers.showSnackBar(context, "Failed to load history", bgColor: Colors.red);
//       }
//     }
//   }
//
//   Widget _buildHistoryTile(Order order) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             // Navigate to chat page in read-only mode
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => OrderChatPage(
//                   order: order,
//                   isReadOnly: true, // Important: Set to read-only
//                 ),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.check_circle,
//                         color: Colors.green,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             order.userName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Order ID: ${order.orderId}",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "Completed",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.green[700],
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Divider(color: Colors.grey[300], height: 1),
//                 const SizedBox(height: 12),
//                 if (order.completedAt != null) ...[
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_today,
//                         size: 16,
//                         color: Colors.grey[600],
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Completed: ${_formatDate(order.completedAt!)}",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.person_outline,
//                       size: 16,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "User ID: ${order.userId}",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.visibility,
//                         size: 16,
//                         color: Colors.blue,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "View chat history",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
//     } catch (e) {
//       return dateString;
//     }
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.history_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No completed orders',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Your completed consultation orders will appear here',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: _fetchCompletedOrders,
//             icon: const Icon(Icons.refresh),
//             label: const Text('Refresh'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: AppColors.iconColor),
//         title: const Text(
//           "History",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _fetchCompletedOrders,
//             icon: Icon(Icons.refresh, color: AppColors.iconColor),
//             tooltip: 'Refresh history',
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : completedOrders.isEmpty
//           ? _buildEmptyState()
//           : RefreshIndicator(
//         onRefresh: _fetchCompletedOrders,
//         color: AppColors.primary,
//         child: ListView.builder(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           itemCount: completedOrders.length,
//           itemBuilder: (context, index) {
//             final order = completedOrders[index];
//             return _buildHistoryTile(order);
//           },
//         ),
//       ),
//     );
//   }
// }

//....................................................................................... URVISH..................


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';
import 'order_chat_page.dart';
import 'helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isLoading = true;
  List<Order> completedOrders = [];
  String? doctorType;
  String? doctorId;

  @override
  void initState() {
    super.initState();
    _loadDoctorInfo();
    _fetchCompletedOrders();
  }

  Future<void> _loadDoctorInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorType = prefs.getString('doctorType');
      doctorId = prefs.getString('doctorId');
    });
  }

  Future<void> _fetchCompletedOrders() async {
    try {
      // ✅ Get doctor information from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final doctorType = prefs.getString('doctorType');
      final doctorId = prefs.getString('doctorId');

      print('🔄 Fetching completed orders for doctor: $doctorType');

      if (doctorType == null || doctorId == null) {
        print('❌ Doctor information not available');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // ✅ Send doctor information to backend
      final url = Uri.parse("${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId");
      final response = await http.get(url);

      print("📦 History Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final dataList = decoded['data'] as List?;

        if (dataList != null) {
          // Filter only completed orders
          final completedOrdersList = dataList.where((order) {
            final status = order['status']?.toString().toLowerCase();
            return status == 'completed';
          }).toList();

          setState(() {
            completedOrders = completedOrdersList.map((e) => Order.fromMap(e)).toList();
            isLoading = false;
          });

          print('✅ Loaded ${completedOrders.length} completed $doctorType orders');
        } else {
          setState(() {
            completedOrders = [];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching completed orders: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        Helpers.showSnackBar(context, "Failed to load history", bgColor: Colors.red);
      }
    }
  }

  Widget _buildHistoryTile(Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to chat page in read-only mode
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderChatPage(
                  order: order,
                  isReadOnly: true, // Important: Set to read-only
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Order ID: ${order.orderId}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (doctorType != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              "Type: $doctorType",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[300], height: 1),
                const SizedBox(height: 12),
                if (order.completedAt != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Completed: ${_formatDate(order.completedAt!)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "User ID: ${order.userId}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "View chat history",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No completed orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          if (doctorType != null)
            Text(
              'No completed $doctorType consultations found',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchCompletedOrders,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (doctorType != null)
              Text(
                "$doctorType Consultations",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _fetchCompletedOrders,
            icon: Icon(Icons.refresh, color: AppColors.iconColor),
            tooltip: 'Refresh history',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : completedOrders.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _fetchCompletedOrders,
        color: AppColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: completedOrders.length,
          itemBuilder: (context, index) {
            final order = completedOrders[index];
            return _buildHistoryTile(order);
          },
        ),
      ),
    );
  }
}