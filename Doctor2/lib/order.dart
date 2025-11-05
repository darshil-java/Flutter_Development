// import 'message.dart';
//
// class Order {
//   final String orderId;
//   final String userId;
//   final String userName;
//   final List<Message> messages;
//
//   Order({
//     required this.orderId,
//     required this.userId,
//     required this.userName,
//     required this.messages,
//   });
//
//   factory Order.fromMap(Map<String, dynamic> map) {
//     return Order(
//       orderId: map['orderId'] ?? '',
//       userId: map['userId'] ?? '',
//       userName: map['userName'] ?? '',
//       messages: (map['messages'] as List? ?? [])
//           .map((msg) => Message.fromMap(msg))
//           .toList(),
//     );
//   }
// }
// import 'message.dart';
//
// class Order {
//   final String orderId;
//   final String userId;
//   final String userName;
//   final String? doctorType;
//   final String? speciality;
//   final int? amount;
//   final bool? paymentCompleted;
//   final String? createdAt;
//   final String? updatedAt;
//   final List<Message> messages;
//   final String? completedAt;
//   final String? status;
//
//   Order({
//     required this.orderId,
//     required this.userId,
//     required this.userName,
//     this.doctorType,
//     this.speciality,
//     this.amount,
//     this.paymentCompleted,
//     this.createdAt,
//     this.updatedAt,
//     this.messages = const [],
//     this.completedAt,
//     this.status,
//   });
//
//   factory Order.fromMap(Map<String, dynamic> map) {
//     // Check if user info is nested
//     final userMap = map['user'] as Map<String, dynamic>?;
//
//     final messageList = map['messages'] != null && map['messages'] is List
//         ? (map['messages'] as List).map((m) => Message.fromMap(m)).toList()
//         : <Message>[];
//
//     return Order(
//       completedAt: map['completedAt']?.toString(),
//       status: map['status']?.toString(),
//       orderId: map['orderId'] ?? map['_id'] ?? '',
//       userId: userMap?['_id'] ?? map['userId'] ?? '',
//       userName: userMap?['name'] ?? map['userName'] ?? 'Unknown User',
//       doctorType: map['doctorType'],
//       speciality: map['speciality'],
//       amount: map['amount'] != null
//           ? (map['amount'] is int
//           ? map['amount']
//           : int.tryParse(map['amount'].toString()))
//           : null,
//       paymentCompleted: map['paymentCompleted'] ?? false,
//       createdAt: map['createdAt']?.toString(),
//       updatedAt: map['updatedAt']?.toString(),
//       messages: messageList,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'orderId': orderId,
//       'userId': userId,
//       'userName': userName,
//       'doctorType': doctorType,
//       'speciality': speciality,
//       'amount': amount,
//       'paymentCompleted': paymentCompleted,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'messages': messages.map((m) => m.toMap()).toList(),
//     };
//   }
// }
//

//
// import 'message.dart';
//
// class Order {
//   final String orderId;
//   final String userId;
//   final String userName;
//   final String? doctorType;
//   final String? speciality;
//   final int? amount;
//   final bool? paymentCompleted;
//   final String? createdAt;
//   final String? updatedAt;
//   final List<Message> messages;
//   final String? completedAt;
//   final String? status;
//   final String? assignedDoctorId;
//   final String? assignedDoctorName;
//   final List<dynamic>? files; // Add this field
//
//   Order({
//     required this.orderId,
//     required this.userId,
//     required this.userName,
//     this.doctorType,
//     this.speciality,
//     this.amount,
//     this.paymentCompleted,
//     this.createdAt,
//     this.updatedAt,
//     this.messages = const [],
//     this.completedAt,
//     this.status,
//     this.assignedDoctorId,
//     this.assignedDoctorName,
//     this.files, // Add this
//   });
//
//   factory Order.fromMap(Map<String, dynamic> map) {
//     // Check if user info is nested
//     final userMap = map['user'] as Map<String, dynamic>?;
//
//     final messageList = map['messages'] != null && map['messages'] is List
//         ? (map['messages'] as List).map((m) => Message.fromMap(m)).toList()
//         : <Message>[];
//
//     return Order(
//       completedAt: map['completedAt']?.toString(),
//       status: map['status']?.toString(),
//       orderId: map['orderId'] ?? map['_id'] ?? '',
//       userId: userMap?['_id'] ?? map['userId'] ?? '',
//       userName: userMap?['name'] ?? map['userName'] ?? 'Unknown User',
//       doctorType: map['doctorType'],
//       speciality: map['speciality'],
//       amount: map['amount'] != null
//           ? (map['amount'] is int
//           ? map['amount']
//           : int.tryParse(map['amount'].toString()))
//           : null,
//       paymentCompleted: map['paymentCompleted'] ?? false,
//       createdAt: map['createdAt']?.toString(),
//       updatedAt: map['updatedAt']?.toString(),
//       messages: messageList,
//       assignedDoctorId: map['assignedDoctorId'],
//       assignedDoctorName: map['assignedDoctorName'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'orderId': orderId,
//       'userId': userId,
//       'userName': userName,
//       'doctorType': doctorType,
//       'speciality': speciality,
//       'amount': amount,
//       'paymentCompleted': paymentCompleted,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'messages': messages.map((m) => m.toMap()).toList(),
//       'assignedDoctorId': assignedDoctorId,
//       'assignedDoctorName': assignedDoctorName,
//     };
//   }
// }








