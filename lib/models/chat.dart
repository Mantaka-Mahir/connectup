class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final String profileImage;
  final bool isOnline;
  final bool isUnread;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.profileImage,
    this.isOnline = false,
    this.isUnread = false,
  });
}

// Model for individual messages in a conversation
class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
  });
}
