import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riwama/model/chat_contact.dart';
import 'package:riwama/model/message.dart';
import 'package:riwama/model/message_enum.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/chat/controller/message_reply_provider.dart';
import 'package:riwama/view/chat/repositories/chat_repository.dart';
import 'package:riwama/view/chat/screens/mobile_chat_screen.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/x.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  Future<ChatContact?> checkChat(ScopeUser user) async {
    final currentUser = ref.watch(authProvider).user;
    final chat = await chatRepository.openChat(user, currentUser!);
    return chat;
  }

  Future<String> createandreturnChat(
      BuildContext context, ScopeUser user) async {
    final chat = await chatRepository.createandreturnChat(
        context, user, ref.read(authProvider).user!);
    return chat;
  }

  void createChat(BuildContext context, ScopeUser user) async {
    chatRepository.createChat(context, user, ref.read(authProvider).user!);
  }

  void updatepic(ChatContact chatContactData) async {
    final currentUser = ref.watch(authProvider).user;
    chatRepository.updateProfilePic(currentUser!, chatContactData);
  }

  void openChat(BuildContext context, ScopeUser user) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shrinkWrap: true,
                children: [
                  Center(child: Text('Loading Chat Data')),
                  SizedBox(height: 10),
                  Loading(),
                ]),
          );
        });

    final currentUser = ref.watch(authProvider).user;
    final chat = await chatRepository.openChat(user, currentUser!);

    if (chat != null) {
      goto(context, MobileChatScreen.routeName, {
        "name": chat.profile[user.uid]!['username'],
        "uid": chat.chatId,
        "isGroupChat": false,
        "profilePic": chat.profile[user.uid]!['profilePic'],
        "recieverUserId": chat.profile[user.uid]!['uid'],
      });
    } else {
      chatRepository.createChat(context, user, currentUser);
    }
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String chatId,
    String recieverUserId,
    bool isGroupChat,
  ) {
    final user = ref.watch(authProvider).user;
    final messageReply = ref.read(messageReplyProvider);
    chatRepository.sendTextMessage(
      context: context,
      text: text,
      chatId: chatId,
      recieverUserId: recieverUserId,
      senderUser: user!,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void deleteFileMessage(
    BuildContext context,
    String recieverUserId,
    String messageId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    chatRepository.deleteFileMessage(
      context: context,
      recieverUserId: recieverUserId,
      messageId: messageId,
      messageEnum: messageEnum,
      isGroupChat: isGroupChat,
    );
  }

  void deleteTextMessage(
    BuildContext context,
    String recieverUserId,
    String messageId,
    bool isGroupChat,
  ) {
    chatRepository.deleteTextMessage(
      context: context,
      recieverUserId: recieverUserId,
      messageId: messageId,
      isGroupChat: isGroupChat,
    );
  }

  void clearChat(
    BuildContext context,
    String recieverUserId,
  ) {
    chatRepository.clearChat(
      context: context,
      recieverUserId: recieverUserId,
    );
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String chatId,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final user = ref.watch(authProvider).user;
    final messageReply = ref.read(messageReplyProvider);
    chatRepository.sendFileMessage(
      context: context,
      file: file,
      chatId: chatId,
      recieverUserId: recieverUserId,
      senderUserData: user!,
      messageEnum: messageEnum,
      ref: ref,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String chatId,
    String recieverUserId,
    bool isGroupChat,
  ) {
    final user = ref.watch(authProvider).user;
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    chatRepository.sendGIFMessage(
      context: context,
      gifUrl: newgifUrl,
      chatId: chatId,
      recieverUserId: recieverUserId,
      senderUser: user!,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFlickMessage(
    BuildContext context,
    String chatId,
    String recieverUserId,
    String postId,
  ) {
    final user = ref.watch(authProvider).user;
    final messageReply = ref.read(messageReplyProvider);
    chatRepository.sendFlickMessage(
        context: context,
        postUid: postId,
        chatId: chatId,
        recieverUserId: recieverUserId,
        senderUser: user!,
        messageReply: messageReply,
        isGroupChat: false);
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }
}
