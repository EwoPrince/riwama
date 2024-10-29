import 'package:flutter/material.dart';
import 'package:riwama/states/verified_state.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/x.dart';

class Networkiss extends StatefulWidget {
  const Networkiss({Key? key}) : super(key: key);

  @override
  State<Networkiss> createState() => _NetworkissState();
}

class _NetworkissState extends State<Networkiss> {
  bool offline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pngegg.png',
                fit: BoxFit.fill,
              ).onDoubleTap(() {
                setState(() {
                  offline = !offline;
                });
              }),
              SizedBox(
                height: 100,
              ),
              Text(
                'You seem to be having a poor network connection',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Please try again',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).onTap(() {
                become(context, VerifiedState.routeName, null);
              }),
              Text(
                '...or you just haven\'t verified your email',
                
                      style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (offline)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 70),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Try OFFLINE',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ).onTap(() {
                        become(context, Land.routeName, null);
                      }),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
