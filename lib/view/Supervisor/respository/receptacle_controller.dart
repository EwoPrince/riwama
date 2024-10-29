import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/services/notification_service.dart';
import 'package:riwama/view/Supervisor/respository/receptacle_repository.dart';

final ReceptacleControllerProvider = Provider((ref) {
  final receptacleRepository =
      ref.watch(ReceptacleRepositoryProvider);
  return ReceptacleController(
    receptacleRepository: receptacleRepository,
    ref: ref,
  );
});

class ReceptacleController {
  final ReceptacleRepository receptacleRepository;
  final ProviderRef ref;

  ReceptacleController({
    required this.receptacleRepository,
    required this.ref,
  });

  Future<String> addReceptacle(
    BuildContext context,
    String lon,
    String lat,
    File file,
  ) async {
    String res = "Some error occurred";
    try {
    final user = ref.watch(authProvider).user;
   await receptacleRepository.addReceptacle(
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

  Future<String> clearReceptacle(
    String receptacleId,
    String uid,
  ) async {
    String res = "Some error occurred";
    try {
      {
        await FirebaseFirestore.instance
            .collection('Receptacle')
            .doc(receptacleId)
            .update({
          'cleared': true,
        });

        // await ref.read(authProvider).getScopeUserData(postOwnerId);
        final fcmToken = ref.read(authProvider).scopeUser!.fcmToken;
        final user = ref.read(authProvider).user!;
        NotificationService.SendNotification(fcmToken, 'RIWAMA',
            '${user.firstName} updated the receptacle state');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> dirtyReceptacle(
    String receptacleId,
    String uid,
  ) async {
    String res = "Some error occurred";
    try {
      {
        await FirebaseFirestore.instance
            .collection('Receptacle')
            .doc(receptacleId)
            .update({
          'cleared': false,
        });
 
        final fcmToken = ref.read(authProvider).scopeUser!.fcmToken;
        final user = ref.read(authProvider).user!;
        NotificationService.SendNotification(fcmToken, 'RIWAMA',
            '${user.firstName} updated the receptacle state');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}
