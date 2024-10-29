import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  final snap;
  const ViewImage({
    Key? key,
    required this.snap,
  }) : super(key: key);
  static const routeName = '/ViewImage';

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  final transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
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
          ),
        ),
      ),
    );
  }
}
