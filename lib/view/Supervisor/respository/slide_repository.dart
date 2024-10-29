import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/slide.dart';
import 'package:riwama/model/user.dart';
import 'package:riwama/provider/common_firebase_storage_repository.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/x.dart';
import 'package:uuid/uuid.dart';

final SlideRepositoryProvider = Provider(
  (ref) => SlideRepository(
    firestore: FirebaseFirestore.instance,
    auth: FAuth.FirebaseAuth.instance,
  ),
);

class SlideRepository {
  final FirebaseFirestore firestore;
  final FAuth.FirebaseAuth auth;

  SlideRepository({
    required this.firestore,
    required this.auth,
  });

  Future addSlide({
    required BuildContext context,
    required File file,
    required User user,
    required ProviderRef ref,
  }) async {
    try {
      var datePublished = DateTime.now();
      var slideId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'Slides/$slideId',
            file,
          );

      await _addSlide(
        slideId: slideId,
        proofImage: imageUrl,
        datePublished: datePublished,
      );

      NotificationService.SendTopicNotification(user.uid, 'Slide Update',
          '${user.firstName} just uploaded a new Slide');
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  Future _addSlide({
    required String slideId,
    required String proofImage,
    required DateTime datePublished,
  }) async {
    final slide = Slide(
      uid: auth.currentUser!.uid,
      profImage: proofImage,
      slideId: slideId,
      datePublished: datePublished,
    );

    await firestore.collection('Slides').doc(slideId).set(
          slide.toMap(),
        );
  }

  Future<String> deleteInterventionRequest(
    String slideId,
  ) async {
    String res = "Some error occurred";
    try {
      await firestore.collection('Slides').doc(slideId).delete();
      await deleteToStorage(
        'Slides/$slideId',
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
