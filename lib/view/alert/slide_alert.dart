import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riwama/model/slide.dart';
import 'package:riwama/view/Supervisor/respository/slide_repository.dart';
import 'package:riwama/x.dart';

class SlideAlert extends ConsumerStatefulWidget {
  const SlideAlert({super.key, required this.pu});
  final Slide pu;
  @override
  ConsumerState<SlideAlert> createState() => _PickupAlertState();
}

class _PickupAlertState extends ConsumerState<SlideAlert> {
  deletePost(String postId) async {
    ref.read(SlideRepositoryProvider).deleteSlide(postId);
    showMessage(
      context,
      'Slide Deleted',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      leading: LayoutBuilder(builder: (context, short) {
        return ConstrainedBox(
          constraints: short,
          child: ExtendedImage.network(
            widget.pu.profImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            cache: true,
            shape: BoxShape.circle,
            cacheMaxAge: Duration(days: 7),
          ),
        );
      }),
      title: Text(
        "Posted at: ${readTimestamp(widget.pu.datePublished)}",
        maxLines: 2,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) {
              return Dialog(
                child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shrinkWrap: true,
                    children: [
                      'Delete this Slide',
                    ]
                        .map(
                          (e) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Center(
                                child: Text(
                              e,
                              textAlign: TextAlign.center,
                            )),
                          ).onTap(() {
                            deletePost(widget.pu.slideId.toString());
                            Navigator.of(context).pop();
                          }),
                        )
                        .toList()),
              );
            },
          );
        },
        icon: const Icon(Icons.delete_outlined),
      ),
    );
  }
}
