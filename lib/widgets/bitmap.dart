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
          color: Colors.grey.shade800,
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
          color: Colors.grey.shade800,
        ),
      ],
    ),
  );
}

Widget TBitmap(BuildContext context) {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
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
                Icons.fire_truck_outlined,
                size: 30,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        Container(
          height: 12,
          width: 3,
          color: Colors.grey.shade800,
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
          color: Colors.grey.shade800,
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
                Icons.accessibility,
                size: 30,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        Container(
          height: 12,
          width: 3,
          color: Colors.grey.shade800,
        ),
      ],
    ),
  );
}
