import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_school_firebase/cubits/Auth/auth_cubit.dart';
import 'package:it_school_firebase/cubits/posts/posts_cubit.dart';
import 'package:it_school_firebase/screens/maps_screen.dart';
import 'package:it_school_firebase/screens/notifications_screen.dart';
import 'package:it_school_firebase/screens/posts_screen.dart';

import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> _handler(RemoteMessage event) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: event.sentTime!.millisecond,
      channelKey: 'basic_channel',
      actionType: ActionType.Default,
      title: event.notification != null
          ? event.notification!.title
          : event.data["title"],
      body: event.notification != null
          ? event.notification!.body
          : event.data["body"],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  String? token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: event.notification != null
            ? event.notification!.title
            : event.data["title"],
        body: event.notification != null
            ? event.notification!.body
            : event.data["body"],
      ),
    );
  });

  FirebaseMessaging.onBackgroundMessage(_handler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => PostsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MapsScreen(),
      ),
    );
  }
}
