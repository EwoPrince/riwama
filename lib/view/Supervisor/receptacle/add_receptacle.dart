import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/map_provider.dart';
import 'package:riwama/services/map_bility.dart';
import 'package:riwama/services/place_service.dart';
import 'package:riwama/view/Supervisor/respository/receptacle_controller.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:uuid/uuid.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/overlaybutton.dart';
import 'package:riwama/x.dart';

void AddReceptacleBottomSheet(
  BuildContext context,
  WidgetRef ref,
  File file,
) {
  showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final _mapcontroller = TextEditingController();

      Future addReceptacleIntervention(
        String lon,
        String lat,
      ) async {
        await ref
            .read(ReceptacleControllerProvider)
            .addReceptacle(
              context,
              lon,
              lat,
              file,
            )
            .then((value) {
          become(context, Land.routeName, null);
          showUpMessage(
              context, 'Receptacle update', 'Rceptacle added successfully');
        });
      }

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
                      'Location of this Receptacle?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    overlayButton(
                      context,
                      'Use my current Location',
                      () async {
                        addReceptacleIntervention(
                          position!.longitude.toString(),
                          position.latitude.toString(),
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

                          addReceptacleIntervention(
                            placeDetails.lat.toString(),
                            placeDetails.lon.toString(),
                          );
                        }
                      },
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
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
                    SizedBox(height: 30),
                  ],
                ),
              );
      });
    },
  );
}
