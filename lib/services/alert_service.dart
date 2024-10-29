import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riwama/model/interventionRequest.dart';
import 'package:riwama/model/pickupRequest.dart';

class AlertService {

  static Stream<List<Interventionrequest>> getInterventions(String uid) {
    return FirebaseFirestore.instance
        .collection("Interventionrequest")
        .orderBy("datePublished", descending: true)
        .snapshots()
        .map((event) {
      List<Interventionrequest> chats = [];
      for (var document in event.docs) {
        var chat = Interventionrequest.fromMap(document.data());
        if (chat.uid == uid ) {
          chats.add(chat);
        }
      }
      return chats;
        });

  }

  static Stream<List<PickupRequest>> getPickUpRequest(String uid) {
    return FirebaseFirestore.instance
        .collection('PickupRequest')
        .orderBy("datePublished", descending: true)
        .snapshots()
        .map((event) {
      List<PickupRequest> groups = [];
      for (var document in event.docs) {
        var group = PickupRequest.fromMap(document.data());
        if (group.uid == uid) {
          groups.add(group);
        }
      }
      return groups;
    });
  }
}
