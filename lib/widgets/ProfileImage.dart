import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riwama/provider/auth_provider.dart';
// import 'package:riwama/view/account/profile/personal_profile.dart';
// import 'package:riwama/view/account/profile/view_profile/veiw_profile.dart';
// import 'package:riwama/x.dart';

class ProfileImage extends ConsumerStatefulWidget {
  const ProfileImage({
    super.key,
    required this.photoUrl,
    required this.uid,
  });
  final String photoUrl;
  final String uid;
  @override
  ConsumerState<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends ConsumerState<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(authProvider).user;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ExtendedImage.network(
        widget.photoUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        cache: true,
        shape: BoxShape.circle,
        cacheMaxAge: Duration(days: 7),
        maxBytes: 60,
      )
      // .onTap(
      //   widget.uid.toString() == "${user!.uid}"
      //       ? () {
      //           goto(
      //             context,
      //             PersonalProfile.routeName,
      //             null,
      //           );
      //         }
      //       : () {
      //           goto(
      //             context,
      //             ViewProfile.routeName,
      //             widget.uid,
      //           );
      //         },
      // ),
    );
  }
}
