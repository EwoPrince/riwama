import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/view/Supervisor/supervisor_industry.dart';
import 'package:riwama/view/dashboard/drawer.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/industry/xview/industry.dart';

class Land extends ConsumerStatefulWidget {
  Land({Key? key}) : super(key: key);
  static const routeName = '/Home';

  @override
  ConsumerState<Land> createState() => _LandState();
}

class _LandState extends ConsumerState<Land> with WidgetsBindingObserver {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(authProvider).user;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: user!.accountLevel == 1 ? Industry() : SupervisorIndustry(),
        endDrawer: NavDrawer(),
      ),
    );
  }
}
