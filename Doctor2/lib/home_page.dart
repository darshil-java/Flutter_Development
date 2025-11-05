// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'order.dart';
// // import 'order_chat_page.dart';
// // import 'helper.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   String? userId;
// //   String? userName;
// //   String? doctorId;
// //   String? doctorType;
// //   String? speciality;
// //   bool isLoading = true;
// //   List<Order> assignedOrders = [];
// //   List<Order> availableOrders = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadDoctorProfileAndOrders();
// //   }
// //
// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     // Refresh orders when returning to home page
// //     _fetchOrders();
// //   }
// //
// //   Future<void> _loadDoctorProfileAndOrders() async {
// //     final prefs = await SharedPreferences.getInstance();
// //
// //     // ✅ Get data with proper null safety
// //     final storedUserId = prefs.getString('userId');
// //     final storedUserName = prefs.getString('name') ?? 'User';
// //     final storedIsDoctor = prefs.getBool('isDoctor') ?? false;
// //
// //     print('🔍 Loading user profile:');
// //     print('  - userId: "$storedUserId"');
// //     print('  - userName: $storedUserName');
// //     print('  - isDoctor: $storedIsDoctor');
// //
// //     // ✅ FIX: Proper null safety check for userId
// //     if (storedUserId == null || storedUserId.isEmpty) {
// //       print('❌ CRITICAL: userId is empty in SharedPreferences!');
// //
// //       // Try to get user ID from other possible locations
// //       final doctorId = prefs.getString('doctorId');
// //       if (doctorId != null && doctorId.isNotEmpty) {
// //         print('🔄 Using doctorId as userId: $doctorId');
// //         await prefs.setString('userId', doctorId);
// //         setState(() {
// //           userId = doctorId;
// //           userName = storedUserName;
// //         });
// //       } else {
// //         if (mounted) {
// //           Helpers.showSnackBar(
// //               context,
// //               "Login session expired. Please login again.",
// //               bgColor: Colors.red
// //           );
// //           Navigator.pushReplacementNamed(context, '/login');
// //         }
// //         return;
// //       }
// //     } else {
// //       setState(() {
// //         userId = storedUserId;
// //         userName = storedUserName;
// //       });
// //     }
// //
// //     // ✅ Only load doctor data if user is a doctor
// //     if (storedIsDoctor == true) {
// //       final storedDoctorId = prefs.getString('doctorId') ?? userId;
// //       final storedDoctorType = prefs.getString('doctorType') ?? prefs.getString('type') ?? '';
// //       final storedSpeciality = prefs.getString('speciality') ?? '';
// //
// //       setState(() {
// //         doctorId = storedDoctorId;
// //         doctorType = storedDoctorType;
// //         speciality = storedSpeciality;
// //       });
// //
// //       print('👨‍⚕ Doctor data loaded:');
// //       print('  - doctorId: $doctorId');
// //       print('  - doctorType: $doctorType');
// //       print('  - speciality: $speciality');
// //
// //       // ✅ FIX: Proper null safety check for doctor data
// //       final hasDoctorType = storedDoctorType != null && storedDoctorType.isNotEmpty;
// //       final hasSpeciality = storedSpeciality != null && storedSpeciality.isNotEmpty;
// //
// //       if (!hasDoctorType || !hasSpeciality) {
// //         print('⚠ Doctor data incomplete - checking registration data...');
// //
// //         // Try to get from registration data
// //         final regType = prefs.getString('type');
// //         final regSpeciality = prefs.getString('speciality');
// //
// //         if (regType != null && regType.isNotEmpty) {
// //           print('🔄 Using registration data: type=$regType, speciality=$regSpeciality');
// //           setState(() {
// //             doctorType = regType;
// //             speciality = regSpeciality ?? '';
// //           });
// //           await prefs.setString('doctorType', regType);
// //           if (regSpeciality != null) {
// //             await prefs.setString('speciality', regSpeciality);
// //           }
// //         }
// //       }
// //
// //       await _fetchOrders();
// //     } else {
// //       print('👤 Regular user - no orders to fetch');
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> _fetchOrders() async {
// //     if (doctorId == null || doctorType == null || speciality == null) {
// //       print('❌ Doctor information not available');
// //       print('🔍 doctorId: $doctorId, doctorType: $doctorType, speciality: $speciality');
// //       setState(() {
// //         isLoading = false;
// //       });
// //       return;
// //     }
// //
// //     try {
// //       setState(() {
// //         isLoading = true;
// //       });
// //
// //       print('🔄 Fetching orders for doctor: $doctorId');
// //       print('🔍 Doctor Type: $doctorType, Speciality: $speciality');
// //
// //       // ✅ FIX: Send doctor information to backend using query parameters
// //       final allOrdersUrl = Uri.parse("${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId");
// //       print('📤 All Orders URL with doctor filter: $allOrdersUrl');
// //
// //       final allOrdersResponse = await http.get(allOrdersUrl);
// //
// //       print("📦 All Orders Response Status: ${allOrdersResponse.statusCode}");
// //       print("📦 All Orders Response Body: ${allOrdersResponse.body}");
// //
// //       if (allOrdersResponse.statusCode == 200) {
// //         final decoded = jsonDecode(allOrdersResponse.body);
// //         final allOrdersData = decoded['data'] as List? ?? [];
// //
// //         print('📥 Loaded ${allOrdersData.length} $doctorType orders from backend');
// //
// //         // Filter assigned orders for this doctor
// //         final assignedOrdersList = allOrdersData.where((order) {
// //           final isAssignedToMe = order['assignedDoctorId'] == doctorId;
// //           final isActive = order['status'] != 'completed' && order['status'] != 'cancelled';
// //           return isAssignedToMe && isActive;
// //         }).toList();
// //
// //         // Filter available orders matching doctor's specialization
// //         final availableOrdersList = allOrdersData.where((order) {
// //           final matchesSpecialization = order['doctorType'] == doctorType;
// //           final isUnassigned = order['assignedDoctorId'] == null ||
// //               order['assignedDoctorId'] == '';
// //           final isPending = order['status'] == 'pending' ||
// //               order['status'] == 'unassigned' ||
// //               order['status'] == 'waiting_for_doctor' ||
// //               order['status'] == 'pending_assignment';
// //           return matchesSpecialization && isUnassigned && isPending;
// //         }).toList();
// //
// //         setState(() {
// //           assignedOrders = assignedOrdersList.map((e) => Order.fromMap(e)).toList();
// //           availableOrders = availableOrdersList.map((e) => Order.fromMap(e)).toList();
// //         });
// //
// //         print('✅ Loaded ${assignedOrders.length} assigned orders');
// //         print('✅ Loaded ${availableOrders.length} available orders');
// //       } else {
// //         print('❌ Failed to load orders: ${allOrdersResponse.statusCode}');
// //         if (mounted) {
// //           Helpers.showSnackBar(context, "Failed to load orders", bgColor: Colors.red);
// //         }
// //       }
// //
// //     } catch (e) {
// //       print('❌ Error fetching orders: $e');
// //       if (mounted) {
// //         Helpers.showSnackBar(context, "Failed to load orders", bgColor: Colors.red);
// //       }
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> _acceptOrder(Order order) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse('${ApiConfig.baseUrl}/api/doctors/orders/accept'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           'orderId': order.orderId,
// //           'doctorId': doctorId,
// //           'doctorType': doctorType,
// //           'speciality': speciality,
// //         }),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           Helpers.showSnackBar(context, "Order accepted successfully!", bgColor: Colors.green);
// //           await _fetchOrders(); // Refresh the list
// //         } else {
// //           Helpers.showSnackBar(context, data['message'] ?? "Failed to accept order", bgColor: Colors.red);
// //         }
// //       } else {
// //         Helpers.showSnackBar(context, "Failed to accept order", bgColor: Colors.red);
// //       }
// //     } catch (e) {
// //       print('❌ Error accepting order: $e');
// //       Helpers.showSnackBar(context, "Error accepting order", bgColor: Colors.red);
// //     }
// //   }
// //
// //   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
// //     return ListTile(
// //       leading: Icon(icon, size: 25, color: AppColors.iconColor),
// //       title: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Text(
// //           title,
// //           style: const TextStyle(
// //             fontSize: 15,
// //             fontWeight: FontWeight.bold,
// //             color: Colors.white,
// //           ),
// //         ),
// //       ),
// //       onTap: onTap,
// //     );
// //   }
// //
// //   Widget _buildOrderTile(Order order, bool isAssigned) {
// //     final isCompleted = order.status?.toLowerCase() == 'completed';
// //
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: isCompleted ? Colors.grey[100] : Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //             color: isCompleted
// //                 ? Colors.grey.withOpacity(0.3)
// //                 : AppColors.primary.withOpacity(0.3),
// //             width: 1.2
// //         ),
// //         boxShadow: isCompleted
// //             ? []
// //             : [
// //           BoxShadow(
// //             color: AppColors.primary.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           borderRadius: BorderRadius.circular(16),
// //           onTap: isCompleted
// //               ? null // Disable tap for completed orders
// //               : () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (_) => OrderChatPage(
// //                   order: order,
// //                   onSessionEnded: _fetchOrders,
// //                 ),
// //               ),
// //             ).then((value) {
// //               if (value == true) {
// //                 _fetchOrders();
// //               }
// //             });
// //           },
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.all(10),
// //                       decoration: BoxDecoration(
// //                         color: isCompleted
// //                             ? Colors.grey.withOpacity(0.2)
// //                             : AppColors.primary.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Icon(
// //                         isCompleted ? Icons.check_circle : Icons.medical_services,
// //                         color: isCompleted ? Colors.grey : AppColors.primary,
// //                         size: 24,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             order.userName,
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                               color: isCompleted ? Colors.grey : Colors.black87,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Text(
// //                             "Order ID: ${order.orderId}",
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               color: isCompleted ? Colors.grey : Colors.grey[600],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     // Show status badge
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         color: _getStatusColor(order.status ?? 'active'),
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Text(
// //                         _getStatusText(order.status ?? 'active'),
// //                         style: const TextStyle(
// //                           fontSize: 10,
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                     if (!isAssigned && !isCompleted)
// //                       const SizedBox(width: 8),
// //                     if (!isAssigned && !isCompleted)
// //                       Icon(
// //                         Icons.add_circle,
// //                         color: AppColors.accent,
// //                         size: 24,
// //                       ),
// //                     if (isAssigned && !isCompleted)
// //                       const SizedBox(width: 8),
// //                     if (isAssigned && !isCompleted)
// //                       Icon(
// //                         Icons.arrow_forward_ios,
// //                         color: AppColors.primary,
// //                         size: 18,
// //                       ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),
// //                 Divider(color: Colors.grey[300], height: 1),
// //                 const SizedBox(height: 12),
// //                 Row(
// //                   children: [
// //                     Icon(
// //                       Icons.person_outline,
// //                       size: 18,
// //                       color: isCompleted ? Colors.grey : AppColors.accent,
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Text(
// //                       "User ID: ${order.userId}",
// //                       style: TextStyle(
// //                         fontSize: 13,
// //                         color: isCompleted ? Colors.grey : Colors.grey[700],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 if (order.doctorType != null) ...[
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     children: [
// //                       Icon(
// //                         Icons.medical_information_outlined,
// //                         size: 18,
// //                         color: isCompleted ? Colors.grey : AppColors.accent,
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         order.doctorType!,
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: isCompleted ? Colors.grey : Colors.grey[700],
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //                 if (order.speciality != null) ...[
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     children: [
// //                       Icon(
// //                         Icons.local_hospital_outlined,
// //                         size: 18,
// //                         color: isCompleted ? Colors.grey : AppColors.accent,
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         order.speciality!,
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: isCompleted ? Colors.grey : Colors.grey[700],
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //                 // Show assigned doctor info
// //                 if (order.assignedDoctorName != null && isAssigned) ...[
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     children: [
// //                       Icon(
// //                         Icons.verified_user,
// //                         size: 18,
// //                         color: isCompleted ? Colors.grey : Colors.green,
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         "Assigned to you",
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: isCompleted ? Colors.grey : Colors.green,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //                 const SizedBox(height: 12),
// //                 if (!isAssigned && !isCompleted)
// //                   ElevatedButton(
// //                     onPressed: () => _acceptOrder(order),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: AppColors.accent,
// //                       foregroundColor: Colors.white,
// //                       minimumSize: const Size(double.infinity, 40),
// //                     ),
// //                     child: const Text("Accept Consultation"),
// //                   ),
// //                 if (isAssigned && !isCompleted)
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: AppColors.accent.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Icon(
// //                           Icons.touch_app,
// //                           size: 16,
// //                           color: AppColors.accent,
// //                         ),
// //                         const SizedBox(width: 6),
// //                         Text(
// //                           "Tap to start consultation",
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             color: AppColors.accent,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 if (isCompleted)
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Icon(
// //                           Icons.visibility,
// //                           size: 16,
// //                           color: Colors.grey,
// //                         ),
// //                         const SizedBox(width: 6),
// //                         Text(
// //                           "Completed - View only",
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             color: Colors.grey,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Color _getStatusColor(String status) {
// //     switch (status.toLowerCase()) {
// //       case 'completed':
// //         return Colors.grey;
// //       case 'pending':
// //         return Colors.orange;
// //       case 'assigned':
// //         return Colors.blue;
// //       case 'in progress':
// //         return Colors.purple;
// //       case 'active':
// //         return Colors.green;
// //       default:
// //         return AppColors.primary;
// //     }
// //   }
// //
// //   String _getStatusText(String status) {
// //     switch (status.toLowerCase()) {
// //       case 'completed':
// //         return 'COMPLETED';
// //       case 'pending':
// //         return 'PENDING';
// //       case 'assigned':
// //         return 'ASSIGNED';
// //       case 'in progress':
// //         return 'IN PROGRESS';
// //       case 'active':
// //         return 'ACTIVE';
// //       default:
// //         return status.toUpperCase();
// //     }
// //   }
// //
// //   Widget _buildSection(String title, List<Order> orders, bool isAssigned) {
// //     if (orders.isEmpty) return const SizedBox();
// //
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Text(
// //             title,
// //             style: const TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black87,
// //             ),
// //           ),
// //         ),
// //         ...orders.map((order) => _buildOrderTile(order, isAssigned)).toList(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(
// //             Icons.medical_services_outlined,
// //             size: 80,
// //             color: Colors.grey[400],
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             'No consultations available',
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.w600,
// //               color: Colors.grey[700],
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           if (doctorType != null && speciality != null)
// //             Text(
// //               'You are registered as $speciality $doctorType doctor',
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: Colors.grey[600],
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           const SizedBox(height: 4),
// //           Text(
// //             'New consultations matching your specialization will appear here',
// //             style: TextStyle(
// //               fontSize: 14,
// //               color: Colors.grey[600],
// //             ),
// //             textAlign: TextAlign.center,
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton.icon(
// //             onPressed: _fetchOrders,
// //             icon: const Icon(Icons.refresh),
// //             label: const Text('Refresh'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: AppColors.primary,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (isLoading || userId == null) {
// //       return Scaffold(
// //         backgroundColor: Colors.grey[50],
// //         appBar: AppBar(
// //           iconTheme: IconThemeData(color: AppColors.iconColor),
// //           backgroundColor: AppColors.primary,
// //           title: const Text(
// //             "Doctor Dashboard",
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ),
// //         body: const Center(child: CircularProgressIndicator()),
// //       );
// //     }
// //
// //     final hasAssignedOrders = assignedOrders.isNotEmpty;
// //     final hasAvailableOrders = availableOrders.isNotEmpty;
// //     final totalOrders = assignedOrders.length + availableOrders.length;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       appBar: AppBar(
// //         iconTheme: IconThemeData(color: AppColors.iconColor),
// //         backgroundColor: AppColors.primary,
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               "Doctor Dashboard",
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             if (doctorType != null && speciality != null)
// //               Text(
// //                 "$speciality $doctorType",
// //                 style: const TextStyle(
// //                   color: Colors.white70,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //           ],
// //         ),
// //         actions: [
// //           if (totalOrders > 0)
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.2),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Text(
// //                 '$totalOrders',
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //           const SizedBox(width: 8),
// //           // IconButton(
// //           //   onPressed: _fetchOrders,
// //           //   icon: Icon(Icons.refresh, color: AppColors.iconColor),
// //           //   tooltip: 'Refresh orders',
// //           // ),
// //           IconButton(
// //             onPressed: () => Navigator.pushNamed(context, '/profile'),
// //             icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor),
// //           ),
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
// //                     Text(
// //                       userName ?? "Doctor",
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     if (doctorType != null && speciality != null)
// //                       Text(
// //                         "$speciality $doctorType",
// //                         style: const TextStyle(
// //                           color: Colors.white70,
// //                           fontSize: 12,
// //                         ),
// //                       ),
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
// //               Divider(
// //                 color: AppColors.iconColor,
// //                 thickness: 2,
// //                 indent: 12,
// //                 endIndent: 12,
// //               ),
// //               Expanded(
// //                 child: ListView(
// //                   padding: EdgeInsets.zero,
// //                   children: [
// //                     drawerItem("Dashboard", Icons.dashboard, () {
// //                       Navigator.pop(context);
// //                       _fetchOrders();
// //                     }),
// //                     // drawerItem("Assigned Consultations", Icons.assignment_ind, () {
// //                     //   Navigator.pop(context);
// //                     //   // Scroll to assigned section
// //                     // }),
// //                     // drawerItem("Available Consultations", Icons.assignment, () {
// //                     //   Navigator.pop(context);
// //                     //   // Scroll to available section
// //                     // }),
// //                     drawerItem("History", Icons.history, () {
// //                       Navigator.pop(context);
// //                       Navigator.pushNamed(context, '/history');
// //                     }),
// //                     drawerItem("Terms & Privacy", Icons.privacy_tip, () {
// //                       Navigator.pop(context);
// //                       Navigator.pushNamed(context, '/terms');
// //                     }),
// //                     drawerItem("Log Out", Icons.logout_sharp, () async {
// //                       Navigator.pop(context);
// //                       bool? confirm = await showDialog<bool>(
// //                         context: context,
// //                         builder: (context) => AlertDialog(
// //                           title: const Text("Confirm Logout"),
// //                           content: const Text("Are you sure you want to logout?"),
// //                           actions: [
// //                             TextButton(
// //                               onPressed: () => Navigator.pop(context, false),
// //                               child: const Text("Cancel"),
// //                             ),
// //                             TextButton(
// //                               onPressed: () => Navigator.pop(context, true),
// //                               child: const Text("Logout"),
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
// //                           final url = Uri.parse("${ApiConfig.baseUrl}/logoutDoctor");
// //                           final response = await http.post(
// //                             url,
// //                             headers: {
// //                               'Content-Type': 'application/json',
// //                               if (token != null) 'Authorization': 'Bearer $token',
// //                             },
// //                           );
// //
// //                           if (response.statusCode == 200) {
// //                             await prefs.clear();
// //                             if (mounted) {
// //                               Navigator.pushNamedAndRemoveUntil(
// //                                 context,
// //                                 '/login',
// //                                     (route) => false,
// //                               );
// //                             }
// //                           } else {
// //                             Helpers.showSnackBar(
// //                               context,
// //                               "Failed to logout from server",
// //                               bgColor: Colors.red,
// //                             );
// //                           }
// //                         } catch (e) {
// //                           print('❌ Logout error: $e');
// //                           Helpers.showSnackBar(
// //                             context,
// //                             "Error logging out",
// //                             bgColor: Colors.red,
// //                           );
// //                         }
// //                       }
// //                     }),
// //                   ],
// //                 ),
// //               ),
// //               Divider(
// //                 color: AppColors.iconColor,
// //                 thickness: 2,
// //                 indent: 12,
// //                 endIndent: 12,
// //               ),
// //               const Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 80),
// //                 child: Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
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
// //       body: totalOrders == 0
// //           ? _buildEmptyState()
// //           : RefreshIndicator(
// //         onRefresh: _fetchOrders,
// //         color: AppColors.primary,
// //         child: ListView(
// //           children: [
// //             _buildSection("Your Assigned Consultations", assignedOrders, true),
// //             _buildSection("Available Consultations", availableOrders, false),
// //           ],
// //         ),
// //       ),
// //       // floatingActionButton: FloatingActionButton(
// //       //   onPressed: _fetchOrders,
// //       //   backgroundColor: AppColors.primary,
// //       //   foregroundColor: Colors.white,
// //       //   tooltip: 'Refresh orders',
// //       //   child: const Icon(Icons.refresh),
// //       // ),
// //     );
// //   }
// // }
//
//
//
//
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'order.dart';
// import 'order_chat_page.dart';
// import 'helper.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   String? userId;
//   String? userName;
//   String? doctorId;
//   String? doctorType;
//   String? speciality;
//   bool isLoading = true;
//   List<Order> assignedOrders = [];
//   List<Order> availableOrders = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadDoctorProfileAndOrders();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Refresh orders when returning to home page
//     _fetchOrders();
//   }
//
//   Future<void> _loadDoctorProfileAndOrders() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // ✅ Get data with proper null safety
//     final storedUserId = prefs.getString('userId');
//     final storedUserName = prefs.getString('name') ?? 'User';
//     final storedIsDoctor = prefs.getBool('isDoctor') ?? false;
//
//     print('🔍 Loading user profile:');
//     print('  - userId: "$storedUserId"');
//     print('  - userName: $storedUserName');
//     print('  - isDoctor: $storedIsDoctor');
//
//     // ✅ FIX: Proper null safety check for userId
//     if (storedUserId == null || storedUserId.isEmpty) {
//       print('❌ CRITICAL: userId is empty in SharedPreferences!');
//
//       // Try to get user ID from other possible locations
//       final doctorId = prefs.getString('doctorId');
//       if (doctorId != null && doctorId.isNotEmpty) {
//         print('🔄 Using doctorId as userId: $doctorId');
//         await prefs.setString('userId', doctorId);
//         setState(() {
//           userId = doctorId;
//           userName = storedUserName;
//         });
//       } else {
//         if (mounted) {
//           Helpers.showSnackBar(
//               context,
//               "Login session expired. Please login again.",
//               bgColor: Colors.red
//           );
//           Navigator.pushReplacementNamed(context, '/login');
//         }
//         return;
//       }
//     } else {
//       setState(() {
//         userId = storedUserId;
//         userName = storedUserName;
//       });
//     }
//
//     // ✅ Only load doctor data if user is a doctor
//     if (storedIsDoctor == true) {
//       final storedDoctorId = prefs.getString('doctorId') ?? userId;
//       final storedDoctorType = prefs.getString('doctorType') ?? prefs.getString('type') ?? '';
//       final storedSpeciality = prefs.getString('speciality') ?? '';
//
//       setState(() {
//         doctorId = storedDoctorId;
//         doctorType = storedDoctorType;
//         speciality = storedSpeciality;
//       });
//
//       print('👨‍⚕ Doctor data loaded:');
//       print('  - doctorId: $doctorId');
//       print('  - doctorType: $doctorType');
//       print('  - speciality: $speciality');
//
//       // ✅ FIX: Proper null safety check for doctor data
//       final hasDoctorType = storedDoctorType != null && storedDoctorType.isNotEmpty;
//       final hasSpeciality = storedSpeciality != null && storedSpeciality.isNotEmpty;
//
//       if (!hasDoctorType || !hasSpeciality) {
//         print('⚠ Doctor data incomplete - checking registration data...');
//
//         // Try to get from registration data
//         final regType = prefs.getString('type');
//         final regSpeciality = prefs.getString('speciality');
//
//         if (regType != null && regType.isNotEmpty) {
//           print('🔄 Using registration data: type=$regType, speciality=$regSpeciality');
//           setState(() {
//             doctorType = regType;
//             speciality = regSpeciality ?? '';
//           });
//           await prefs.setString('doctorType', regType);
//           if (regSpeciality != null) {
//             await prefs.setString('speciality', regSpeciality);
//           }
//         }
//       }
//
//       await _fetchOrders();
//     } else {
//       print('👤 Regular user - no orders to fetch');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchOrders() async {
//     if (doctorId == null || doctorType == null || speciality == null) {
//       print('❌ Doctor information not available');
//       print('🔍 doctorId: $doctorId, doctorType: $doctorType, speciality: $speciality');
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }
//
//     try {
//       setState(() {
//         isLoading = true;
//       });
//
//       print('🔄 Fetching orders for doctor: $doctorId');
//       print('🔍 Doctor Type: $doctorType, Speciality: $speciality');
//
//       // ✅ FIX: Send doctor information to backend using query parameters
//       final allOrdersUrl = Uri.parse("${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId");
//       print('📤 All Orders URL with doctor filter: $allOrdersUrl');
//
//       final allOrdersResponse = await http.get(allOrdersUrl);
//
//       print("📦 All Orders Response Status: ${allOrdersResponse.statusCode}");
//       print("📦 All Orders Response Body: ${allOrdersResponse.body}");
//
//       if (allOrdersResponse.statusCode == 200) {
//         final decoded = jsonDecode(allOrdersResponse.body);
//         final allOrdersData = decoded['data'] as List? ?? [];
//
//         print('📥 Loaded ${allOrdersData.length} $doctorType orders from backend');
//
//         // Filter assigned orders for this doctor
//         final assignedOrdersList = allOrdersData.where((order) {
//           final isAssignedToMe = order['assignedDoctorId'] == doctorId;
//           final isActive = order['status'] != 'completed' && order['status'] != 'cancelled';
//           return isAssignedToMe && isActive;
//         }).toList();
//
//         // Filter available orders matching doctor's specialization
//         final availableOrdersList = allOrdersData.where((order) {
//           final matchesSpecialization = order['doctorType'] == doctorType;
//           final isUnassigned = order['assignedDoctorId'] == null ||
//               order['assignedDoctorId'] == '';
//           final isPending = order['status'] == 'pending' ||
//               order['status'] == 'unassigned' ||
//               order['status'] == 'waiting_for_doctor' ||
//               order['status'] == 'pending_assignment';
//           return matchesSpecialization && isUnassigned && isPending;
//         }).toList();
//
//         setState(() {
//           assignedOrders = assignedOrdersList.map((e) => Order.fromMap(e)).toList();
//           availableOrders = availableOrdersList.map((e) => Order.fromMap(e)).toList();
//         });
//
//         print('✅ Loaded ${assignedOrders.length} assigned orders');
//         print('✅ Loaded ${availableOrders.length} available orders');
//       } else {
//         print('❌ Failed to load orders: ${allOrdersResponse.statusCode}');
//         if (mounted) {
//           Helpers.showSnackBar(context, "Failed to load orders", bgColor: Colors.red);
//         }
//       }
//
//     } catch (e) {
//       print('❌ Error fetching orders: $e');
//       if (mounted) {
//         Helpers.showSnackBar(context, "Failed to load orders", bgColor: Colors.red);
//       }
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _acceptOrder(Order order) async {
//     try {
//       print('🔄 Accepting order: ${order.orderId}');
//       print('👨‍⚕ Doctor accepting: $doctorId ($doctorType - $speciality)');
//
//       setState(() {
//         isLoading = true;
//       });
//
//       final response = await http.post(
//         Uri.parse('${ApiConfig.baseUrl}/api/doctors/orders/accept'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'orderId': order.orderId,
//           'doctorId': doctorId,
//           'doctorType': doctorType,
//           'speciality': speciality,
//         }),
//       );
//
//       print('📡 Accept order response status: ${response.statusCode}');
//       print('📡 Accept order response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           Helpers.showSnackBar(context, "Order accepted successfully!", bgColor: Colors.green);
//
//           // Navigate directly to the chat page after successful acceptance
//           if (mounted) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => OrderChatPage(
//                   order: order.copyWith(
//                     assignedDoctorId: doctorId,
//                     assignedDoctorName: userName,
//                     status: 'assigned',
//                   ),
//                   onSessionEnded: _fetchOrders,
//                 ),
//               ),
//             ).then((value) {
//               // Refresh orders when returning from chat
//               _fetchOrders();
//             });
//           }
//         } else {
//           Helpers.showSnackBar(context, data['message'] ?? "Failed to accept order", bgColor: Colors.red);
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } else {
//         Helpers.showSnackBar(context, "Failed to accept order", bgColor: Colors.red);
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('❌ Error accepting order: $e');
//       Helpers.showSnackBar(context, "Error accepting order", bgColor: Colors.red);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void _openOrderChat(Order order) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => OrderChatPage(
//           order: order,
//           onSessionEnded: _fetchOrders,
//         ),
//       ),
//     ).then((value) {
//       if (value == true) {
//         _fetchOrders();
//       }
//     });
//   }
//
//   Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 25, color: AppColors.iconColor),
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildOrderTile(Order order, bool isAssigned) {
//     final isCompleted = order.status?.toLowerCase() == 'completed';
//     final isAccepted = isAssigned && order.assignedDoctorId == doctorId;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: isCompleted ? Colors.grey[100] : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//             color: isCompleted
//                 ? Colors.grey.withOpacity(0.3)
//                 : AppColors.primary.withOpacity(0.3),
//             width: 1.2
//         ),
//         boxShadow: isCompleted
//             ? []
//             : [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: isCompleted
//               ? null // Disable tap for completed orders
//               : isAccepted
//               ? () => _openOrderChat(order) // Open chat for accepted orders
//               : null, // No tap for unaccepted available orders
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
//                         color: isCompleted
//                             ? Colors.grey.withOpacity(0.2)
//                             : isAccepted
//                             ? Colors.green.withOpacity(0.1)
//                             : AppColors.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         isCompleted
//                             ? Icons.check_circle
//                             : isAccepted
//                             ? Icons.chat
//                             : Icons.medical_services,
//                         color: isCompleted
//                             ? Colors.grey
//                             : isAccepted
//                             ? Colors.green
//                             : AppColors.primary,
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
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: isCompleted ? Colors.grey : Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Order ID: ${order.orderId}",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: isCompleted ? Colors.grey : Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Show status badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor(order.status ?? 'active'),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _getStatusText(order.status ?? 'active'),
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     if (!isAssigned && !isCompleted)
//                       const SizedBox(width: 8),
//                     if (!isAssigned && !isCompleted)
//                       Icon(
//                         Icons.add_circle,
//                         color: AppColors.accent,
//                         size: 24,
//                       ),
//                     if (isAssigned && !isCompleted)
//                       const SizedBox(width: 8),
//                     if (isAssigned && !isCompleted)
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         color: AppColors.primary,
//                         size: 18,
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Divider(color: Colors.grey[300], height: 1),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.person_outline,
//                       size: 18,
//                       color: isCompleted ? Colors.grey : AppColors.accent,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "User ID: ${order.userId}",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: isCompleted ? Colors.grey : Colors.grey[700],
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (order.doctorType != null) ...[
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.medical_information_outlined,
//                         size: 18,
//                         color: isCompleted ? Colors.grey : AppColors.accent,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         order.doctorType!,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: isCompleted ? Colors.grey : Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 if (order.speciality != null) ...[
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.local_hospital_outlined,
//                         size: 18,
//                         color: isCompleted ? Colors.grey : AppColors.accent,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         order.speciality!,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: isCompleted ? Colors.grey : Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 // Show assigned doctor info
//                 if (order.assignedDoctorName != null && isAccepted) ...[
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.verified_user,
//                         size: 18,
//                         color: isCompleted ? Colors.grey : Colors.green,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Assigned to you",
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: isCompleted ? Colors.grey : Colors.green,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 const SizedBox(height: 12),
//                 // Show Accept button for available orders
//                 if (!isAssigned && !isCompleted)
//                   ElevatedButton(
//                     onPressed: () => _acceptOrder(order),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.accent,
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 40),
//                     ),
//                     child: const Text("Accept Consultation"),
//                   ),
//                 // Show chat access for assigned orders
//                 if (isAccepted && !isCompleted)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.chat,
//                           size: 16,
//                           color: Colors.green,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           "Tap to start consultation",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.green,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 if (isCompleted)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.visibility,
//                           size: 16,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           "Completed - View only",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Colors.grey;
//       case 'pending':
//         return Colors.orange;
//       case 'assigned':
//         return Colors.blue;
//       case 'in progress':
//         return Colors.purple;
//       case 'active':
//         return Colors.green;
//       default:
//         return AppColors.primary;
//     }
//   }
//
//   String _getStatusText(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return 'COMPLETED';
//       case 'pending':
//         return 'PENDING';
//       case 'assigned':
//         return 'ASSIGNED';
//       case 'in progress':
//         return 'IN PROGRESS';
//       case 'active':
//         return 'ACTIVE';
//       default:
//         return status.toUpperCase();
//     }
//   }
//
//   Widget _buildSection(String title, List<Order> orders, bool isAssigned) {
//     if (orders.isEmpty) return const SizedBox();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         ...orders.map((order) => _buildOrderTile(order, isAssigned)).toList(),
//       ],
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.medical_services_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No consultations available',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           if (doctorType != null && speciality != null)
//             Text(
//               'You are registered as $speciality $doctorType doctor',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           const SizedBox(height: 4),
//           Text(
//             'New consultations matching your specialization will appear here',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: _fetchOrders,
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
//     if (isLoading || userId == null) {
//       return Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: AppColors.iconColor),
//           backgroundColor: AppColors.primary,
//           title: const Text(
//             "Doctor Dashboard",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final hasAssignedOrders = assignedOrders.isNotEmpty;
//     final hasAvailableOrders = availableOrders.isNotEmpty;
//     final totalOrders = assignedOrders.length + availableOrders.length;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppColors.iconColor),
//         backgroundColor: AppColors.primary,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Doctor Dashboard",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             if (doctorType != null && speciality != null)
//               Text(
//                 "$speciality $doctorType",
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 12,
//                 ),
//               ),
//           ],
//         ),
//         actions: [
//           if (totalOrders > 0)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 '$totalOrders',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           const SizedBox(width: 8),
//           IconButton(
//             onPressed: () => Navigator.pushNamed(context, '/profile'),
//             icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor),
//           ),
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
//                     Text(
//                       userName ?? "Doctor",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (doctorType != null && speciality != null)
//                       Text(
//                         "$speciality $doctorType",
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12,
//                         ),
//                       ),
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
//               Divider(
//                 color: AppColors.iconColor,
//                 thickness: 2,
//                 indent: 12,
//                 endIndent: 12,
//               ),
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     drawerItem("Dashboard", Icons.dashboard, () {
//                       Navigator.pop(context);
//                       _fetchOrders();
//                     }),
//                     drawerItem("History", Icons.history, () {
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/history');
//                     }),
//                     drawerItem("Terms & Privacy", Icons.privacy_tip, () {
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/terms');
//                     }),
//                     drawerItem("Log Out", Icons.logout_sharp, () async {
//                       Navigator.pop(context);
//                       bool? confirm = await showDialog<bool>(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text("Confirm Logout"),
//                           content: const Text("Are you sure you want to logout?"),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, false),
//                               child: const Text("Cancel"),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.pop(context, true),
//                               child: const Text("Logout"),
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
//                           final url = Uri.parse("${ApiConfig.baseUrl}/logoutDoctor");
//                           final response = await http.post(
//                             url,
//                             headers: {
//                               'Content-Type': 'application/json',
//                               if (token != null) 'Authorization': 'Bearer $token',
//                             },
//                           );
//
//                           if (response.statusCode == 200) {
//                             await prefs.clear();
//                             if (mounted) {
//                               Navigator.pushNamedAndRemoveUntil(
//                                 context,
//                                 '/login',
//                                     (route) => false,
//                               );
//                             }
//                           } else {
//                             Helpers.showSnackBar(
//                               context,
//                               "Failed to logout from server",
//                               bgColor: Colors.red,
//                             );
//                           }
//                         } catch (e) {
//                           print('❌ Logout error: $e');
//                           Helpers.showSnackBar(
//                             context,
//                             "Error logging out",
//                             bgColor: Colors.red,
//                           );
//                         }
//                       }
//                     }),
//                   ],
//                 ),
//               ),
//               Divider(
//                 color: AppColors.iconColor,
//                 thickness: 2,
//                 indent: 12,
//                 endIndent: 12,
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 80),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
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
//       body: totalOrders == 0
//           ? _buildEmptyState()
//           : RefreshIndicator(
//         onRefresh: _fetchOrders,
//         color: AppColors.primary,
//         child: ListView(
//           children: [
//             _buildSection("Your Assigned Consultations", assignedOrders, true),
//             _buildSection("Available Consultations", availableOrders, false),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'order.dart';
import 'order_chat_page.dart';
import 'helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  String? userName;
  String? doctorId;
  String? doctorType;
  String? speciality;
  bool isLoading = true;
  List<Order> assignedOrders = [];
  List<Order> availableOrders = [];

  @override
  void initState() {
    super.initState();
    _loadDoctorProfileAndOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh orders when returning to home page
    _fetchOrders();
  }

  Future<void> _loadDoctorProfileAndOrders() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Get data with proper null safety
    final storedUserId = prefs.getString('userId');
    final storedUserName = prefs.getString('name') ?? 'User';
    final storedIsDoctor = prefs.getBool('isDoctor') ?? false;

    print('🔍 Loading user profile:');
    print('  - userId: "$storedUserId"');
    print('  - userName: $storedUserName');
    print('  - isDoctor: $storedIsDoctor');

    // ✅ FIX: Proper null safety check for userId
    if (storedUserId == null || storedUserId.isEmpty) {
      print('❌ CRITICAL: userId is empty in SharedPreferences!');

      // Try to get user ID from other possible locations
      final doctorId = prefs.getString('doctorId');
      if (doctorId != null && doctorId.isNotEmpty) {
        print('🔄 Using doctorId as userId: $doctorId');
        await prefs.setString('userId', doctorId);
        setState(() {
          userId = doctorId;
          userName = storedUserName;
        });
      } else {
        if (mounted) {
          Helpers.showSnackBar(
              context,
              "Login session expired. Please login again.",
              bgColor: Colors.red
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }
    } else {
      setState(() {
        userId = storedUserId;
        userName = storedUserName;
      });
    }

    // ✅ Only load doctor data if user is a doctor
    if (storedIsDoctor == true) {
      final storedDoctorId = prefs.getString('doctorId') ?? userId;
      final storedDoctorType = prefs.getString('doctorType') ?? prefs.getString('type') ?? '';
      final storedSpeciality = prefs.getString('speciality') ?? '';

      setState(() {
        doctorId = storedDoctorId;
        doctorType = storedDoctorType;
        speciality = storedSpeciality;
      });

      print('👨‍⚕ Doctor data loaded:');
      print('  - doctorId: $doctorId');
      print('  - doctorType: $doctorType');
      print('  - speciality: $speciality');

      // ✅ FIX: Proper null safety check for doctor data
      final hasDoctorType = storedDoctorType != null && storedDoctorType.isNotEmpty;
      final hasSpeciality = storedSpeciality != null && storedSpeciality.isNotEmpty;

      if (!hasDoctorType || !hasSpeciality) {
        print('⚠ Doctor data incomplete - checking registration data...');

        // Try to get from registration data
        final regType = prefs.getString('type');
        final regSpeciality = prefs.getString('speciality');

        if (regType != null && regType.isNotEmpty) {
          print('🔄 Using registration data: type=$regType, speciality=$regSpeciality');
          setState(() {
            doctorType = regType;
            speciality = regSpeciality ?? '';
          });
          await prefs.setString('doctorType', regType);
          if (regSpeciality != null) {
            await prefs.setString('speciality', regSpeciality);
          }
        }
      }

      await _fetchOrders();
    } else {
      print('👤 Regular user - no orders to fetch');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchOrders() async {
    if (doctorId == null || doctorType == null || speciality == null) {
      print('❌ Doctor information not available');
      print('🔍 doctorId: $doctorId, doctorType: $doctorType, speciality: $speciality');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      print('🔄 Fetching orders for doctor: $doctorId');
      print('🔍 Doctor Type: $doctorType, Speciality: $speciality');

      // ✅ FIX: Send doctor information to backend using query parameters
      final allOrdersUrl = Uri.parse("${ApiConfig.baseUrl}/getOrders?doctorType=$doctorType&doctorId=$doctorId");
      print('📤 All Orders URL with doctor filter: $allOrdersUrl');

      final allOrdersResponse = await http.get(allOrdersUrl);

      print("📦 All Orders Response Status: ${allOrdersResponse.statusCode}");
      print("📦 All Orders Response Body: ${allOrdersResponse.body}");

      if (allOrdersResponse.statusCode == 200) {
        final decoded = jsonDecode(allOrdersResponse.body);
        final allOrdersData = decoded['data'] as List? ?? [];

        print('📥 Loaded ${allOrdersData.length} $doctorType orders from backend');

        // Filter assigned orders for this doctor
        final assignedOrdersList = allOrdersData.where((order) {
          final isAssignedToMe = order['assignedDoctorId'] == doctorId;
          final isActive = order['status'] != 'completed' && order['status'] != 'cancelled';
          return isAssignedToMe && isActive;
        }).toList();

        // Filter available orders matching doctor's specialization
        final availableOrdersList = allOrdersData.where((order) {
          final matchesSpecialization = order['doctorType'] == doctorType;
          final isUnassigned = order['assignedDoctorId'] == null ||
              order['assignedDoctorId'] == '';
          final isPending = order['status'] == 'pending' ||
              order['status'] == 'unassigned' ||
              order['status'] == 'waiting_for_doctor' ||
              order['status'] == 'pending_assignment';
          return matchesSpecialization && isUnassigned && isPending;
        }).toList();

        setState(() {
          assignedOrders = assignedOrdersList.map((e) => Order.fromMap(e)).toList();
          availableOrders = availableOrdersList.map((e) => Order.fromMap(e)).toList();
        });

        print('✅ Loaded ${assignedOrders.length} assigned orders');
        print('✅ Loaded ${availableOrders.length} available orders');
      } else {
        print('❌ Failed to load orders: ${allOrdersResponse.statusCode}');
        if (mounted) {
          Helpers.showSnackBar(context, "Failed to load orders", bgColor: Colors.red);
        }
      }

    } catch (e) {
      print('❌ Error fetching orders: $e');
      if (mounted) {
        Helpers.showSnackBar(context, "Failed to load orders", bgColor: Colors.red);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _acceptOrder(Order order) async {
    try {
      print('🔄 Accepting order: ${order.orderId}');
      print('👨‍⚕ Doctor accepting: $doctorId ($doctorType - $speciality)');

      // Create updated order with doctor information using copyWith
      final updatedOrder = order.copyWith(
        assignedDoctorId: doctorId,
        assignedDoctorName: userName,
        status: 'assigned',
      );

      // Remove from available orders and add to assigned orders immediately
      setState(() {
        availableOrders.removeWhere((o) => o.orderId == order.orderId);
        assignedOrders.insert(0, updatedOrder); // Add to top of assigned orders
      });

      print('✅ Updated order: ${updatedOrder.orderId}');
      print('✅ Assigned to: ${updatedOrder.assignedDoctorName} ($doctorId)');
      print('✅ New status: ${updatedOrder.status}');

      Helpers.showSnackBar(context, "Order accepted successfully!", bgColor: Colors.green);

      // Navigate directly to the chat page after successful acceptance
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderChatPage(
              order: updatedOrder,
              onSessionEnded: _fetchOrders,
            ),
          ),
        ).then((value) {
          // Refresh orders when returning from chat
          _fetchOrders();
        });
      }

    } catch (e) {
      print('❌ Error accepting order: $e');
      Helpers.showSnackBar(context, "Error accepting order", bgColor: Colors.red);
    }
  }

  void _openOrderChat(Order order) {
    print('💬 Opening chat for order: ${order.orderId}');
    print('👨‍⚕ Current doctor: $doctorId, Assigned doctor: ${order.assignedDoctorId}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderChatPage(
          order: order,
          onSessionEnded: _fetchOrders,
        ),
      ),
    ).then((value) {
      // Refresh orders when returning from chat
      _fetchOrders();
    });
  }

  Widget drawerItem(String title, IconData icon, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, size: 25, color: AppColors.iconColor),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildOrderTile(Order order, bool isAssigned) {
    final isCompleted = order.status?.toLowerCase() == 'completed';
    final isAccepted = isAssigned && order.assignedDoctorId == doctorId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isCompleted
                ? Colors.grey.withOpacity(0.3)
                : isAccepted
                ? Colors.green.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.3),
            width: 1.2
        ),
        boxShadow: isCompleted
            ? []
            : [
          BoxShadow(
            color: (isAccepted ? Colors.green : AppColors.primary).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isCompleted
              ? null // Disable tap for completed orders
              : isAccepted
              ? () => _openOrderChat(order) // Open chat for accepted orders
              : null, // No tap for unaccepted available orders
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
                        color: isCompleted
                            ? Colors.grey.withOpacity(0.2)
                            : isAccepted
                            ? Colors.green.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : isAccepted
                            ? Icons.chat
                            : Icons.medical_services,
                        color: isCompleted
                            ? Colors.grey
                            : isAccepted
                            ? Colors.green
                            : AppColors.primary,
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? Colors.grey : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Order ID: ${order.orderId}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isCompleted ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Show status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status ?? 'active'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(order.status ?? 'active'),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!isAssigned && !isCompleted)
                      const SizedBox(width: 8),
                    if (!isAssigned && !isCompleted)
                      Icon(
                        Icons.add_circle,
                        color: AppColors.accent,
                        size: 24,
                      ),
                    if (isAssigned && !isCompleted)
                      const SizedBox(width: 8),
                    if (isAssigned && !isCompleted)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey[300], height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: isCompleted ? Colors.grey : AppColors.accent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "User ID: ${order.userId}",
                      style: TextStyle(
                        fontSize: 13,
                        color: isCompleted ? Colors.grey : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                if (order.doctorType != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.medical_information_outlined,
                        size: 18,
                        color: isCompleted ? Colors.grey : AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.doctorType!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isCompleted ? Colors.grey : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                if (order.speciality != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.local_hospital_outlined,
                        size: 18,
                        color: isCompleted ? Colors.grey : AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.speciality!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isCompleted ? Colors.grey : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                // Show assigned doctor info
                if (order.assignedDoctorName != null && isAccepted) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 18,
                        color: isCompleted ? Colors.grey : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Assigned to you",
                        style: TextStyle(
                          fontSize: 13,
                          color: isCompleted ? Colors.grey : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // Show Accept button for available orders
                if (!isAssigned && !isCompleted)
                  ElevatedButton(
                    onPressed: () => _acceptOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text("Accept Consultation"),
                  ),
                // Show chat access for assigned orders
                if (isAccepted && !isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Tap to start consultation",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Completed - View only",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'assigned':
        return Colors.blue;
      case 'in progress':
        return Colors.purple;
      case 'active':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'COMPLETED';
      case 'pending':
        return 'PENDING';
      case 'assigned':
        return 'ASSIGNED';
      case 'in progress':
        return 'IN PROGRESS';
      case 'active':
        return 'ACTIVE';
      default:
        return status.toUpperCase();
    }
  }

  Widget _buildSection(String title, List<Order> orders, bool isAssigned) {
    if (orders.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...orders.map((order) => _buildOrderTile(order, isAssigned)).toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No consultations available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          if (doctorType != null && speciality != null)
            Text(
              'You are registered as $speciality $doctorType doctor',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 4),
          Text(
            'New consultations matching your specialization will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchOrders,
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
    if (isLoading || userId == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.iconColor),
          backgroundColor: AppColors.primary,
          title: const Text(
            "Doctor Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final hasAssignedOrders = assignedOrders.isNotEmpty;
    final hasAvailableOrders = availableOrders.isNotEmpty;
    final totalOrders = assignedOrders.length + availableOrders.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.iconColor),
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Doctor Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (doctorType != null && speciality != null)
              Text(
                "$speciality $doctorType",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          if (totalOrders > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalOrders',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: Icon(Icons.person_outline_sharp, color: AppColors.iconColor),
          ),
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
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/logo.png"),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName ?? "Doctor",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (doctorType != null && speciality != null)
                      Text(
                        "$speciality $doctorType",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    const Text(
                      "info@healthbuddy.com",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                color: AppColors.iconColor,
                thickness: 2,
                indent: 12,
                endIndent: 12,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    drawerItem("Dashboard", Icons.dashboard, () {
                      Navigator.pop(context);
                      _fetchOrders();
                    }),
                    drawerItem("History", Icons.history, () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/history');
                    }),
                    drawerItem("Terms & Privacy", Icons.privacy_tip, () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/terms');
                    }),
                    drawerItem("Log Out", Icons.logout_sharp, () async {
                      Navigator.pop(context);
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        try {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('token');

                          final url = Uri.parse("${ApiConfig.baseUrl}/logoutDoctor");
                          final response = await http.post(
                            url,
                            headers: {
                              'Content-Type': 'application/json',
                              if (token != null) 'Authorization': 'Bearer $token',
                            },
                          );

                          if (response.statusCode == 200) {
                            await prefs.clear();
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                    (route) => false,
                              );
                            }
                          } else {
                            Helpers.showSnackBar(
                              context,
                              "Failed to logout from server",
                              bgColor: Colors.red,
                            );
                          }
                        } catch (e) {
                          print('❌ Logout error: $e');
                          Helpers.showSnackBar(
                            context,
                            "Error logging out",
                            bgColor: Colors.red,
                          );
                        }
                      }
                    }),
                  ],
                ),
              ),
              Divider(
                color: AppColors.iconColor,
                thickness: 2,
                indent: 12,
                endIndent: 12,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Made With",
                        style: TextStyle(color: AppColors.textLight, fontSize: 12),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.favorite, color: AppColors.textLight, size: 14),
                      SizedBox(width: 5),
                      Text(
                        "By VSGLogic",
                        style: TextStyle(color: AppColors.textLight, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: totalOrders == 0
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _fetchOrders,
        color: AppColors.primary,
        child: ListView(
          children: [
            _buildSection("Your Assigned Consultations", assignedOrders, true),
            _buildSection("Available Consultations", availableOrders, false),
          ],
        ),
      ),
    );
  }
}