import 'package:flutter/material.dart';
import 'package:riwama/model/PickupRequest_enum.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/view/alert/pickup_alert_widget.dart';
import 'package:riwama/view/profile/view_profile/empty_flick.dart';

class RecyclablePickup extends StatelessWidget {
  const RecyclablePickup({super.key, required this.post});
  final List<PickupRequest> post;

  @override
  Widget build(BuildContext context) {
    final newdata = post
        .where((element) => element.type == PickupRequestEnum.recyclables)
        .toList();

    return newdata.length == 0
        ? EmptyFlick()
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: newdata.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: PickupAlert(
                  pu: newdata[index],
                ),
              );
            },
          );
  }
}
