import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class localnotifyMgr {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;

  BehaviorSubject<ReceiveNotification> get didReceiveNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  localnotifyMgr.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      requstIOSPermission();
    }
    initializePlatform();
  }

  requstIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings('img'); //알람 이미지 설정
    var initSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification notification =
              ReceiveNotification(id, title, body, payload);
          didReceiveNotificationSubject.add(notification);
        });
    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveNotificationSubject.listen((notificaton) {
      onNotificationReceive(notificaton);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  //test 용 알림 기능
  Future<void> showNotification() async {
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME', 'CHANNEL_DESCRIPTION',
        importance: Importance.max, priority: Priority.high, playSound: true);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    print(platformChannel);
    // 알람 내용 설정
    await flutterLocalNotificationsPlugin.show(
        0, '🔔 주간리포트가 도착했습니다 🔔', '지난 일주일간의 통계를 확인해보세요', platformChannel,
        payload: 'new payload');
  }

  //매주 월요일 12시에 알림 기능 제공함
  Future<void> showWeeklyAtDayTimeNotification() async {
    /* zonedSchedule 사용 */
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME', 'CHANNEL_DESCRIPTION',
        importance: Importance.max, priority: Priority.high, playSound: true);
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // NotificationChannel들이 살아있어서 다중으로 알림 오는 것을 방지
    // 여러개의 알람을 하고 싶을 경우, 다음 deleteNotificationChannelGroup를 빼줌
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup('CHANNEL_ID');

    final notiTitle = '🔔 주간리포트가 도착했습니다 🔔';
    final notiDesc = '지난 일주일간의 통계를 확인해보세요';

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, notiTitle, notiDesc, _nextInstanceOfMondayTenAM(), platformChannel,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: "new payload");
  }

  // 알람을 월요일로 설정
  tz.TZDateTime _nextInstanceOfMondayTenAM() {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != DateTime.monday) {
      // 설정된 알림이 월요일이 아닌 경우, 알람을 1일 뒤로 미룸
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // 알람을 12시로 설정
  tz.TZDateTime _nextInstanceOfTenAM() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul')); // 지역 설정
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local); // 현재 날짜와 시간 불러오기

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, 12, 0); // 오늘 날짜의 12시로 알림 설정
    // 이미 지난 시간으로 알람이 설정됐을 경우, 알람을 1일 뒤로 미룸
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification(@required this.id, @required this.title,
      @required this.body, @required this.payload);
}
