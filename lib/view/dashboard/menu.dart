import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/view/Supervisor/add_slide.dart';
import 'package:riwama/view/Supervisor/receptacle_sample.dart';
import 'package:riwama/view/Supervisor/supervisor_form.dart';
import 'package:riwama/view/profile/pic_profile_view.dart';
import 'package:riwama/view/account/general_setting.dart';
import 'package:riwama/view/industry/intervention/view_intervention/list_intervention.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:riwama/view/industry/pickupRequest/view_request/pickup_row.dart';
import 'package:riwama/view/userguild/helpcenter.dart';
import 'package:riwama/widgets/settingsTile.dart';
import 'package:riwama/x.dart';
import '../profile/personal_profile.dart';

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
  CarouselSliderController buttonCarouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final timeHour = DateTime.now().hour;

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
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    timeHour < 12
                        ? 'Good Morning'
                        : timeHour < 16
                            ? 'Good Afternoon'
                            : 'Good Evening',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                                  height: 124.0,
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
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: .0),
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
        body: Consumer(builder: (context, ref, child) {
          final user = ref.watch(authProvider).user;
          return ListView(
            children: [
              SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Hero(
                      tag: "${user!.photoUrl}",
                      child: ExtendedImage.network(
                        "${user.photoUrl}",
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        cache: true,
                        shape: BoxShape.circle,
                      ),
                    ).onTap(() {
                      goto(
                        context,
                        PicProfileView.routeName,
                        "${user.photoUrl}",
                      );
                    }),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                        child: Text(
                          "${user.firstName} ${user.lastName}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      FittedBox(
                        child: Text(
                          "${user.email}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      FittedBox(
                        child: Text(
                          "${user.phone}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).onTap(() {
                    goto(
                      context,
                      PersonalProfile.routeName,
                      null,
                    );
                  }),
                ],
              ),
              SizedBox(height: 28),
              user.accountLevel == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SettingsTile(
                              context,
                              Icons.settings_outlined,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SettingsTile(
                        context,
                        Icons.settings_outlined,
                        'Intervention List',
                        'Tweak your account how ever you would',
                        user.accountLevel == 1 ? false : true,
                        false)
                    .onTap(() {
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
                        Icons.settings_outlined,
                        'Pick Up List',
                        'Tweak your account how ever you would',
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
                      child: SettingsTile(
                              context,
                              Icons.settings_outlined,
                              'Add Slide',
                              'Update to the RIWAMA Slides',
                              false,
                              false)
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
                              Icons.settings_outlined,
                              'Add Receptacle',
                              'Update to the public a Receptacle location',
                              false,
                              false)
                          .onTap(() {
                        goto(context, ReceptacleSample.routeName, null);
                      }),
                    )
                  : SizedBox.shrink(),
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
          );
        }),
      ),
    );
  }
}
