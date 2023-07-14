import 'notification_list_response.dart';

class NotificationResponse {
  List<NotificationData>? unReadNotificationList;
  List<NotificationData>? readNotificationList;
  List<NotificationData>? notifications;

  NotificationResponse({this.unReadNotificationList, this.readNotificationList, this.notifications});
}