import 'message.dart';

class Order {
  final String orderId;
  final String userId;
  final String userName;
  final String? doctorType;
  final String? speciality;
  final int? amount;
  final bool? paymentCompleted;
  final String? createdAt;
  final String? updatedAt;
  final List<Message> messages;
  final String? completedAt;
  final String? status;
  final String? assignedDoctorId;
  final String? assignedDoctorName;
  final List<dynamic>? files;

  Order({
    required this.orderId,
    required this.userId,
    required this.userName,
    this.doctorType,
    this.speciality,
    this.amount,
    this.paymentCompleted,
    this.createdAt,
    this.updatedAt,
    this.messages = const [],
    this.completedAt,
    this.status,
    this.assignedDoctorId,
    this.assignedDoctorName,
    this.files,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    // Check if user info is nested
    final userMap = map['user'] as Map<String, dynamic>?;

    final messageList = map['messages'] != null && map['messages'] is List
        ? (map['messages'] as List).map((m) => Message.fromMap(m)).toList()
        : <Message>[];

    // ✅ FIX: Extract files from the correct API response structure
    List<dynamic> files = [];

    // Extract files from reports.files.all structure (from your Postman response)
    if (map['reports'] != null &&
        map['reports'] is Map<String, dynamic> &&
        map['reports']['files'] != null &&
        map['reports']['files'] is Map<String, dynamic> &&
        map['reports']['files']['all'] != null &&
        map['reports']['files']['all'] is List) {
      files = map['reports']['files']['all'];
      print('✅ Extracted ${files.length} files from reports.files.all');
    }
    // Also check if files are directly in the order (fallback)
    else if (map['files'] != null && map['files'] is List) {
      files = map['files'];
      print('✅ Extracted ${files.length} files from direct files field');
    } else {
      print('ℹ️ No files found in order data');
    }

    // Debug: Print file details if any files found
    if (files.isNotEmpty) {
      for (var file in files) {
        print('📄 File in Order: ${file['fileName']} - ${file['uploadedBy']}');
      }
    }

    return Order(
      completedAt: map['completedAt']?.toString(),
      status: map['status']?.toString(),
      orderId: map['orderId'] ?? map['_id'] ?? '',
      userId: userMap?['_id'] ?? map['userId'] ?? '',
      userName: userMap?['name'] ?? map['userName'] ?? map['patientName'] ?? 'Unknown User',
      doctorType: map['doctorType'],
      speciality: map['speciality'],
      amount: map['amount'] != null
          ? (map['amount'] is int
          ? map['amount']
          : int.tryParse(map['amount'].toString()))
          : null,
      paymentCompleted: map['paymentCompleted'] ?? false,
      createdAt: map['createdAt']?.toString(),
      updatedAt: map['updatedAt']?.toString(),
      messages: messageList,
      assignedDoctorId: map['assignedDoctorId'],
      assignedDoctorName: map['assignedDoctorName'],
      files: files,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'doctorType': doctorType,
      'speciality': speciality,
      'amount': amount,
      'paymentCompleted': paymentCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'messages': messages.map((m) => m.toMap()).toList(),
      'assignedDoctorId': assignedDoctorId,
      'assignedDoctorName': assignedDoctorName,
      'files': files,
    };
  }

  // Add copyWith method
  Order copyWith({
    String? orderId,
    String? userId,
    String? userName,
    String? doctorType,
    String? speciality,
    int? amount,
    bool? paymentCompleted,
    String? createdAt,
    String? updatedAt,
    List<Message>? messages,
    String? completedAt,
    String? status,
    String? assignedDoctorId,
    String? assignedDoctorName,
    List<dynamic>? files,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      doctorType: doctorType ?? this.doctorType,
      speciality: speciality ?? this.speciality,
      amount: amount ?? this.amount,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
      assignedDoctorName: assignedDoctorName ?? this.assignedDoctorName,
      files: files ?? this.files,
    );
  }

  @override
  String toString() {
    return 'Order(orderId: $orderId, userId: $userId, userName: $userName, status: $status, assignedDoctorId: $assignedDoctorId)';
  }
}