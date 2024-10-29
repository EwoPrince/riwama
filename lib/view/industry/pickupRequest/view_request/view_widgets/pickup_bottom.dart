import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/industry/pickupRequest/respository/pickupRequest_controller.dart';

class PickupBottom extends ConsumerStatefulWidget {
  const PickupBottom({super.key, required this.snap});
  final PickupRequest snap;

  @override
  ConsumerState<PickupBottom> createState() => _PostBottomState();
}

class _PostBottomState extends ConsumerState<PickupBottom> {
  bool isLikeAnimating = false;

  clearRequest(
    String uid,
  ) async {
    ref
        .watch(PickupRequestControllerProvider)
        .clearRequest(widget.snap.PickupRequestId, uid);
  }

  // recordPostView(
  //   String postId,
  // ) async {
  //   ref.watch(PickupRequestControllerProvider).recordPostView(postId);
  // }

  // view() async {
  //   recordPostView(widget.snap.PickupRequestId);
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Container(
      key: ValueKey<String>(widget.snap.description),
      // onVisibilityChanged: (visibilityInfo) {
      //   if (visibilityInfo.visibleFraction == 1.0) {
      //     view();
      //   } else {}
      // },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          user!.uid == widget.snap.uid
              ? widget.snap.cleared == true
                  ? Text(
                      'Cleared',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )
                  :  Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: Image.asset(
                          'assets/waste.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        // ${widget.snap.views}
                        'Waiting for Pick up',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    widget.snap.cleared == true
                        ? Text(
                            'Cleared',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                clearRequest(user.uid);
                              },
                            ),
                          ),
                  ],
                ),
        ],
      ),
    );
  }
}
