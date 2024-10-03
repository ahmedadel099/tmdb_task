// lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/person_repository.dart';
import '../api/api_client.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register Dio
  getIt.registerLazySingleton(() => Dio());

  // Register ApiClient
  getIt.registerLazySingleton(() => ApiClient(getIt<Dio>()));

  // Register PersonRepository
  getIt.registerLazySingleton(() => PersonRepository(getIt<ApiClient>()));
}
