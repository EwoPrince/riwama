import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/interventionRequest.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/model/receptacle.dart';
import 'package:riwama/model/slide.dart';
import 'package:riwama/services/industry_service.dart';

final industryProvider =
    ChangeNotifierProvider<IndustryProviders>((ref) => IndustryProviders());

class IndustryProviders extends ChangeNotifier {
  List<Slide> _slideData = [];
  List<PickupRequest> _worldDataPR = [];
  List<Interventionrequest> _worldDataIR = [];
  List<Receptacle> _recept = [];
  List<PickupRequest> _timePR = [];
  List<Interventionrequest> _timeIR = [];

  // List<ScopeUser> _hooks = [];

  List<Slide> get sildeData => _slideData;
  List<PickupRequest> get worldDataPR => _worldDataPR;
  List<Interventionrequest> get worldDataIR => _worldDataIR;
  List<Receptacle> get recept => _recept;
  List<PickupRequest> get timePR => _timePR;
  List<Interventionrequest> get timeIR => _timeIR;
  // List<ScopeUser> get hooks => _hooks;

  Future fetchSlider() async {
    try {
      final Stream<List<Slide>> dataStream = IndustryService.fetchSlides();
      dataStream.listen((data) {
        _slideData = data;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future fetchWorldReceptacles() async {
    try {
      final Stream<List<Receptacle>> dataStream =
          IndustryService.fetchReceptacle();
      dataStream.listen((data) {
        _recept = data;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future fetchWorldPickupRequest() async {
    try {
      final Stream<List<PickupRequest>> dataStream =
          IndustryService.fetchPickupRequest();
      dataStream.listen((data) {
        _worldDataPR = data;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future fetchWorldInterventionRequest() async {
    try {
      final Stream<List<Interventionrequest>> dataStream =
          IndustryService.fetchInterventionRequest();
      dataStream.listen((data) {
        _worldDataIR = data;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future fetchTimePR(DateTime time) async {
    try {
      final Stream<List<PickupRequest>> dataStream =
          IndustryService.fetchTimePR(time);
      dataStream.listen((data) {
        _timePR.clear();
        _timePR = data;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future fetchTimeIR(DateTime time) async {
    try {
      final Stream<List<Interventionrequest>> dataStream =
          IndustryService.fetchTimeIR(time);
      dataStream.listen((data) {
        _timeIR.clear();
        _timeIR = data;
        notifyListeners();
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Future<void> fetchHooksData(List Hooks) async {
  //   try {
  //     final dataStream = await IndustryService.fetchHooksData(Hooks);
  //     _hooks = dataStream;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }
}
