import 'package:get_it/get_it.dart';
import 'package:connect_plus/services/auth_service/injection_container.dart'
    as auth_service;

final GetIt sl = GetIt.instance;

void init() {
  auth_service.init(sl);
}
