import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/services/pick_file.dart';
import 'package:riwama/view/Supervisor/respository/slide_controller.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/x.dart';

class AddSlide extends ConsumerStatefulWidget {
  static const routeName = '/AddSlide';
  @override
  _AddSlideState createState() => _AddSlideState();
}

class _AddSlideState extends ConsumerState<AddSlide> {
  File? image;

  selectGalleryImage() async {
    final mage = await pickImageFromGallery(context);
    if (mage != null) {
      setState(() {
        image = mage;
      });
    }
  }

  void clearImage() {
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Slide'),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Upload an Image sample for this Slide',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              image == null
                  ? SizedBox(
                      height: size.height * 0.2,
                      child: Image.asset(
                        'assets/waste-management.png',
                        fit: BoxFit.contain,
                      ))
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: size.height * 0.3,
                      child: ExtendedImage.file(image!).onTap(() {
                        clearImage();
                      }),
                    ),
              if (image != null) SizedBox(height: 5),
              if (image != null)
                Text(
                  'Tap the Image to Reselect',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (image == null)
                button(context, 'Select Slide', () {
                  selectGalleryImage();
                }),
              if (image != null)
                button(context, 'Done', () async {
                  await ref
                      .read(SlideControllerProvider)
                      .addSlide(
                        context,
                        image!,
                      )
                      .then((value) {
                    become(context, Land.routeName, null);
                    showUpMessage(context, 'Request Successful',
                        'Your request for an intervention has been delivered successfully');
                  });
                }),
            ],
          ),
        ));
  }
}
