import 'package:flutter/material.dart';
import 'package:riwama/view/account/resetPass.dart';
import 'package:riwama/widgets/settingsTile.dart';
import 'package:riwama/x.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);
  static const routeName = '/SecurityScreen';

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security and Account Access'),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'Manage your account security, or change your password if you forgot your password.',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 5,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              SettingsTile(
                context,
                Icons.lock_outline,
                'Change Password',
                'Reset your password by verifying your email',
                true,
                true,
              ).onTap(() {
                goto(
                  context,
                  ResetPass.routeName,
                  null,
                );
              }),
            ],
          )),
    );
  }
}
