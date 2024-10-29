import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riwama/view/profile/view_profile/veiw_profile.dart';
import 'package:riwama/view/chat/widgets/bottom_chat_field.dart';
import 'package:riwama/view/chat/widgets/chat_list.dart';
import 'package:riwama/x.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final String recieverUserId;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
    required this.recieverUserId,
  });

  static const routeName = '/ChatSpace';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: isGroupChat
            ? Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              )
            : Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ExtendedImage.network(
              profilePic,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              cache: true,
              shape: BoxShape.circle,
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ).onTap(
              () {
                goto(
                  context,
                  ViewProfile.routeName,
                  recieverUserId,
                );
              },
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ChatList(
                recieverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              chatId: uid,
              receiverUserId: recieverUserId,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
