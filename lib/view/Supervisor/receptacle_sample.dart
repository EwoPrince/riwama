import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/services/pick_file.dart';
import 'package:riwama/view/industry/intervention/intervention_widget/request_intervention.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/select_card.dart';
import 'package:riwama/x.dart';

class ReceptacleSample extends ConsumerStatefulWidget {
  static const routeName = '/ReceptacleSample';
  @override
  _ReceptacleSampleState createState() => _ReceptacleSampleState();
}

class _ReceptacleSampleState extends ConsumerState<ReceptacleSample> {
  File? image;

  selectGalleryImage() async {
    final mage = await pickImageFromGallery(context);
    if (mage != null) {
      setState(() {
        image = mage;
      });
    }
  }

  selectCameraImage() async {
    final mage = await pickImageFromCamara(context);
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
        title: Text('Add Receptacle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Upload an Image sample for this Receptacle',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            image == null
                ? SizedBox(
                    height: size.height * 0.2,
                    child: Image.asset(
                      'assets/sap.png',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectCard(
                    iconData: Icons.camera_alt_outlined,
                    title: 'Snap from camera',
                  ).onTap(() {
                    selectCameraImage();
                  }),
                  SelectCard(
                    iconData: Icons.photo_outlined,
                    title: 'Pick from Gallery',
                  ).onTap(() {
                    selectGalleryImage();
                  }),
                ],
              ),
            if (image != null)
              button(context, 'Done', () {
                InterventionModalBottomSheet(context, ref, image!);
              },),
          ],
        ),
      ),
    );
  }
}
