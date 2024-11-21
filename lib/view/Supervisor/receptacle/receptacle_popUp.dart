import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:riwama/model/receptacle.dart';
import 'package:riwama/x.dart';

Widget ReceptaclePopUp(
  BuildContext context,
  Receptacle data,
) {
  final size = MediaQuery.of(context).size;
  return Dialog(
    child: Container(
      padding: EdgeInsets.all(8.0),
      width: size.width * 0.65,
      height: size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            "Receptacle PopUp",
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
                'Updated on :',
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
                'Updated by :',
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
            width: size.width * 0.62,
            height: size.height * 0.18,
            child: LayoutBuilder(builder: (context, short) {
              return ConstrainedBox(
                constraints: short,
                child: ExtendedImage.network(
                  data.profImage,
                  fit: BoxFit.contain,
                  cache: true,
                  cacheMaxAge: Duration(days: 7),
                ),
              );
            }),
          ),
          SizedBox(width: 6),
          // SizedBox(
          //   width: size.width * 0.4,
          //   child: button(context, 'View', () {
          //     goto(context, InterventionView.routeName, data);
          //   }),
          // ),
        ],
      ),
    ),
  );
}
