import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/services/report_service.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/view_widgets/pickup_bottom.dart';
import 'package:riwama/view/industry/xview/timing.dart';
import 'package:riwama/view/industry/pickupRequest/respository/pickupRequest_repository.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/view_widgets/pickup_display_section.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/x.dart';
import 'package:swipe_to/swipe_to.dart';

class PickupView extends ConsumerStatefulWidget {
  final PickupRequest snap;
  PickupView({required this.snap});
  static const routeName = '/PickupView';

  @override
  ConsumerState<PickupView> createState() => _PickupViewState();
}

class _PickupViewState extends ConsumerState<PickupView> {
  _selectDate(BuildContext context, DateTime choosen) async {
    DateTime? selectedDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: choosen,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        goto(
          context,
          Timing.routeName,
          selectedDate!,
        );
      });
    }
  }

  deletePost(String postId) async {
    ref
        .read(PickupRequestRepositoryProvider)
        .deletePost(postId, widget.snap.type);
    showMessage(
      context,
      'Post Deleted',
    );
  }

  @override
  Widget build(BuildContext context) {
    var ize = MediaQuery.of(context).size;
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Pick Up Request',
          softWrap: true,
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          widget.snap.uid.toString() == "${user!.uid}"
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
                                      deletePost(widget.snap.PickupRequestId
                                          .toString());
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
                            'Report this request',
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
                                  ReportService().reportPost('Report Post',
                                      widget.snap.PickupRequestId);
                                } else if (index == 1) {
                                  // Function for 'I Don't want to see this again'
                                  showMessage(context,
                                      'Alright, we\'ll do something about it');
                                } else if (index == 2) {
                                  // Function for 'Block This User'
                                  ReportService().BlockUser(widget.snap.uid);
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
                  icon: const Icon(Icons.more_vert_outlined),
                ),
        ],
      ),
      body: SwipeTo(
        onRightSwipe: (DragDownDetails) {
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Posted on :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      DateFormat.yMMMd().format(widget.snap.datePublished),
                    ).onTap(() {
                      _selectDate(context, widget.snap.datePublished);
                    }),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Posted by :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      widget.snap.name,
                    ).onTap(() {
                      _selectDate(context, widget.snap.datePublished);
                    }),
                  ],
                ),
                SizedBox(height: 6),

                /// IMAGE SECTION OF THE POST
                Text(
                  "Location for PickUp:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: ize.width * 0.98,
                  height: ize.height * 0.35,
                  child: PickupDisplaySection(
                    snap: widget.snap,
                  ),
                ),

                SizedBox(height: 12),
                PickupBottom(
                  snap: widget.snap,
                ),

                SizedBox(height: 12),
                user.accountLevel == 2
                    ? button(context, 'Clear Request', () {})
                    : SizedBox.shrink(),

                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
