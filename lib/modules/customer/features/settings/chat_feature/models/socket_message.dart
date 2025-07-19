class SocketMessage {
  final String message;
  final String mediaUrl;
  final String mediaType;
  final bool adminReply;
  final String? clientId;

  SocketMessage({
    required this.message,
    this.mediaUrl = '',
    this.mediaType = 'text',
    this.adminReply = false,
    this.clientId,
  });

  factory SocketMessage.fromJson(Map<String, dynamic> json) {
    return SocketMessage(
      message: json['message'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? 'text',
      adminReply: json['adminReply'] as bool? ?? false,
      clientId: json['client']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'adminReply': adminReply,
        'client': clientId,
      };
}
