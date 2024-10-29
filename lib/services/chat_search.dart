// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riwama/model/chat_contact.dart';
// import 'package:riwama/provider/auth_provider.dart';
// import 'package:riwama/provider/chat_provider.dart';
// import 'package:intl/intl.dart';
// import 'package:riwama/view/account/profile/view_profile/veiw_profile.dart';
// import 'package:riwama/view/chat/controller/chat_controller.dart';
// import 'package:riwama/view/chat/screens/mobile_chat_screen.dart';
// import 'package:riwama/widgets/overlaybutton.dart';
// import 'package:riwama/x.dart';

// class chartSingleSearch extends SearchDelegate<ChatContact?> {
//   chartSingleSearch();

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//             query = "";
//           })
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () => close(context, null),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final cont = ref.watch(chatProvider).contacts;
//         final uid = ref.read(authProvider).user!.uid;

//         final availablecont = cont.where((chat) {
//           final users = chat.getProfiles
//               .where((profile) => profile.uid != uid)
//               .map((e) => e.username.toLowerCase())
//               .toList();

//           final queriedUsers =
//               users.where((names) => names.contains(query.toLowerCase()));

//           return queriedUsers.isNotEmpty;
//         }).toList();

//         return availablecont.isNotEmpty
//             ? ListView.builder(
//                 physics: BouncingScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: availablecont.length,
//                 itemBuilder: (context, index) {
//                   var chatContactData = availablecont[index];

//                   _showModalBottomSheet(
//                       BuildContext context, ChatContact chatContactData) {
//                     showModalBottomSheet(
//                       context: context,
//                       showDragHandle: true,
//                       isScrollControlled: true,
//                       builder: (BuildContext context) {
//                         final otherUser = chatContactData.getProfiles
//                             .where((element) =>
//                                 element.uid != ref.read(authProvider).user!.uid)
//                             .firstOrNull;

//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.transparent,
//                           ),
//                           padding: EdgeInsets.all(32),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 8.0),
//                                 child: ListTile(
//                                   title: Text(
//                                     otherUser!.username,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   subtitle: Padding(
//                                     padding: const EdgeInsets.only(top: 6.0),
//                                     child: Text(
//                                       chatContactData.lastMessage,
//                                       style: const TextStyle(fontSize: 15),
//                                     ),
//                                   ),
//                                   leading: ExtendedImage.network(
//                                     otherUser.profilePic,
//                                     width: 60,
//                                     height: 60,
//                                     fit: BoxFit.cover,
//                                     cache: true,
//                                     shape: BoxShape.circle,
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(30.0),
//                                     ),
//                                   ).onTap(() {
//                                     goto(context, ViewProfile.routeName,
//                                         otherUser.uid);
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
//                                               chatContactData.lastMessageBy ==
//                                                           otherUser.uid &&
//                                                       !chatContactData.isSeen
//                                                   ? Colors.green
//                                                   : Colors.grey,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       if (chatContactData.isSeen &&
//                                           chatContactData.lastMessageBy !=
//                                               otherUser.uid)
//                                         Icon(
//                                           Icons.done_all,
//                                           size: 20,
//                                           color: Colors.blue,
//                                         ),
//                                       if (!chatContactData.isSeen &&
//                                           chatContactData.lastMessageBy !=
//                                               otherUser.uid)
//                                         Icon(
//                                           Icons.done,
//                                           size: 20,
//                                           color: Colors.grey,
//                                         ),
//                                       if (chatContactData.lastMessageBy ==
//                                               otherUser.uid &&
//                                           !chatContactData.isSeen)
//                                         SizedBox(
//                                           height: 12,
//                                         ),
//                                       if (chatContactData.lastMessageBy ==
//                                               otherUser.uid &&
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
//                               overlayButton(
//                                 context,
//                                 'Clear chat', () {
//                                 ref
//                                     .read(chatControllerProvider)
//                                     .clearChat(context, otherUser.uid);
//                                 Navigator.pop(context);
//                               },
//                               true,
//                               false,
//                               ),
//                               overlayButton(
//                                 context,
//                                 'Cancel', () {
//                                 Navigator.pop(context);
//                               },
//                               false,
//                               true,
//                               ),
//                               SizedBox(height: 16),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }

//                   final otherUser = chatContactData.getProfiles
//                       .where((element) =>
//                           element.uid != ref.read(authProvider).user!.uid)
//                       .firstOrNull;

