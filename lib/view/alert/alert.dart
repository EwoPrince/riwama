import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/alert_provider.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/profile/view_profile/empty_flick.dart';
import 'package:riwama/view/alert/intervention_alert_widget.dart';
import 'package:riwama/view/alert/pickup_alert_widget.dart';
import 'package:riwama/widgets/loading.dart';

class Alerts extends ConsumerStatefulWidget {
  const Alerts({super.key});
  static const routeName = '/Alerts';

  @override
  ConsumerState<Alerts> createState() => _AlertsState();
}

class _AlertsState extends ConsumerState<Alerts> {
  late Future futureHolder;

  @override
  void initState() {
    super.initState();
    futureHolder = fetchdata();
  }

  Future<bool> fetchdata() async {
    final user = ref.read(authProvider).user;
    try {
     await ref.read(alertProvider).fetchInterventionrequest(user!.uid);
     await ref.read(alertProvider).fetchPickUpRequest(user.uid);
      await Future.delayed(const Duration(milliseconds: 200));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ALERTS",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: FutureBuilder(
          future: futureHolder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (snapshot.hasError) {
              return Loading();
            }

            return Consumer(builder: (context, ref, child) {
              final IRdata = ref.watch(alertProvider).interventionRequest;
              final PRdata = ref.watch(alertProvider).pickUpRequest;
              final newdata = IRdata.where(
                      (element) => element.InterventionrequestId.isNotEmpty)
                  .toList();
              final PRnewdata =
                  PRdata.where((element) => element.PickupRequestId.isNotEmpty)
                      .toList();
              return newdata.isEmpty
                  ? Center(child: EmptyFlick())
                  : ListView.separated(
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
                      separatorBuilder: (context, index) {
                        return PRnewdata.isEmpty
                            ? SizedBox.shrink()
                            : Padding(
                                padding: EdgeInsets.all(8.0),
                                child: PickupAlert(
                                  pu: PRnewdata[index],
                                ),
                              );
                      },
                    );
            });
          }),
    );
  }
}
