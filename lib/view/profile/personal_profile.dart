import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/account/account_information.dart';
import 'package:riwama/view/account/general_setting.dart';
import 'package:riwama/view/profile/edit_profile.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pic_profile_view.dart';

class PersonalProfile extends ConsumerStatefulWidget {
  const PersonalProfile({
    Key? key,
  }) : super(key: key);
  static const routeName = '/PersonalProfile';

  @override
  _PersonalProfileState createState() => _PersonalProfileState();
}

class _PersonalProfileState extends ConsumerState<PersonalProfile>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = ref.read(authProvider).user;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Hero(
                tag: user!.photoUrl,
                child: ExtendedImage.network(
                  user.photoUrl,
                  width: size.width * 0.35,
                  height: size.width * 0.35,
                  fit: BoxFit.cover,
                  cache: true,
                  shape: BoxShape.circle,
                ),
              ).onTap(() {
                goto(
                  context,
                  PicProfileView.routeName,
                  user.photoUrl,
                );
              }),
              SizedBox(height: 12),
              FittedBox(
                child: Text(
                  user.firstName,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ).onTap(() {
                  goto(
                    context,
                    AccountInformation.routeName,
                    null,
                  );
                }),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user.lastName != ' ')
                    FittedBox(
                      child: Text(
                        user.lastName,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ).onTap(() {
                        goto(
                          context,
                          AccountInformation.routeName,
                          null,
                        );
                      }),
                    ),
                  SizedBox(width: 4),
                  if (user.middleName != ' ')
                    FittedBox(
                      child: Text(
                        user.middleName,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ).onTap(() {
                        goto(
                          context,
                          AccountInformation.routeName,
                          null,
                        );
                      }),
                    ),
                ],
              ),
              SizedBox(height: 14),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.7,
                        child: Text(
                          'Number of Pick Up Request made',
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${user.purNumber}',
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.7,
                        child: Text(
                          'Number of Intervention Request made',
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${user.irNumber}',
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    child: button(context, 'Edit Profile', () {
                      goto(context, Editprofile.routeName, null);
                    }),
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 150,
                    child: button(context, 'Settings', () {
                      goto(context, Settingss.routeName, null);
                    }),
                  ),
                ],
              ),
              button(
                context,
                'Contact Consumer Services',
                () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '+2347085136311',
                  );
                  try {
                    await launchUrl(launchUri);
                  } catch (error) {
                    showMessage(context, "Cannot dial");
                  }
                },
              ),
            ],
          ),
        ));
  }
}
