import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/receptacle.dart';
import 'package:riwama/model/user.dart';
import 'package:riwama/provider/common_firebase_storage_repository.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/x.dart';
import 'package:uuid/uuid.dart';

final ReceptacleRepositoryProvider = Provider(
  (ref) => ReceptacleRepository(
    firestore: FirebaseFirestore.instance,
    auth: FAuth.FirebaseAuth.instance,
  ),
);

class ReceptacleRepository {
  final FirebaseFirestore firestore;
  final FAuth.FirebaseAuth auth;

  ReceptacleRepository({
    required this.firestore,
    required this.auth,
  });

  Future addReceptacle({
    required BuildContext context,
    required String lat,
    required String lon,
    required File file,
    required User user,
    required ProviderRef ref,
  }) async {
    try {
      var datePublished = DateTime.now();
      var receptacleId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'Receptacle/$receptacleId',
            file,
          );

     await _addR(
        name: user.firstName,
        description: '',
        uid: user.uid,
        receptacleId: receptacleId,
        proofImage: imageUrl,
        datePublished: datePublished,
        lon: lon,
        lat: lat,
      );

      NotificationService.SendTopicNotification(user.uid, 'Receptacle Update',
          '${user.firstName} just uploaded a new Receptacle');
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  Future _addR({
    required String name,
    required String description,
    required String uid,
    required String receptacleId,
    required String proofImage,
    required DateTime datePublished,
    required String lon,
    required String lat,
  }) async {
    final receptacle = Receptacle(
      name: name,
      description: description,
      uid: auth.currentUser!.uid,
      profImage: proofImage,
      receptacleId: receptacleId,
      datePublished: datePublished,
      cleared: true,
      lon: lon,
      lat: lat,
    );

    await firestore
        .collection('Receptacle')
        .doc(receptacleId)
        .set(
          receptacle.toMap(),
        );
  }

  Future<String> deleteInterventionRequest(
    String receptacleId,
  ) async {
    String res = "Some error occurred";
    try {
      await firestore
          .collection('Receptacle')
          .doc(receptacleId)
          .delete();
      await deleteToStorage(
        'Receptacle/$receptacleId',
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
