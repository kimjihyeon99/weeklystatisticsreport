import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class localnotifyMgr{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  localnotifyMgr.init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if(Platform.isIOS){
      requstIOSPermission();
    }
    initializePlatform();
  }

  requstIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation
    <IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );
  }

  initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings('img');//알람 이미지 설정
    var initSettingIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async{
        ReceiveNotification notification = ReceiveNotification(id, title, body, payload);
        didReceiveNotificationSubject.add(notification);

      }
    );
    initSetting= InitializationSettings(android: initSettingAndroid,iOS: initSettingIOS );
  }

  setOnNotificationReceive(Function onNotificationReceive){
    didReceiveNotificationSubject.listen((notificaton) {
      onNotificationReceive(notificaton);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload) async{
          onNotificationClick(payload);
        });
  }
  
  Future<void> showNotification() async{

      var androidChannel = AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
        'CHANNEL_DESCRIPTION',
    importance: Importance.max,
    priority:  Priority.high,
    playSound: false);
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android:androidChannel,iOS: iosChannel);
    print(platformChannel);
    // 알람 내용 설정
    await flutterLocalNotificationsPlugin.show(0, '🔔 주간리포트가 도착했습니다 🔔', '지난 일주일간의 통계를 확인해보세요', platformChannel,payload:'new payload'
    );
  }
}

class ReceiveNotification{
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification(@required this.id, @required this.title, @required this.body, @required this.payload);
}