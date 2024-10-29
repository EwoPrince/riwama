import 'package:flutter/material.dart';
import 'package:riwama/view/alert/alert.dart';
import 'package:riwama/view/userguild/additonal_res.dart';
import 'package:riwama/view/userguild/privacy_tips.dart';
import 'package:riwama/view/account/security.dart';
import 'package:riwama/view/account/yourAccount.dart';
import 'package:riwama/widgets/settingsTile.dart';
import 'package:riwama/x.dart';

class Settingss extends StatefulWidget {
  static const routeName = '/Settings';
  @override
  State<Settingss> createState() => _SettingssState();
}

class _SettingssState extends State<Settingss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            children: [
              SettingsTile(
                context,
                Icons.person_outline,
                'Your account',
                'See information about your account and Edit any if you want to.',
                true,
                false,
              ).onTap(() {
                goto(
                  context,
                  YourAccount.routeName,
                  null,
                );
              }),
              SettingsTile(
                context,
                Icons.lock_outline,
                'Account access',
                'Manage your account security, or change your password if you forgot your password.',
                false,
                false,
              ).onTap(() {
                goto(context, SecurityScreen.routeName, null);
              }),
              SettingsTile(
                context,
                Icons.privacy_tip_outlined,
                'Privacy and Safety',
                'Get tips on how to keep your account secured and what to share on riwama.',
                false,
                false,
              ).onTap(() {
                goto(
                  context,
                  PrivacyTips.routeName,
                  null,
                );
              }),
              SettingsTile(
                context,
                Icons.notification_important_outlined,
                'Notification',
                'See all available notifications in touch with this account.',
                false,
                false,
              ).onTap(() {
                goto(context, Alerts.routeName, null);
              }),
              SettingsTile(
                context,
                Icons.menu_outlined,
                'Additional resources',
                'Check out other places for helpful information to learn more about riwama products and services',
                false,
                true,
              ).onTap(() {
                goto(
                  context,
                  AdditonalRes.routeName,
                  null,
                );
              }),
            ],
          )),
    );
  }
}
