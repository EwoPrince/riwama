import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/alert/tow_alert.dart';
import 'package:riwama/view/profile/view_profile/empty_flick.dart';

// ignore: must_be_immutable
class TowList extends ConsumerStatefulWidget {
  TowList({super.key});
  static const routeName = '/TowList';

  @override
  ConsumerState<TowList> createState() => _TowListState();
}

class _TowListState extends ConsumerState<TowList> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(authProvider).user;
    var IRData = ref.watch(industryProvider).worldDataTR;
    final IR = IRData.where((element) => element.uid == user!.uid).toList();
    final newdata =
        IR.where((element) => element.TowRequestId.isNotEmpty).toList();

    final fulldata =
        IRData.where((element) => element.TowRequestId.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tow Service Request'),
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
                      child: TowAlert(
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
                      child: TowAlert(
                        ir: newdata[index],
                      ),
                    );
                  },
                ),
    );
  }
}
