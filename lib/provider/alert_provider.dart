import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/interventionRequest.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/services/alert_service.dart';

final alertProvider =
    ChangeNotifierProvider<AlertProviders>((ref) => AlertProviders());

class AlertProviders extends ChangeNotifier {
  List<Interventionrequest> _interventionRequest = [];
  List<PickupRequest> _pickUpRequest = [];
  int _unreadChat = 0;

  List<Interventionrequest> get interventionRequest => _interventionRequest;
  List<PickupRequest> get pickUpRequest => _pickUpRequest;
  int get unreadChat => _unreadChat;

  Future<void> fetchInterventionrequest(String uid) async {
    try {
      final Stream<List<Interventionrequest>> dataStream =
          AlertService.getInterventions(uid);
      dataStream.listen((data) {
        List<Interventionrequest> chatx = data.where((element) {
          bool notSeen = element.cleared == false;
          return notSeen;
        }).toList();

        _interventionRequest = data;
        _unreadChat = ++chatx.length;

        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> fetchPickUpRequest(String uid) async {
    try {
      final Stream<List<PickupRequest>> dataStream =
          AlertService.getPickUpRequest(uid);
      dataStream.listen((data) {
        List<PickupRequest> chatx = data.where((element) {
          bool notSeen = element.cleared == false;
          return notSeen;
        }).toList();

        _pickUpRequest = data;
        _unreadChat = ++chatx.length;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
