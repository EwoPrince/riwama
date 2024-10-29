import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/message_enum.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_view.dart';
import 'package:riwama/view/utility/down_mage.dart';
import 'package:riwama/view/utility/viewclip.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/x.dart';
import 'package:readmore/readmore.dart';

import 'video_player_item.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return widget.type == MessageEnum.text
        ? ReadMoreText(
            widget.message,
            trimLines: 5,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: const TextStyle(
              fontSize: 16,
            ),
          ).onDoubleTap(() {
            Clipboard.setData(new ClipboardData(
              text: widget.message,
            )).then((value) {
              showMessage(context, 'Copied to Clipboard');
            });
          })
        : widget.type == MessageEnum.audio
            ? IconButton(
                constraints: const BoxConstraints(minWidth: 100),
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.play(UrlSource(widget.message));

                    audioPlayer.onPlayerComplete.listen((_) {
                      setState(() {
                        isComplete = !isComplete;
                      });
                    });
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                    isComplete = false;
                  });
                },
                icon: Icon(isComplete
                    ? Icons.replay
                    : isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle),
              )
            : widget.type == MessageEnum.video
                ? VideoPlayerItem(
                    videoUrl: widget.message,
                  ).onTap(() {
                    goto(
                      context,
                      ViewPage.routeName,
                      widget.message,
                    );
                  })
                : widget.type == MessageEnum.flick
                    ? xPost(
                        postId: widget.message,
                      )
                    : widget.type == MessageEnum.gif
                        ? ExtendedImage.network(
                            widget.message,
                          ).onTap(() {
                            goto(
                              context,
                              DownMage.routeName,
                              widget.message,
                            );
                          })
                        : ExtendedImage.network(
                            widget.message,
                          ).onTap(() {
                            goto(
                              context,
                              DownMage.routeName,
                              widget.message,
                            );
                          });
  }
}

class xPost extends ConsumerStatefulWidget {
  final String postId;
  const xPost({Key? key, required this.postId}) : super(key: key);

  @override
  _xPost createState() => _xPost();
}

class _xPost extends ConsumerState<xPost> {
  bool isLoading = false;
  late PickupRequest? snap;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (postSnap.exists) {
        final Map<String, dynamic> flick =
            postSnap.data() as Map<String, dynamic>;

        snap = PickupRequest.fromMap(flick);
      } else {
        snap = null;
      }

      setState(() {});
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isLoading
        ? Loading()
        : snap == null
        ? Text(
            'Flick has been Raptured',
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 8,
            ),
          )
        : 
        Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: size.width * 0.27,
              height: size.height * 0.25,
              child: LayoutBuilder(builder: (context, parentSize) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(1),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAlias,
                          height: parentSize.maxHeight * 0.6,
                          width: parentSize.maxWidth * 0.8,
                          child: Hero(
                              tag: snap!.profImage,
                              child: SizedBox.shrink(),
                              // DisplayProfileTextImageGIF(
                              //   post: snap!.profImage,
                              //   type: snap!.type,
                              // ),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        snap!.description,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: parentSize.maxWidth * 0.08,
                        ),
                      ),
                    ),
                  ],
                ).onTap(() {
                  goto(
                    context,
                    PickupView.routeName,
                    snap,
                  );
                });
              }),
            ),
          );
  }
}
