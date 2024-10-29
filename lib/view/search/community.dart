import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_type/household_pickup.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_type/hazardous_pickup.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_type/recyclable_pickup.dart';
import 'package:riwama/widgets/loading.dart';

class Community extends ConsumerStatefulWidget {
  final option;
  const Community(this.option, {super.key});

  @override
  ConsumerState<Community> createState() => _CommunityState();
}

class _CommunityState extends ConsumerState<Community>
    with SingleTickerProviderStateMixin {
  late Future futureHolder;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3,
    );
    futureHolder = fetchdata();
    super.initState();
  }

  @override
  void dispose() {
    // ref.watch(industryProvider).worldData;
    _tabController.dispose();
    super.dispose();
  }

  Future fetchdata() async {
    // ref.read(industryProvider).worldData;
  }

  Future refresh() async {
    setState(() {
      futureHolder = fetchdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
            future: futureHolder,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return Consumer(builder: (context, ref, child) {
                final data = ref.watch(industryProvider).worldDataPR;
                final newdata = data
                    .where((element) => element.PickupRequestId.isNotEmpty)
                    .toList();

                return Scaffold(
                  appBar: TabBar(
                    controller: _tabController,
                    onTap: (int index) {},
                    indicator: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                    ),
                    tabs: [
                      FittedBox(
                        child: Tab(text: 'household'),
                      ),
                      FittedBox(
                        child: Tab(text: 'recyclables'),
                      ),
                      FittedBox(
                        child: Tab(text: 'hazardous'),
                      ),
                    ],
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    dragStartBehavior: DragStartBehavior.down,
                    physics: BouncingScrollPhysics(),
                    children: [
                      HouseholdPickup(post: newdata),
                      RecyclablePickup(post: newdata),
                      HazardousPickup(post: newdata),
                    ],
                  ),
                );
              });
            }),
      ),
    );
  }
}
