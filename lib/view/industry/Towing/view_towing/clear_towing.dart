import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/tow.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/services/pick_file.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/view/industry/Towing/respository/towRequest_controller.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/select_card.dart';
import 'package:riwama/x.dart';

class ClearTowing extends ConsumerStatefulWidget {
  const ClearTowing({super.key, required this.snap});
  final TowRequest snap;
  static const routeName = '/ClearTowing';

  @override
  ConsumerState<ClearTowing> createState() => _PostBottomState();
}

class _PostBottomState extends ConsumerState<ClearTowing> {
  bool isLoading = false;
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


  clearRequest(
    String uid,
    File ile,
  ) async {
    setState(() {
      isLoading = true;
    });
    ref
        .watch(TowRequestControllerProvider)
        .clearRequest(widget.snap.TowRequestId, uid, 
          ile,
        );
    become(context, Land.routeName, null);
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Clear Pick up Request',
          softWrap: true,
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              Text(
                'Provide the following to resolve this Pick up Request',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Upload an Image sample of after the Tow Service',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              image == null
                  ? SizedBox(
                      height: size.height * 0.2,
                      child: Image.asset(
                        'assets/smaple.png',
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
              SizedBox(height: 12),
              if (image != null)
                isLoading == true
                    ? Loading()
                    : button(context, 'Done', () {
                        clearRequest(
                          user!.uid,
                          image!,
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
