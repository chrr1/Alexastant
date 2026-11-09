class ChatMessageModel {
  final String text;
  final bool isUser;
  final String time;
  final bool hasActionCard;

  ChatMessageModel({
    required this.text,
    required this.isUser,
    required this.time,
    this.hasActionCard = false,
  });
}

