import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/view/profile/view_profile/veiw_profile.dart';
import 'package:riwama/view/chat/controller/chat_controller.dart';
import 'package:riwama/x.dart';

class USerTile extends ConsumerWidget {
  const USerTile({super.key, required this.US});
  final ScopeUser US;

  @override
  Widget build(BuildContext context, ref) {
    return ListTile(
      onTap: () => goto(
        context,
        ViewProfile.routeName,
        US.uid.toString(),
      ),
      leading: ExtendedImage.network(
        US.photoUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        cache: true,
        shape: BoxShape.circle,
      ),
      title: Text(
        US.name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      trailing: US.isOnline!
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              height: 12,
              width: 12,
            )
          : SizedBox.shrink(),
    );
  }
}

class USerTileMessage extends ConsumerWidget {
  const USerTileMessage({super.key, required this.US});
  final ScopeUser US;

  @override
  Widget build(BuildContext context, ref) {
    return ListTile(
      onTap: () => goto(
        context,
        ViewProfile.routeName,
        US.uid.toString(),
      ),
      leading: ExtendedImage.network(
        US.photoUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        cache: true,
        shape: BoxShape.circle,
      ),
      title: Text(
        US.name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            color: US.isOnline! ? Colors.green : Colors.grey,
          ).onTap(() {
            ref.read(chatControllerProvider).openChat(context, US);
          }),
          if (US.isOnline!) SizedBox(height: 8),
          if (US.isOnline!)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              height: 12,
              width: 12,
            ),
        ],
      ),
    );
  }
}
