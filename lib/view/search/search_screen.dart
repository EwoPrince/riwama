import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/view/search/community.dart';
import 'package:riwama/view/search/user_search.dart';
import 'package:riwama/view/userguild/comingsoon.dart';
import 'package:riwama/widgets/button.dart';
import 'package:riwama/widgets/textField.dart';
import 'package:riwama/x.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  bool showEditor = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: showSearch
            ? showEditor
                ? Form(
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "field is required";
                          }
                          return null;
                        },
                        autocorrect: true,
                        controller: searchController,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showSearch = true;
                                });
                              },
                              icon: Icon(
                                Icons.send,
                                color: Theme.of(context).primaryColor,
                              )),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          disabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        keyboardType: TextInputType.text),
                  )
                : Text(searchController.text).onTap(() {
                    setState(() {
                      showEditor = !showEditor;
                    });
                  })
            : Text('Crystal').onTap(() {
                Scaffold.of(context).openDrawer();
              }),
      ),

      /// Search Body
      body: Container(
          child: showSearch

              /// User Search
              ? Column(
                  children: [
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: TabBar(
                          controller: _tabController,
                          onTap: (int index) {},
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // color: AbjWhite,
                          ),
                          tabs: const [
                            FittedBox(
                              child: Tab(
                                text: 'People',
                              ),
                            ),
                            FittedBox(
                              child: Tab(
                                text: 'Flick',
                              ),
                            ),
                            FittedBox(
                              child: Tab(
                                text: 'Groups',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        dragStartBehavior: DragStartBehavior.down,
                        physics: BouncingScrollPhysics(),
                        children: [
                          USerSearch(
                            searchController: searchController,
                          ),
                          Community(
                            searchController.text,
                          ),
                          ComingSoon(),
                        ],
                      ),
                    ),
                  ],
                )

              /// Regural storage flow from world
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: reusableTextField(
                              'Search for anything',
                              searchController,
                              Theme.of(context).primaryColor, () {
                            return null;
                          })),
                      button(context, 'Search', () {
                        setState(() {
                          showSearch = true;
                        });
                      })
                    ],
                  ),
                )),
    );
  }
}
