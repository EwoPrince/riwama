import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/industry_provider.dart';
import 'package:riwama/provider/map_provider.dart';
import 'package:riwama/view/dashboard/land.dart';
import 'package:riwama/view/userguild/networkIssuse.dart';
import 'package:riwama/widgets/loading.dart';

class VerifiedState extends ConsumerStatefulWidget {
  const VerifiedState({Key? key}) : super(key: key);
  static const routeName = '/VerifyUser';

  @override
  ConsumerState<VerifiedState> createState() => _VerifiedStateState();
}

class _VerifiedStateState extends ConsumerState<VerifiedState> {
  bool isEmailVerified = false;
  late Future futureHolder;
  late String randomStart = '';
  var uid = FirebaseAuth.instance.currentUser!.uid;

  final startlist = [
    "Dumping Time remains 6pm to 10pm Everyday",
    "Making Waste Management Simple & Smart.",
    "Let\'s Keep Rivers State Beautiful!",
    "Effortless Waste Management at Your Fingertips.",
    "Together for a Greener Rivers State.",
    "Smart Waste, Cleaner State!",
    "Cleaner Tomorrow Starts Today!",
    "For a Cleaner, Greener Future.",
  ];

  Future<bool> checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      await FirebaseMessaging.instance.getToken().then((value) {
        ref.read(authProvider).updateFcmToken(value!);
      });
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> start() async {
    try {
      await ref.read(authProvider).listenTocurrentUserNotifier(uid);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future fetchdata() async {
    ref.watch(industryProvider).fetchSlider();
    ref.watch(industryProvider).fetchWorldReceptacles();
    ref.watch(industryProvider).fetchWorldPickupRequest();
    ref.watch(industryProvider).fetchWorldInterventionRequest();
    ref.watch(industryProvider).fetchWorldTowRequest();
    ref.watch(mapProvider).fetchLocation();
  }

  randomText() {
    Random random = Random();
    int randomIndex = random.nextInt(startlist.length);
    final randomItem = startlist[randomIndex];
    setState(() {
      randomStart = randomItem;
    });
  }

  @override
  void initState() {
    super.initState();
    futureHolder = checkEmailVerified();
    start();
    randomText();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureHolder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loading(),
                    SizedBox(height: 100),
                    Text(
                      randomStart,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.data == true) {
          return Land();
        }
        if (snapshot.data == false) {
          return Networkiss();
        }

        return Center(
          child: Text(
            'This Error is the first of it\'s kind.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }
}
