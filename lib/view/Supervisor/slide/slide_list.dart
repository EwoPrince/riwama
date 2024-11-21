import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/Supervisor/slide/add_slide.dart';
import 'package:riwama/view/alert/Slide_alert.dart';
import 'package:riwama/view/profile/view_profile/empty_flick.dart';
import 'package:riwama/x.dart';

// ignore: must_be_immutable
class SlideList extends ConsumerStatefulWidget {
  SlideList({super.key});
  static const routeName = '/SlideList';

  @override
  ConsumerState<SlideList> createState() => _InterventionListState();
}

class _InterventionListState extends ConsumerState<SlideList> {
  @override
  Widget build(BuildContext context) {
    var IRData = ref.watch(industryProvider).sildeData;
    final fulldata =
        IRData.where((element) => element.slideId.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Slide List'),
      ),
      body: fulldata.isEmpty
          ? EmptyFlick()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: fulldata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SlideAlert(
                    pu: fulldata[index],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          goto(context, AddSlide.routeName, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
