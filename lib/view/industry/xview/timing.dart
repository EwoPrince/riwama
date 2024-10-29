import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/alert/pickup_alert_widget.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/x.dart';
import 'package:swipe_to/swipe_to.dart';
import '../pickupRequest/view_request/pickup_view.dart';

class Timing extends ConsumerStatefulWidget {
  final DateTime option;
  const Timing({
    super.key,
    required this.option,
  });
  static const routeName = '/TimeQuerry';

  @override
  ConsumerState<Timing> createState() => _TimingState();
}

class _TimingState extends ConsumerState<Timing> {
  late Future futureHolder;

  @override
  initState() {
    futureHolder = fetchdata();
    super.initState();
  }

  Future fetchdata() async {
    ref.read(industryProvider).fetchTimePR(widget.option);
  }

  @override
  void dispose() {
    ref.watch(industryProvider).timePR;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMd().format(widget.option)),
      ),
      body: RefreshIndicator(
        onRefresh: fetchdata,
        child: FutureBuilder(
            future: futureHolder,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return Consumer(builder: (context, ref, child) {
                final data = ref.watch(industryProvider).timePR;
                final newdata = data
                    .where((element) => element.PickupRequestId.isNotEmpty)
                    .toList();

                return newdata.isEmpty
                    ? Loading()
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemCount: newdata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SwipeTo(
                              onLeftSwipe: (DragUpdateDetails) => goto(
                                context,
                                PickupView.routeName,
                                newdata[index],
                              ),
                              child: PickupAlert(
                                pu: newdata[index],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox.shrink();
                        },
                      );
              });
            }),
      ),
    );
  }
}
