
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/common_firebase_storage_repository.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/view/industry/Towing/respository/towRequest_repository.dart';


final TowRequestControllerProvider = Provider((ref) {
  final towRequestRepository = ref.watch(TowRequestRepositoryProvider);


  return TowRequestController(
    towRequestRepository: towRequestRepository,
    ref: ref,
  );
});

class TowRequestController {
  final TowRequestRepository towRequestRepository;
  final ProviderRef ref;

  TowRequestController({
    required this.towRequestRepository,
    required this.ref,
  });

  Future<String> sendRequestTow(
    BuildContext context,
    String lon,
    String lat,
    String type,
  ) async {
    String res = "Some error occurred";
    try {
      final user = ref.watch(authProvider).user;
      towRequestRepository.sendRequest(
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
    String towId,
    String uid,
    File file,
  ) async {
    String res = "Some error occurred";
    try {
      {

        
      
        String imageUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'TowRequest/$towId',
              file,
            );
            
        await FirebaseFirestore.instance
            .collection('TowRequest')
            .doc(towId)
            .update({
          'ClearedByUid': uid,
          'cleared': true,
          'profImage': imageUrl,
        });

        // await ref.read(authProvider).getScopeUserData(postOwnerId);
        final fcmToken = ref.read(authProvider).scopeUser!.fcmToken;
        final user = ref.read(authProvider).user!;
        NotificationService.SendNotification(
            fcmToken, 'RIWAMA', '${user.firstName} Cleared your Tow Request');
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
