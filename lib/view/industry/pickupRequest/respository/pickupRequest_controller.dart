import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/common_firebase_storage_repository.dart';
import 'package:riwama/services/notification_service.dart';
import 'pickupRequest_repository.dart';

final PickupRequestControllerProvider = Provider((ref) {
  final pickupRequestRepository = ref.watch(PickupRequestRepositoryProvider);
  return PickupRequestController(
    pickupRequestRepository: pickupRequestRepository,
    ref: ref,
  );
});

class PickupRequestController {
  final PickupRequestRepository pickupRequestRepository;
  final ProviderRef ref;

  PickupRequestController({
    required this.pickupRequestRepository,
    required this.ref,
  });

  Future<String> sendRequestInstantPickup(
    BuildContext context,
    String lon,
    String lat,
    String type,
  ) async {
    String res = "Some error occurred";
    try {
      final user = ref.watch(authProvider).user;
      pickupRequestRepository.sendRequest(
        context: context,
        lon: lon,
        lat: lat,
        type: type,
        user: user!,
      );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> clearRequest(
    String pickupId,
    String uid,
    File file,
  ) async {
    String res = "Some error occurred";
    try {
      {
        String imageUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'pickupId/$pickupId',
              file,
            );

        await FirebaseFirestore.instance
            .collection('PickupRequest')
            .doc(pickupId)
            .update({
          'ClearedByUid': uid,
          'cleared': true,
          'profImage': imageUrl,
        });

        // await ref.read(authProvider).getScopeUserData(postOwnerId);
        final fcmToken = ref.read(authProvider).scopeUser!.fcmToken;
        final user = ref.read(authProvider).user!;
        NotificationService.SendNotification(fcmToken, 'RIWAMA',
            '${user.firstName} Cleared your Pick up request');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> recordPostView(String postId) async {
  //   String res = "Some error occurred";
  //   try {
  //     // Increment the view count by 1
  //     await FirebaseFirestore.instance.collection('posts').doc(postId).update({
  //       'views': FieldValue.increment(1),
  //     });

  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }
}
