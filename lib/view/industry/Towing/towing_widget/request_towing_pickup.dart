import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/map_provider.dart';
import 'package:riwama/services/map_bility.dart';
import 'package:riwama/services/place_service.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/view/industry/Towing/respository/towRequest_controller.dart';
import 'package:riwama/view/industry/Towing/towing_widget/billing_request.dart';
import 'package:riwama/widgets/button.dart';
import 'package:uuid/uuid.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/overlaybutton.dart';
import 'package:riwama/x.dart';

void XshowTowingBottomSheet(BuildContext context, WidgetRef ref) {
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
                      'Location of Vehicle for this Pickup?',
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
                          RequestInstantTow.routeName,
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
                            RequestInstantTow.routeName,
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

class RequestInstantTow extends ConsumerStatefulWidget {
  final String lat;
  final String lon;
  const RequestInstantTow({
    super.key,
    required this.lat,
    required this.lon,
  });
  static const routeName = '/RequestInstantTow';

  @override
  _RequestInstantTowState createState() => _RequestInstantTowState();
}

class _RequestInstantTowState extends ConsumerState<RequestInstantTow> {
  String warningData = 'Cash';
  bool isLoading = false;

  Future sendRequestInstantTow() async {
    setState(() {
      isLoading = true;
    });

    await ref
        .read(TowRequestControllerProvider)
        .sendRequestTow(
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
        title: Text('Request Instant Tow Service'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: BillingRequest(
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
              sendRequestInstantTow();
            },
          ),
        ],
      ),
    );
  }
}
