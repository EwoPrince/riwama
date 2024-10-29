import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riwama/model/message_enum.dart';
import 'package:riwama/view/chat/controller/message_reply_provider.dart';
import 'package:riwama/view/chat/controller/chat_controller.dart';
import 'package:riwama/services/pick_file.dart';
import 'package:riwama/view/chat/widgets/edit_chat_image.dart';
import 'package:riwama/x.dart';
import 'message_reply_preview.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomChatField extends HookConsumerWidget {
  final String receiverUserId;
  final String chatId;
  final bool isGroupChat;

  const BottomChatField({
    required this.receiverUserId,
    required this.isGroupChat,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _messageController = useTextEditingController();
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    // final soundRecorder = ref.watch(flutterSoundRecorderProvider);
    final isRecorderInit = useState(false);
    final isRecording = useState(false);
    final isShowSendButton = useState(false);
    final isShowEmojiContainer = useState(false);

    void openAudio() async {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        showMessage(context, 'Mic permission not allowed!');
        await Permission.microphone.request();
      }
      // await soundRecorder.openRecorder();
      isRecorderInit.value = true;
    }

    useEffect(() {
      openAudio();
      return () {
        // soundRecorder.closeRecorder();
      };
    }, []);

    sendFileMessage(File file, MessageEnum messageEnum) {
      ref.read(chatControllerProvider).sendFileMessage(
            context,
            file,
            chatId,
            receiverUserId,
            messageEnum,
            isGroupChat,
          );
    }

    sendAudio() async {
      if (isRecording.value) {
        var tempDir = await getTemporaryDirectory();
        var path = '${tempDir.path}/flutter_sound.aac';
        if (isRecording.value) {
          // soundRecorder.stopRecorder().then((_) {
          //   sendFileMessage(File(path), MessageEnum.audio);
          // });
        }
        isRecording.value = !isRecording.value;
      }
    }

    Future<void> sendTextMessage() async {
      final text = _messageController.text;

      if (isShowSendButton.value && text.isNotEmpty) {
        ref.read(chatControllerProvider).sendTextMessage(
              context,
              text,
              chatId,
              receiverUserId,
              isGroupChat,
            );
        _messageController.clear();
        isShowSendButton.value = false;
      } else if (isRecording.value) {
        sendAudio();
      } else
        showMessage(context, 'hold to record');
    }

    record() async {
      if (isRecorderInit.value) {
        var tempDir = await getTemporaryDirectory();
        var path = '${tempDir.path}/flutter_sound.aac';
        // soundRecorder.startRecorder(
        //   toFile: path,
        // );

        isRecording.value = !isRecording.value;
      }
    }

    void selectImage() async {
      final image = await pickImageFromGallery(context);
      if (image != null) {
        goto(
          context,
          EditChatImage.routeName,
          {
            "file": image,
            "receiverUserId": receiverUserId,
            "chatId": chatId,
            "isGroupChat": isGroupChat,
          },
        );
      }
    }

    void selectVideo() async {
      final video = await pickVideoFromGallery(context);
      if (video != null) {
        sendFileMessage(video, MessageEnum.video);
      }
    }

    void selectGIF() async {}

    void hideEmojiContainer() {
      isShowEmojiContainer.value = false;
    }

    void showEmojiContainer() {
      isShowEmojiContainer.value = true;
    }

    void showKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
    void hideKeyboard() => FocusScope.of(context).unfocus();

    void toggleEmojiKeyboardContainer() {
      if (isShowEmojiContainer.value) {
        showKeyboard();
        hideEmojiContainer();
      } else {
        hideKeyboard();
        showEmojiContainer();
      }
    }

    return Column(
      children: [
        if (isShowMessageReply) MessageReplyPreview(),
        isShowSendButton.value
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: selectGIF,
                      icon: Icon(
                        Icons.gif,
                      ),
                    ),
                    IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.camera_alt,
                      ),
                    ),
                    IconButton(
                      onPressed: selectVideo,
                      icon: Icon(
                        Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
              ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                autocorrect: true,
                controller: _messageController,
                minLines: 1,
                maxLines: 7,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    isShowSendButton.value = true;
                  } else {
                    isShowSendButton.value = false;
                  }
                },
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: IconButton(
                    onPressed: toggleEmojiKeyboardContainer,
                    icon: Icon(
                      Icons.emoji_emotions,
                    ),
                  ),
                  hintText:
                      isRecording.value ? 'Recording...' : '...say somthing',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 30,
                child: InkWell(
                  child: Icon(
                    isShowSendButton.value
                        ? Icons.send
                        : isRecording.value
                            ? Icons.record_voice_over_rounded
                            : Icons.mic,
                  ),
                  onTap: sendTextMessage,
                  onLongPress: record,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
