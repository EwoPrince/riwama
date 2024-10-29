import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/profile/edit_profile.dart';
import 'package:riwama/view/profile/editx/first_name.dart';
import 'package:riwama/view/profile/editx/phone.dart';
import 'package:riwama/view/profile/editx/last_name.dart';
import 'package:riwama/x.dart';

class AccountInformation extends ConsumerStatefulWidget {
  const AccountInformation({Key? key});
  static const routeName = '/AccountInformation';

  @override
  ConsumerState<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends ConsumerState<AccountInformation> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goto(
            context,
            Editprofile.routeName,
            null,
          );
        },
        child: Icon(Icons.edit_outlined),
      ),
      appBar: AppBar(
        title: Text('Account Information'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "First Name",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      "${user!.firstName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ).onTap(() {
                      goto(
                        context,
                        FullName.routeName,
                        null,
                      );
                    }),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Name",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      "${user.lastName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ).onTap(() {
                      goto(
                        context,
                        LastName.routeName,
                        null,
                      );
                    }),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      "${user.email}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      "${user.phone}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ).onTap(() {
                      goto(
                        context,
                        Phone.routeName,
                        null,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
