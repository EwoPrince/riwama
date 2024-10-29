import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/model/PickupRequest_enum.dart';
import 'package:riwama/model/user.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/x.dart';
import 'package:uuid/uuid.dart';

final PickupRequestRepositoryProvider = Provider(
  (ref) => PickupRequestRepository(
    firestore: FirebaseFirestore.instance,
    auth: FAuth.FirebaseAuth.instance,
  ),
);

class PickupRequestRepository {
  final FirebaseFirestore firestore;
  final FAuth.FirebaseAuth auth;

  PickupRequestRepository({
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
      var pickuprequestId = const Uuid().v1();
      _sendRequest(
        name: user.firstName,
        profImage: user.photoUrl,
        description: '',
        uid: user.uid,
        pickupRequestId: pickuprequestId,
        pickupType: type.toPickupEnum(),
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
    required String pickupRequestId,
    required PickupRequestEnum pickupType,
    required DateTime datePublished,
    required String lon,
    required String lat,
  }) async {
    final pickupRequest = PickupRequest(
      name: name,
      profImage: profImage,
      description: description,
      uid: auth.currentUser!.uid,
      PickupRequestId: pickupRequestId,
      type: pickupType,
      datePublished: datePublished,
      cleared: false,
      lon: lon,
      lat: lat,
    );

    await firestore.collection('PickupRequest').doc(pickupRequestId).set(
          pickupRequest.toMap(),
        );
  }

  Future<String> deletePost(
    String pickupRequestId,
    PickupRequestEnum pickupRequestEnum,
  ) async {
    String res = "Some error occurred";
    try {
      await firestore.collection('PickupRequest').doc(pickupRequestId).delete();
      await deleteToStorage(
        'post/${pickupRequestEnum.type}/$pickupRequestId',
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
