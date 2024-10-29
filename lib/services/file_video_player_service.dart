import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class FileVideoPlayerService extends StatefulWidget {
  final File video;
  const FileVideoPlayerService({super.key, required this.video});

  @override
  State<FileVideoPlayerService> createState() => _FileVideoPlayerServiceState();
}

class _FileVideoPlayerServiceState extends State<FileVideoPlayerService> {
  late CachedVideoPlayerPlusController controller;

  @override
  void initState() {
    controller =
    CachedVideoPlayerPlusController.file(
      
        widget.video,
      
    )..initialize().then((value) async {
        await controller.setLooping(true);
        controller.play();
        setState(() {
        });
      });
        
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;
    final isPlay = controller.value.isPlaying;

    return InkWell(
        onDoubleTap: () {
          controller.setVolume(isMuted ? 1 : 0);
        },
        onTap: () {
          isPlay ? controller.pause() : controller.play();
        },
        child: CachedVideoPlayerPlus(controller));
  }
}
