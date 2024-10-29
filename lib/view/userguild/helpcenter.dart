// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riwama/widgets/loading.dart';

class helpcenter extends StatelessWidget {
  const helpcenter({Key? key}) : super(key: key);
  static const routeName = '/HelpCenter';

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('extras');
    return Scaffold(
        appBar: AppBar(
          title: Text("Help Center"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: users.doc('helpcenter').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return const Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          "${data['one']}",
                        ),
                      ),
                    );
                  }
                  return Loading();
                },
              ),
            ],
          ),
        ));
  }
}
