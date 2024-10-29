import 'package:flutter/material.dart';

Container coinBalance(BuildContext context, String river, String sea) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        width: 3.0,
        style: BorderStyle.solid,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
          child: Text(
            'Fish Tank',
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w900,
                fontSize: 28,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/silver.png",
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                river,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/gold.png",
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                sea,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
