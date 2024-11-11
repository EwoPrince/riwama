import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

Duration normalspeed = Duration(milliseconds: 700);

String readTimestamp(DateTime timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = timestamp;
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' DAY AGO';
    } else {
      time = diff.inDays.toString() + ' DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
    }
  }

  return time;
}

String k_m_b_generator(num) {
  if (num > 999 && num < 99999) {
    return "${(num / 1000).toStringAsFixed(1)} K";
  } else if (num > 99999 && num < 999999) {
    return "${(num / 1000).toStringAsFixed(0)} K";
  } else if (num > 999999 && num < 999999999) {
    return "${(num / 1000000).toStringAsFixed(1)} M";
  } else if (num > 999999999) {
    return "${(num / 1000000000).toStringAsFixed(1)} B";
  } else {
    return num.toString();
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        content: Text(text),
        dismissDirection: DismissDirection.endToStart,
      ),
    );
}

void showUpMessage(BuildContext context, String text, String title) {
  Flushbar(
      title: title,
      message: text,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.green,
      boxShadows: [BoxShadow(color: Colors.green, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(
        Icons.check,
        color: Colors.white,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
    ).show(context);
}

void errorUpMessage(BuildContext context, String text, String title) {
  Flushbar(
    title: title,
    message: text,
    duration: Duration(seconds: 2),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}

void goto(BuildContext context, String location, Object? extra) {
  context.push(location, extra: extra);
}

void become(BuildContext context, String location, Object? extra) {
  context.pushReplacement(location, extra: extra);
}

const globalStyle = TextStyle(
  fontFamily: 'DMSans',
  fontSize: 12,
  fontWeight: FontWeight.w800,
);

extension Click on Widget {
  Widget onTap(VoidCallback? callback) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: callback,
      child: this,
    );
  }
}


extension LongPress on Widget {
  Widget onLongPress(VoidCallback? callback) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onLongPress: callback,
      child: this,
    );
  }
}

extension DoubleClick on Widget {
  Widget onDoubleTap(VoidCallback? callback) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onDoubleTap: callback,
      child: this,
    );
  }
}

// const apiKey = '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';

// const serverKey =
//     'AAAAIXKs1OQ:APA91bGLdaMgnDQW5tl_Pxihqg62OOl-BIuNkUsHL7WG6wvnqW6t1_9Xle9I3jDBnwdmA1D57Z6MBE2EI42vcv4A4lA4hEg-Yh4CHUnGRiM0ZBVnEwPXJrkF0_4996oDWxt07h4_GOyR'; // Replace with your FCM server key

// const String testDevice = '1EF95E3F71E6CFA3ADC906A384D4BF28';
