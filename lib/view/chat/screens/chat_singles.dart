// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:riwama/model/chat_contact.dart';
// import 'package:riwama/provider/auth_provider.dart';
// import 'package:riwama/provider/chat_provider.dart';
// import 'package:riwama/provider/reload_provider.dart';
// import 'package:riwama/view/account/profile/view_profile/veiw_profile.dart';
// import 'package:riwama/view/chat/controller/chat_controller.dart';
// import 'package:riwama/view/chat/screens/mobile_chat_screen.dart';
// import 'package:riwama/widgets/loading.dart';
// import 'package:riwama/widgets/overlaybutton.dart';
// import 'package:riwama/x.dart';

// class ChatSingles extends ConsumerStatefulWidget {
//   const ChatSingles({super.key});

//   @override
//   ConsumerState<ChatSingles> createState() => _ChatSinglesState();
// }

// class _ChatSinglesState extends ConsumerState<ChatSingles>
//     with SingleTickerProviderStateMixin {
//   late Future futureHolder;

//   Future<bool> fetchdata() async {
//     final user = ref.read(authProvider).user;
//     try {
//       await ref.read(chatProvider).fetchChatContacts(user!.uid);
//       await Future.delayed(const Duration(milliseconds: 200));
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> newLoad() async {
//     await Future.delayed(const Duration(milliseconds: 20));
//     return true;
//   }

//   Future<void> onRefresh() async {
//     setState(() {
//       futureHolder = fetchdata();
//     });
//   }

//   @override
//   initState() {
//     final alreadytLoaded = ref.read(xsinglechatProvider);
//     if (!alreadytLoaded) {
//       futureHolder = fetchdata();
//     } else {
//       futureHolder = newLoad();
//     }
//     super.initState();
//   }

//   void _showModalBottomSheet(
//       BuildContext context, ChatContact chatContactData) {
//     final otherUser = chatContactData.getProfiles
//         .where((element) => element.uid != ref.read(authProvider).user!.uid)
//         .firstOrNull;

//     showModalBottomSheet(
//       context: context,
//       showDragHandle: true,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//           ),
//           padding: EdgeInsets.all(32),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(bottom: 8.0),
//                 child: ListTile(
//                   title: Text(
//                     otherUser!.username,
//                     maxLines: 1,
//                     style: const TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                   subtitle: Padding(
//                     padding: const EdgeInsets.only(top: 6.0),
//                     child: Text(
//                       chatContactData.lastMessage,
//                       maxLines: 2,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   leading: ExtendedImage.network(
//                     otherUser.profilePic,
//                     width: 60,
//                     height: 60,
//                     fit: BoxFit.cover,
//                     cache: true,
//                     shape: BoxShape.circle,
//                   ).onTap(() {
//                     goto(
//                       context,
//                       ViewProfile.routeName,
//                       otherUser.uid,
//                     );
//                   }),
//                   trailing: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         DateFormat.Hm().format(chatContactData.datePublished),
//                         style: TextStyle(
//                           color:
//                               chatContactData.lastMessageBy == otherUser.uid &&
//                                       !chatContactData.isSeen
//                                   ? Colors.green
//                                   : Colors.grey,
//                           fontSize: 13,
//                         ),
//                       ),
//                       if (chatContactData.isSeen &&
//                           chatContactData.lastMessageBy != otherUser.uid)
//                         Icon(
//                           Icons.done_all,
//                           size: 20,
//                           color: Colors.blue,
//                         ),
//                       if (!chatContactData.isSeen &&
//                           chatContactData.lastMessageBy != otherUser.uid)
//                         Icon(
//                           Icons.done,
//                           size: 20,
//                           color: Colors.grey,
//                         ),
//                       if (chatContactData.lastMessageBy == otherUser.uid &&
//                           !chatContactData.isSeen)
//                         SizedBox(
//                           height: 12,
//                         ),
//                       if (chatContactData.lastMessageBy == otherUser.uid &&
//                           !chatContactData.isSeen)
//                         Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.green,
//                           ),
//                           height: 12,
//                           width: 12,
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               overlayButton(
//                 context,
//                 'Clear chat',
//                 () {
//                   ref
//                       .read(chatControllerProvider)
//                       .clearChat(context, chatContactData.chatId);
//                   Navigator.pop(context);
//                 },
//                 true,
//                 false,
//               ),
//               overlayButton(
//                 context,
//                 'Cancel',
//                 () {
//                   Navigator.pop(context);
//                 },
//                 false,
//                 true,
//               ),
//               SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.read(authProvider).user;
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         elevation: 40,
//         onPressed: () {},
//         child: Icon(Icons.add),
//       ),
//       body: RefreshIndicator(
//         onRefresh: onRefresh,
//         child: FutureBuilder(
//             future: futureHolder,
//             builder: (context, snapshot) {
//               if (snapshot.hasError)
//                 return Text('You\'ve got some damn errors');
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Loading();
//               }
//               return Consumer(builder: (context, ref, child) {
//                 final data = ref.watch(chatProvider).contacts;
//                 final newdata =
//                     data.where((element) => element.chatId.isNotEmpty).toList();
//                 return newdata.isEmpty
//                     ? Center(
//                         child: Column(
//                           children: [
//                             FittedBox(
//                               child: Image.asset(
//                                 'assets/merest.png',
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                             Text(
//                               'You have no DM',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: newdata.length,
//                         itemBuilder: (context, index) {
//                           var chatContactData = newdata[index];

//                           final otherUser = chatContactData.getProfiles
//                               .where((element) =>
//                                   element.uid !=
//                                   ref.read(authProvider).user!.uid)
//                               .firstOrNull;

//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 8.0),
//                                 child: ListTile(
//                                   onLongPress: () {
//                                     _showModalBottomSheet(
//                                         context, chatContactData);
//                                   },
//                                   onTap: () {
//                                     ref
//                                         .read(chatControllerProvider)
//                                         .updatepic(chatContactData);
//                                     goto(context, MobileChatScreen.routeName, {
//                                       "name": otherUser.username,
//                                       "uid": chatContactData.chatId,
//                                       "isGroupChat": false,
//                                       "profilePic": otherUser.profilePic,
//                                       "recieverUserId": otherUser.uid,
//                                     });
//                                   },
//                                   title: Text(
//                                     otherUser!.username,
//                                     maxLines: 1,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   subtitle: Padding(
//                                     padding: const EdgeInsets.only(top: 6.0),
//                                     child: Text(
//                                       chatContactData.lastMessage,
//                                       maxLines: 2,
//                                       style: const TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                   leading: ExtendedImage.network(
//                                     otherUser.profilePic,
//                                     width: 60,
//                                     height: 60,
//                                     fit: BoxFit.cover,
//                                     cache: true,
//                                     shape: BoxShape.circle,
//                                   ).onTap(() {
//                                     goto(
//                                       context,
//                                       ViewProfile.routeName,
//                                       otherUser.uid,
//                                     );
//                                   }),
//                                   trailing: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         DateFormat.Hm().format(
//                                             chatContactData.datePublished),
//                                         style: TextStyle(
//                                           color:
//                                               chatContactData.lastMessageBy !=
//                                                           user!.uid &&
//                                                       !chatContactData.isSeen
//                                                   ? Colors.green
//                                                   : Colors.grey,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       if (chatContactData.isSeen &&
//                                           chatContactData.lastMessageBy ==
//                                               user.uid)
//                                         Icon(
//                                           Icons.done_all,
//                                           size: 20,
//                                           color: Colors.blue,
//                                         ),
//                                       if (!chatContactData.isSeen &&
//                                           chatContactData.lastMessageBy ==
//                                               user.uid)
//                                         Icon(
//                                           Icons.done,
//                                           size: 20,
//                                           color: Colors.grey,
//                                         ),
//                                       if (chatContactData.lastMessageBy !=
//                                               user.uid &&
//                                           !chatContactData.isSeen)
//                                         SizedBox(
//                                           height: 12,
//                                         ),
//                                       if (chatContactData.lastMessageBy !=
//                                               user.uid &&
//                                           !chatContactData.isSeen)
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Colors.green,
//                                           ),
//                                           height: 12,
//                                           width: 12,
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Divider(
//                                 indent: 85,
//                               ),
//                             ],
//                           );
//                         },
//                       );
//               });
//             }),
//       ),
//     );
//   }
// }
