import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/services/report_service.dart';
import 'package:riwama/view/industry/pickupRequest/respository/pickupRequest_repository.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_view.dart';
import 'package:riwama/x.dart';

class PickupAlert extends ConsumerStatefulWidget {
  const PickupAlert({super.key, required this.pu});
  final PickupRequest pu;
  @override
  ConsumerState<PickupAlert> createState() => _PickupAlertState();
}

class _PickupAlertState extends ConsumerState<PickupAlert> {
  deletePost(String postId) async {
    ref
        .read(PickupRequestRepositoryProvider)
        .deletePost(postId, widget.pu.type);
    showMessage(
      context,
      'Post Deleted',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return ListTile(
      style: ListTileStyle.list,
      onTap: () => goto(
        context,
        PickupView.routeName,
        widget.pu,
      ),
      leading: Icon(
        Icons.fire_truck,
      ),
      title: Text(
        widget.pu.cleared == true
            ? 'Your Pickup Request has been Cleared'
            : 'Waiting for Pickup',
      ),
      subtitle: Text(
        "Posted at: ${readTimestamp(widget.pu.datePublished)}",
        maxLines: 2,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
      trailing: widget.pu.uid.toString() == "${user!.uid}"
          ? IconButton(
              onPressed: () {
                showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            'Delete this post',
                          ]
                              .map(
                                (e) => Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Center(
                                      child: Text(
                                    e,
                                    textAlign: TextAlign.center,
                                  )),
                                ).onTap(() {
                                  deletePost(
                                      widget.pu.PickupRequestId.toString());
                                  Navigator.of(context).pop();
                                }),
                              )
                              .toList()),
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_outlined),
            )
          : IconButton(
              onPressed: () {
                showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (context) {
                    return Dialog(
                        child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: [
                        'Report Post',
                        'I Don\'t want to see this again',
                        'Block This User',
                      ].asMap().entries.map(
                        (entry) {
                          int index = entry.key;
                          String item = entry.value;

                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Center(
                                child: Text(
                              item,
                              textAlign: TextAlign.center,
                            )),
                          ).onTap(() {
                            // Conditionally apply different functions based on the index or content
                            if (index == 0) {
                              // Function for 'Report Post'
                              ReportService().reportPost(
                                  'Report Post', widget.pu.PickupRequestId);
                            } else if (index == 1) {
                              // Function for 'I Don't want to see this again'
                              showMessage(context,
                                  'Alright, we\'ll do something about it');
                            } else if (index == 2) {
                              // Function for 'Block This User'
                              ReportService().BlockUser(widget.pu.uid);
                            }

                            // Close the current screen or dialog
                            Navigator.of(context).pop();
                          });
                        },
                      ).toList(),
                    ));
                  },
                );
              },
              icon: const Icon(
                Icons.more_vert_outlined,
              ),
            ),
    );
  }
}
