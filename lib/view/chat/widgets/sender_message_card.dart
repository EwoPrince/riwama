import 'package:flutter/material.dart';
import 'package:riwama/model/message_enum.dart';
import 'package:riwama/view/chat/widgets/bubble_color.dart';
import 'package:riwama/view/chat/widgets/display_text_image_gif.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:riwama/model/scope_user.dart';
import 'package:riwama/view/profile/view_profile/veiw_profile.dart';
import 'package:riwama/widgets/loading.dart';
import 'package:riwama/x.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: (DragUpdateDetails) => onRightSwipe(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            color: Colors.transparent,
            elevation: 1,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: BubblePainter(
                  bubbleContext: context,
                  scrollable: Scrollable.of(context),
                  colors: [
                    Color.fromARGB(255, 88, 241, 98),
                    Color.fromARGB(255, 4, 80, 8)
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: type == MessageEnum.text
                          ? const EdgeInsets.only(
                              left: 10,
                              right: 30,
                              top: 5,
                              bottom: 20,
                            )
                          : EdgeInsets.only(
                              left: 5,
                              top: 5,
                              right: 5,
                              bottom: 25,
                            ),
                      child: Column(
                        children: [
                          if (isReplying) ...[
                            Text(
                              username,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5,
                                  ),
                                ),
                              ),
                              child: DisplayTextImageGIF(
                                message: repliedText,
                                type: repliedMessageType,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                          DisplayTextImageGIF(
                            message: message,
                            type: type,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 10,
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SenderMessageCardGroup extends StatelessWidget {
  const SenderMessageCardGroup({
    Key? key,
    required this.message,
    required this.senderid,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  }) : super(key: key);
  final String message;
  final String senderid;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: (DragUpdateDetails) => onRightSwipe(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(width: 8),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(senderid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Loading();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }

                if (!snapshot.hasData) {
                  return Text('Nope');
                }

                var documentSnapshot = snapshot.data;
                var docx = ScopeUser.fromMap(
                    documentSnapshot?.data() as Map<String, dynamic>);

                return ExtendedImage.network(
                  docx.photoUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  cache: true,
                  shape: BoxShape.circle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                );
              },
            ).onTap(() {
              goto(
                context,
                ViewProfile.routeName,
                senderid,
              );
            }),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 40,
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 1,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    painter: BubblePainter(
                      bubbleContext: context,
                      scrollable: Scrollable.of(context),
                      colors: [
                        Color.fromARGB(255, 88, 241, 98),
                        Color.fromARGB(255, 4, 80, 8)
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: type == MessageEnum.text
                              ? const EdgeInsets.only(
                                  left: 10,
                                  right: 30,
                                  top: 5,
                                  bottom: 20,
                                )
                              : EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  right: 5,
                                  bottom: 25,
                                ),
                          child: Column(
                            children: [
                              if (isReplying) ...[
                                Text(
                                  username,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        5,
                                      ),
                                    ),
                                  ),
                                  child: DisplayTextImageGIF(
                                    message: repliedText,
                                    type: repliedMessageType,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                              DisplayTextImageGIF(
                                message: message,
                                type: type,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 10,
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
