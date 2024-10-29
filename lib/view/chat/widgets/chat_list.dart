import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riwama/model/message.dart';
import 'package:riwama/model/message_enum.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/chat/controller/message_reply_provider.dart';
import 'package:riwama/view/chat/controller/chat_controller.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/x.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;

  ChatList({
    required this.recieverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  bool isSelected = false;

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var uid = ref.read(authProvider).user!.uid;
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .groupChatStream(widget.recieverUserId)
            : ref
                .read(chatControllerProvider)
                .chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return snapshot.data!.isEmpty
              ? Column(
                  children: [
                    FittedBox(
                      child: Image.asset(
                        'assets/meandpet.gif',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Start a chat Stream',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  controller: messageController,
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, i) {
                    final currentMessageData = snapshot.data![i];
                    final previousMessageData =
                        i > 0 ? snapshot.data![i - 1] : null;

                    bool isSameDay(DateTime date1, DateTime date2) {
                      return date1.year == date2.year &&
                          date1.month == date2.month &&
                          date1.day == date2.day;
                    }

                    Widget buildDateSeparator(DateTime date) {
                      return Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Text(
                              DateFormat.yMMMd().format(date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      );
                    }

                    if (i == 0 ||
                        (previousMessageData != null &&
                            !isSameDay(currentMessageData.datePublished,
                                previousMessageData.datePublished))) {
                      return buildDateSeparator(
                          currentMessageData.datePublished);
                    }

                    return SizedBox.shrink();
                  },
                  itemBuilder: (context, index) {
                    final messageData = snapshot.data![index];

                    var datePublished =
                        DateFormat.Hm().format(messageData.datePublished);

                    if (!messageData.isSeen && messageData.senderId != uid) {
                      ref.read(chatControllerProvider).setChatMessageSeen(
                            context,
                            widget.recieverUserId,
                            messageData.messageId,
                          );
                    }

                    if (messageData.senderId == uid) {
                      return isSelected
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.delete_outlined).onTap(() {
                                    messageData.type == "text"
                                        ? ref
                                            .read(chatControllerProvider)
                                            .deleteTextMessage(
                                                context,
                                                widget.recieverUserId,
                                                messageData.messageId,
                                                widget.isGroupChat)
                                        : ref
                                            .read(chatControllerProvider)
                                            .deleteFileMessage(
                                                context,
                                                widget.recieverUserId,
                                                messageData.messageId,
                                                messageData.type,
                                                widget.isGroupChat);
                                  }),
                                ),
                                InkWell(
                                  onLongPress: () {
                                    setState(() {
                                      isSelected = !isSelected;
                                    });
                                  },
                                  child: MyMessageCard(
                                    message: messageData.text,
                                    date: datePublished,
                                    type: messageData.type,
                                    repliedText: messageData.repliedMessage,
                                    username: messageData.repliedTo,
                                    repliedMessageType:
                                        messageData.repliedMessageType,
                                    onLeftSwipe: () => onMessageSwipe(
                                      messageData.text,
                                      true,
                                      messageData.type,
                                    ),
                                    isSeen: messageData.isSeen,
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onLongPress: () {
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              },
                              child: MyMessageCard(
                                message: messageData.text,
                                date: datePublished,
                                type: messageData.type,
                                repliedText: messageData.repliedMessage,
                                username: messageData.repliedTo,
                                repliedMessageType:
                                    messageData.repliedMessageType,
                                onLeftSwipe: () => onMessageSwipe(
                                  messageData.text,
                                  true,
                                  messageData.type,
                                ),
                                isSeen: messageData.isSeen,
                              ),
                            );
                    }

                    return isSelected
                        ? !widget.isGroupChat
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onLongPress: () {
                                      setState(() {
                                        isSelected = !isSelected;
                                      });
                                    },
                                    child: SenderMessageCard(
                                      message: messageData.text,
                                      date: datePublished,
                                      type: messageData.type,
                                      username: messageData.repliedTo,
                                      repliedMessageType:
                                          messageData.repliedMessageType,
                                      onRightSwipe: () => onMessageSwipe(
                                        messageData.text,
                                        false,
                                        messageData.type,
                                      ),
                                      repliedText: messageData.repliedMessage,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Icon(Icons.delete_outlined).onTap(() {
                                      messageData.type == "text"
                                          ? ref
                                              .read(chatControllerProvider)
                                              .deleteTextMessage(
                                                  context,
                                                  widget.recieverUserId,
                                                  messageData.messageId,
                                                  widget.isGroupChat)
                                          : ref
                                              .read(chatControllerProvider)
                                              .deleteFileMessage(
                                                  context,
                                                  widget.recieverUserId,
                                                  messageData.messageId,
                                                  messageData.type,
                                                  widget.isGroupChat);
                                    }),
                                  ),
                                ],
                              )
                            : InkWell(
                                onLongPress: () {
                                  setState(() {
                                    isSelected = !isSelected;
                                  });
                                },
                                child: SenderMessageCardGroup(
                                  message: messageData.text,
                                  date: datePublished,
                                  type: messageData.type,
                                  username: messageData.repliedTo,
                                  repliedMessageType:
                                      messageData.repliedMessageType,
                                  onRightSwipe: () => onMessageSwipe(
                                    messageData.text,
                                    false,
                                    messageData.type,
                                  ),
                                  repliedText: messageData.repliedMessage,
                                  senderid: messageData.senderId,
                                ),
                              )
                        : InkWell(
                            onLongPress: () {
                              setState(() {
                                isSelected = !isSelected;
                              });
                            },
                            child: widget.isGroupChat
                                ? SenderMessageCardGroup(
                                    message: messageData.text,
                                    date: datePublished,
                                    type: messageData.type,
                                    username: messageData.repliedTo,
                                    repliedMessageType:
                                        messageData.repliedMessageType,
                                    onRightSwipe: () => onMessageSwipe(
                                      messageData.text,
                                      false,
                                      messageData.type,
                                    ),
                                    repliedText: messageData.repliedMessage,
                                    senderid: messageData.senderId,
                                  )
                                : SenderMessageCard(
                                    message: messageData.text,
                                    date: datePublished,
                                    type: messageData.type,
                                    username: messageData.repliedTo,
                                    repliedMessageType:
                                        messageData.repliedMessageType,
                                    onRightSwipe: () => onMessageSwipe(
                                      messageData.text,
                                      false,
                                      messageData.type,
                                    ),
                                    repliedText: messageData.repliedMessage,
                                  ),
                          );
                  },
                );
        });
  }
}
