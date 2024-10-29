import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/widgets/user_tile.dart';

class USerSearch extends ConsumerStatefulWidget {
  const USerSearch({
    super.key,
    required this.searchController,
  });
  final TextEditingController searchController;

  @override
  ConsumerState<USerSearch> createState() => _USerSearchState();
}

class _USerSearchState extends ConsumerState<USerSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where(
            'username',
            isGreaterThanOrEqualTo: widget.searchController.text,
          )
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final docData = docs[index].data();
            ScopeUser state;
            state = ScopeUser.fromMap(docData);

            return Padding(
              padding: EdgeInsets.all(8.0),
              child: USerTile(
                US: state,
              ),
            );
          },
        );
      },
    ));
  }
}
