import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:riwama/view/profile/edit_pic_profile.dart';
import 'package:riwama/x.dart';

class PicProfileView extends StatefulWidget {
  final snap;
  const PicProfileView({
    Key? key,
    required this.snap,
  }) : super(key: key);
  static const routeName = '/MyProfilePic';

  @override
  State<PicProfileView> createState() => _PicProfileViewState();
}

class _PicProfileViewState extends State<PicProfileView> {
  final transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Hero(
              tag: widget.snap,
              child: InteractiveViewer(
                transformationController: transformationController,
                boundaryMargin: EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 3.5,
                // You can off zooming by setting scaleEnable to false
                //scaleEnabled: false,
                onInteractionStart: (context) {},
                onInteractionEnd: (details) {
                  setState(() {
                    transformationController.toScene(Offset.zero);
                  });
                },
                onInteractionUpdate: (context) {},
                child: ExtendedImage.network(
                  widget.snap,
                  // height: 500,
                  fit: BoxFit.contain,
                  cache: true,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goto(
            context,
            EditPicProfile.routeName,
            null,
          );
        },
        child: Icon(
          Icons.photo_camera_outlined,
          size: 32,
        ),
      ),
    );
  }
}
