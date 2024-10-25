import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyapp/models/models.dart';
import 'package:studyapp/screens/screens.dart' show LeaderBoardScreen;
import 'package:studyapp/utils/logger.dart';

class NotificationService extends GetxService {
  final _notifications = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    _initNotifications();
    super.onInit();
  }

  Future<void> _initNotifications() async {
    const androidInitializationSettings =
    AndroidInitializationSettings('@drawable/app_notification_icon');

    InitializationSettings initializationSettings =
    const InitializationSettings(android: androidInitializationSettings);

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final QuizPaperModel quizPaperModel =
          QuizPaperModel.fromJson(json.decode(response.payload!));
          Get.toNamed(LeaderBoardScreen.routeName, arguments: quizPaperModel);
        }
      },
    );
  }

  Future<void> showQuizCompletedNotification({
    required int id,
    String? title,
    String? body,
    String? imageUrl,
    String? payload,
  }) async {
    BigPictureStyleInformation? bigPictureStyleInformation;
    String? largeIconPath;

    if (imageUrl != null) {
      largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
      final String? bigPicturePath =
      await _downloadAndSaveFile(imageUrl, 'bigPicture');

      if (bigPicturePath != null) {
        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          hideExpandedLargeIcon: true,
          contentTitle: '<b>$title</b>',
          htmlFormatContentTitle: true,
          summaryText: '<b>$body</b>',
          htmlFormatSummaryText: true,
        );
      }
    }

    _notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'quizcomplete',
          'quizcomplete',
          channelDescription: 'Open leaderboard',
          importance: Importance.max,
          largeIcon: FilePathAndroidBitmap(largeIconPath!),
          styleInformation: bigPictureStyleInformation,
          priority: Priority.max,
        ),
      ),
      payload: payload,
    );
  }

  Future<String?> _downloadAndSaveFile(String url, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final http.Response response = await http.get(Uri.parse(url));
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      AppLogger.e(e);
    }
    return null;
  }
}
