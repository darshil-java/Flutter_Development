import 'package:flutter/material.dart';

class OrderMessage {
  final String text;
  final bool isBot;
  final bool showButtons;
  final bool isUploadPrompt;
  final bool isSystem;
  final String? filePath;
  final DateTime? createdAt;
  final bool isSecondOpinion;
  final String id;

  OrderMessage({
    required this.text,
    required this.isBot,
    this.showButtons = false,
    this.isUploadPrompt = false,
    this.isSystem = false,
    this.filePath,
    this.createdAt,
    this.isSecondOpinion = false,
    String? id,
  }) : id = id ?? UniqueKey().toString();

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isBot': isBot,
      'showButtons': showButtons,
      'isUploadPrompt': isUploadPrompt,
      'isSystem': isSystem,
      'filePath': filePath,
      'createdAt': createdAt?.toIso8601String(),
      'isSecondOpinion': isSecondOpinion,
      'id': id,
    };
  }

  factory OrderMessage.fromMap(Map<String, dynamic> map) {
    return OrderMessage(
      text: map['text'] ?? '',
      isBot: map['isBot'] ?? false,
      showButtons: map['showButtons'] ?? false,
      isUploadPrompt: map['isUploadPrompt'] ?? false,
      isSystem: map['isSystem'] ?? false,
      filePath: map['filePath'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      isSecondOpinion: map['isSecondOpinion'] ?? false,
      id: map['id'],
    );
  }
}

class ChatOrder {
  final String orderNumber;
  final DateTime createdAt;
  final List<OrderMessage> messages;
  final String? doctorType;
  final String? doctorCategory;
  final bool paymentCompleted;
  final String? patientQuery;
  final String status;

  ChatOrder({
    required this.orderNumber,
    required this.createdAt,
    required this.messages,
    this.doctorType,
    this.doctorCategory,
    this.paymentCompleted = false,
    this.patientQuery,
    this.status = 'Completed',
  });

  Map<String, dynamic> toMap() {
    return {
      'orderNumber': orderNumber,
      'createdAt': createdAt.toIso8601String(),
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'doctorType': doctorType,
      'doctorCategory': doctorCategory,
      'paymentCompleted': paymentCompleted,
      'patientQuery': patientQuery,
      'status': status,
    };
  }

  factory ChatOrder.fromMap(Map<String, dynamic> map) {
    return ChatOrder(
      orderNumber: map['orderNumber'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      messages: (map['messages'] as List)
          .map((msgMap) => OrderMessage.fromMap(msgMap))
          .toList(),
      doctorType: map['doctorType'],
      doctorCategory: map['doctorCategory'],
      paymentCompleted: map['paymentCompleted'] ?? false,
      patientQuery: map['patientQuery'],
      status: map['status'] ?? 'Completed',
    );
  }
}