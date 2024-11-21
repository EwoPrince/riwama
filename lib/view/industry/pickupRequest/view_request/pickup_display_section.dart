import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/provider/map_provider.dart';
import 'package:riwama/widgets/bitmap.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class PickupDisplaySection extends ConsumerStatefulWidget {
  const PickupDisplaySection({super.key, required this.snap});
  final PickupRequest snap;

  @override
  ConsumerState<PickupDisplaySection> createState() =>
      _PickupDisplaySectionState();
}

class _PickupDisplaySectionState extends ConsumerState<PickupDisplaySection> {
  late Future futureHolder;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  late PolylinePoints polylinePoints;
  int polyId = 1;

  Future onMapCreated() async {
    var position = ref.watch(mapProvider).position;
    double? lon = double.tryParse(widget.snap.lon);
    double? lat = double.tryParse(widget.snap.lat);

    List<LatLng> latlngSegment1 = [];

    LatLng _lat1 = LatLng(position!.latitude, position.longitude);
    LatLng _lat2 = LatLng(lat!, lon!);
    LatLng _lastMapPosition = _lat1;

    latlngSegment1.add(_lat1);
    latlngSegment1.add(_lat2);

    _markers.add(
      Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        icon: await MeBitmap(context).toBitmapDescriptor(
          logicalSize: const Size(80, 80),
          imageSize: const Size(80, 80),
        ),
        infoWindow: InfoWindow(
          title: 'your location',
          snippet: 'This is a snippet',
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId(_lat2.toString()),
        position: _lat2,
        icon: await PRBitmap(context).toBitmapDescriptor(
          logicalSize: const Size(80, 80),
          imageSize: const Size(80, 80),
        ),
        infoWindow: InfoWindow(
          title: 'Intervention',
          snippet: 'this is the location of your Pick Up',
        ),
      ),
    );

    _polyline.add(
      Polyline(
        polylineId: PolylineId(_lat2.toString()),
        points: latlngSegment1,
        color: Colors.blue,
        width: 6,
        geodesic: true,
        consumeTapEvents: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureHolder = onMapCreated();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureHolder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        if (snapshot.hasError) {
          return Loading();
        }

        return Consumer(
          builder: (context, ref, child) {
            var position = ref.watch(mapProvider).position;
            return Hero(
              tag: widget.snap.profImage.toString(),
              child: position == null
                  ? Loading()
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 9,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      markers: _markers,
                      polylines: _polyline,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);
                        var position = ref.watch(mapProvider).position;
                        double? lon = double.tryParse(widget.snap.lon);
                        double? lat = double.tryParse(widget.snap.lat);

                        List<LatLng> latlngSegment1 = [];

                        final origin =
                            PointLatLng(position!.latitude, position.longitude);
                        final destination = PointLatLng(lat!, lon!);

                        final PolylineResult result =
                            await polylinePoints.getRouteBetweenCoordinates(
                          googleApiKey: Platform.isAndroid
                              ? 'AIzaSyD-yXrA6zoQRzns6mTgCJYSsRRzhkoMyXY'
                              : 'AIzaSyBcFY0dn1sCb3IPvZ7ErG2X1sZhTEq4atc',
                          request: PolylineRequest(
                            origin: origin,
                            destination: destination,
                            mode: TravelMode.driving,
                          ),
                        );

                        if (result.status == 'OK' && result.points.isNotEmpty) {
                          latlngSegment1
                              .clear(); // Clear previous coordinates if any
                          for (var point in result.points) {
                            latlngSegment1
                                .add(LatLng(point.latitude, point.longitude));
                          }

                          final polylineIdVal = 'polyline_id_$polyId';
                          polyId++;
                          final polylineId = PolylineId(polylineIdVal);

                          _polyline.add(
                            Polyline(
                              polylineId: polylineId,
                              points: latlngSegment1,
                              color: Colors.blue,
                              width: 6,
                              geodesic: true,
                              consumeTapEvents: true,
                            ),
                          );
                          setState(() {});
                        }
                      },
                      mapType: MapType.normal,
                      trafficEnabled: true,
                    ),
            );
          },
        );
      },
    );
  }
}