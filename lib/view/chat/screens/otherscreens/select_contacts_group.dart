import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riwama/model/scope_user.dart';
// import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/provider/reload_provider.dart';
import 'package:riwama/widgets/loading.dart';

final selectedGroupContacts = StateProvider<List<ScopeUser>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];
  late Future futureHolder;

  Future<bool> fetchdata() async {
    // final user = ref.read(authProvider).user;
    try {
      // ref.read(HutBoxProvider).fetchHutBoxData(user!.bux);
      ref.read(xboxProvider.notifier).initXviewLoad();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> newLoad() async {
    await Future.delayed(const Duration(milliseconds: 20));
    return true;
  }

  Future<void> onRefresh() async {
    setState(() {
      futureHolder = fetchdata();
    });
  }

  @override
  initState() {
    final alreadytLoaded = ref.read(xboxProvider);
    if (!alreadytLoaded) {
      futureHolder = fetchdata();
    } else {
      futureHolder = newLoad();
    }
    super.initState();
  }

  void selectContact(int index, ScopeUser user) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    ref
        .read(selectedGroupContacts.notifier)
        .update((state) => [...state, user]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder(
            future: futureHolder,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return Consumer(
                builder: (context, ref, child) {
                  // final data = ref.watch(HutBoxProvider).HutBox;
                  final newdata = [];
                  // data.where((element) => element.name.isNotEmpty).toList();

                  return newdata.length == 0
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Loading(),
                            SizedBox(height: 12),
                            Text('try again if loading continues')
                          ],
                        ))
                      : ListView.builder(
                          itemCount: newdata.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                onTap: () {
                                  selectContact(index, newdata[index]);
                                },
                                title: Text(
                                  newdata[index].username,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                leading: selectedContactsIndex.contains(index)
                                    ? IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.done),
                                      )
                                    : ExtendedImage.network(
                                        newdata[index].photoUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        cache: true,
                                        shape: BoxShape.circle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                      ),
                              ),
                            );
                          });
                },
              );
            }),
      ),
    );
  }
}
