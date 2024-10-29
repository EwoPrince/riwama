import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/map_provider.dart';
import 'package:riwama/services/map_bility.dart';
import 'package:riwama/services/place_service.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/view/industry/pickupRequest/request_widget/describe_request.dart';
import 'package:riwama/view/industry/pickupRequest/respository/pickupRequest_controller.dart';
import 'package:riwama/widgets/button.dart';
import 'package:uuid/uuid.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/overlaybutton.dart';
import 'package:riwama/x.dart';

void XshowRIPModalBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final _mapcontroller = TextEditingController();

      return Consumer(builder: (context, ref, _) {
        var position = ref.watch(mapProvider).position;
        var location = ref.read(mapProvider).fetchLocation;
        return location == false
            ? Loading()
            : Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      'Location for this Pickup?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    overlayButton(
                      context,
                      'Use my current Location',
                      () {
                        goto(
                          context,
                          RequestInstantPickup.routeName,
                          {
                            'lat': position!.latitude.toString(),
                            'lot': position.longitude.toString(),
                          },
                        );
                      },
                      true,
                      true,
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      controller: _mapcontroller,
                      readOnly: true,
                      keyboardType: TextInputType.streetAddress,
                      onTap: () async {
                        final sessionToken = Uuid().v4();
                        final Suggestion? result = await showSearch(
                          context: context,
                          delegate: AddressSearch(sessionToken),
                        );
                        if (result != null) {
                          final placeDetails =
                              await PlaceApiProvider(sessionToken)
                                  .fetchLatLon(result.placeId);
                    
                          _mapcontroller.text = result.description;
                          goto(
                            context,
                            RequestInstantPickup.routeName,
                            {
                              'lat': placeDetails.lat.toString(),
                              'lot': placeDetails.lon.toString(),
                            },
                          );
                        }
                      },
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Search Location',
                        prefixIcon: Icon(Icons.location_pin),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 4),
                    overlayButton(
                      context,
                      'Cancel',
                      () {
                        Navigator.pop(context);
                      },
                      false,
                      true,
                    ),
                    SizedBox(height: 36),
                  ],
                ),
              );
      });
    },
  );
}

class RequestInstantPickup extends ConsumerStatefulWidget {
  final String lat;
  final String lon;
  const RequestInstantPickup({
    super.key,
    required this.lat,
    required this.lon,
  });
  static const routeName = '/RequestInstantPickup';

  @override
  _RequestInstantPickupState createState() => _RequestInstantPickupState();
}

class _RequestInstantPickupState extends ConsumerState<RequestInstantPickup> {
  String warningData = 'household';
  bool isLoading = false;

  Future sendRequestInstantPickup() async {
    setState(() {
      isLoading = true;
    });

    await ref
        .read(PickupRequestControllerProvider)
        .sendRequestInstantPickup(
          context,
          widget.lon,
          widget.lat,
          warningData,
        )
        .then((value) {
      become(context, Land.routeName, null);
      showUpMessage(context, 'Request Successful',
          'Your request for an instant pickup has been delivered successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Instant Pickup'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: DescribeRequest(
              requestSelected: (String? value) {
                setState(() {
                  warningData = value!;
                });
              },
            ),
          ),
          SizedBox(height: 24),
          button(
            context,
            "Send Request",
            () {
              sendRequestInstantPickup();
            },
          ),
        ],
      ),
    );
  }
}
