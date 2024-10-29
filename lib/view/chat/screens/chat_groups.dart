// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:riwama/provider/auth_provider.dart';
// import 'package:riwama/provider/chat_provider.dart';
// import 'package:riwama/provider/reload_provider.dart';
// import 'package:riwama/view/chat/screens/otherscreens/group_profile.dart';
// import 'package:riwama/view/chat/screens/mobile_chat_screen.dart';
// import 'package:riwama/view/chat/screens/otherscreens/create_group_screen.dart';
// import 'package:riwama/widgets/loading.dart';
// import 'package:riwama/x.dart';

// class ChatGroups extends ConsumerStatefulWidget {
//   const ChatGroups({super.key});

//   @override
//   ConsumerState<ChatGroups> createState() => _ChatGroupsState();
// }

// class _ChatGroupsState extends ConsumerState<ChatGroups>
//     with SingleTickerProviderStateMixin {
//   late Future futureHolder;

//   Future<bool> fetchdata() async {
//     final user = ref.read(authProvider).user;
//     try {
//       await Future.delayed(const Duration(milliseconds: 200));
//       await ref.read(chatProvider).fetchChatGroups(user!.uid);
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
//     final alreadytLoaded = ref.read(xgroupchatProvider);
//     if (!alreadytLoaded) {
//       futureHolder = fetchdata();
//     } else {
//       futureHolder = newLoad();
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         elevation: 40,
//         onPressed: () => goto(
//           context,
//           CreateGroupScreen.routeName,
//           null,
//         ),
//         child: Icon(Icons.add),
//       ),
//       body: RefreshIndicator(
//         onRefresh: onRefresh,
//         child: FutureBuilder(
//             future: futureHolder,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Loading();
//               }
//               return Consumer(builder: (context, ref, child) {
//                 final data = ref.watch(chatProvider).group;
//                 final newdata =
//                     data.where((element) => element.name.isNotEmpty).toList();
//                 return newdata.isEmpty
//                     ? Center(
//                         child: Column(
//                           children: [
//                             FittedBox(
//                               child: Image.asset(
//                                 'assets/leaf.gif',
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                             Text(
//                               'Create a Group chat with your HutBox',
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
//                           var groupData = newdata[index];
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 8.0),
//                                 child: ListTile(
//                                   title: Text(
//                                     groupData.name,
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   subtitle: Padding(
//                                     padding: EdgeInsets.only(top: 6.0),
//                                     child: Text(
//                                       groupData.lastMessage,
//                                       maxLines: 2,
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                   leading: ExtendedImage.network(
//                                     groupData.groupPic,
//                                     width: 60,
//                                     height: 60,
//                                     fit: BoxFit.cover,
//                                     cache: true,
//                                     shape: BoxShape.circle,
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(30.0),
//                                     ),
//                                   ).onTap(() {
//                                     goto(
//                                       context,
//                                       GroupProfile.routeName,
//                                       groupData.groupId,
//                                     );
//                                   }),
//                                   trailing: Text(
//                                     DateFormat.Hm()
//                                         .format(groupData.datePublished),
//                                     style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ),
//                               ).onTap(() {
//                                 goto(context, MobileChatScreen.routeName, {
//                                   "name": groupData.name,
//                                   "uid": groupData.groupId,
//                                   "isGroupChat": true,
//                                   "profilePic": groupData.groupPic,
//                                   "recieverUserId": groupData.groupId,
//                                 });
//                               }),
//                               const Divider(indent: 85),
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
