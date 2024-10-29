// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riwama/model/chat_contact.dart';
// import 'package:riwama/model/group.dart';
// import 'package:riwama/services/alert_service.dart';

// final chatProvider =
//     ChangeNotifierProvider<ChatProviders>((ref) => ChatProviders());

// class ChatProviders extends ChangeNotifier {
//   List<ChatContact> _contacts = [];
//   int _unreadChat = 0;
//   List<Group> _group = [];

//   List<ChatContact> get contacts => _contacts;
//   int get unreadChat => _unreadChat;
//   List<Group> get group => _group;

//   Future<void> fetchChatContacts(String uid) async {
//     try {
//       final Stream<List<ChatContact>> dataStream =
//           ChatService.getChatContacts(uid);
//       dataStream.listen((data) {
//         List<ChatContact> chatx = data.where((element) {
//           bool notSeen =
//               element.isSeen == false && element.lastMessageBy != uid;

//           return notSeen;
//         }).toList();

//         _unreadChat = chatx.length;
//         _contacts = data;
        
//         notifyListeners();
//       });
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }

//   Future<void> fetchChatGroups(String uid) async {
//     try {
//       final Stream<List<Group>> dataStream = ChatService.getChatGroups(uid);
//       dataStream.listen((data) {
//         _group = data;
//         notifyListeners();
//       });
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }
// }
