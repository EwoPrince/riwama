import 'package:flutter/material.dart';

Widget overlayButton(
  BuildContext context,
  String name,
  VoidCallback? onTap,
  bool top,
  bool buttom,
) {
  final size = MediaQuery.of(context).size;
  return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: top
              ? BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
              : buttom
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                  : null,
          border: top
              ? Border(bottom: BorderSide.none)
              : buttom
                  ? Border(top: BorderSide.none)
                  : Border(
                      top: BorderSide(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      bottom: BorderSide(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
          color: Theme.of(context).colorScheme.primary,
        ),
        width: size.width - 13,
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 28,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ],
        ),
      ));
}
