import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/services/notification_service.dart';
import 'intervention_repository.dart';

final InterventionRequestControllerProvider = Provider((ref) {
  final interventionRequestRepository =
      ref.watch(InterventionRequestRepositoryProvider);
  return InterventionRequestController(
    interventionRequestRepository: interventionRequestRepository,
    ref: ref,
  );
});

class InterventionRequestController {
  final InterventionRequestRepository interventionRequestRepository;
  final ProviderRef ref;

  InterventionRequestController({
    required this.interventionRequestRepository,
    required this.ref,
  });

  Future<String> sendInterventionRequest(
    BuildContext context,
    String lon,
    String lat,
    File file,
  ) async {
    String res = "Some error occurred";
    try {
    final user = ref.watch(authProvider).user;
    interventionRequestRepository.sendInterventionRequest(
      context: context,
      file: file,
      user: user!,
      lat: lat,
      lon: lon,
      ref: ref,
    );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> clearIntervention(
    String interventionId,
    String uid,
  ) async {
    String res = "Some error occurred";
    try {
      {
        await FirebaseFirestore.instance
            .collection('Interventionrequest')
            .doc(interventionId)
            .update({
          'ClearedByUid': uid,
          'cleared': true,
        });

        // await ref.read(authProvider).getScopeUserData(postOwnerId);
        final fcmToken = ref.read(authProvider).scopeUser!.fcmToken;
        final user = ref.read(authProvider).user!;
        NotificationService.SendNotification(fcmToken, 'RIWAMA',
            '${user.firstName} cleared your intervention request');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> recordPostView(String postId) async {
    String res = "Some error occurred";
    try {
      // Increment the view count by 1
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'views': FieldValue.increment(1),
      });

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
