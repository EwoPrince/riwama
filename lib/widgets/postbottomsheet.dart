import 'package:flutter/material.dart';
import 'package:riwama/view/industry/intervention/intervention_widget/sample_select.dart';
import '../view/industry/pickupRequest/request_widget/request_instant_pickup.dart';
import '../x.dart';
import 'overlaybutton.dart';

void XshowModalBottomSheet(BuildContext context, ref) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            Text(
              'Use RIWAMA public Services',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            overlayButton(
              context,
              'Request Instant Pickup',
              () {
                XshowRIPModalBottomSheet(context, ref);
              },
              true,
              false,
            ),
            overlayButton(
              context,
              'Request for Intervention',
              () {
                goto(
                  context,
                  SampleSelect.routeName,
                  null,
                );
              },
              false,
              false,
            ),
            overlayButton(
              context,
              'Cancel',
              () {
                Navigator.pop(context);
              },
              false,
              true,
            ),
            SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
