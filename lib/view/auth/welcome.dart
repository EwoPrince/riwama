import 'package:flutter/material.dart';
import 'package:riwama/states/verified_state.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/x.dart';

// ignore: camel_case_types
class Welcome extends StatefulWidget {
  const Welcome();
  static const routeName = '/WelcomeToriwama';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0), // Adjust the padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome to the RIWAMA mobile app',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Your Account has been activated successfully, PLease proceed to the Homepage.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            button(
              context,
              'Proceed',
              () {
                become(context, VerifiedState.routeName, null);
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
