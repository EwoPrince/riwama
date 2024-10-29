import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/auth/onboarding.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/x.dart';

class LogOut extends StatelessWidget {
  const LogOut({Key? key}) : super(key: key);
  static const routeName = '/LogOut';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log out'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Would you like to log out of your riwama account, you will be able to sign in when ever you insert your Email and password.',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 5,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Spacer(),
            Consumer(builder: (context, ref, child) {
              return button(
                context,
                'Log Out',
                () async {
                  ref.read(authProvider).logoutUser();
                  become(context, Onboarding.routeName, null);
                },
              );
            }),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
