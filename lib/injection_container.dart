import 'package:get_it/get_it.dart';
import 'package:connect_plus/services/auth_service/injection_container.dart'
    as auth_service;
import 'package:connect_plus/services/push_notifications_service/injection_container.dart'
    as push_notifications;

final GetIt sl = GetIt.instance;

void init() {
  auth_service.init(sl);
  push_notifications.init(sl);
}
