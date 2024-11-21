import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/receptacle.dart';
import 'package:riwama/view/Supervisor/receptacle/view_receptacle.dart';
import 'package:riwama/x.dart';

class ReceptacleAlert extends ConsumerStatefulWidget {
  const ReceptacleAlert({super.key, required this.ir});
  final Receptacle ir;
  @override
  ConsumerState<ReceptacleAlert> createState() => _ReceptacleAlertState();
}

class _ReceptacleAlertState extends ConsumerState<ReceptacleAlert> {
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      onTap: () => goto(
        context,
        ReceptacleView.routeName,
        widget.ir,
      ),
      leading: Icon(
        Icons.recycling,
      ),
      title: Text(
        widget.ir.cleared == true
            ? 'This Receptacle Request has been Cleared'
            : 'Waiting for Receptacle',
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
