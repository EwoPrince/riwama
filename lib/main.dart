import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riwama/provider/theme_provider.dart';
import 'package:riwama/route/route.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    } else {}
  });

  isFlutterLocalNotificationsInitialized = true;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationService.showFlutterNotification(message);
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showFlutterNotification(message);
    });
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
    FlutterNativeSplash.remove();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
      (value) => runApp(
        const ProviderScope(child: MyApp()),
      ),
    );
  }, (error, stackTrace) {
    print(error);
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(themeProvider);
    return FutureBuilder(
        future: ref.read(themeProvider.notifier).onAppLaunch(context),
        builder: (context, snapshot) {
          return MaterialApp.router(
            theme: isDarkMode!
                ? FlexColorScheme.dark(
                    scheme: FlexScheme.green,
                    useMaterial3: true,
                    swapLegacyOnMaterial3: true,
                    fontFamily: 'Lexend',
                  ).toTheme
                : FlexColorScheme.light(
                    scheme: FlexScheme.green,
                    useMaterial3: true,
                    swapLegacyOnMaterial3: true,
                    fontFamily: 'Lexend',
                  ).toTheme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
