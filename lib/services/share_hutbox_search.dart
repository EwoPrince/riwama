// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riwama/model/scope_user.dart';
// import 'package:riwama/provider/hutbux_provider.dart';
// import 'package:riwama/view/account/profile/view_profile/veiw_profile.dart';
// import 'package:riwama/view/chat/controller/chat_controller.dart';
// import 'package:riwama/x.dart';

// class ShareHutBoxSearch extends SearchDelegate<ScopeUser?> {
//   final String postUid;
//   ShareHutBoxSearch({
//     required this.postUid,
//   });

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
//         final cont = ref.watch(HutBoxProvider).HutBox;

//         final availablecont = cont
//             .where((element) =>
//                 element.username.toLowerCase().contains(query.toLowerCase()))
//             .toList();

//         return availablecont.isNotEmpty
//             ? ListView.builder(
//                 physics: BouncingScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: availablecont.length,
//                 itemBuilder: (context, index) {
//                   var chatContactData = availablecont[index];

//                   return Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: ListTile(
//                       onTap: () async {
//                         final chat = await ref
//                             .read(chatControllerProvider)
//                             .checkChat(chatContactData);
//                         if (chat != null) {
//                           ref.read(chatControllerProvider).sendFlickMessage(
//                                 context,
//                                 chat.chatId,
//                                 chatContactData.uid,
//                                 postUid,
//                               );
//                         } else {
//                           var chatid = await ref
//                               .read(chatControllerProvider)
//                               .createandreturnChat(context, chatContactData);
//                           ref.read(chatControllerProvider).sendFlickMessage(
//                                 context,
//                                 chatid,
//                                 chatContactData.uid,
//                                 postUid,
//                               );
//                         }
//                       },
//                       leading: ExtendedImage.network(
//                         chatContactData.photoUrl,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         cache: true,
//                         shape: BoxShape.circle,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(30.0),
//                         ),
//                       ).onTap(() {
//                         goto(
//                           context,
//                           ViewProfile.routeName,
//                           chatContactData.uid.toString(),
//                         );
//                       }),
//                       title: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(width: 10),
//                           Text(
//                             chatContactData.username,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
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
//         final cont = ref.watch(HutBoxProvider).HutBox;
//         final availablesubcat = cont
//             .where((element) =>
//                 element.username.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//         return ListView.builder(
//           physics: BouncingScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: availablesubcat.length,
//           itemBuilder: (context, index) {
//             var chatContactData = availablesubcat[index];

//             return Padding(
//               padding: EdgeInsets.all(8.0),
//               child: ListTile(
//                 onTap: () async {
//                   final chat = await ref
//                       .read(chatControllerProvider)
//                       .checkChat(chatContactData);
//                   if (chat != null) {
//                     ref.read(chatControllerProvider).sendFlickMessage(
//                           context,
//                           chat.chatId,
//                           chatContactData.uid,
//                           postUid,
//                         );
//                   } else {
//                     var chatid = await ref
//                         .read(chatControllerProvider)
//                         .createandreturnChat(context, chatContactData);
//                     ref.read(chatControllerProvider).sendFlickMessage(
//                           context,
//                           chatid,
//                           chatContactData.uid,
//                           postUid,
//                         );
//                   }
//                 },
//                 leading: ExtendedImage.network(
//                   chatContactData.photoUrl,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                   cache: true,
//                   shape: BoxShape.circle,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(30.0),
//                   ),
//                 ).onTap(() {
//                   goto(
//                     context,
//                     ViewProfile.routeName,
//                     chatContactData.uid.toString(),
//                   );
//                 }),
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(width: 10),
//                     Text(
//                       chatContactData.username,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }));
//     }
//     return const Center(child: Text("What're you lookin for ?"));
//   }
// }
