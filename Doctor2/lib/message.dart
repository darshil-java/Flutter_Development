class Message {
  final String text;
  final bool isBot;
  final DateTime createdAt;
  final String? userName;

  Message({
    required this.text,
    required this.isBot,
    required this.createdAt,
    this.userName,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] ?? '',
      isBot: map['isBot'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      userName: map['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isBot': isBot,
      'createdAt': createdAt.toIso8601String(),
      'userName': userName,
    };
  }
}
