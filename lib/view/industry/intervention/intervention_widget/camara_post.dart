// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/services/pick_file.dart';
import 'package:riwama/view/industry/intervention/intervention_widget/edit_image.dart';
import 'package:riwama/widgets/button.dart';

class CamaraPost extends ConsumerStatefulWidget {
  const CamaraPost({Key? key}) : super(key: key);
  static const routeName = '/CamaraPost';

  @override
  ConsumerState<CamaraPost> createState() => _CamaraPostState();
}

class _CamaraPostState extends ConsumerState<CamaraPost> {
  File? file;

  _selectImage() async {
    final mage = await pickImageFromCamara(context);
    if (mage != null) {
      setState(() {
        file = mage;
      });
    }
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  @override
  void initState() {
    _selectImage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    clearImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SnapsHot')),
      body: file == null
          ? Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Keep your posts fresh and clutter-free with our new auto-delete feature. Say goodbye to outdated content as posts automatically vanish after 14 days.',
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  button(context, 'Snap Shot', () {
                    _selectImage();
                  }),
                  SizedBox(height: 30),
                ],
              ),
            )
          : EditImage(
              file: file!,
            ),
    );
  }
}
