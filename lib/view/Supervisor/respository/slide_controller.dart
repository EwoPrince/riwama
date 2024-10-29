import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/Supervisor/respository/slide_repository.dart';

final SlideControllerProvider = Provider((ref) {
  final slideRepository =
      ref.watch(SlideRepositoryProvider);
  return SlideController(
    slideRepository: slideRepository,
    ref: ref,
  );
});

class SlideController {
  final SlideRepository slideRepository;
  final ProviderRef ref;

  SlideController({
    required this.slideRepository,
    required this.ref,
  });

  Future<String> addSlide(
    BuildContext context,
    File file,
  ) async {
    String res = "Some error occurred";
    try {
    final user = ref.watch(authProvider).user;
   await slideRepository.addSlide(
      context: context,
      file: file,
      user: user!,
      ref: ref,
    );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}
