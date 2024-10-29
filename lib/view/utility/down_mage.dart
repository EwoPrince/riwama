import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:riwama/widgets/overlaybutton.dart';
import 'package:riwama/x.dart';
// import 'package:share_plus/share_plus.dart';

class DownMage extends StatefulWidget {
  final snap;
  const DownMage({
    Key? key,
    required this.snap,
  }) : super(key: key);
  static const routeName = '/ImageExplore';

  @override
  State<DownMage> createState() => _DownMageState();
}

class _DownMageState extends State<DownMage> {
  final transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: Hero(
            tag: widget.snap,
            child: ExtendedImage.network(
              widget.snap,
              fit: BoxFit.contain,
              cache: true,
              shape: BoxShape.rectangle,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  minScale: 0.9,
                  animationMinScale: 0.7,
                  maxScale: 3.0,
                  animationMaxScale: 3.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: false,
                  initialAlignment: InitialAlignment.center,
                );
              },
            ),
          ),
        ).onTap(() {
          Navigator.pop(context);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalBottomSheet(context);
        },
        child: Icon(Icons.share),
      ),
    );
  }

  void shareImage({required String url}) async {
    Navigator.pop(context);
    // showUpMessage(context, 'getting your image ready to share', 'Media');
    // final response = await get(Uri.parse(url));
    // var picid = Uuid().v1();
    // final directory = await getTemporaryDirectory();
    // File file = await File('${directory.path}/$picid.png')
    //     .writeAsBytes(response.bodyBytes);
    // await Share.shareXFiles([XFile(file.path)], text: 'Share');
  }

  void labelImage({required File file}) async {}

  // void downloadImage({required String url}) async {
  //   Navigator.pop(context);
  //   final response = await get(Uri.parse(url));
  //   var picid = Uuid().v1();
  //   final directory = await getTemporaryDirectory();
  //   File file = await File('${directory.path}/$picid.png')
  //       .writeAsBytes(response.bodyBytes);
  //   String ppath = '${file.path}';
  //   // GallerySaver.saveImage(
  //   //   ppath,
  //   //   albumName: "riwama",
  //   //   toDcim: true,
  //   // );
  //   showUpMessage(context, 'Image Downloaded', 'Media');
  // }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              overlayButton(
                context,
                'share image',
                () {
                  shareImage(url: widget.snap);
                },
                true,
                false,
              ),
              overlayButton(
                context,
                'Cancel',
                () {
                  Navigator.pop(context);
                },
                false,
                true,
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
