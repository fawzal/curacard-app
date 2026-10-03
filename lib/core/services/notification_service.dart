import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    // Default location, should ideally be user's local timezone.
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked: ${details.payload}');
      },
    );
  }

  Future<void> requestPermissions() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  /// Memprogram alarm/notifikasi. 
  /// Jika `useAlarm` true, maka notifikasi akan berdering secara intens/insisten.
  Future<void> scheduleMedicationReminder({
    required int id,
    required String medicationName,
    required String dosage,
    required String scheduledTime, // e.g. "08:00 AM"
    required bool useAlarm,
  }) async {
    // Parsing "08:00 AM" to hour and minute
    int hour = 8;
    int minute = 0;
    try {
      final isPM = scheduledTime.toLowerCase().contains('pm');
      final timeParts = scheduledTime.split(' ')[0].split(':');
      hour = int.parse(timeParts[0]);
      minute = int.parse(timeParts[1]);
      if (isPM && hour < 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;
    } catch (e) {
      debugPrint('Failed to parse scheduledTime: $scheduledTime');
    }

    // Hitung waktu terdekat untuk jam tersebut
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);

    // Konfigurasi Notifikasi Android
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      useAlarm ? 'alarm_channel_id' : 'reminder_channel_id',
      useAlarm ? 'Alarm Obat' : 'Pengingat Obat',
      channelDescription: 'Notifikasi untuk jadwal minum obat',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: useAlarm,
      // insistent = true membuat notifikasi berdering terus menerus layaknya alarm
      additionalFlags: useAlarm ? Int32List.fromList([4]) : null, // FLAG_INSISTENT
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: 'Waktunya Minum Obat!',
      body: '$medicationName ($dosage) dijadwalkan pada $scheduledTime.',
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Berulang setiap hari pada jam tersebut
    );
  }

  /// Membatalkan alarm berdasarkan ID
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
