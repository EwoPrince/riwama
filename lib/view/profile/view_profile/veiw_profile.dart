import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/pickupRequest.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/view/chat/controller/chat_controller.dart';
import 'package:riwama/x.dart';
import 'package:riwama/view/utility/view_mage.dart';
import 'package:riwama/widgets/loading.dart';

class ViewProfile extends ConsumerStatefulWidget {
  final String uid;
  const ViewProfile({
    Key? key,
    required this.uid,
  }) : super(key: key);

  static const routeName = '/Profile';

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends ConsumerState<ViewProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PickupRequest> posts = [];

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .orderBy('datePublished', descending: true)
          .get();

      postLen = postSnap.docs.length;

      userData = ScopeUser.fromMap(userSnap.data() as Map<String, dynamic>);

      setState(() {});
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  late ScopeUser userData;
  int postLen = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            body: Loading(),
          )
        : Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        leading: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        actions: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: userData.isOnline == true
                                      ? Theme.of(context).primaryColor
                                      : null,
                                ),
                                onPressed: () async {
                                  ref
                                      .read(chatControllerProvider)
                                      .openChat(context, userData);
                                }),
                          )
                        ],
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        pinned: true,
                        floating: true,
                        stretch: true,
                        expandedHeight: size.height * 0.7,
                        flexibleSpace: FlexibleSpaceBar(
                          expandedTitleScale: 1,
                          centerTitle: true,
                          title: Container(
                            height: 50,
                            width: size.width * 0.7,
                            child: Center(
                              child: TabBar(
                                controller: _tabController,
                                onTap: (int index) {},
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tabs: [
                                  FittedBox(
                                    child: Tab(
                                      text: 'Recent Flicks',
                                    ),
                                  ),
                                  FittedBox(
                                    child: Tab(
                                      text: 'Hottest Flicks',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          background: Stack(
                            children: [
                              ExtendedImage.network(
                                userData.photoUrl,
                                height: size.height * 0.4,
                                width: size.width * 0.9,
                                fit: BoxFit.fill,
                                cache: true,
                                shape: BoxShape.rectangle,
                                colorBlendMode: BlendMode.darken,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.9),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(120)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(height: 50),
                                    Hero(
                                      tag: userData.photoUrl,
                                      child: ExtendedImage.network(
                                        userData.photoUrl,
                                        width: size.width * 0.35,
                                        height: size.width * 0.35,
                                        fit: BoxFit.cover,
                                        cache: true,
                                        shape: BoxShape.circle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                      ),
                                    ).onTap(() {
                                      goto(
                                        context,
                                        ViewImage.routeName,
                                        userData.photoUrl,
                                      );
                                    }),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (userData.isOnline != true)
                                          SizedBox(),
                                        if (userData.isOnline == true)
                                          Text(
                                            '*       Online       *',
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      userData.name,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headlineMedium!
                                          .copyWith(
                                              fontSize: 32,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Content Count : ',
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '  ${postLen}',
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Container()),
          );
  }
}
