import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/person.dart';
import '../../data/repositories/person_repository.dart';
import '../api/api_client.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  final personBox = await Hive.openBox<Person>('persons');

  // Register Dio
  getIt.registerLazySingleton(() => Dio());

  // Register ApiClient
  getIt.registerLazySingleton(() => ApiClient(getIt<Dio>()));

  // Register NetworkInfo
  getIt.registerLazySingleton(() => NetworkInfo(Connectivity()));

  // Register PersonRepository
  getIt.registerLazySingleton(
      () => PersonRepository(getIt<ApiClient>(), personBox));
}
