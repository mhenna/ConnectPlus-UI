import 'package:get_it/get_it.dart';
import 'auth_service.dart';

void init(GetIt sl) {
  sl.registerLazySingleton<AuthService>(() => AuthService());
}
