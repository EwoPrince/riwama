import 'package:flutter/material.dart';
import 'package:riwama/view/userguild/get_to_us.dart';
import 'package:riwama/view/userguild/helpcenter.dart';
import 'package:riwama/view/userguild/tac.dart';
import 'package:riwama/widgets/settingsTile.dart';
import 'package:riwama/x.dart';

class AdditonalRes extends StatefulWidget {
  const AdditonalRes({Key? key}) : super(key: key);
  static const routeName = '/AdditonalResources';

  @override
  State<AdditonalRes> createState() => _AdditonalResState();
}

class _AdditonalResState extends State<AdditonalRes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additonal Resources'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Check out other places for helpful information to learn more about riwama products and services',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 5,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            SettingsTile(
              context,
              Icons.menu_book_outlined,
              'Terms and Conditions',
              'See the document governing the contractual relationship between riwama and its user.',
              true,
              false,
            ).onTap(() {
              goto(
                context,
                tac.routeName,
                null,
              );
            }),
            SettingsTile(
              context,
              Icons.help_center_outlined,
              'Help Center',
              'A centralized hub for users to access information around process, products, and services concerning riwama.',
              false,
              false,
            ).onTap(() {
              goto(
                context,
                helpcenter.routeName,
                null,
              );
            }),
            SettingsTile(
              context,
              Icons.contact_support_outlined,
              'Get to us',
              'Make Complaints and Enquiries about process, products, and services concerning riwama.',
              false,
              true,
            ).onTap(() {
              goto(
                context,
                GetToUs.routeName,
                null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
