import 'package:alnabali_driver/src/features/auth/auth_repository.dart';
import 'package:alnabali_driver/src/features/trip/trip_controller.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/notification/home_notifications_page.dart';
import 'package:alnabali_driver/src/features/profile/home_account_page.dart';
import 'package:alnabali_driver/src/features/trip/home_trips_page.dart';
import 'package:alnabali_driver/src/widgets/app_icons_icons.dart';
import 'package:alnabali_driver/src/widgets/gnav/gnav.dart';
import 'package:alnabali_driver/src/widgets/gnav/gbutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _controller = PageController();
  int selectedIndex = 0;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String mToken = "";
  String tripID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    requestPermission();
    getToken().then((value) {
      saveFCMToken().then((value) {
        print("fcmtoken" + value.toString());
        if (!value) {
          showToastMessage("Failed to register device");
        }
      });
    });
    initInfo();
  }

  // need to be top level to be passed in initialized
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse details) {
    try {
      if (details != null && details.toString().isNotEmpty) {
        // context.goNamed(AppRoute.home.name);
      }
    } catch (e) {}
    return;
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();

    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        try {
          if (details != null && details.toString().isNotEmpty) {
            print("========================================");
            print(tripID);
            if (tripID == "") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            } else {
              context.pushNamed(
                AppRoute.tripDetail.name,
                params: {'tripId': tripID},
              );
            }
          }
        } catch (e) {}
        return;
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    FirebaseMessaging.onMessage.listen((message) async {
      print("===============OnMessage================");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      String msgBody = message.notification?.body ?? "get";
      List<String> msgList = msgBody.split("::::");
      tripID = msgList[1];

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        msgList[0],
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
          0, message.notification?.title, msgList[0], platformChannelSpecifics,
          payload: msgList[0]);
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    //   print("onTap click");
    //   print(message.data["trip_id"]);
    // });
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print('My token is $token');
      setState(() {
        mToken = token!;
        // Commons.fcm_token = token!;
        // print('My token is $mToken');
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    final tripCtr = ref.read(tripControllerProvider.notifier);
    tripCtr.saveToken(token);
  }

  Future<bool> saveFCMToken() async {
    if (mToken == "") return false;
    final tripCtr = ref.read(tripControllerProvider.notifier);
    return await tripCtr.saveFCMToken(mToken);
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    double gap = 10;
    final padding = EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h);

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          decoration: kBgDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 30.h),
                height: 190.h,
                child: Image.asset('assets/images/home_icon.png'),
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (page) {
                    setState(() {
                      selectedIndex = page;
                      //badge = badge + 1;
                    });
                  },
                  controller: _controller,
                  itemCount: 3,
                  itemBuilder: (context, position) {
                    if (position == 0) {
                      return const HomeTripsPage();
                    } else if (position == 1) {
                      return const HomeNotificationsPage();
                    } else {
                      return const HomeAccountPage();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.all(24.h),
          decoration: BoxDecoration(
            color: kColorPrimaryBlue,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                color: Colors.black.withOpacity(.4),
                offset: const Offset(0, 25),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: GNav(
              tabs: [
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav1,
                  text: AppLocalizations.of(context).trips,
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav2,
                  text: AppLocalizations.of(context).notification,
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav3,
                  text: AppLocalizations.of(context).account,
                )
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
                _controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
