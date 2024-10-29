import 'package:flutter/material.dart';

Padding button(BuildContext context, String name, Function onTap) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
      ),
    ),
  );
}
