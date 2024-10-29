import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/alert/intervention_alert_widget.dart';
import 'package:riwama/view/profile/view_profile/empty_flick.dart';

// ignore: must_be_immutable
class InterventionList extends ConsumerStatefulWidget {
  InterventionList({super.key});
  static const routeName = '/InterventionList';

  @override
  ConsumerState<InterventionList> createState() => _InterventionListState();
}

class _InterventionListState extends ConsumerState<InterventionList> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(authProvider).user;
    var IRData = ref.watch(industryProvider).worldDataIR;
    final IR = IRData.where((element) => element.uid == user!.uid).toList();
    final newdata = IR
        .where((element) => element.InterventionrequestId.isNotEmpty)
        .toList();

    final fulldata =
        IRData.where((element) => element.InterventionrequestId.isNotEmpty)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Intervention Request'),
      ),
      body: newdata.isEmpty
          ? EmptyFlick()
          : user!.accountLevel >= 2
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: fulldata.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InterventionAlert(
                        ir: fulldata[index],
                      ),
                    );
                  },
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: newdata.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InterventionAlert(
                        ir: newdata[index],
                      ),
                    );
                  },
                ),
    );
  }
}
