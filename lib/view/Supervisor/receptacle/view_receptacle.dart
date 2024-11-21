import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riwama/model/receptacle.dart';
import 'package:riwama/provider/auth_provider.dart';
import 'package:riwama/view/Supervisor/receptacle/receptacle_display_map.dart';
import 'package:riwama/widgets/button.dart';
import 'package:swipe_to/swipe_to.dart';

class ReceptacleView extends ConsumerStatefulWidget {
  final Receptacle snap;
  ReceptacleView({required this.snap});
  static const routeName = '/ReceptacleView';

  @override
  ConsumerState<ReceptacleView> createState() => _ReceptacleViewState();
}

class _ReceptacleViewState extends ConsumerState<ReceptacleView> {
  @override
  Widget build(BuildContext context) {
    var ize = MediaQuery.of(context).size;
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Receptacle View',
          softWrap: true,
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SwipeTo(
        onRightSwipe: (DragDownDetails) {
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Posted on :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      DateFormat.yMMMd().format(widget.snap.datePublished),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Posted by :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      widget.snap.name,
                    )
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Sample of Receptacle:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: ize.width * 0.97,
                  height: ize.height * 0.45,
                  child: LayoutBuilder(builder: (context, short) {
                    return ConstrainedBox(
                      constraints: short,
                      child: ExtendedImage.network(
                        widget.snap.profImage,
                        fit: BoxFit.contain,
                        cache: true,
                        cacheMaxAge: Duration(days: 7),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 6),

                /// IMAGE SECTION OF THE POST
                Text(
                  "Location for Receptacle:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: ize.width * 0.98,
                  height: ize.height * 0.45,
                  child: ReceptacleDisplayMap(
                    snap: widget.snap,
                  ),
                ),

                SizedBox(height: 12),
                user!.accountLevel >= 2
                    ? button(context, 'Update Receptacle', () {})
                    : SizedBox.shrink(),

                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
