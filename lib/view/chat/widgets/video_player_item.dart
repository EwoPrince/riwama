import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:riwama/view/utility/viewclip.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerPlusController videoPlayerController;
  bool isInitializing = true;

  @override
  void initState() {
    videoPlayerController =
    CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
      httpHeaders: {
        'Connection': 'keep-alive',
      },
      invalidateCacheIfOlderThan: const Duration(days: 7),
    )..initialize().then((value) async {
        await videoPlayerController.setLooping(true);
        videoPlayerController.play();
        setState(() {
          isInitializing = false;
        });
      });
        
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: LayoutBuilder(builder: (context, size) {
            return Stack(
              children: [
                if (videoPlayerController.value.isInitialized)
                  CachedVideoPlayerPlus(videoPlayerController),
                if (isInitializing)
                  Center(
                    child: Image.asset(
                      'assets/video.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                Positioned(
                  bottom: size.maxHeight * 0.6,
                  right: 0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shadowColor:
                          Theme.of(context).shadowColor.withOpacity(0.2),
                    ),
                    onPressed: () {
                      if (videoPlayerController.value.isInitialized) {
                        videoPlayerController.setVolume(
                            videoPlayerController.value.volume == 0 ? 1 : 0);
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      videoPlayerController.value.isInitialized &&
                              videoPlayerController.value.volume == 0
                          ? Icons.volume_off
                          : Icons.volume_up,
                    ),
                  ),
                ),
                Positioned(
                  bottom: size.maxHeight * 0.4,
                  right: 0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shadowColor:
                          Theme.of(context).shadowColor.withOpacity(0.2),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPage(url: widget.videoUrl),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.play_circle,
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
