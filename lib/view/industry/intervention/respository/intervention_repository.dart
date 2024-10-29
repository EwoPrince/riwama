import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/interventionRequest.dart';
import 'package:riwama/model/user.dart';
import 'package:riwama/provider/common_firebase_storage_repository.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/x.dart';
import 'package:uuid/uuid.dart';

final InterventionRequestRepositoryProvider = Provider(
  (ref) => InterventionRequestRepository(
    firestore: FirebaseFirestore.instance,
    auth: FAuth.FirebaseAuth.instance,
  ),
);

class InterventionRequestRepository {
  final FirebaseFirestore firestore;
  final FAuth.FirebaseAuth auth;

  InterventionRequestRepository({
    required this.firestore,
    required this.auth,
  });

  Future sendInterventionRequest({
    required BuildContext context,
    required String lat,
    required String lon,
    required File file,
    required User user,
    required ProviderRef ref,
  }) async {
    try {
      var datePublished = DateTime.now();
      var interventionId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'Intervention/$interventionId',
            file,
          );

      _sendRequest(
        name: user.firstName,
        profImage: user.photoUrl,
        uid: user.uid,
        interventionrequestId: interventionId,
        proofImage: imageUrl,
        datePublished: datePublished,
        lon: lon,
        lat: lat,
      );

      NotificationService.SendTopicNotification(user.uid, 'Intervention Update',
          '${user.firstName} just uploaded a new intervention request!');
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  Future _sendRequest({
    required String name,
    required String profImage,
    required String uid,
    required String interventionrequestId,
    required String proofImage,
    required DateTime datePublished,
    required String lon,
    required String lat,
  }) async {
    final interventionrequest = Interventionrequest(
      name: name,
      profImage: profImage,
      uid: auth.currentUser!.uid,
      proofImage: proofImage,
      InterventionrequestId: interventionrequestId,
      datePublished: datePublished,
      cleared: false,
      lon: lon,
      lat: lat,
    );

    await firestore
        .collection('Interventionrequest')
        .doc(interventionrequestId)
        .set(
          interventionrequest.toMap(),
        );
  }

  Future<String> deleteInterventionRequest(
    String interventionrequestId,
  ) async {
    String res = "Some error occurred";
    try {
      await firestore
          .collection('Interventionrequest')
          .doc(interventionrequestId)
          .delete();
      await deleteToStorage(
        'PickupRequest/$interventionrequestId',
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
