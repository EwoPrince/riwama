import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/alert/receptacle_alert.dart';
import 'package:riwama/view/profile/view_profile/empty_flick.dart';

// ignore: must_be_immutable
class ReceptacleList extends ConsumerStatefulWidget {
  ReceptacleList({super.key});
  static const routeName = '/Receptacle';

  @override
  ConsumerState<ReceptacleList> createState() => _InterventionListState();
}

class _InterventionListState extends ConsumerState<ReceptacleList> {
  @override
  Widget build(BuildContext context) {
        var IRData = ref.watch(industryProvider).recept;
    final fulldata =
        IRData.where((element) => element.receptacleId.isNotEmpty)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Receptacle List'),
      ),
      body: fulldata.isEmpty
          ? EmptyFlick()
         : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: fulldata.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ReceptacleAlert(
                        ir: fulldata[index],
                      ),
                    );
                  },
                )
             
    );
  }
}
