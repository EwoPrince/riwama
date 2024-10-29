import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/provider/map_provider.dart';
import 'package:riwama/view/dashboard/menu.dart';
import 'package:riwama/view/industry/intervention/view_intervention/intervention_popup.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_popup.dart';
import 'package:riwama/widgets/bitmap.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/postbottomsheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riwama/x.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class SupervisorIndustry extends ConsumerStatefulWidget {
  const SupervisorIndustry({Key? key}) : super(key: key);

  @override
  ConsumerState<SupervisorIndustry> createState() => _SupervisorIndustryState();
}

class _SupervisorIndustryState extends ConsumerState<SupervisorIndustry>
    with SingleTickerProviderStateMixin {
  late Future futureHolder;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final List<Marker> _markers = [];

  Future fetchdata() async {
    ref.read(mapProvider).fetchLocation;
    var PRData = ref.watch(industryProvider).worldDataPR;
    var IRData = ref.watch(industryProvider).worldDataIR;
    final IR = IRData.where((element) => element.cleared == false).toList();
    final PR = PRData.where((element) => element.cleared == false).toList();

    for (var location in IR) {
      var lat = double.tryParse(location.lat);
      var lon = double.tryParse(location.lon);

      _markers.add(
        Marker(
          markerId: MarkerId(location.InterventionrequestId.toString()),
          position: LatLng(lat!, lon!),
          icon: await IRBitmap(context).toBitmapDescriptor(
              logicalSize: const Size(80, 80), imageSize: const Size(80, 80)),
          infoWindow: InfoWindow(
            title: "Intervention Request",
            snippet: 'Posted by ${location.name}',
            onTap: () {
              showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (context) {
                    return InterventionPopUp(context, location);
                  });
            },
          ),
        ),
      );
    }

    for (var location in PR) {
      var lat = double.tryParse(location.lat);
      var lon = double.tryParse(location.lon);
      _markers.add(
        Marker(
          markerId: MarkerId(location.PickupRequestId.toString()),
          position: LatLng(lat!, lon!),
          icon: await PRBitmap(context).toBitmapDescriptor(
              logicalSize: const Size(80, 80), imageSize: const Size(80, 80)),
          infoWindow: InfoWindow(
              title: "Pickup Request",
              snippet: 'Posted by ${location.name}',
              onTap: () {
                showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) {
                      return PickUpPopUp(context, location);
                    });
              }),
        ),
      );
    }

    setState(() {});
  }

  void created() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futureHolder = fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "RIWAMA",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ).onTap(() {
              goto(context, Menu.routeName, null);
        }),
        actions: [
          IconButton(
            onPressed: () {
          Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ],
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
              final position = ref.watch(mapProvider).position;
              return position == null
                  ? Loading()
                  : Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.83,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 11,
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              markers: Set<Marker>.of(_markers),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                created();
                              },
                            ),
                          ),
                        ),
                      ],
                    );
            });
          }),

      /// amazing floating button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          XshowModalBottomSheet(context, ref);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        clipBehavior: Clip.antiAlias,
        child: Icon(
          Icons.delete_forever_rounded,
          color: Theme.of(context).scaffoldBackgroundColor,
          size: 32,
        ),
        elevation: 20,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}