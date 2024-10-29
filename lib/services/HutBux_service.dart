// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:riwama/model/scope_user.dart';
// import 'package:riwama/model/user.dart';
// import 'package:riwama/services/notification_service.dart';

// class HutBoxService {
//   static Future<List<ScopeUser>> fetchHutBoxData(List<String> box) async {
//     List<ScopeUser> scoperxList = [];

//     Future.forEach(box, (String element) async {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(element)
//           .get();
//       if (snapshot.exists) {
//         final userData = snapshot.data() as Map<String, dynamic>;
//         ScopeUser state;
//         state = ScopeUser.fromMap(userData);
//         scoperxList.add(state);
//       }
//     });

//     return scoperxList;
//   }

//   static Future<List<ScopeUser>> fetchboxData(List<String> box) async {
//     List<ScopeUser> scoperList = [];

//     Future.forEach(box, (String element) async {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(element)
//           .get();
//       if (snapshot.exists) {
//         final userData = snapshot.data() as Map<String, dynamic>;
//         ScopeUser state;
//         state = ScopeUser.fromMap(userData);
//         scoperList.add(state);
//       }
//     });

//     return scoperList;
//   }

//   Future<void> KickUser(String uid, String HutBoxId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(HutBoxId)
//           .update({
//         'bux': FieldValue.arrayRemove([uid])
//       });

//       await FirebaseFirestore.instance.collection('users').doc(uid).update({
//         'hutbox': FieldValue.arrayRemove([HutBoxId])
//       });
//       await NotificationService.unsubscribeto(HutBoxId);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<void> HutUser(String uid, String HutBoxId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(HutBoxId)
//           .update({
//         'bux': FieldValue.arrayUnion([uid])
//       });
//       await FirebaseFirestore.instance.collection('users').doc(uid).update({
//         'hutbox': FieldValue.arrayUnion([HutBoxId])
//       });
//       await NotificationService.subscribeto(HutBoxId);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   static Stream<List<ScopeUser>> suggestHutBox(User user) {
//     return FirebaseFirestore.instance
//         .collection('users')
//         .orderBy(
//           'name',
//         )
//         .limit(70)
//         .snapshots()
//         .map((QuerySnapshot event) {
//       List<ScopeUser> sc = [];

//       for (QueryDocumentSnapshot document in event.docs) {
//         ScopeUser xu =
//             ScopeUser.fromMap(document.data() as Map<String, dynamic>);

//         // Check if the user's uid is not in the box list
//         if (!user.bux.contains(xu.uid)) {
//           sc.add(xu);
//         }
//       }
//       return sc;
//     });
//   }

//   static Stream<List<ScopeUser>> suggestHutBoxGradeA(User user) {
//     return FirebaseFirestore.instance
//         .collection('users')
//         .orderBy('isOnline')
//         .limit(50)
//         .snapshots()
//         .map((QuerySnapshot event) {
//       List<ScopeUser> sc = [];

//       for (QueryDocumentSnapshot document in event.docs) {
//         ScopeUser xu =
//             ScopeUser.fromMap(document.data() as Map<String, dynamic>);

//         // Check if the user's uid is not in the box list
//         if (!user.bux.contains(xu.uid)) {
//           sc.add(xu);
//         }
//       }
//       return sc;
//     });
//   }

//   static Stream<List<ScopeUser>> suggestHutBoxGradeB(User user) {
//     return FirebaseFirestore.instance
//         .collection('users')
//         .orderBy(
//           'phone',
//         )
//         .limit(50)
//         .snapshots()
//         .map((QuerySnapshot event) {
//       List<ScopeUser> sc = [];

//       for (QueryDocumentSnapshot document in event.docs) {
//         ScopeUser xu =
//             ScopeUser.fromMap(document.data() as Map<String, dynamic>);

//         // Check if the user's uid is not in the box list
//         if (!user.bux.contains(xu.uid)) {
//           sc.add(xu);
//         }
//       }
//       return sc;
//     });
//   }

//   static Stream<List<ScopeUser>> suggestHutBoxGradeC(User user) {
//     return FirebaseFirestore.instance
//         .collection('users')
//         .orderBy(
//           'bux',
//         )
//         .limit(50)
//         .snapshots()
//         .map((QuerySnapshot event) {
//       List<ScopeUser> sc = [];

//       for (QueryDocumentSnapshot document in event.docs) {
//         ScopeUser xu =
//             ScopeUser.fromMap(document.data() as Map<String, dynamic>);

//         // Check if the user's uid is not in the box list
//         if (!user.bux.contains(xu.uid)) {
//           sc.add(xu);
//         }
//       }
//       return sc;
//     });
//   }
// }