//                   return Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: ListTile(
//                           onLongPress: () {
//                             _showModalBottomSheet(context, chatContactData);
//                           },
//                           onTap: () {
//                             goto(
//                               context,
//                               MobileChatScreen.routeName,
//                               {
//                                 "uid": chatContactData.chatId,
//                                 "name": otherUser.username,
//                                 "isGroupChat": false,
//                                 "profilePic": otherUser.profilePic,
//                                 "recieverUserId": otherUser.uid,
//                               },
//                             );
//                           },
//                           title: Text(
//                             otherUser!.username,
//                             style: const TextStyle(
//                               fontSize: 18,
//                             ),
//                           ),
//                           subtitle: Padding(
//                             padding: const EdgeInsets.only(top: 6.0),
//                             child: Text(
//                               chatContactData.lastMessage,
//                               style: const TextStyle(fontSize: 15),
//                             ),
//                           ),
//                           leading: ExtendedImage.network(
//                             otherUser.profilePic,
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                             cache: true,
//                             shape: BoxShape.circle,
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(30.0),
//                             ),
//                           ).onTap(() {
//                             goto(context, ViewProfile.routeName, {
//                               "uid": otherUser.uid,
//                             });
//                           }),
//                           trailing: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 DateFormat.Hm()
//                                     .format(chatContactData.datePublished),
//                                 style: TextStyle(
//                                   color: chatContactData.lastMessageBy ==
//                                               otherUser.uid &&
//                                           !chatContactData.isSeen
//                                       ? Colors.green
//                                       : Colors.grey,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                               if (chatContactData.isSeen &&
//                                   chatContactData.lastMessageBy !=
//                                       otherUser.uid)
//                                 Icon(
//                                   Icons.done_all,
//                                   size: 20,
//                                   color: Colors.blue,
//                                 ),
//                               if (!chatContactData.isSeen &&
//                                   chatContactData.lastMessageBy !=
//                                       otherUser.uid)
//                                 Icon(
//                                   Icons.done,
//                                   size: 20,
//                                   color: Colors.grey,
//                                 ),
//                               if (chatContactData.lastMessageBy ==
//                                       otherUser.uid &&
//                                   !chatContactData.isSeen)
//                                 SizedBox(
//                                   height: 12,
//                                 ),
//                               if (chatContactData.lastMessageBy ==
//                                       otherUser.uid &&
//                                   !chatContactData.isSeen)
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.green,
//                                   ),
//                                   height: 12,
//                                   width: 12,
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Divider(
//                         indent: 85,
//                       ),
//                     ],
//                   );
//                 },
//               )
//             : Center(child: Text("Nope! That ain't available"));
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isNotEmpty) {
//       return Consumer(builder: ((context, ref, child) {
//         final uid = ref.read(authProvider).user!.uid;
//         final cont = ref.watch(chatProvider).contacts;
//         final availablesubcat = cont.where((chat) {
//           final users = chat.getProfiles
//               .where((profile) => profile.uid != uid)
//               .map((e) => e.username.toLowerCase())
//               .toList();

//           final queriedUsers =
//               users.where((names) => names.contains(query.toLowerCase()));

//           return queriedUsers.isNotEmpty;
//         }).toList();

//         return ListView.builder(
//           physics: BouncingScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: availablesubcat.length,
//           itemBuilder: (context, index) {
//             var chatContactData = availablesubcat[index];
//             final otherUser = chatContactData.getProfiles
//                 .where((element) =>
//                     element.uid != ref.read(authProvider).user!.uid)
//                 .firstOrNull;

//             _showModalBottomSheet(
//                 BuildContext context, ChatContact chatContactData) {
//               showModalBottomSheet(
//                 context: context,
//                 showDragHandle: true,
//                 isScrollControlled: true,
//                 builder: (BuildContext context) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                     ),
//                     padding: EdgeInsets.all(32),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: ListTile(
//                             title: Text(
//                               otherUser!.username,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                               ),
//                             ),
//                             subtitle: Padding(
//                               padding: const EdgeInsets.only(top: 6.0),
//                               child: Text(
//                                 chatContactData.lastMessage,
//                                 style: const TextStyle(fontSize: 15),
//                               ),
//                             ),
//                             leading: ExtendedImage.network(
//                               otherUser.profilePic,
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                               cache: true,
//                               shape: BoxShape.circle,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(30.0),
//                               ),
//                             ).onTap(() {
//                               goto(
//                                 context,
//                                 ViewProfile.routeName,
//                                 otherUser.uid,
//                               );
//                             }),
//                             trailing: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   DateFormat.Hm()
//                                       .format(chatContactData.datePublished),
//                                   style: TextStyle(
//                                     color: chatContactData.lastMessageBy ==
//                                                 otherUser.uid &&
//                                             !chatContactData.isSeen
//                                         ? Colors.green
//                                         : Colors.grey,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 if (chatContactData.isSeen &&
//                                     chatContactData.lastMessageBy !=
//                                         otherUser.uid)
//                                   Icon(
//                                     Icons.done_all,
//                                     size: 20,
//                                     color: Colors.blue,
//                                   ),
//                                 if (!chatContactData.isSeen &&
//                                     chatContactData.lastMessageBy !=
//                                         otherUser.uid)
//                                   Icon(
//                                     Icons.done,
//                                     size: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 if (chatContactData.lastMessageBy ==
//                                         otherUser.uid &&
//                                     !chatContactData.isSeen)
//                                   SizedBox(
//                                     height: 12,
//                                   ),
//                                 if (chatContactData.lastMessageBy ==
//                                         otherUser.uid &&
//                                     !chatContactData.isSeen)
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.green,
//                                     ),
//                                     height: 12,
//                                     width: 12,
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         overlayButton(
//                           context,
//                           'Clear chat', () {
//                           ref
//                               .read(chatControllerProvider)
//                               .clearChat(context, otherUser.uid);
//                           Navigator.pop(context);
//                         },
//                         true,
//                         false,
//                         ),
//                         overlayButton(
//                           context,
//                           'Cancel', () {
//                           Navigator.pop(context);
//                         },
//                         false,
//                         true,
//                         ),
//                         SizedBox(height: 16),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }

//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: ListTile(
//                     onLongPress: () {
//                       _showModalBottomSheet(context, chatContactData);
//                     },
//                     onTap: () {
//                       goto(context, MobileChatScreen.routeName, {
//                         "name": otherUser.username,
//                         "uid": chatContactData.chatId,
//                         "isGroupChat": false,
//                         "profilePic": otherUser.profilePic,
//                         "recieverUserId": otherUser.uid,
//                       });
//                     },
//                     title: Text(
//                       otherUser!.username,
//                       style: const TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 6.0),
//                       child: Text(
//                         chatContactData.lastMessage,
//                         style: const TextStyle(fontSize: 15),
//                       ),
//                     ),
//                     leading: ExtendedImage.network(
//                       otherUser.profilePic,
//                       width: 60,
//                       height: 60,
//                       fit: BoxFit.cover,
//                       cache: true,
//                       shape: BoxShape.circle,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(30.0),
//                       ),
//                     ).onTap(() {
//                       goto(context, ViewProfile.routeName, otherUser.uid);
//                     }),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           DateFormat.Hm().format(chatContactData.datePublished),
//                           style: TextStyle(
//                             color: chatContactData.lastMessageBy ==
//                                         otherUser.uid &&
//                                     !chatContactData.isSeen
//                                 ? Colors.green
//                                 : Colors.grey,
//                             fontSize: 13,
//                           ),
//                         ),
//                         if (chatContactData.isSeen &&
//                             chatContactData.lastMessageBy != otherUser.uid)
//                           Icon(
//                             Icons.done_all,
//                             size: 20,
//                             color: Colors.blue,
//                           ),
//                         if (!chatContactData.isSeen &&
//                             chatContactData.lastMessageBy != otherUser.uid)
//                           Icon(
//                             Icons.done,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                         if (chatContactData.lastMessageBy == otherUser.uid &&
//                             !chatContactData.isSeen)
//                           SizedBox(
//                             height: 12,
//                           ),
//                         if (chatContactData.lastMessageBy == otherUser.uid &&
//                             !chatContactData.isSeen)
//                           Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.green,
//                             ),
//                             height: 12,
//                             width: 12,
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Divider(
//                   indent: 85,
//                 ),
//               ],
//             );
//           },
//         );
//       }));
//     }
//     return const Center(child: Text("What're you lookin for ?"));
//   }
// }
