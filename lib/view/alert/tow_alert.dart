import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/tow.dart';
import 'package:riwama/view/industry/Towing/view_towing/towing_view.dart';
import 'package:riwama/x.dart';

class TowAlert extends ConsumerStatefulWidget {
  const TowAlert({super.key, required this.ir});
  final TowRequest ir;
  @override
  ConsumerState<TowAlert> createState() => _TowAlertState();
}

class _TowAlertState extends ConsumerState<TowAlert> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      onTap: () => goto(
        context,
        TowingView.routeName,
        widget.ir,
      ),
      leading: Icon(
        Icons.recycling,
      ),
      title: Text(
        widget.ir.cleared == true
            ? 'This Tow Request has been Cleared'
            : 'Waiting for Tow Service',
      ),
      subtitle: Text(
        "Posted at: ${readTimestamp(widget.ir.datePublished)}",
        maxLines: 2,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }
}
