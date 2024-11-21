import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riwama/model/interventionRequest.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/model/receptacle.dart';
import 'package:riwama/model/slide.dart';
import 'package:riwama/model/tow.dart';

class IndustryService {

  static Stream<List<Slide>> fetchSlides() {
    return FirebaseFirestore.instance
        .collection('Slides')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((QuerySnapshot event) {
      List<Slide> R = [];

      for (QueryDocumentSnapshot document in event.docs) {
        Slide pr =
            Slide.fromMap(document.data() as Map<String, dynamic>);
        R.add(pr);
      }

      return R;
    });
  }


  static Stream<List<Receptacle>> fetchReceptacle() {
    return FirebaseFirestore.instance
        .collection('Receptacle')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((QuerySnapshot event) {
      List<Receptacle> R = [];

      for (QueryDocumentSnapshot document in event.docs) {
        Receptacle pr =
            Receptacle.fromMap(document.data() as Map<String, dynamic>);
        R.add(pr);
      }

      return R;
    });
  }


  static Stream<List<TowRequest>> fetchTowRequest() {
    return FirebaseFirestore.instance
        .collection('TowRequest')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((QuerySnapshot event) {
      List<TowRequest> R = [];

      for (QueryDocumentSnapshot document in event.docs) {
        TowRequest pr =
            TowRequest.fromMap(document.data() as Map<String, dynamic>);
        R.add(pr);
      }

      return R;
    });
  }


  static Stream<List<PickupRequest>> fetchPickupRequest() {
    return FirebaseFirestore.instance
        .collection('PickupRequest')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((QuerySnapshot event) {
      List<PickupRequest> pRs = [];

      for (QueryDocumentSnapshot document in event.docs) {
        PickupRequest pr =
            PickupRequest.fromMap(document.data() as Map<String, dynamic>);
        pRs.add(pr);
      }

      return pRs;
    });
  }

  static Stream<List<Interventionrequest>> fetchInterventionRequest() {
    return FirebaseFirestore.instance
        .collection('Interventionrequest')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((QuerySnapshot event) {
      List<Interventionrequest> iRs = [];

      for (QueryDocumentSnapshot document in event.docs) {
        Interventionrequest iR = Interventionrequest.fromMap(
            document.data() as Map<String, dynamic>);
        iRs.add(iR);
      }

      return iRs;
    });
  }

  static Stream<List<PickupRequest>> fetchTimePR(DateTime time) {
    return FirebaseFirestore.instance
        .collection('PickupRequest')
        .where('datePublished', isGreaterThanOrEqualTo: time)
        .snapshots()
        .map((QuerySnapshot event) {
      List<PickupRequest> tPRs = [];

      for (QueryDocumentSnapshot document in event.docs) {
        PickupRequest tPR =
            PickupRequest.fromMap(document.data() as Map<String, dynamic>);
        tPRs.add(tPR);
      }

      return tPRs;
    });
  }

  static Stream<List<Interventionrequest>> fetchTimeIR(DateTime time) {
    return FirebaseFirestore.instance
        .collection('PickupRequest')
        .where('datePublished', isGreaterThanOrEqualTo: time)
        .snapshots()
        .map((QuerySnapshot event) {
      List<Interventionrequest> tIRs = [];

      for (QueryDocumentSnapshot document in event.docs) {
        Interventionrequest tIR = Interventionrequest.fromMap(
            document.data() as Map<String, dynamic>);
        tIRs.add(tIR);
      }

      return tIRs;
    });
  }

  // static Future<List<ScopeUser>> fetchHooksData(List hook) async {
  //   List<ScopeUser> scoperList = [];

  //   Future.forEach(hook, (element) async {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(element.toString())
  //         .get();
  //     if (snapshot.exists) {
  //       final userData = snapshot.data() as Map<String, dynamic>;
  //       ScopeUser state;
  //       state = ScopeUser.fromMap(userData);
  //       scoperList.add(state);
  //     }
  //   });

  //   return scoperList;
  // }
}
