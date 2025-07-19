class MessageModel {
  final String message;
  final String mediaUrl;
  final String mediaType;
  final bool adminReply;
  final String clientId;
  final String? name;
  final String? profilePicture;
  final DateTime createdAt;

  MessageModel({
    required this.message,
    this.mediaUrl = '',
    this.mediaType = 'text',
    this.adminReply = false,
    required this.clientId,
    this.name,
    this.profilePicture,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? 'text',
      adminReply: json['adminReply'] as bool? ?? false,
      clientId: json['client']?.toString() ?? '',
      name: json['name'] as String?,
      profilePicture: json['profilePicture'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'adminReply': adminReply,
        'client': clientId,
        'name': name,
        'profilePicture': profilePicture,
        'createdAt': createdAt.toIso8601String(),
      };
}
