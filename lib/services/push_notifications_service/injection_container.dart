import 'package:connect_plus/services/push_notifications_service/push_notifications_service.dart';
import 'package:get_it/get_it.dart';

void init(GetIt sl) {
  sl.registerLazySingleton<PushNotificationsService>(
      () => PushNotificationsService());
}
