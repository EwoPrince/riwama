import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/theme_provider.dart';
import 'package:riwama/view/Supervisor/supervisor_form.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/view/industry/Towing/view_towing/list_towing.dart';
import 'package:riwama/view/profile/personal_profile.dart';
import 'package:riwama/view/industry/intervention/view_intervention/list_intervention.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_row.dart';
import 'package:riwama/view/userguild/helpcenter.dart';
import 'package:riwama/view/account/general_setting.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/drawertile.dart';
import 'package:riwama/view/Billing/Billing.dart';
import 'package:riwama/x.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends ConsumerStatefulWidget {
  @override
  ConsumerState<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends ConsumerState<NavDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Uri FBurl =
        Uri.parse('https://web.facebook.com/profile.php?id=61557723915652');
    final Uri TTurl = Uri.parse('https://www.tiktok.com/@officialriwama');

    return Consumer(builder: (context, ref, child) {
      final user = ref.watch(authProvider).user;
      return Drawer(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                switchIcon(),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Hero(
                                tag: user!.photoUrl,
                                child: ExtendedImage.network(
                                  "${user.photoUrl}",
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                  cache: true,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ).onTap(() {
                                  goto(
                                    context,
                                    PersonalProfile.routeName,
                                    null,
                                  );
                                }),
                              ),
                            ),
                            Text(
                              "${user.firstName}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ).onTap(() {
                              goto(
                                context,
                                PersonalProfile.routeName,
                                null,
                              );
                            }),
                            Text(
                              "${user.lastName} ${user.middleName}",
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ).onTap(() {
                              goto(
                                context,
                                PersonalProfile.routeName,
                                null,
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Services",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      SizedBox(height: 12),
                      drawerTile(
                        Icons.notifications_active_outlined,
                        'Pick Up Request List',
                      ).onTap(() {
                        goto(
                          context,
                          PickupRow.routeName,
                          null,
                        );
                      }),
                      SizedBox(height: 12),
                      drawerTile(
                        Icons.notifications_active_outlined,
                        'Intervention List',
                      ).onTap(() {
                        goto(
                          context,
                          InterventionList.routeName,
                          null,
                        );
                      }),
                      SizedBox(height: 12),
                      drawerTile(
                        Icons.notifications_active_outlined,
                        'Tow Request List',
                      ).onTap(() {
                        goto(
                          context,
                          TowList.routeName,
                          null,
                        );
                      }),
                      SizedBox(height: 12),
                      drawerTile(
                        Icons.monetization_on_outlined,
                        'Billings',
                      ).onTap(() {
                        goto(
                          context,
                          Billings.routeName,
                          null,
                        );
                      }),
                    ],
                  ),
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    user.accountLevel == 1
                        ? SizedBox(
                            width: 220,
                            child: button(context, 'Supervisor Mode', () {
                              goto(context, SupervisorForm.routeName, null);
                            }),
                          )
                        : SizedBox(
                            width: 220,
                            child:
                                button(context, 'Public User Mode', () async {
                              try {
                                await ref
                                    .read(authProvider)
                                    .revertSupervisor()
                                    .then((value) {
                                  become(context, Land.routeName, null);
                                  showUpMessage(
                                      context,
                                      'Supervisor Registration sent successfully',
                                      'Application Summited');
                                });
                              } catch (e) {
                                showUpMessage(context, "Error", e.toString());
                              }
                            }),
                          ),
                    TextButton(
                      onPressed: () {
                        goto(
                          context,
                          Settingss.routeName,
                          null,
                        );
                      },
                      child: Text(
                        'Settings and Privacy',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        goto(
                          context,
                          helpcenter.routeName,
                          null,
                        );
                      },
                      child: Text(
                        'Help Center',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () async {
                              if (!await launchUrl(
                                FBurl,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw Exception('Could not launch $FBurl');
                              }
                            },
                            icon: Icon(Icons.facebook)),
                        IconButton(
                            onPressed: () async {
                              if (!await launchUrl(
                                TTurl,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw Exception('Could not launch $TTurl');
                              }
                            },
                            icon: Icon(Icons.tiktok)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget switchIcon() {
    return Consumer(
      builder: (context, ref, child) {
        final future = ref.watch(themeProvider.notifier).onAppLaunch(context);
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return Switch(
              value: snapshot.data ?? context.isDarkMode,
              onChanged: (value) async {
                value = ref
                    .watch(themeProvider.notifier)
                    .changeMode(context, !snapshot.data!);
              },
              thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Icon(Icons.sunny);
                }
                return Icon(Icons.mode_night);
              }),
            );
          },
        );
      },
    );
  }
}
