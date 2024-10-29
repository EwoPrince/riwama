// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riwama/services/chat_search.dart';
// import 'package:riwama/view/chat/screens/chat_groups.dart';
// import 'package:riwama/view/chat/screens/chat_singles.dart';
// import 'package:riwama/x.dart';

// class chatList extends ConsumerStatefulWidget {
//   const chatList({super.key});

//   @override
//   ConsumerState<chatList> createState() => _ContactsListState();
// }

// class _ContactsListState extends ConsumerState<chatList>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(vsync: this, length: 2);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Chats").onTap(() {
//           Scaffold.of(context).openDrawer();
//         }),
//         actions: [
//           Padding(
//             padding: EdgeInsets.all(12.0),
//             child: FittedBox(
//               child: Icon(
//                 Icons.search_outlined,
//               ),
//             ).onTap(() {
//               showSearch(context: context, delegate: chartSingleSearch());
//             }),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 70,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: TabBar(
//                 controller: _tabController,
//                 onTap: (int index) {},
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 tabs: [
//                   FittedBox(
//                     child: Tab(
//                       text: 'Messages',
//                     ),
//                   ),
//                   FittedBox(
//                     child: Tab(
//                       text: 'Groups',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               dragStartBehavior: DragStartBehavior.down,
//               physics: BouncingScrollPhysics(),
//               children: [
//                 ChatSingles(),
//                 ChatGroups(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
