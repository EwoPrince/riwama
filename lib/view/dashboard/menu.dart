import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/Supervisor/add_slide.dart';
import 'package:riwama/view/Supervisor/receptacle_sample.dart';
import 'package:riwama/view/Supervisor/supervisor_form.dart';
import 'package:riwama/view/profile/personal_profile.dart';
import 'package:riwama/view/profile/pic_profile_view.dart';
import 'package:riwama/view/account/general_setting.dart';
import 'package:riwama/view/industry/intervention/view_intervention/list_intervention.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_row.dart';
import 'package:riwama/view/userguild/helpcenter.dart';
import 'package:riwama/widgets/select_card.dart';
import 'package:riwama/widgets/settingsTile.dart';
import 'package:riwama/x.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends ConsumerStatefulWidget {
  static const routeName = '/Menu';
  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  int currentSlide = 0;
  late Future futureHolder;

  Future fetchdata() async {
    await ref.read(industryProvider).fetchSlider();
  }

  @override
  void initState() {
    super.initState();
    futureHolder = fetchdata();
  }

  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final timeHour = DateTime.now().hour;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                pinned: true,
                floating: true,
                stretch: true,
                expandedHeight: 360.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: SizedBox(),
                  background: FutureBuilder(
                      future: futureHolder,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('There currently is no item'));
                        }

                        return Consumer(
                          builder: (context, ref, child) {
                            final slide = ref.read(industryProvider).sildeData;

                            final newSlide = slide
                                .where((element) => element.slideId.isNotEmpty)
                                .toList();

                            return CarouselSlider(
                              carouselController: buttonCarouselController,
                              options: CarouselOptions(
                                  initialPage: 0,
                                  scrollDirection: Axis.horizontal,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.2,
                                  viewportFraction: 0.9,
                                  enableInfiniteScroll: true,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  height: 350.0,
                                  onPageChanged: (index, _) {
                                    setState(() {
                                      currentSlide = index;
                                    });
                                  }),
                              items: newSlide.map((image) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        child: ExtendedImage.network(
                                          image.profImage,
                                          fit: BoxFit.cover,
                                          cache: true,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          },
                        );
                      }),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SizedBox(height: 80),
              FittedBox(
                child: Text(
                  timeHour < 12
                      ? 'Good Morning ${user!.firstName}'
                      : timeHour < 16
                          ? 'Good Afternoon ${user!.firstName}'
                          : 'Good Evening ${user!.firstName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ).onTap(() {
                goto(
                  context,
                  PersonalProfile.routeName,
                  null,
                );
              }),
              SizedBox(height: 8),
              FittedBox(
                child: Text(
                  'What Service could we provide you',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 28),
              user.accountLevel == 1
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SettingsTile(
                              context,
                              Icons.family_restroom,
                              'Join RIWAMA',
                              'Become a public service provider',
                              true,
                              false)
                          .onTap(() {
                        goto(context, SupervisorForm.routeName, null);
                      }),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectCard(
                    iconData: Icons.call,
                    title: 'Contact RIWAMA Front Desk',
                  ).onTap(() async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '+2347085136311',
                    );
                    try {
                      await launchUrl(launchUri);
                    } catch (error) {
                      showMessage(context, "Cannot dial");
                    }
                  }),
                  SelectCard(
                    iconData: Icons.electric_rickshaw_rounded,
                    title: 'Call Instant Tow Request',
                  ).onTap(() async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '+2347085136311',
                    );
                    try {
                      await launchUrl(launchUri);
                    } catch (error) {
                      showMessage(context, "Cannot dial");
                    }
                  }),
                ],
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SettingsTile(
                  context,
                  Icons.notifications_active_outlined,
                  'Intervention List',
                  'See a list of Intervention request you have made',
                  user.accountLevel == 1 ? false : true,
                  false,
                ).onTap(() {
                  goto(
                    context,
                    InterventionList.routeName,
                    null,
                  );
                }),
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SettingsTile(
                        context,
                        Icons.notifications_active_outlined,
                        'Pick Up List',
                        'See a list of Pick Up request you have made',
                        false,
                        false)
                    .onTap(() {
                  goto(
                    context,
                    PickupRow.routeName,
                    null,
                  );
                }),
              ),
              user.accountLevel >= 2 ? SizedBox(height: 3) : SizedBox.shrink(),
              user.accountLevel >= 2
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SettingsTile(context, Icons.add_box, 'Add Slide',
                              'Update to the RIWAMA Slides', false, false)
                          .onTap(() {
                        goto(context, AddSlide.routeName, null);
                      }),
                    )
                  : SizedBox.shrink(),
              user.accountLevel >= 2 ? SizedBox(height: 3) : SizedBox.shrink(),
              user.accountLevel >= 2
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SettingsTile(
                              context,
                              Icons.add_location_alt,
                              'Add Receptacle',
                              'Update to the public a Receptacle location',
                              false,
                              false)
                          .onTap(() {
                        goto(context, ReceptacleSample.routeName, null);
                      }),
                    )
                  : SizedBox.shrink(),
              if (user.accountLevel >= 2) SizedBox(height: 3),
              if (user.accountLevel >= 2)
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runAlignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SelectCard(
                      iconData: Icons.call,
                      title: 'S.A on waste Operation',
                    ).onTap(() async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '+2347085136311',
                      );
                      try {
                        await launchUrl(launchUri);
                      } catch (error) {
                        showMessage(context, "Cannot dial");
                      }
                    }),
                    SelectCard(
                      iconData: Icons.call,
                      title: 'S.A on Inspection',
                    ).onTap(() async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '+2347085136311',
                      );
                      try {
                        await launchUrl(launchUri);
                      } catch (error) {
                        showMessage(context, "Cannot dial");
                      }
                    }),
                    SelectCard(
                      iconData: Icons.call,
                      title: 'S.A on Intervention',
                    ).onTap(() async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '+2347085136311',
                      );
                      try {
                        await launchUrl(launchUri);
                      } catch (error) {
                        showMessage(context, "Cannot dial");
                      }
                    }),
                    SelectCard(
                      iconData: Icons.call,
                      title: 'S.A on Community Market',
                    ).onTap(() async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: '+2347085136311',
                      );
                      try {
                        await launchUrl(launchUri);
                      } catch (error) {
                        showMessage(context, "Cannot dial");
                      }
                    }),
                  ],
                ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SettingsTile(
                        context,
                        Icons.settings_outlined,
                        'General Settings',
                        'Tweak your account how ever you would',
                        false,
                        false)
                    .onTap(() {
                  goto(
                    context,
                    Settingss.routeName,
                    null,
                  );
                }),
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SettingsTile(
                  context,
                  Icons.help_outline_outlined,
                  'Help Center',
                  'Are you lost 😗',
                  false,
                  true,
                ).onTap(() {
                  goto(
                    context,
                    helpcenter.routeName,
                    null,
                  );
                }),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
