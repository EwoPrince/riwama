// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riwama/model/scope_user.dart';
// import 'package:riwama/provider/hutbux_provider.dart';
// import 'package:riwama/widgets/user_transfer_tile.dart';

// class TransferSearch extends SearchDelegate<ScopeUser?> {
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
//                     child: UserTransferTile(
//                       US: chatContactData,
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
//               child: UserTransferTile(
//                 US: chatContactData,
//               ),
//             );
//           },
//         );
//       }));
//     }
//     return const Center(child: Text("What're you lookin for ?"));
//   }
// }
