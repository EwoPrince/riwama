import 'package:flutter/material.dart';
import 'package:riwama/model/tow.dart';
import 'package:riwama/view/industry/Towing/view_towing/towing_view.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/x.dart';

Widget TowingPopUp(
  BuildContext context,
  TowRequest data,
) {
  final size = MediaQuery.of(context).size;
  return Dialog(
    child: Container(
      padding: EdgeInsets.all(8.0),
      width: size.width * 0.65,
      height: size.height * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            "Tow Service Request",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Post on :',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(readTimestamp(data.datePublished)),
            ],
          ),
          SizedBox(width: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Post by :',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(data.name),
            ],
          ),
          SizedBox(width: 6),
          SizedBox(
            width: size.width * 0.4,
            child: button(context, 'View', () {
              goto(context, TowingView.routeName, data);
            }),
          ),
        ],
      ),
    ),
  );
}
