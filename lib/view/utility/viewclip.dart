
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class ViewPage extends StatefulWidget {
  final String url;

  ViewPage({required this.url});
  static const routeName = '//ViewVideo';

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late CachedVideoPlayerPlusController  controller;
  bool _isPlaying = true;
  double _volume = 1.0;

  @override
  void initState() {
    controller =
    CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(
        widget.url,
      ),
      httpHeaders: {
        'Connection': 'keep-alive',
      },
      invalidateCacheIfOlderThan: const Duration(days: 7),
    )..initialize().then((value) async {
        await controller.setLooping(true);
        controller.play();
        setState(() {
        });
      });
        
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SwipeTo(
        onRightSwipe: (D) {
          Navigator.pop(context);
        },
        child: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    _togglePlay();
                  },
                  onDoubleTap: () {
                    _toggleMute();
                  },
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CachedVideoPlayerPlus(controller),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                child: _buildControlsOverlay(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: _togglePlay,
              color: Colors.white,
            ),
            Expanded(
              child: Slider(
                value: controller.value.position.inSeconds.toDouble(),
                max: controller.value.duration.inSeconds.toDouble(),
                onChanged: (newValue) {
                  controller.seekTo(Duration(seconds: newValue.toInt()));
                },
              ),
            ),
            IconButton(
              icon:
                  _volume > 0 ? Icon(Icons.volume_up) : Icon(Icons.volume_off),
              onPressed: _toggleMute,
              color: Colors.white,
            ),
            SizedBox(width: 40)
          ],
        ),
      ),
    );
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _isPlaying ? controller.play() : controller.pause();
  }

  void _toggleMute() {
    setState(() {
      _volume = _volume > 0 ? 0 : 1;
    });
    controller.setVolume(_volume);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
