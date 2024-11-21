import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/tow.dart';
import 'package:riwama/model/user.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/x.dart';
import 'package:uuid/uuid.dart';

final TowRequestRepositoryProvider = Provider(
  (ref) => TowRequestRepository(
    firestore: FirebaseFirestore.instance,
    auth: FAuth.FirebaseAuth.instance,
  ),
);

class TowRequestRepository {
  final FirebaseFirestore firestore;
  final FAuth.FirebaseAuth auth;

  TowRequestRepository({
    required this.firestore,
    required this.auth,
  });

  Future sendRequest({
    required BuildContext context,
    required String lat,
    required String lon,
    required String type,
    required User user,
  }) async {
    try {
      var datePublished = DateTime.now();
      var TowRequestId = const Uuid().v1();
      _sendRequest(
        name: user.firstName,
        profImage: user.photoUrl,
        description: user.phone,
        uid: user.uid,
        TowRequestId: TowRequestId,
        datePublished: datePublished,
        lat: lat,
        lon: lon,
      );

      NotificationService.SendTopicNotification(user.uid, 'Pickup Update',
          '${user.firstName} just uploaded a new pickup request!');
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  Future _sendRequest({
    required String name,
    required String profImage,
    required String description,
    required String uid,
    required String TowRequestId,
    required DateTime datePublished,
    required String lon,
    required String lat,
  }) async {
    final towRequest = TowRequest(
      name: name,
      profImage: profImage,
      description: auth.currentUser!.phoneNumber ?? '0000000',
      uid: auth.currentUser!.uid,
      TowRequestId: TowRequestId,
      datePublished: datePublished,
      cleared: false,
      lon: lon,
      lat: lat,
    );

    await firestore.collection('TowRequest').doc(TowRequestId).set(
          towRequest.toMap(),
        );
  }

  Future<String> deletePost(
    String TowRequestId,
  ) async {
    String res = "Some error occurred";
    try {
      await firestore.collection('TowRequest').doc(TowRequestId).delete();
      await deleteToStorage(
        'TowRequest/$TowRequestId',
      );

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  deleteToStorage(
    String childName,
  ) async {
    Reference ref = FirebaseStorage.instance.ref().child(childName);
    ref.delete();
  }
}
