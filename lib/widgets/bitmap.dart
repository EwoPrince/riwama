import 'package:flutter/material.dart';

Widget IRBitmap(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
      border: Border.all(
        width: 3,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
    child: Center(
      child: Icon(
        Icons.live_help,
        size: 50,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
  );
}

Widget PRBitmap(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
      border: Border.all(
        width: 3,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
    child: Center(
      child: Icon(
        Icons.fire_truck,
        size: 50,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
  );
}

Widget DropBitmap(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.green,
      shape: BoxShape.circle,
      border: Border.all(
        width: 3,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
    child: Center(
      child: Icon(
        Icons.recycling,
        size: 50,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
  );
}

Widget MeBitmap(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.deepOrange,
      shape: BoxShape.circle,
      border: Border.all(
        width: 3,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
    child: Center(
      child: Icon(
        Icons.accessibility,
        size: 50,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    ),
  );
}
