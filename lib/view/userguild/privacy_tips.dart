import 'package:flutter/material.dart';
import 'package:riwama/view/userguild/helpcenter.dart';
import 'package:riwama/widgets/settingsTile.dart';
import 'package:riwama/x.dart';

class PrivacyTips extends StatefulWidget {
  const PrivacyTips({Key? key}) : super(key: key);
  static const routeName = '/PrivacyTips';

  @override
  State<PrivacyTips> createState() => _PrivacyTipsState();
}

class _PrivacyTipsState extends State<PrivacyTips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy and Safety'),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get tips on how to keep your account secured and what to share on riwama.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Use data to make riwama work',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'We need to store and process your data in other to provide you the basic riwama services, such as your Location, and comments across requests and interventions. By using riwama, you allow us to provide this basic service. You can stop this by Deactivating or Deleting your account',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Use data to Customize and improve my riwama Experience',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'This allow us to use and process information about how you navigate and use riwama for analytical purpose, also allowing us to include you in new features and exprerimental test.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Spacer(),
              SettingsTile(
                context,
                Icons.help_center_outlined,
                'Help Center',
                'A centralized hub for users to access information around process, products, and services concerning riwama.',
                true,
                true,
              ).onTap(() {
                goto(
                  context,
                  helpcenter.routeName,
                  null,
                );
              }),
            ],
          )),
    );
  }
}
