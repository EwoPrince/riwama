import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riwama/model/chat_contact.dart';
import 'package:riwama/model/message.dart';
import 'package:riwama/model/message_enum.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/model/user.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/view/chat/controller/message_reply_provider.dart';
import 'package:riwama/provider/common_firebase_storage_repository.dart';
import 'package:riwama/view/chat/screens/mobile_chat_screen.dart';
import 'package:riwama/x.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FAuth.FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FAuth.FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Future<ChatContact?> openChat(ScopeUser user, User currentUser) async {
    var uidList = [];
    uidList.add(currentUser.uid);
    uidList.add(user.uid);

    var chatContact = await firestore
        .collection('chats')
        .where('membersUid', isEqualTo: uidList)
        .limit(1)
        .get();

    if (chatContact.size > 0) {
      updateProfilePic(
          currentUser, ChatContact.fromMap(chatContact.docs.first.data()));

      return ChatContact.fromMap(chatContact.docs.first.data());
    } else {
      var uidList = [];

      uidList.add(user.uid);
      uidList.add(currentUser.uid);

      var chatContact2 = await firestore
          .collection('chats')
          .where('membersUid', isEqualTo: uidList)
          .limit(1)
          .get();

      if (chatContact2.size > 0) {
        updateProfilePic(
            currentUser, ChatContact.fromMap(chatContact2.docs.first.data()));
        return ChatContact.fromMap(chatContact2.docs.first.data());
      }
    }

    return null;
  }

  void updateProfilePic(User currentUser, ChatContact chatContactData) async {
    final meprofile = chatContactData.getProfiles
        .where((element) => element.uid == currentUser.uid)
        .firstOrNull;

    final otherUser = chatContactData.getProfiles
        .where((element) => element.uid != currentUser.uid)
        .firstOrNull;

    if (currentUser.photoUrl != meprofile!.profilePic) {
      Map<String, dynamic> profiles = {};

      profiles[currentUser.uid] = {
        "uid": currentUser.uid,
        "username": currentUser.firstName,
        "profilePic": currentUser.photoUrl,
      };

      profiles[otherUser!.uid] = {
        "uid": otherUser.uid,
        "username": otherUser.username,
        "profilePic": otherUser.profilePic,
      };

      await firestore.collection('chats').doc(chatContactData.chatId).update({
        'profile': profiles,
        'datePublished': DateTime.now().millisecondsSinceEpoch,
      });
    }

    if (currentUser.firstName != meprofile.username) {
      Map<String, dynamic> profiles = {};

      profiles[currentUser.uid] = {
        "uid": currentUser.uid,
        "username": currentUser.firstName,
        "profilePic": currentUser.photoUrl,
      };

      profiles[otherUser!.uid] = {
        "uid": otherUser.uid,
        "username": otherUser.username,
        "profilePic": otherUser.profilePic,
      };

      await firestore.collection('chats').doc(chatContactData.chatId).update({
        'profile': profiles,
        'datePublished': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  void createChat(
      BuildContext context, ScopeUser user, User currentUser) async {
    try {
      var chatId = Uuid().v1();

      List<String> members = [];
      members.add(currentUser.uid);
      members.add(user.uid);

      Map<String, dynamic> profiles = {};

      profiles[currentUser.uid] = {
        "uid": currentUser.uid,
        "username": currentUser.firstName,
        "profilePic": currentUser.photoUrl,
      };

      profiles[user.uid] = {
        "uid": user.uid,
        "username": user.firstName,
        "profilePic": user.photoUrl,
      };

      ChatContact chat = ChatContact(
        chatId: chatId,
        lastMessage: 'Started a Chat',
        profile: profiles,
        membersUid: members,
        datePublished: DateTime.now(),
        isSeen: false,
        lastMessageBy: user.uid,
      );

      await firestore
          .collection('chats')
          .doc(chatId)
          .set(chat.toMap())
          .then((value) => {
                goto(context, MobileChatScreen.routeName, {
                  "name": chat.profile[user.uid]!['username'],
                  "uid": chatId,
                  "isGroupChat": false,
                  "profilePic": chat.profile[user.uid]!['profilePic'],
                  "recieverUserId": chat.profile[user.uid]!['uid'],
                })
              });
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  Future<String> createandreturnChat(
      BuildContext context, ScopeUser user, User currentUser) async {
    var chatId = Uuid().v1();
    try {
      List<String> members = [];
      members.add(currentUser.uid);
      members.add(user.uid);

      Map<String, dynamic> profiles = {};

      profiles[currentUser.uid] = {
        "uid": currentUser.uid,
        "username": currentUser.firstName,
        "profilePic": currentUser.photoUrl,
      };

      profiles[user.uid] = {
        "uid": user.uid,
        "username": user.firstName,
        "profilePic": user.photoUrl,
      };

      ChatContact chat = ChatContact(
        chatId: chatId,
        lastMessage: 'Started a Chat',
        profile: profiles,
        membersUid: members,
        datePublished: DateTime.now(),
        isSeen: false,
        lastMessageBy: user.uid,
      );

      await firestore.collection('chats').doc(chatId).set(chat.toMap());
    } catch (e) {
      showMessage(context, e.toString());
    }
    return chatId;
  }

  Stream<List<Message>> getChatStream(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('datePublished')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groudId) {
    return firestore
        .collection('groups')
        .doc(groudId)
        .collection('chats')
        .orderBy('datePublished')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection(
    User senderUserData,
    String text,
    DateTime datePublished,
    String chatId,
    bool isGroupChat,
    bool isSeen,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(chatId).update({
        'lastMessage': text,
        'datePublished': DateTime.now().millisecondsSinceEpoch,
        'isSeen': isSeen,
        'lastMessageBy': senderUserData.uid,
      });
    } else {
      await firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'datePublished': DateTime.now().millisecondsSinceEpoch,
        'isSeen': isSeen,
        'lastMessageBy': senderUserData.uid,
      });
    }
  }

  void _saveSeenDataToContactsSubcollection(
    String chatId,
    bool isGroupChat,
    bool isSeen,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(chatId).update({
        'isSeen': isSeen,
      });
    } else {
      await firestore.collection('chats').doc(chatId).update({
        'isSeen': isSeen,
      });
    }
  }

  void _saveMessageToMessageSubcollection({
    required String chatId,
    required String text,
    required DateTime datePublished,
    required String messageId,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      chatId: chatId,
      text: text,
      type: messageType,
      datePublished: datePublished,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : '',
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore
          .collection('groups')
          .doc(chatId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String chatId,
    required String recieverUserId,
    required User senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var datePublished = DateTime.now();
      User? recieverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = User.fromMap(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        text,
        datePublished,
        chatId,
        isGroupChat,
        false,
      );
      _saveMessageToMessageSubcollection(
        chatId: chatId,
        text: text,
        datePublished: datePublished,
        messageType: MessageEnum.text,
        messageId: messageId,
        messageReply: messageReply,
        senderUsername: senderUser.firstName,
        isGroupChat: isGroupChat,
      );

      if (!isGroupChat) {
        NotificationService.SendNotification(
            recieverUserData!.fcmToken, senderUser.firstName, text);
      }
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String chatId,
    required String recieverUserId,
    required User senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var datePublished = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl;

      switch (messageEnum) {
        case MessageEnum.audio:
          imageUrl = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId.aac',
                file,
              );
          break;
        case MessageEnum.video:
          imageUrl = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
                file,
              );
          break;

        case MessageEnum.image:
          imageUrl = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
                file,
              );
          break;
        case MessageEnum.gif:
          imageUrl = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
                file,
              );
          break;
        default:
          imageUrl = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
                file,
              );
      }

      User? recieverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = User.fromMap(userDataMap.data()!);
      }
      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }

      _saveDataToContactsSubcollection(
        senderUserData,
        contactMsg,
        datePublished,
        chatId,
        isGroupChat,
        false,
      );

      _saveMessageToMessageSubcollection(
        chatId: chatId,
        text: imageUrl,
        datePublished: datePublished,
        messageId: messageId,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUsername: senderUserData.firstName,
        isGroupChat: isGroupChat,
      );

      if (!isGroupChat) {
        NotificationService.SendNotification(
            recieverUserData!.fcmToken, senderUserData.firstName, contactMsg);
      }
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String chatId,
    required String recieverUserId,
    required User senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var datePublished = DateTime.now();
      User? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = User.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        'GIF',
        datePublished,
        chatId,
        isGroupChat,
        false,
      );

      _saveMessageToMessageSubcollection(
        chatId: chatId,
        text: gifUrl,
        datePublished: datePublished,
        messageType: MessageEnum.gif,
        messageId: messageId,
        messageReply: messageReply,
        senderUsername: senderUser.firstName,
        isGroupChat: isGroupChat,
      );

      if (!isGroupChat) {
        NotificationService.SendNotification(
            recieverUserData!.fcmToken, senderUser.firstName, 'GIF');
      }
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void sendFlickMessage({
    required BuildContext context,
    required String postUid,
    required String chatId,
    required String recieverUserId,
    required User senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var datePublished = DateTime.now();
      User? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = User.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
          senderUser, 'FLICK', datePublished, chatId, isGroupChat, false);

      _saveMessageToMessageSubcollection(
        chatId: chatId,
        text: postUid,
        datePublished: datePublished,
        messageType: MessageEnum.flick,
        messageId: messageId,
        messageReply: messageReply,
        senderUsername: senderUser.firstName,
        isGroupChat: isGroupChat,
      );

      if (!isGroupChat) {
        NotificationService.SendNotification(
            recieverUserData!.fcmToken, senderUser.firstName, 'Flick');
      }
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void deleteFileMessage({
    required BuildContext context,
    required String recieverUserId,
    required String messageId,
    required MessageEnum messageEnum,
    required bool isGroupChat,
  }) async {
    try {
      if (isGroupChat) {
        // Delete the file message in the group chat
        await firestore
            .collection('groups')
            .doc(recieverUserId)
            .collection('chats')
            .doc(messageId)
            .delete();

        await FirebaseStorage.instance
            .ref()
            .child(
                'chat/${messageEnum.type}/${auth.currentUser!.uid}/$recieverUserId/$messageId')
            .delete();
      } else {
        // Delete the file message in the user's chat
        await firestore
            .collection('chats')
            .doc(recieverUserId)
            .collection('messages')
            .doc(messageId)
            .delete();

        // Also delete it from the receiver's chat
        await firestore
            .collection('chats')
            .doc(auth.currentUser!.uid)
            .collection('messages')
            .doc(messageId)
            .delete();

        await FirebaseStorage.instance
            .ref()
            .child(
                'chat/${messageEnum.type}/${auth.currentUser!.uid}/$recieverUserId/$messageId')
            .delete();
      }
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void deleteTextMessage({
    required BuildContext context,
    required String recieverUserId,
    required String messageId,
    required bool isGroupChat,
  }) async {
    try {
      if (isGroupChat) {
        // Delete the text message in the group chat
        await firestore
            .collection('groups')
            .doc(recieverUserId)
            .collection('chats')
            .doc(messageId)
            .delete();
      } else {
        // Delete the text message in the user's chat

        await firestore
            .collection('chats')
            .doc(recieverUserId)
            .collection('messages')
            .doc(messageId)
            .delete();
      }
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void clearChat({
    required BuildContext context,
    required String recieverUserId,
  }) async {
    try {
      await firestore.collection('chats').doc(recieverUserId).delete();

      await FirebaseStorage.instance
          .ref()
          .child('chat/audio/${auth.currentUser!.uid}/$recieverUserId')
          .delete();

      await FirebaseStorage.instance
          .ref()
          .child('chat/image/${auth.currentUser!.uid}/$recieverUserId')
          .delete();

      await FirebaseStorage.instance
          .ref()
          .child('chat/video/${auth.currentUser!.uid}/$recieverUserId')
          .delete();
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      _saveSeenDataToContactsSubcollection(
        recieverUserId,
        false,
        true,
      );
    } catch (e) {
      showMessage(context, e.toString());
    }
  }
}
