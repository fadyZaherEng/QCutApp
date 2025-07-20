import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/modules/customer/features/settings/chat_feature/chat_bubble_for_barber.dart';
import 'package:q_cut/modules/customer/features/settings/chat_feature/chat_bubble_for_customer.dart';
import 'package:get/get.dart';

import 'logic/chat_controller.dart';

class ChatWithUsViewBody extends StatefulWidget {
  const ChatWithUsViewBody({super.key});

  @override
  State<ChatWithUsViewBody> createState() => ChatWithUsViewBodyState();
}

class ChatWithUsViewBodyState extends State<ChatWithUsViewBody> {
  final ScrollController _scrollController = ScrollController();
  final ChatController _chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _chatController.loadMoreMessages();
    }
  }

  void sendMessage(String message) {
    _chatController.sendMessage(message);
  }

  void sendImage(String imagePath) {
    _chatController.sendImageMessage(imagePath);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (_chatController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_chatController.messages.isEmpty) {
              return Center(
                child: Text('noMessagesYet'.tr),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              itemCount: _chatController.messages.length + 1,
              // +1 for loading indicator
              itemBuilder: (context, index) {
                if (index == _chatController.messages.length) {
                  return Obx(() => _chatController.isLoadingMore.value
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink());
                }

                final message = _chatController.messages[index];

                print(
                    '=================== Message Details ===================');
                print('Message: ${message.message}');
                print('MediaType: ${message.mediaType}');
                print('MediaURL: ${message.mediaUrl}');
                print('Created At: ${message.createdAt}');
                print('====================================================');

                return message.adminReply
                    ? ChatBubbleForBarber(
                        text: message.message,
                        mediaType: message.mediaType,
                        mediaUrl: message.mediaUrl,
                      )
                    : ChatBubbleForCustomer(
                        text: message.message,
                        mediaType: message.mediaType,
                        mediaUrl: message.mediaUrl,
                      );
              },
            );
          }),
        ),
      ],
    );
  }
}
