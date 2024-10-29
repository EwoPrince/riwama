import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_type/household_pickup.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_type/recyclable_pickup.dart';
import 'pickup_type/hazardous_pickup.dart';

class PickupRow extends ConsumerStatefulWidget {
  PickupRow({super.key});
  static const routeName = '/PickUpRow';

  @override
  _PickupRowState createState() => _PickupRowState();
}

class _PickupRowState extends ConsumerState<PickupRow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(authProvider).user;
    var PRData = ref.watch(industryProvider).worldDataPR;
    final PR = PRData.where((element) => element.uid == user!.uid).toList();
    final newdata =
        PR.where((element) => element.PickupRequestId.isNotEmpty).toList();
    final fulldata =
        PRData.where((element) => element.PickupRequestId.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Up Request'),
      ),
      body: TabBarView(
        controller: _tabController,
        dragStartBehavior: DragStartBehavior.down,
        physics: BouncingScrollPhysics(),
        children: [
          HouseholdPickup(post: user!.accountLevel >= 2 ? fulldata : newdata),
          RecyclablePickup(post: user.accountLevel >= 2 ? fulldata : newdata),
          HazardousPickup(post: user.accountLevel >= 2 ? fulldata : newdata),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        onTap: (int index) {},
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2),
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
    );
  }
}
