import 'package:flutter/material.dart';

Widget IRBitmap(BuildContext context) {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.live_help,
                size: 30,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        Container(
          height: 12,
          width: 3,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    ),
  );
}

Widget PRBitmap(BuildContext context) {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.fire_truck,
                size: 30,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        Container(
          height: 12,
          width: 3,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    ),
  );
}

Widget DropBitmap(BuildContext context) {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
      color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
        Icons.recycling,
                size: 30,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        Container(
          height: 12,
          width: 3,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    ),
  );
}

Widget MeBitmap(BuildContext context) {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
      color: Colors.deepOrange,
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
        Icons.recycling,
                size: 30,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        Container(
          height: 12,
          width: 3,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    ),
  );
}
