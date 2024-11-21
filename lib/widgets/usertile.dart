import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/widgets/loading.dart';

class UserTile extends ConsumerStatefulWidget {
  final String Uid;

  const UserTile({
    super.key,
    required this.Uid,
  });

  @override
  ConsumerState<UserTile> createState() => _boxState();
}

class _boxState extends ConsumerState<UserTile> {
  bool isLoading = true;
  late ScopeUser userData;

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.Uid)
          .get();

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
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : ListTile(
            leading: ExtendedImage.network(
              userData.photoUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              cache: true,
              shape: BoxShape.circle,
            ),
            title: Text(
              '${userData.firstName} ${userData.lastName}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              userData.phone,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          );
  }
}
