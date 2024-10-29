import 'package:flutter/material.dart';

Widget SettingsTile(
  BuildContext context,
  IconData icon,
  String name,
  String description,
  bool top,
  bool bottom,
) {
  final size = MediaQuery.of(context).size;
  return Container(
    width: size.width - 30,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    decoration: BoxDecoration(
      borderRadius: top
          ? BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )
          : bottom
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : null,
      border: top
          ? Border(bottom: BorderSide.none)
          : bottom
              ? Border(top: BorderSide.none)
              : Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
      color: Theme.of(context).colorScheme.inversePrimary,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            SizedBox(height: 4),
            SizedBox(
              width: size.width - 90,
              child: Text(
                description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
